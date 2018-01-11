//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProjectTrainAWC_LW.uc
//  AUTHOR:  Amineri
//  PURPOSE: This object represents the instance data for an XCom HQ train AWC project, LW version
//           This has to extend the TrainRookie project so that certain hard-coded functions will recognize the training project
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProjectTrainAWC_LW extends XComGameState_HeadquartersProjectTrainRookie dependson (LWAWCUtilities);

var name AbilityName;					// name of the ability being trained
var int NewLevel;						// the level of the ability being trained
var AWCTrainingType TrainingOption;		// the option type being trained (e.g. offense, defense, etc)
var int TrainingIndex;					// the index in the randomized abilities currently being trained

//---------------------------------------------------------------------------------------
// Call when you start a new project, NewGameState should be none if not coming from tactical
function SetProjectFocus(StateObjectReference FocusRef, optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_GameTime TimeState;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;
	ProjectFocus = FocusRef; // Unit
	AuxilaryReference = AuxRef; // Facility
	
	ProjectPointsRemaining = CalculatePointsToTrain();
	InitialProjectPoints = ProjectPointsRemaining;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ProjectFocus.ObjectID));
	//UnitState.PsiTrainingRankReset();
	UnitState.SetStatus(eStatus_Training);

	UpdateWorkPerHour(NewGameState);
	TimeState = XComGameState_GameTime(History.GetSingleGameStateObjectForClass(class'XComGameState_GameTime'));
	StartDateTime = TimeState.CurrentTime;

	if (`STRATEGYRULES != none)
	{
		if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(TimeState.CurrentTime, `STRATEGYRULES.GameTime))
		{
			StartDateTime = `STRATEGYRULES.GameTime;
		}
	}
	
	if (MakingProgress())
	{
		SetProjectedCompletionDateTime(StartDateTime);
	}
	else
	{
		// Set completion time to unreachable future
		CompletionDateTime.m_iYear = 9999;
	}
}

//---------------------------------------------------------------------------------------
function int CalculatePointsToTrain()
{
	local float BaseTrainingHours;
	local XComGameState_Unit Unit;

	BaseTrainingHours = class'LWAWCUtilities'.static.GetAWCTrainingDays(NewLevel) * 24.0;
	if (TrainingOption == AWCTT_Pistol)
	{
		BaseTrainingHours *= class'LWAWCUtilities'.default.PistolTrainingMultiplier;
	}

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ProjectFocus.ObjectID));
	if (Unit.HasSoldierAbility('QuickStudy'))
	{
		BaseTrainingHours *= class'LWAWCUtilities'.default.QuickStudyTrainingMultiplier;
	}

	return int(BaseTrainingHours);
}

//---------------------------------------------------------------------------------------
function int CalculateWorkPerHour(optional XComGameState StartState = none, optional bool bAssumeActive = false)
{
	return 1;
}

function string GetTrainingAbilityFriendlyName()
{
	return class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityName).LocFriendlyName;
}

function name GetTrainingAbilityName()
{
	return AbilityName;
}

//---------------------------------------------------------------------------------------
// Remove the project
function OnProjectCompleted()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ, NewXComHQ;
	local XComGameState_Unit Unit;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit_AWC_LW AWCState;
	local XComGameState UpdateState;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState_HeadquartersProjectTrainAWC_LW ProjectState;
	local XComGameState_StaffSlot StaffSlotState;

	History = `XCOMHISTORY;
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(ProjectFocus.ObjectID));
	
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("LW AWC Training Complete");
	UpdateState = History.CreateNewGameState(true, ChangeContainer);
	UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));

	AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);
	AWCState = XComGameState_Unit_AWC_LW(UpdateState.CreateStateObject(class'XComGameState_Unit_AWC_LW', AWCState.ObjectID));
	AWCState.TrainAbility(TrainingIndex, TrainingOption);
	AWCState.LastAbilityTrainedName = AWCState.AbilityTrainingName;

	UpdatedUnit.SetStatus(eStatus_Active);

	ProjectState = XComGameState_HeadquartersProjectTrainAWC_LW(History.GetGameStateForObjectID(GetReference().ObjectID));
	if (ProjectState != none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		if (XComHQ != none)
		{
			NewXComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			UpdateState.AddStateObject(NewXComHQ);
			NewXComHQ.Projects.RemoveItem(ProjectState.GetReference());
			UpdateState.RemoveStateObject(ProjectState.ObjectID);
		}


		// Remove the soldier from the staff slot
		StaffSlotState = UpdatedUnit.GetStaffSlot();
		if (StaffSlotState != none)
		{
			StaffSlotState.EmptySlot(UpdateState);
		}
	}

	UpdateState.AddStateObject(UpdatedUnit);
	UpdateState.AddStateObject(AWCState);
	UpdateState.AddStateObject(ProjectState);
	`GAMERULES.SubmitGameState(UpdateState);

	UITrainingComplete(ProjectFocus);
}

function UITrainingComplete(StateObjectReference UnitRef)
{
	local UIAlert_AWCTrainingComplete_LW Alert;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPres;

	Alert = HQPres.Spawn(class'UIAlert_AWCTrainingComplete_LW', HQPres);
	Alert.eAlertName = 'eAlert_TrainingComplete';
	Alert.DisplayPropertySet.SecondaryRoutingKey = Alert.eAlertName; // Necessary? Probably not. Who cares?
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicIntProperty(Alert.DisplayPropertySet, 'UnitRef', UnitRef.ObjectID);
	Alert.DisplayPropertySet.CallbackFunction = TrainingCompleteCB;
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringProperty(Alert.DisplayPropertySet, 'SoundToPlay', "Geoscape_CrewMemberLevelledUp");
	HQPres.ScreenStack.Push(Alert);
}

simulated function TrainingCompleteCB(/*EUIAction*/ Name eAction, out /*UIAlert*/ DynamicPropertySet AlertData, optional bool bInstants = false) // eAction now of type Name, AlertData now of type DynamicPropertySet
{
	//local XComGameState NewGameState; 
	local XComHQPresentationLayer HQPres;
	local StateObjectReference UnitRef; // Added for WOTC compatibility, see below

	HQPres = `HQPres;
	
	//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Unit Promotion");
	//`XEVENTMGR.TriggerEvent('UnitPromoted', , , NewGameState);
	//`GAMERULES.SubmitGameState(NewGameState);

	if (!HQPres.m_kAvengerHUD.Movie.Stack.HasInstanceOf(class'UIArmory_LWOfficerPromotion')) // If we are already in the promotion screen, just close this popup
	{
		//if (eAction == eUIAction_Accept) // eAction now of type Name
		if (eAction == 'eUIAction_Accept')
		{
			//GoToArmoryLWOfficerPromotion(AlertData.UnitInfo.UnitRef, true); // AlertData.UnitInfo deprecated in favor of the DisplayPropertySet, now must reverse reference the UnitRef by its ObjectID
			UnitRef.ObjectID = class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(AlertData, 'UnitRef');
			GoToArmoryAWCPromotion(UnitRef, true);
		}
		else
		{
			`GAME.GetGeoscape().Resume();
		}
	}
}

simulated function GoToArmoryAWCPromotion(StateObjectReference UnitRef, optional bool bInstantb = false)
{
	local UIArmory_AWCExpandedPromotion_LW AWCScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPres;
	
	if (`GAME.GetGeoscape().IsScanning())
		HQPres.StrategyMap2D.ToggleScan();

	//call Armory_MainMenu to populate pawn data
	if(HQPres.ScreenStack.IsNotInStack(class'UIArmory_MainMenu'))
		UIArmory_MainMenu(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_MainMenu', HQPres), HQPres.Get3DMovie())).InitArmory(UnitRef,,,,,, bInstant);


	AWCScreen = UIArmory_AWCExpandedPromotion_LW(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_AWCExpandedPromotion_LW', HQPres), HQPres.Get3DMovie()));
	AWCScreen.InitPromotion(UnitRef, bInstant);
}

function String GetDisplayName()
{
    return GetTrainingAbilityFriendlyName();
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}

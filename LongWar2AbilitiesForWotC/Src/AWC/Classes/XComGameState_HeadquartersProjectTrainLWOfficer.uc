//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProjectTrainLWOfficer.uc
//  AUTHOR:  Amineri
//  PURPOSE: This object represents the instance data for an XCom HQ train officer project, LW version
//           This has to extend the TrainRookie project so that certain hard-coded functions will recognize the training project
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProjectTrainLWOfficer extends XComGameState_HeadquartersProjectTrainRookie config (LW_OfficerPack);

//var() name NewClassName; // the name of the class the rookie will eventually be promoted to
var name AbilityName;	// name of the ability being trained
var int NewRank;		// the new officer rank to be achieved

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
	return int(class'LWOfficerUtilities'.static.GetOfficerTrainingDays(NewRank) * 24.0);
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
	local XComHeadquartersCheatManager CheatMgr;
	local XComGameState_HeadquartersXCom XComHQ, NewXComHQ;
	local XComGameState_Unit Unit;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit_LWOfficer OfficerState;
	local XComGameState UpdateState;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local SoldierClassAbilityType Ability;
	local ClassAgnosticAbility NewOfficerAbility;
	local XComGameState_HeadquartersProjectTrainLWOfficer ProjectState;
	local XComGameState_StaffSlot StaffSlotState;

	Ability.AbilityName = AbilityName;
	Ability.ApplyToWeaponSlot = eInvSlot_Unknown;
	Ability.UtilityCat = '';
	NewOfficerAbility.AbilityType = Ability;
	NewOfficerAbility.iRank = 0;
	NewOfficerAbility.bUnlocked = true;

	History = `XCOMHISTORY;
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ProjectFocus.ObjectID));
	
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("LW Officer Training Complete");
	UpdateState = History.CreateNewGameState(true, ChangeContainer);
	UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));

	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
	OfficerState = XComGameState_Unit_LWOfficer(UpdateState.CreateStateObject(class'XComGameState_Unit_LWOfficer', OfficerState.ObjectID));

	OfficerState.SetOfficerRank(NewRank);
	
	UpdatedUnit = class'LWOfficerUtilities'.static.AddInitialAbilities(UpdatedUnit, OfficerState, UpdateState);

	OfficerState.LastAbilityTrainedName = OfficerState.AbilityTrainingName;
	//OfficerState.SetRankTraining(-1, '');
	//UpdatedUnit.AWCAbilities.AddItem(NewOfficerAbility);
	OfficerState.OfficerAbilities.AddItem(NewOfficerAbility);
	UpdatedUnit.SetStatus(eStatus_Active);

	//ProjectState = XComGameState_HeadquartersProjectTrainLWOfficer(`XCOMHISTORY.GetGameStateForObjectID(ProjectRef.ObjectID));
	ProjectState = XComGameState_HeadquartersProjectTrainLWOfficer(`XCOMHISTORY.GetGameStateForObjectID(GetReference().ObjectID));
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
	UpdateState.AddStateObject(OfficerState);
	UpdateState.AddStateObject(ProjectState);
	`GAMERULES.SubmitGameState(UpdateState);

	CheatMgr = XComHeadquartersCheatManager(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().CheatManager);
	if (CheatMgr == none || !CheatMgr.bGamesComDemo)
	{
		UITrainingComplete(ProjectFocus);
	}
}

function UITrainingComplete(StateObjectReference UnitRef)
{
	local UIAlert_LWOfficerTrainingComplete Alert;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPres;

	Alert = HQPres.Spawn(class'UIAlert_LWOfficerTrainingComplete', HQPres);
	//Alert.eAlert = eAlert_TrainingComplete; // UIAlert.eAlert deprecated in WOTC. Now eAlertName of type Name
	//Alert.UnitInfo.UnitRef = UnitRef;
	//Alert.fnCallback = TrainingCompleteCB;
	//Alert.SoundToPlay = "Geoscape_CrewMemberLevelledUp";
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
			GoToArmoryLWOfficerPromotion(UnitRef, true);
		}
		else
		{
			`GAME.GetGeoscape().Resume();
		}
	}
}

simulated function GoToArmoryLWOfficerPromotion(StateObjectReference UnitRef, optional bool bInstantb = false)
{
	//local XComGameState_HeadquartersXCom XComHQ;
	//local XComGameState_FacilityXCom ArmoryState;
	local UIArmory_LWOfficerPromotion OfficerScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPres;
	
	if (`GAME.GetGeoscape().IsScanning())
		HQPres.StrategyMap2D.ToggleScan();

	//call Armory_MainMenu to populate pawn data
	if(HQPres.ScreenStack.IsNotInStack(class'UIArmory_MainMenu'))
		UIArmory_MainMenu(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_MainMenu', HQPres), HQPres.Get3DMovie())).InitArmory(UnitRef,,,,,, bInstant);


	OfficerScreen = UIArmory_LWOfficerPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWOfficerPromotion', HQPres), HQPres.Get3DMovie()));
	OfficerScreen.InitPromotion(UnitRef, bInstant);
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}

//---------------------------------------------------------------------------------------
//  FILE:    UIChooseAWCAbility_LW.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Allows selection of one of three AWC abilities to train
//           
//---------------------------------------------------------------------------------------

class UIChooseAWCAbility_LW extends UISimpleCommodityScreen;

var array<SoldierAbilityInfo> m_arrAbilities;
var array<int> m_arrAbilityLevels;

var StateObjectReference m_UnitRef; // set in XComHQPresentationLayer
var StateObjectReference m_StaffSlotRef; // set in XComHQPresentationLayer

var bool bInArmory;

//-------------- EVENT HANDLING --------------------------------------------------------
simulated function OnPurchaseClicked(UIList kList, int itemIndex)
{
	if (itemIndex != iSelectedItem)
	{
		iSelectedItem = itemIndex;
	}

	if (CanAffordItem(iSelectedItem))
	{
		if (OnAbilitySelected(iSelectedItem))
			Movie.Stack.Pop(self);
		//UpdateData();
	}
	else
	{
		class'UIUtilities_Sound'.static.PlayNegativeSound();
	}
}

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local UIArmory_AWCExpandedPromotion_LW PromotionScreen;
	local UIScreenStack ScreenStack;

	ScreenStack = `SCREENSTACK;
	PromotionScreen = UIArmory_AWCExpandedPromotion_LW(ScreenStack.GetScreen(class'UIArmory_AWCExpandedPromotion_LW'));
	if(PromotionScreen != none)
	{
		bInArmory = true;
		CameraTag = name(PromotionScreen.GetPromotionBlueprintTag(PromotionScreen.UnitReference));
		DisplayTag = name(PromotionScreen.GetPromotionBlueprintTag(PromotionScreen.UnitReference));
		PromotionScreen.Hide();
	}
	else
	{
		CameraTag = 'UIDisplay_Academy'; 
		DisplayTag = 'UIDisplay_Academy'; 
	}
	super.InitScreen(InitController, InitMovie, InitName);

	ItemCard.Hide();
}

simulated function bool CanAffordItem(int ItemIndex)
{
	local int AbilityIdx;
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(History.GetGameStateForObjectID(m_UnitRef.ObjectID));

	//find the m_arrAbility entry that matches the Ability Commodity
	for (AbilityIdx = 0; AbilityIdx < 3; AbilityIdx++)
	{
		if (arrItems[ItemIndex].Title == m_arrAbilities[AbilityIdx].AbilityTemplate.LocFriendlyName)
		{
			break;
		}
	}
	if (Unit.GetSoldierRank() <= m_arrAbilities[AbilityIdx].iRank)
	{
		return false;
	}
	return true;
}

simulated function PopulateData()
{
	local Commodity Template;
	local int i;
	local UIInventory_ClassListItem ListItem;

	List.ClearItems();
	List.bSelectFirstAvailable = false;

	for (i = 0; i < arrItems.Length; i++)
	{
		Template = arrItems[i];
		if (i < m_arrRefs.Length)
		{
			ListItem = Spawn(class'UIInventory_ClassListItem', List.itemContainer);
			ListItem.InitInventoryListCommodity(Template, m_arrRefs[i], GetButtonString(i), m_eStyle, , 125);
		}
		else
		{
			ListItem = Spawn(class'UIInventory_ClassListItem', List.itemContainer);
			ListItem.InitInventoryListCommodity(Template, , GetButtonString(i), m_eStyle, , 125);
		}


		if (!CanAffordItem(i))
		{
			ListItem.SetDisabled(true, class'UIArmory_AWCExpandedPromotion_LW'.default.m_strAbilityLockedDescription);
		}
	}
}

simulated function PopulateResearchCard(optional Commodity ItemCommodity, optional StateObjectReference ItemRef)
{
}

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function GetItems()
{
	arrItems = ConvertAbilitiesToCommodities();
}

simulated function array<Commodity> ConvertAbilitiesToCommodities()
{
	local X2AbilityTemplate AbilityTemplate;
	local int iAbility;
	local array<Commodity> arrCommodoties;
	local Commodity AbilityComm;

	m_arrAbilities.Remove(0, m_arrAbilities.Length);
	m_arrAbilities = GetAbilities();

	for (iAbility = 0; iAbility < m_arrAbilities.Length; iAbility++)
	{
		AbilityTemplate = m_arrAbilities[iAbility].AbilityTemplate;
		
		if (AbilityTemplate != none)
		{
			AbilityComm.Title = AbilityTemplate.LocFriendlyName;
			AbilityComm.Image = AbilityTemplate.IconImage;
			AbilityComm.Desc = AbilityTemplate.GetMyLongDescription(, XComGameState_Unit(History.GetGameStateForObjectID(m_UnitRef.ObjectID)));
			AbilityComm.OrderHours = GetAbilityOrderDays(iAbility);

			arrCommodoties.AddItem(AbilityComm);
		}
	}

	return arrCommodoties;
}

simulated function int GetAbilityOrderDays(int iAbility)
{
	local float BaseTrainingHours;
	local XComGameState_Unit Unit;


	BaseTrainingHours = class'LWAWCUtilities'.static.GetAWCTrainingDays(m_arrAbilityLevels[iAbility]) * 24.0;
	if (AWCTrainingType(m_arrAbilities[iAbility].iBranch)  == AWCTT_Pistol)
	{
		BaseTrainingHours *= class'LWAWCUtilities'.default.PistolTrainingMultiplier;
	}

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(m_UnitRef.ObjectID));
	if (Unit.HasSoldierAbility('QuickStudy'))
	{
		BaseTrainingHours *= class'LWAWCUtilities'.default.QuickStudyTrainingMultiplier;
	}

	return int(BaseTrainingHours);
}

simulated function String GetButtonString(int ItemIndex)
{
	return m_strBuy;
}

//-----------------------------------------------------------------------------

simulated function array<SoldierAbilityInfo> GetAbilities()
{
	local array<SoldierAbilityInfo> SoldierAbilities;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_AWC_LW AWCState;
	local X2AbilityTemplateManager AbilityTemplateManager;

	m_arrAbilityLevels.Length = 0;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(m_UnitRef.ObjectID));
	AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	SoldierAbilities.AddItem(GetFirstAvailableAWCAbility(AWCState.OffenseAbilities, AbilityTemplateManager, 0));
	SoldierAbilities.AddItem(GetFirstAvailableAWCAbility(AWCState.PistolAbilities, AbilityTemplateManager, 1));
	SoldierAbilities.AddItem(GetFirstAvailableAWCAbility(AWCState.DefenseAbilities, AbilityTemplateManager, 2));

	return SoldierAbilities;
}

function SoldierAbilityInfo GetFirstAvailableAWCAbility(array<ClassAgnosticAbility> AbilityList, X2AbilityTemplateManager Mgr, int Branch)
{
	local ClassAgnosticAbility AWCAbility;
	local SoldierAbilityInfo SoldierAbility;
	local X2AbilityTemplate AbilityTemplate;
	local int Count;

	foreach AbilityList(AWCAbility, Count)
	{
		if(!AWCAbility.bUnlocked)
		{
			AbilityTemplate = Mgr.FindAbilityTemplate(AWCAbility.AbilityType.AbilityName);
			if(AbilityTemplate != none)
			{
				m_arrAbilityLevels[Branch] = AWCAbility.iRank;
				SoldierAbility.AbilityTemplate = AbilityTemplate;
				SoldierAbility.iRank = Count;
				SoldierAbility.iBranch = Branch;
				return SoldierAbility;
			}
		}
	}
}

function bool OnAbilitySelected(int iOption)
{
	local XComGameState NewGameState;
	local XComGameState_StaffSlot StaffSlotState;
	local XComGameState_HeadquartersProjectTrainAWC_LW TrainAWCProject;
	local StaffUnitInfo UnitInfo;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit_AWC_LW AWCState;
	local Commodity AbilityComm;
	local int AbilityIdx;
	
	StaffSlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(m_StaffSlotRef.ObjectID));

	if (StaffSlotState != none)
	{
		AbilityComm = arrItems[iOption];
		//find the m_arrAbility entry that matches the Ability Commodity
		for (AbilityIdx = 0; AbilityIdx < 3; AbilityIdx++)
		{
			if (AbilityComm.Title == m_arrAbilities[AbilityIdx].AbilityTemplate.LocFriendlyName)
			{
				break;
			}
		}
		if (AbilityIdx == 3)
		{
			`REDSCREEN("Could not find ability to match ability commodity.");
			return true; // didn't find a matching ability
		}

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Staffing Train AWC Slot");
		UnitInfo.UnitRef = m_UnitRef;
		StaffSlotState.FillSlot(UnitInfo, NewGameState);

		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
		AWCState =  class'LWAWCUtilities'.static.GetAWCComponent(UnitState);
		
		// Start a new AWC ability training project
		TrainAWCProject = XComGameState_HeadquartersProjectTrainAWC_LW(NewGameState.CreateStateObject(class'XComGameState_HeadquartersProjectTrainAWC_LW'));
		NewGameState.AddStateObject(TrainAWCProject);
		TrainAWCProject.TrainingIndex = m_arrAbilities[AbilityIdx].iRank; 
		TrainAWCProject.TrainingOption = AWCTrainingType(m_arrAbilities[AbilityIdx].iBranch);
		TrainAWCProject.NewLevel = m_arrAbilityLevels[AbilityIdx];
		TrainAWCProject.AbilityName = m_arrAbilities[AbilityIdx].AbilityTemplate.DataName;
		TrainAWCProject.SetProjectFocus(UnitInfo.UnitRef, NewGameState, StaffSlotState.Facility);

		AWCState = XComGameState_Unit_AWC_LW(NewGameState.CreateStateObject(class'XComGameState_Unit_AWC_LW', AWCState.ObjectID));
		NewGameState.AddStateObject(AWCState);
		AWCState.AbilityTrainingName = TrainAWCProject.AbilityName;

		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		XComHQ.Projects.AddItem(TrainAWCProject.GetReference());

		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

		`XSTRATEGYSOUNDMGR.PlaySoundEvent("StrategyUI_Staff_Assign");

	}
	if (bInArmory)
	{
		CloseScreen();
	}
	else
	{
		RefreshFacility();
	}
	return true;
}

simulated function RefreshFacility()
{
	local UIScreen QueueScreen;

	QueueScreen = Movie.Stack.GetScreen(class'UIFacility_TrainingCenter');
	if (QueueScreen != None)
		UIFacility_TrainingCenter(QueueScreen).RealizeFacility();
}

//----------------------------------------------------------------
simulated function OnCancelButton(UIButton kButton) { OnCancel(); }
simulated function OnCancel()
{
	CloseScreen();
}

simulated function CloseScreen()
{
	local UIArmory_AWCExpandedPromotion_LW PromotionScreen;
	local UIScreenStack ScreenStack;

	ScreenStack = `SCREENSTACK;
	PromotionScreen = UIArmory_AWCExpandedPromotion_LW(ScreenStack.GetScreen(class'UIArmory_AWCExpandedPromotion_LW'));
	if(PromotionScreen != none)
	{
		PromotionScreen.Header.PopulateData();
		PromotionScreen.Show();
	}
	super.CloseScreen();	
}

//==============================================================================

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	`HQPRES.m_kAvengerHUD.NavHelp.AddBackButton(OnCancel);
}

defaultproperties
{
	InputState = eInputState_Consume;

	bHideOnLoseFocus = true;
	bSelectFirstAvailable = false;
	//bConsumeMouseEvents = true;

	//DisplayTag = "UIDisplay_Academy"
	//CameraTag = "UIDisplay_Academy"
}

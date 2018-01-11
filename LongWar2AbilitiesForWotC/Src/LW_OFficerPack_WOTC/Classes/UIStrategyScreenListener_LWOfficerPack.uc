//---------------------------------------------------------------------------------------
//  FILE:    UIStrategyScreenListener_LWOfficerPack
//  AUTHOR:  Amineri (Long War Studios)
//
//  PURPOSE: Implements nuclear option to replace XComHQPresentationLayer in order to provide alternative implementation of UISquadSelect
//
//--------------------------------------------------------------------------------------- 

class UIStrategyScreenListener_LWOfficerPack extends UIScreenListener;

struct PanelIconPair
{
	var UIPanel Panel;
	var UIIcon Icon;
};

var bool bRegisteredForEvents;

var array<PanelIconPair> OfficerIcons_SquadSelect;

var UIArmory_MainMenu ArmoryMainMenu;
var UIListItemString LeaderAbilityButton;
var delegate<OnItemSelectedCallback> NextOnSelectionChanged;

delegate OnItemSelectedCallback(UIList _list, int itemIndex);

private function bool IsInStrategy()
{
	return `HQGAME  != none && `HQPC != None && `HQPRES != none;
}

event OnInit(UIScreen Screen)
{
	if(IsInStrategy() && !bRegisteredForEvents)
	{
		RegisterForEvents();
		bRegisteredForEvents = true;
	}
}

function RegisterForEvents()
{
	local X2EventManager EventManager;
	local Object ThisObj;

	ThisObj = self;

	EventManager = `XEVENTMGR;

	EventManager.RegisterForEvent(ThisObj, 'EnterSquadSelect', RemoveInvalidSoldiers); // hook to remove invalid soldiers if someone in squad became on officer since last time
	EventManager.RegisterForEvent(ThisObj, 'OnValidateDeployableSoldiers', ValidateDeployableSoldiersForOfficer); // hook to prevent second officer on mission

	EventManager.RegisterForEvent(ThisObj, 'OnUpdateSquadSelect_ListItem', AddOfficerIcon_SquadSelectListItem); // hook to add officer icon to SquadSelect_ListItem

	EventManager.RegisterForEvent(ThisObj, 'OnSoldierListItemUpdateDisabled', SetDisabledOfficerListItems);  // hook to disable selecting officers if officer already on mission
	EventManager.RegisterForEvent(ThisObj, 'OnSoldierListItemUpdate_End', AddOfficerIcon_PersonnelListItem); // hook to add officer icon to soldier list items in UIPersonnel
	EventManager.RegisterForEvent(ThisObj, 'OnSoldierListItem_GetPersonnelStatus', CheckOfficerMissionStatus); // hook to override status for officers prevented from going on mission

	EventManager.RegisterForEvent(ThisObj, 'OnArmoryMainMenuUpdate', AddArmoryMainMenuItem);

	EventManager.RegisterForEvent(ThisObj, 'OnDismissSoldier', CleanUpComponentStateOnDismiss);
}

function EventListenerReturn AddArmoryMainMenuItem(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData) // Added CallbackData
{
	local UIList List;
	local XComGameState_Unit Unit;

	`LOG("AddArmoryMainMenuItem: Starting.");

	List = UIList(EventData);
	if(List == none)
	{
		`REDSCREEN("Add Armory MainMenu event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	ArmoryMainMenu = UIArmory_MainMenu(EventSource);
	if(ArmoryMainMenu == none)
	{
		`REDSCREEN("Add Armory MainMenu event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ArmoryMainMenu.UnitReference.ObjectID));

	// -------------------------------------------------------------------------------
	// Leader Abilities: 
	if (class'LWOfficerUtilities'.static.IsOfficer(Unit) || class'UIArmory_LWOfficerPromotion'.default.ALWAYSSHOW) 
	{
		LeaderAbilityButton = ArmoryMainMenu.Spawn(class'UIListItemString', List.ItemContainer).InitListItem(CAPS(class'X2EventListener_LWOfficer_ArmoryMainMenu'.default.strOfficerMenuOption));
		LeaderAbilityButton.ButtonBG.OnClickedDelegate = OnOfficerButtonCallback;
		if(NextOnSelectionChanged == none)
		{
		 	NextOnSelectionChanged = List.OnSelectionChanged;
			List.OnSelectionChanged = OnSelectionChanged;
		}
		List.MoveItemToBottom(FindDismissListItem(List));
	}
	return ELR_NoInterrupt;
}

//callback handler for list button -- invokes the LW officer ability UI
simulated function OnOfficerButtonCallback(UIButton kButton)
{
	local XComHQPresentationLayer HQPres;
	local UIArmory_LWOfficerPromotion OfficerScreen;

	HQPres = `HQPRES;
	OfficerScreen = UIArmory_LWOfficerPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWOfficerPromotion', HQPres), HQPres.Get3DMovie()));
	OfficerScreen.InitPromotion(ArmoryMainMenu.GetUnitRef(), false);
}

//callback handler for list button info at bottom of screen
simulated function OnSelectionChanged(UIList ContainerList, int ItemIndex)
{
	if (ContainerList.GetItem(ItemIndex) == LeaderAbilityButton) 
	{
		ArmoryMainMenu.MC.ChildSetString("descriptionText", "htmlText", class'UIUtilities_Text'.static.AddFontInfo(class'X2EventListener_LWOfficer_ArmoryMainMenu'.default.OfficerListItemDescription, true));
		return;
	}
	NextOnSelectionChanged(ContainerList, ItemIndex);
}

simulated function UIListItemString FindDismissListItem(UIList List)
{
	local int Idx;
	local UIListItemString Current;

	for (Idx = 0; Idx < List.ItemCount ; Idx++)
	{
		Current = UIListItemString(List.GetItem(Idx));
		//`log("Dismiss Search: Text=" $ Current.Text $ ", DismissName=" $ ArmoryMainMenu.m_strDismiss);
		if (Current.Text == ArmoryMainMenu.m_strDismiss)
			return Current;
	}
	return none;
}

function EventListenerReturn RemoveInvalidSoldiers(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData) // Added CallbackData
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local int idx;
	local bool bFoundOfficer;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	XComHQ = `XCOMHQ;
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	for(idx = XComHQ.Squad.Length - 1; idx >= 0; idx--)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[idx].ObjectID));
		if(UnitState != none)
		{
			if(class'LWOfficerUtilities'.static.IsOfficer(UnitState))
			{
				if(!bFoundOfficer)
					bFoundOfficer = true;
				else
				{
					XComHQ.Squad.Remove(idx, 1);
				}
			}
		}
	}
	NewGameState.AddStateObject(XComHQ);
	return ELR_NoInterrupt;
}

function EventListenerReturn ValidateDeployableSoldiersForOfficer(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData) // Added CallbackData
{
	local int idx;
	local LWTuple DeployableSoldiers;
	local UISquadSelect SquadSelect;
	local XComGameState_Unit UnitState;
	local GeneratedMissionData MissionData;
	local bool bAllowWoundedSoldiers;

	DeployableSoldiers = LWTuple(EventData);
	if(DeployableSoldiers == none)
	{
		`REDSCREEN("Validate Deployable Soldiers event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	SquadSelect = UISquadSelect(EventSource);
	if(SquadSelect == none)
	{
		`REDSCREEN("Validate Deployable Soldiers event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}

	MissionData = SquadSelect.XComHQ.GetGeneratedMissionData(SquadSelect.XComHQ.MissionRef.ObjectID);
	bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;

	if(!class'LWOfficerUtilities'.static.HasOfficerInSquad(SquadSelect.XComHQ) || bAllowWoundedSoldiers)
		return ELR_NoInterrupt;

	if(DeployableSoldiers.Id != 'DeployableSoldiers')
		return ELR_NoInterrupt;

	for(idx = DeployableSoldiers.Data.Length - 1; idx >= 0; idx--)
	{
		if(DeployableSoldiers.Data[idx].kind == LWTVObject)
		{
			UnitState = XComGameState_Unit(DeployableSoldiers.Data[idx].o);
			if(UnitState != none)
			{
				if(class'LWOfficerUtilities'.static.IsOfficer(UnitState))
				{
					DeployableSoldiers.Data.Remove(idx, 1);
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn AddOfficerIcon_SquadSelectListItem(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData) // Added CallbackData
{
	local XComGameState_Unit Unit;
	local UISquadSelect_ListItem ListItem;
	local PanelIconPair NewIcon;
	local int idx;

	ListItem = UISquadSelect_ListItem(EventSource);
	if(ListItem == none)
	{
		`REDSCREEN("Add Officer Icon event triggered with invalid source.");
		return ELR_NoInterrupt;
	}

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ListItem.GetUnitRef().ObjectID));
	
	idx = OfficerIcons_SquadSelect.Find('Panel', ListItem);
	if (class'LWOfficerUtilities'.static.IsOfficer(Unit))
	{
		if(idx == -1)
		{
			NewIcon.Panel = ListItem;
			NewIcon.Icon = ListItem.Spawn(class'UIIcon', ListItem.DynamicContainer).InitIcon('abilityIcon1MC', class'LWOfficerUtilities'.static.GetGenericIcon(), false, true, 18);
			NewIcon.Icon.Hide();
			NewIcon.Icon.OriginBottomRight();
			NewIcon.Icon.SetPosition(50.5, 265);
			OfficerIcons_SquadSelect.AddItem(NewIcon);
			idx = OfficerIcons_SquadSelect.Length-1;
		}
		OfficerIcons_SquadSelect[idx].Icon.Show();
	} else {
		if(idx != -1)
			OfficerIcons_SquadSelect[idx].Icon.Hide();
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn SetDisabledOfficerListItems(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData) // Added CallbackData
{
	local XComGameState_HeadquartersXCom XComHQ;
	local UIPersonnel_ListItem ListItem;
	local XComGameState_Unit Unit;
	local GeneratedMissionData MissionData;
	local bool bAllowWoundedSoldiers;

	//only do this for squadselect
	if(!IsInSquadSelect())
		return ELR_NoInterrupt;

	ListItem = UIPersonnel_ListItem(EventData);
	if(ListItem == none)
	{
		`REDSCREEN("Set Disabled Officer List Items event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	XComHQ = `XCOMHQ;
	MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);
	bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ListItem.UnitRef.ObjectID));
	if(Unit != none)
	{
		if(class'LWOfficerUtilities'.static.IsOfficer(Unit) && class'LWOfficerUtilities'.static.HasOfficerInSquad() && !bAllowWoundedSoldiers)
			ListItem.SetDisabled(true);
	}
	return ELR_NoInterrupt;
}

function bool IsInSquadSelect()
{
	local int Index;
	local UIScreenStack ScreenStack;

	ScreenStack = `SCREENSTACK;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if( ScreenStack.Screens[Index].IsA('UISquadSelect') )
			return true;
	}
	return false; 
}

function EventListenerReturn AddOfficerIcon_PersonnelListItem(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData) // Added CallbackData
{
	local XComGameState_Unit Unit;
	local UIPersonnel_SoldierListItem ListItem;
	//local int SlotIndex;
	local UIIcon OfficerIcon;
	
	ListItem = UIPersonnel_SoldierListItem(EventData);
	if(ListItem == none)
	{
		`REDSCREEN("Set Disabled Officer List Items event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ListItem.UnitRef.ObjectID));
	if (class'LWOfficerUtilities'.static.IsOfficer(Unit))
	{
		OfficerIcon = ListItem.Spawn(class'UIIcon', ListItem).InitIcon('abilityIcon1MC', class'LWOfficerUtilities'.static.GetGenericIcon(), false, true, 18);
		OfficerIcon.OriginTopLeft();
		OfficerIcon.SetPosition(101, 24);
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn CheckOfficerMissionStatus(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData) // Added CallbackData
{
	local LWTuple PersonnelStrings;
	local UIPersonnel_SoldierListItem ListItem;
	local XComGameState_HeadquartersXCom HQState;
	local bool bUnitInSquad, bAllowWoundedSoldiers;
	local GeneratedMissionData MissionData;
	local XComGameState_Unit Unit;

	//only do this for squadselect
	if(!IsInSquadSelect())
		return ELR_NoInterrupt;

	PersonnelStrings = LWTuple(EventData);
	if(PersonnelStrings == none)
	{
		`REDSCREEN("Check Officer MissionStatus event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	ListItem = UIPersonnel_SoldierListItem(EventSource);
	if(ListItem == none)
	{
		`REDSCREEN("Check Officer MissionStatus event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}

	HQState = `XCOMHQ;
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ListItem.UnitRef.ObjectID));
	bUnitInSquad = HQState.IsUnitInSquad(Unit.GetReference());
	MissionData = HQState.GetGeneratedMissionData(HQState.MissionRef.ObjectID);
	bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;

	if(Unit != none && PersonnelStrings.Id == 'PersonnelStrings') 
	{
		if(PersonnelStrings.Data.Length == 0 || PersonnelStrings.Data[0].b != true) // not already set by another method
		{
			if (!bUnitInSquad && class'LWOfficerUtilities'.static.IsOfficer(Unit) && class'LWOfficerUtilities'.static.HasOfficerInSquad() && !bAllowWoundedSoldiers)
			{
				PersonnelStrings.Data.Add(4-PersonnelStrings.Data.Length);
				PersonnelStrings.Data[0].kind = LWTVBool;
				PersonnelStrings.Data[0].b = true;
				PersonnelStrings.Data[1].kind = LWTVString;
				PersonnelStrings.Data[2].kind = LWTVString;
				PersonnelStrings.Data[3].kind = LWTVString;
				PersonnelStrings.Data[1].s = class'UIUtilities_Text'.static.GetColoredText(class'UIPersonnel_ListItem_SquadSelect_LWOfficerPack'.default.strOfficerAlreadySelectedStatus, eUIState_Bad, -1);
				PersonnelStrings.Data[2].s = "";
				PersonnelStrings.Data[3].s = "";
			}
		}
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn CleanUpComponentStateOnDismiss(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData) // Added CallbackData
{
	local XComGameState_Unit UnitState, UpdatedUnit;
	local XComGameState NewGameState;
	local XComGameState_Unit_LWOfficer OfficerState, UpdatedOfficer;

	UnitState = XComGameState_Unit(EventData);
	if(UnitState == none)
		return ELR_NoInterrupt;

	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);
	if(OfficerState != none)
	{
		`LOG("LWOfficerPack: Found OfficerState, Unit=" $ UnitState.GetFullName() $ ", Removing Component.");
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("OfficerState cleanup");
		UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
		UpdatedOfficer = XComGameState_Unit_LWOfficer(NewGameState.CreateStateObject(class'XComGameState_Unit_LWOfficer', OfficerState.ObjectID));
		NewGameState.RemoveStateObject(UpdatedOfficer.ObjectID);
		UpdatedUnit.RemoveComponentObject(UpdatedOfficer);
		NewGameState.AddStateObject(UpdatedOfficer);
		NewGameState.AddStateObject(UpdatedUnit);
		if (NewGameState.GetNumGameStateObjects() > 0)
			`GAMERULES.SubmitGameState(NewGameState);
		else
			`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}
	return ELR_NoInterrupt;
}

//function bool IsDLCActive(string DLCIdentifier)
//{
	//local X2DownloadableContentInfo DLCInfo;
	//local array<X2DownloadableContentInfo> DLCInfos;
	//local XComOnlineEventMgr EventManager;
//
	//EventManager = `ONLINEEVENTMGR;
	//
	////retrieve all active DLCs
	//DLCInfos = EventManager.GetDLCInfos(false);
	//foreach DLCInfos(DLCInfo)
	//{
		//if(DLCInfo.DLCIdentifier == DLCIdentifier)
			//return true;
	//}
	//return false;
//}

// This event is triggered after a screen gains focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	if(UISquadSelect(Screen) != none)
	{
		OfficerIcons_SquadSelect.Length = 0;
	}
	if(UIArmory_MainMenu(Screen) != none)
	{
		ArmoryMainMenu = none;
		NextOnSelectionChanged = none;
	}
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
}
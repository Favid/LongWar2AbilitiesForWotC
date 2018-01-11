//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_AWCEventListener
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Implements screen listeners for hooking to other objects
//
//--------------------------------------------------------------------------------------- 

class UIScreenListener_AWCEventListener extends UIScreenListener;

struct PanelIconPair
{
	var UIPanel Panel;
	var UIIcon Icon;
};

var bool bRegisteredForEvents;

var UIArmory_MainMenu ArmoryMainMenu;
var UIListItemString AWCAbilityButton;
var delegate<OnItemSelectedCallback> NextOnSelectionChanged;

delegate OnItemSelectedCallback(UIList _list, int itemIndex);

private function bool IsInStrategy()
{
	return `HQGAME  != none && `HQPC != None && `HQPRES != none;
}

event OnInit(UIScreen Screen)
{
	//reset switch in tactical so we re-register back in strategy
	if(UITacticalHUD(Screen) == none)
	{
		RegisterForEvents();
		bRegisteredForEvents = false;
	}
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

	EventManager.UnRegisterFromAllEvents(ThisObj);
	EventManager.RegisterForEvent(ThisObj, 'OnArmoryMainMenuUpdate', AddArmoryMainMenuItem);
	EventManager.RegisterForEvent(ThisObj, 'PreRollForAWCAbility', UpdateUnitAWCAbilities);
	//EventManager.RegisterForEvent(ThisObj, 'ModifyEarnedSoldierAbilities', ModifyEarnedSoldierAbilities,,,,true);
}

//function EventListenerReturn ModifyEarnedSoldierAbilities(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID)
//{
	//local XComLWTuple OverrideTuple;
	//local XComGameState_Unit Unit;
	//local XComGameState_Unit_AWC_LW AWCState;
	//local X2EarnedAbilityContainer AbilityContainer;
	//local ClassAgnosticAbility Ability;
//
	////`LOG("AWCPack / ModifyEarnedSoldierAbilities: Starting.");
//
	//OverrideTuple = XComLWTuple(EventData);
	//if(OverrideTuple == none)
	//{
		//`REDSCREEN("ModifyEarnedSoldierAbilities event triggered with invalid event data.");
		//return ELR_NoInterrupt;
	//}
	//Unit = XComGameState_Unit(EventSource);
	//if(Unit == none)
	//{
		//`REDSCREEN("ModifyEarnedSoldierAbilities event triggered with invalid event source.");
		//return ELR_NoInterrupt;
	//}
//
	//AbilityContainer = X2EarnedAbilityContainer(OverrideTuple.Data[0].o);
	//if(AbilityContainer == none)
		//`REDSCREEN("ModifyEarnedSoldierAbilities event has null X2EarnedAbilityContainer");
//
	//AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);
	//if (AWCState != none)
	//{
		////Modify the EarnedAbilities with the AWC abilities from the AWCState
		//foreach AWCState.OffenseAbilities(Ability)
		//{
			//if(Ability.bUnlocked)
				//AbilityContainer.EarnedAbilities.AddItem(Ability.AbilityType);
		//}
//
		//foreach AWCState.DefenseAbilities(Ability)
		//{
			//if(Ability.bUnlocked)
				//AbilityContainer.EarnedAbilities.AddItem(Ability.AbilityType);
		//}
//
		//foreach AWCState.PistolAbilities(Ability)
		//{
			//if(Ability.bUnlocked)
				//AbilityContainer.EarnedAbilities.AddItem(Ability.AbilityType);
		//}
		//
	//}
//
	//return ELR_NoInterrupt;
//}

function EventListenerReturn UpdateUnitAWCAbilities(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideTuple;
	local XComGameState_Unit Unit; //, UpdatedUnit;
	//local XComGameState_Unit_AWC_LW AWCState;
	//local XComGameState UpdateGameState;

	//`LOG("AWCPack / UpdateUnitAWCAbilities: Starting.");

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("PreRollForAWCAbility event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	Unit = XComGameState_Unit(EventSource);
	if(Unit == none)
	{
		`REDSCREEN("PreRollForAWCAbility event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	//disable the existing AWC random ability
	OverrideTuple.Data[0].b = true;

	return ELR_NoInterrupt;
}

function EventListenerReturn AddArmoryMainMenuItem(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local UIList List;
	local XComGameState_Unit Unit;
	local XComGameState_HeadquartersXCom XCOMHQ;

	//`LOG("AWCPack / AddArmoryMainMenuItem: Starting.");

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

	XCOMHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	// -------------------------------------------------------------------------------
	// AWC Abilities: 
	if ((class'LWAWCUtilities'.static.GetAWCComponent(Unit) != none && XCOMHQ.HasFacilityByName('RecoveryCenter')) || class'UIArmory_AWCExpandedPromotion_LW'.default.ALWAYSSHOW) 
	{
		AWCAbilityButton = ArmoryMainMenu.Spawn(class'UIListItemString', List.ItemContainer).InitListItem(CAPS(class'LWAWCUtilities'.default.strAWCMenuOption));
		AWCAbilityButton.MCName = 'ArmoryMainMenu_AWCAbilityButton_LW';
		AWCAbilityButton.ButtonBG.OnClickedDelegate = OnAWCButtonCallback;
		if(NextOnSelectionChanged == none)
		{
		 	NextOnSelectionChanged = List.OnSelectionChanged;
			List.OnSelectionChanged = OnSelectionChanged;
		}
		List.MoveItemToBottom(FindDismissListItem(List));
	}
	return ELR_NoInterrupt;
}

//callback handler for list button -- invokes the AWC ability UI
simulated function OnAWCButtonCallback(UIButton kButton)
{
	local XComHQPresentationLayer HQPres;
	local UIArmory_AWCExpandedPromotion_LW AWCScreen;

	HQPres = `HQPRES;
	AWCScreen = UIArmory_AWCExpandedPromotion_LW(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_AWCExpandedPromotion_LW', HQPres), HQPres.Get3DMovie()));
	AWCScreen.InitPromotion(ArmoryMainMenu.GetUnitRef(), false);
}

//callback handler for list button info at bottom of screen
simulated function OnSelectionChanged(UIList ContainerList, int ItemIndex)
{
	if (ContainerList.GetItem(ItemIndex) == AWCAbilityButton) 
	{
		ArmoryMainMenu.MC.ChildSetString("descriptionText", "htmlText", class'UIUtilities_Text'.static.AddFontInfo(class'LWAWCUtilities'.default.strAWCListItemDescription, true));
		return;
	}
	NextOnSelectionChanged(ContainerList, ItemIndex);
}

simulated function UIListItemString FindDismissListItem(UIList List)
{

	return UIListItemString(List.GetChildByName('ArmoryMainMenu_DismissButton', false));
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
}
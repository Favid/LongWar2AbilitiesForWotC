class X2EventListener_LWOfficer_ArmoryMainMenu extends X2EventListener;

var localized string strOfficerMenuOption;
var localized string strOfficerTooltip;
var localized string OfficerListItemDescription;

var delegate<OnItemSelectedCallback> NextOnSelectionChanged;
delegate OnItemSelectedCallback(UIList _list, int itemIndex);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateMainMenuListenerTemplate());

	return Templates;
}

static function CHEventListenerTemplate CreateMainMenuListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'AddLWOfficerPerkOptionListener');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OnArmoryMainMenuUpdate', OnArmoryMainMenuUpdate, ELD_Immediate);
	`LOG("Register Event OnArmoryMainMenuUpdate",, 'LW_OfficerPack_WOTC');

	return Template;
}

static function EventListenerReturn OnArmoryMainMenuUpdate(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local UIList List;
	local UIArmory_MainMenu MainMenu;
	local XComGameState_Unit UnitState;
	local UIListItemString OfficerListItem;

	`LOG(GetFuncName(),, 'LW_OfficerPack_WOTC');
	
	List = UIList(EventData);
	MainMenu = UIArmory_MainMenu(EventSource);	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(MainMenu.GetUnitRef().ObjectID));

	if (class'LWOfficerUtilities'.static.IsOfficer(UnitState) || class'UIArmory_LWOfficerPromotion'.default.ALWAYSSHOW) 
	{
		//link in selection-change info
		//NextOnSelectionChanged = List.OnSelectionChanged;
		//List.OnSelectionChanged = OnSelectionChanged;
		
		//OfficerListItem = UIListItemString_SelfContained(MainMenu.Spawn(class'UIListItemString_SelfContained', List.ItemContainer).InitListItem(Caps(strOfficerMenuOption)).SetDisabled(false, strOfficerTooltip));
		OfficerListItem = MainMenu.Spawn(class'UIListItemString', List.ItemContainer).InitListItem(Caps(default.strOfficerMenuOption)).SetDisabled(false, default.strOfficerTooltip);
		OfficerListItem.ButtonBG.OnClickedDelegate = OnOfficerButtonCallback;
	}

	//if(NextOnSelectionChanged == none)
	//{
	// 	NextOnSelectionChanged = List.OnSelectionChanged;
	//	List.OnSelectionChanged = OnSelectionChanged;
	//}
	List.MoveItemToBottom(FindDismissListItem(List));
	
	class'LWOfficerUtilities'.static.GCandValidationChecks();

	return ELR_NoInterrupt;
}

//callback handler for list button -- invokes the LW officer ability UI
simulated function OnOfficerButtonCallback(UIButton kButton)
{
	local XComHQPresentationLayer HQPres;
	local UIArmory_LWOfficerPromotion OfficerScreen;
	local StateObjectReference UnitRef;

	HQPres = `HQPRES;
	UnitRef = UIArmory_MainMenu(HQPres.ScreenStack.GetScreen(class'UIArmory_MainMenu')).GetUnitRef();
	
	OfficerScreen = UIArmory_LWOfficerPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWOfficerPromotion', HQPres), HQPres.Get3DMovie()));
	OfficerScreen.InitPromotion(UnitRef, false);
}

simulated static function UIListItemString FindDismissListItem(UIList List)
{
	return UIListItemString(List.GetChildByName('ArmoryMainMenu_DismissButton', false));
}
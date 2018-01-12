//---------------------------------------------------------------------------------------
//  FILE:    UIAlert_AWCTrainingComplete_LW.uc
//  AUTHOR:  Amineri
//  PURPOSE: Customized UI Alert for Officer training 
//           
//---------------------------------------------------------------------------------------
class UIAlert_AWCTrainingComplete_LW extends UIAlert;

//override for UIAlert child to trigger specific Alert built in this class
simulated function BuildAlert()
{
	`RedScreen("UIAlert_AWCTrainingComplete_LW BuildAlert");
	BindLibraryItem();
	BuildAWCTrainingCompleteAlert();
}

//New Alert building function
simulated function BuildAWCTrainingCompleteAlert()
{	
	local XComGameState_Unit UnitState;
	local XComGameState_Unit_AWC_LW AWCState;
	local X2AbilityTemplate TrainedAbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local string AbilityIcon, AbilityName, AbilityDescription, ClassIcon, ClassName, RankName;
	
	`RedScreen("UIAlert_AWCTrainingComplete_LW BuildAWCTrainingCompleteAlert");

	if( LibraryPanel == none )
	{
		`RedScreen("UI Problem with the alerts! Couldn't find LibraryPanel for current eAlertType: " $ eAlertName);
		return;
	}

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(DisplayPropertySet, 'UnitRef')));
	AWCState =  class'LWAWCUtilities'.static.GetAWCComponent(UnitState);

	ClassName = "";
	ClassIcon = class'LWAWCUtilities'.static.GetAWCLevelIcon(AWCState.CurrentTrainingIndex);
	RankName = Caps(class'LWAWCUtilities'.static.GetAWCLevelName(AWCState.CurrentTrainingIndex));
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	TrainedAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AWCState.LastAbilityTrainedName);

	// Ability Name
	AbilityName = TrainedAbilityTemplate.LocFriendlyName != "" ? TrainedAbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for ability '" $ TrainedAbilityTemplate.DataName $ "'");

	// Ability Description
	AbilityDescription = TrainedAbilityTemplate.HasLongDescription() ? TrainedAbilityTemplate.GetMyLongDescription() : ("Missing 'LocLongDescription' for ability " $ TrainedAbilityTemplate.DataName $ "'");
	AbilityIcon = TrainedAbilityTemplate.IconImage;

	// Send over to flash
	LibraryPanel.MC.BeginFunctionOp("UpdateData");
	LibraryPanel.MC.QueueString(m_strTrainingCompleteLabel);
	LibraryPanel.MC.QueueString(GetOrStartWaitingForStaffImage()); 
	LibraryPanel.MC.QueueString(ClassIcon);
	LibraryPanel.MC.QueueString(RankName);
	LibraryPanel.MC.QueueString(UnitState.GetName(eNameType_FullNick));
	LibraryPanel.MC.QueueString(ClassName);
	LibraryPanel.MC.QueueString(AbilityIcon);
	LibraryPanel.MC.QueueString(m_strNewAbilityLabel);
	LibraryPanel.MC.QueueString(AbilityName);
	LibraryPanel.MC.QueueString(AbilityDescription);
	LibraryPanel.MC.QueueString(m_strViewSoldier);
	LibraryPanel.MC.QueueString(m_strCarryOn);
	LibraryPanel.MC.EndOp();

	if(Movie.Pres.ScreenStack.IsInStack(class'UIArmory_AWCExpandedPromotion_LW'))
		Button1.Hide();
}

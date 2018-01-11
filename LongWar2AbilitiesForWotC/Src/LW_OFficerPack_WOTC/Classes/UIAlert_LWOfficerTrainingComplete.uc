//---------------------------------------------------------------------------------------
//  FILE:    UIAlert_LWOfficerTrainingComplete.uc
//  AUTHOR:  Amineri
//  PURPOSE: Customized UI Alert for Officer training 
//           
//---------------------------------------------------------------------------------------
class UIAlert_LWOfficerTrainingComplete extends UIAlert;

//override for UIAlert child to trigger specific Alert built in this class
simulated function BuildAlert()
{
	BindLibraryItem();
	BuildOfficerTrainingCompleteAlert();
}

//New Alert building function
simulated function BuildOfficerTrainingCompleteAlert()
{

	local XComGameState_Unit UnitState;
	local XComGameState_Unit_LWOfficer OfficerState;
	local X2AbilityTemplate TrainedAbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_ResistanceFaction FactionState;
	local string AbilityIcon, AbilityName, AbilityDescription, ClassIcon, ClassName, RankName;
	
	if( LibraryPanel == none )
	{
		`RedScreen("UI Problem with the alerts! Couldn't find LibraryPanel for current eAlertName: " $ eAlertName); // eAlertType: " $ eAlert);
		return;
	}

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID( // UnitInfo.UnitRef.ObjectID)); // UnitInfo removed in WOTC, changed to part of DisplayPropertySet
		class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(DisplayPropertySet, 'UnitRef')));
	OfficerState =  class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);

	ClassName = "";
	ClassIcon = class'LWOfficerUtilities'.static.GetRankIcon(OfficerState.GetOfficerRank());
	RankName = Caps(class'LWOfficerUtilities'.static.GetLWOfficerRankName(OfficerState.GetOfficerRank()));
	
	FactionState = UnitState.GetResistanceFaction();
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	TrainedAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(OfficerState.LastAbilityTrainedName);

	// Ability Name
	AbilityName = TrainedAbilityTemplate.LocFriendlyName != "" ? TrainedAbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for ability '" $ TrainedAbilityTemplate.DataName $ "'");

	// Ability Description
	AbilityDescription = TrainedAbilityTemplate.HasLongDescription() ? TrainedAbilityTemplate.GetMyLongDescription() : ("Missing 'LocLongDescription' for ability " $ TrainedAbilityTemplate.DataName $ "'");
	AbilityIcon = TrainedAbilityTemplate.IconImage;

	// Send over to flash
	LibraryPanel.MC.BeginFunctionOp("UpdateData");
	LibraryPanel.MC.QueueString(m_strTrainingCompleteLabel);
	LibraryPanel.MC.QueueString(""); 
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
	GetOrStartWaitingForStaffImage();
	
	//bsg-crobinson (5.17.17): Buttons need to be in a different area for this screen
	Button1.OnSizeRealized = OnTrainingButtonRealized;
	Button2.OnSizeRealized = OnTrainingButtonRealized;
	//bsg-crobinson (5.17.17): end

	// Hide "View Soldier" button if player is on top of avenger, prevents ui state stack issues
	if(Movie.Pres.ScreenStack.IsInStack(class'UIArmory_LWOfficerPromotion'))
	{
		Button1.Hide();
		Button1.DisableNavigation();
	}
	
	if (FactionState != none)
		SetFactionIcon(FactionState.GetFactionIcon());
}

//simulated function string GetOrStartWaitingForOfficerStaffImage()
//{
	//local XComPhotographer_Strategy Photo;
	//local X2ImageCaptureManager CapMan;
//
	//CapMan = X2ImageCaptureManager(`XENGINE.GetImageCaptureManager());
	//Photo = `GAME.StrategyPhotographer;
//
	//StaffPicture = CapMan.GetStoredImage(UnitInfo.UnitRef, name("UnitPicture"$UnitInfo.UnitRef.ObjectID));
	//if (StaffPicture == none)
	//{
		//// if we have a photo queued then setup a callback so we can sqap in the image when it is taken
		//if (!Photo.HasPendingHeadshot(UnitInfo.UnitRef, UpdateAlertImage))
		//{
			//Photo.AddHeadshotRequest(UnitInfo.UnitRef, 'UIPawnLocation_ArmoryPhoto', 'SoldierPicture_Head_Armory', 512, 512, UpdateAlertImage, class'X2StrategyElement_DefaultSoldierPersonalities'.static.Personality_ByTheBook());
		//}
//
		//return "";
	//}
//
	//return "img:///"$PathName(StaffPicture);
//}
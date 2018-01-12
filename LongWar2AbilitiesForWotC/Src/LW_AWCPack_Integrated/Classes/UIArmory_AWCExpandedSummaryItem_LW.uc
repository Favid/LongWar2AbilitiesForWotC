//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_AWCExpandedSummaryItem_LW
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: (New) Container to hold individual items for the list showing ability summary
//
//--------------------------------------------------------------------------------------- 

class UIArmory_AWCExpandedSummaryItem_LW  extends UIPanel;

var int BGPadding;
var UIBGBox BGBox; 
var UIImage ClassIcon;
var UIICon AbilityIcon;
var UIScrollingText AbilityTitleText;
var UITextContainer AbilitySummaryText;

simulated function UIArmory_AWCExpandedSummaryItem_LW InitSummaryItem()
{
	`RedScreen("UIArmory_AWCExpandedSummaryItem_LW InitSummaryItem");
	InitPanel();
	BGBox = Spawn(class'UIBGBox', self);
	BGBox.InitPanel('', class'UIUtilities_Controls'.const.MC_X2Background).SetSize(Width, Height);

	AbilityIcon = Spawn(class'UIIcon', self);
	AbilityIcon.InitIcon('IconMC',,false, true, 26); // 'IconMC' matches instance name of control in Flash's 'AbilityItem' Symbol
	AbilityIcon.SetPosition(12, 12);

	ClassIcon = Spawn(class'UIImage', self);
	ClassIcon.InitImage();
	ClassIcon.SetPosition(10, 10);
	ClassIcon.SetSize(36, 36);
	ClassIcon.Hide();

	AbilityTitleText = Spawn(class'UIScrollingText', self).InitScrollingText(, "Title", 146,,,true);
	AbilityTitleText.SetText(class'UIUtilities_Text'.static.GetColoredText("SAMPLE VERY LONG ABILITY TITLE", eUIState_Normal, 26));

	AbilityTitleText.SetPosition(50, 13);

	AbilitySummaryText = Spawn(class'UITextContainer', self).InitTextContainer(,"",6, 48, 196, 110);

	return self;
}

simulated function SetSummaryData(string IconPath, string ClassPath, string TitleText, string SummaryText)
{
	`RedScreen("UIArmory_AWCExpandedSummaryItem_LW SetSummaryData");
	if (IconPath != "")
	{
		AbilityIcon.LoadIcon(iconPath);
		AbilityIcon.Show();
	} else {
		AbilityIcon.Hide();
	}

	if (ClassPath != "")
	{
		ClassIcon.LoadImage(ClassPath);
		ClassIcon.Show();
	} else {
		ClassIcon.Hide();
	}
	
	AbilityTitleText.SetText(TitleText);
	AbilitySummaryText.SetHTMLText(SummaryText);

	Show();
}

defaultproperties
{
	BGPadding = -6;
	Width = 214;
	Height = 168;
	bCascadeFocus = false;
}
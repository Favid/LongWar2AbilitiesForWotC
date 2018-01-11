//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_AWCExpandedPromotionItem_LW
//  AUTHOR:  Amineri
//
//  PURPOSE: Tweaked expanded ability selection UI for AWC officer system
//
//--------------------------------------------------------------------------------------- 

class UIArmory_AWCExpandedPromotionItem_LW extends UIArmory_PromotionItem;

//var int Rank;
//var name ClassName;
//var name AbilityName1;
//var name AbilityName2;
var name AbilityName3;

//var UIButton InfoButton1;
//var UIButton InfoButton2;
var UIButton InfoButton3;

//var UIIcon AbilityIcon1;
//var UIIcon AbilityIcon2;
var UIIcon AbilityIcon3;

//var UIIcon ClassIcon;

var UIText RankLabel;

//var bool bIsDisabled;
//var bool bEligibleForPromotion;

//var localized string m_strNewRank;

simulated function UIArmory_PromotionItem InitPromotionItem(int InitRank)
{
	Rank = InitRank;

	InitPanel();

	Navigator.HorizontalNavigation = true;

	AbilityIcon1 = Spawn(class'UIIcon', self).InitIcon('abilityIcon1MC');
	AbilityIcon1.ProcessMouseEvents(OnChildMouseEvent);
	AbilityIcon1.bDisableSelectionBrackets = true;
	AbilityIcon1.bAnimateOnInit = false;
	AbilityIcon1.Hide(); // starts hidden

	AbilityIcon2 = Spawn(class'UIIcon', self).InitIcon('abilityIcon2MC');
	AbilityIcon2.ProcessMouseEvents(OnChildMouseEvent);
	AbilityIcon2.bDisableSelectionBrackets = true;
	AbilityIcon2.bAnimateOnInit = false;
	AbilityIcon2.Hide(); // starts hidden

	AbilityIcon3 = Spawn(class'UIIcon', self).InitIcon('abilityIcon3MC');
	AbilityIcon3.ProcessMouseEvents(OnChildMouseEvent);
	AbilityIcon3.bDisableSelectionBrackets = true;
	AbilityIcon3.bAnimateOnInit = false;
	AbilityIcon3.Hide(); // starts hidden

	InfoButton1 = Spawn(class'UIButton', self);
	InfoButton1.bIsNavigable = false;
	InfoButton1.InitButton('infoButtonLeft');
	InfoButton1.ProcessMouseEvents(OnChildMouseEvent);
	InfoButton1.bAnimateOnInit = false;
	InfoButton1.Hide(); // starts hidden

	InfoButton2 = Spawn(class'UIButton', self);
	InfoButton2.bIsNavigable = false;
	InfoButton2.InitButton('infoButtonCenter');
	InfoButton2.ProcessMouseEvents(OnChildMouseEvent);
	InfoButton2.bAnimateOnInit = false;
	InfoButton2.Hide(); // starts hidden

	InfoButton3 = Spawn(class'UIButton', self);
	InfoButton3.bIsNavigable = false;
	InfoButton3.InitButton('infoButtonRight');
	InfoButton3.ProcessMouseEvents(OnChildMouseEvent);
	InfoButton3.bAnimateOnInit = false;
	InfoButton3.Hide(); // starts hidden

	ClassIcon = Spawn(class'UIIcon', self);
	ClassIcon.bIsNavigable = false;
	ClassIcon.InitIcon('classIconMC');
	ClassIcon.ProcessMouseEvents(OnChildMouseEvent);
	ClassIcon.bAnimateOnInit = false;
	ClassIcon.bDisableSelectionBrackets = true;
	ClassIcon.Hide(); // starts hidden

	//RankLabel = Spawn(class'UIText', self).InitText('rankLabel');
	//RankLabel.bAnimateOnInit = false;
	//RankLabel.Hide(); // starts hidden

	MC.FunctionString("setPromoteRank", class'UIArmory_PromotionItem'.default.m_strNewRank);

	return self;
}

simulated function SetDisabled(bool bDisabled)
{
	bIsDisabled = bDisabled;

	AbilityIcon1.SetDisabled(bIsDisabled);
	AbilityIcon2.SetDisabled(bIsDisabled);
	AbilityIcon3.SetDisabled(bIsDisabled);

	MC.FunctionBool("setDisabled", bIsDisabled);

	RealizeInfoButtons();
}


simulated function SetPromote3(bool bIsPromote, optional bool highlightAbility1, optional bool highlightAbility2, optional bool highlightAbility3)
{
	bEligibleForPromotion = bIsPromote;
	
	MC.BeginFunctionOp("setPromote");
	MC.QueueBoolean(bIsPromote);
	MC.QueueBoolean(highlightAbility1);
	MC.QueueBoolean(highlightAbility2);
	MC.QueueBoolean(highlightAbility3);
	MC.EndOp();
}

simulated function SetClassData(string Icon, string Label)
{
	ClassIcon.Show();
	AbilityIcon1.Hide();
	InfoButton1.Hide();
	AbilityIcon2.Hide();
	InfoButton2.Hide();

	MC.BeginFunctionOp("setClassData");
	MC.QueueString(Icon);
	MC.QueueString(Label);
	MC.EndOp();
}

simulated function SetRankData(string Icon, string Label)
{
	MC.BeginFunctionOp("setRankData");
	MC.QueueString(Icon);
	MC.QueueString(Label);
	MC.EndOp();
}

simulated function SetAbilityData3(string Icon1, string Name1, string Icon2, string Name2, string Icon3, string Name3)
{
	if(Icon1 == "" && Name1 == "") {
		AbilityIcon1.Hide();
		InfoButton1.Hide();
	} else {
		AbilityIcon1.Show();
	}
	if(Icon2 == "" && Name2 == "") {
		AbilityIcon2.Hide();
		InfoButton2.Hide();
	} else {
		AbilityIcon2.Show();
	}
	if(Icon3 == "" && Name3 == "") {
		AbilityIcon3.Hide();
		InfoButton3.Hide();
	} else {
		AbilityIcon3.Show();
	}

	MC.BeginFunctionOp("setAbilityData");
	MC.QueueString(Icon1);
	MC.QueueString(Name1);
	MC.QueueString(Icon2);
	MC.QueueString(Name2);
	MC.QueueString(Icon3);
	MC.QueueString(Name3);
	MC.EndOp();
}

simulated function SetEquippedAbilities3(optional bool bEquippedAbility1, optional bool bEquippedAbility2, optional bool bEquippedAbility3)
{
	MC.BeginFunctionOp("setEquippedAbilities");
	MC.QueueBoolean(bEquippedAbility1);
	MC.QueueBoolean(bEquippedAbility2);
	MC.QueueBoolean(bEquippedAbility3);
	MC.EndOp();
}

simulated function RealizeVisuals()
{
	MC.FunctionVoid("realizeFocus");
}

simulated function OnAbilityInfoClicked(UIButton Button)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local UIArmory_AWCExpandedPromotion_LW PromotionScreen;
	local int idx;

	PromotionScreen = UIArmory_AWCExpandedPromotion_LW(Screen);

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if(Button == InfoButton1)
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName1);
	else if(Button == InfoButton2)
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName2);
	else if(Button == InfoButton3)
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName3);

	if(AbilityTemplate != none)
		`HQPRES.UIAbilityPopup(AbilityTemplate, PromotionScreen.UnitReference);
}

//override Mouse Controls to point back to UIArmory_AWCExpandedPromotion_LW mouse handlers
// all other functionality identical to parent method
simulated function OnChildMouseEvent(UIPanel ChildControl, int cmd)
{
	local bool bHandled;
	local UIArmory_AWCExpandedPromotion_LW PromotionScreen;

	bHandled = true;
	PromotionScreen = UIArmory_AWCExpandedPromotion_LW(Screen);

	switch(ChildControl)  
	{
	case AbilityIcon1:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
		{
			if(bEligibleForPromotion)
				PromotionScreen.ConfirmAbilitySelection(Rank, 0);
			else
				Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN)
		{
			OnReceiveFocus();
			AbilityIcon1.OnReceiveFocus();
			RealizePromoteState();
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
		{
			AbilityIcon1.OnLoseFocus();
			RealizePromoteState();
		}
		break;
	case AbilityIcon2:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
		{
			if(bEligibleForPromotion)
				PromotionScreen.ConfirmAbilitySelection(Rank, 1);
			else
				Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		{
			OnReceiveFocus();
			AbilityIcon2.OnReceiveFocus();
			RealizePromoteState();
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
		{
			AbilityIcon2.OnLoseFocus();
			RealizePromoteState();
		}
		break;
	case AbilityIcon3:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
		{
			if(bEligibleForPromotion)
				PromotionScreen.ConfirmAbilitySelection(Rank, 2);
			else
				Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		{
			OnReceiveFocus();
			AbilityIcon3.OnReceiveFocus();
			RealizePromoteState();
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
		{
			AbilityIcon3.OnLoseFocus();
			RealizePromoteState();
		}
		break;
	case InfoButton1:
	case InfoButton2:
	case InfoButton3:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
		{
			OnAbilityInfoClicked(UIButton(ChildControl));
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		{
			OnReceiveFocus();
		}
		break;
	case ClassIcon:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		{
			OnReceiveFocus();
		}
		break;
	default:
		bHandled = false;
		break;
	}

	if( bHandled )
		RealizeVisuals();
}

simulated function RealizePromoteState()
{
	if(bEligibleForPromotion && Movie.Pres.ScreenStack.GetCurrentScreen() == Screen)
		SetPromote3(true, AbilityIcon1.bIsFocused, AbilityIcon2.bIsFocused, AbilityIcon3.bIsFocused);
}

simulated function RealizeInfoButtons()
{
	InfoButton1.SetVisible(bIsFocused && !bIsDisabled && !ClassIcon.bIsVisible && AbilityIcon1.bIsVisible);
	InfoButton2.SetVisible(bIsFocused && !bIsDisabled && !ClassIcon.bIsVisible && AbilityIcon2.bIsVisible);
	InfoButton3.SetVisible(bIsFocused && !bIsDisabled && AbilityIcon3.bIsVisible);
}

simulated function OnReceiveFocus()
{
	super(UIPanel).OnReceiveFocus();

	// Hax: The first promotion item isn't on the list, so if any other list item gets selected, we must ensure that one loses its focus
	if(self != UIArmory_AWCExpandedPromotion_LW(Screen).ClassRowItem)
		UIArmory_AWCExpandedPromotion_LW(Screen).ClassRowItem.OnLoseFocus();

	if(UIArmory_AWCExpandedPromotion_LW(Screen).List.GetItemIndex(self) != INDEX_NONE)
		UIArmory_AWCExpandedPromotion_LW(Screen).List.SetSelectedItem(self);
	else
		UIArmory_AWCExpandedPromotion_LW(Screen).List.SetSelectedIndex(-1);

	RealizeInfoButtons();
}

simulated function OnLoseFocus()
{
	// Leave highlighted when confirming ability selection
	if(Movie.Pres.ScreenStack.GetCurrentScreen() == Screen)
	{
		super(UIPanel).OnLoseFocus();
		RealizeInfoButtons();
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	// Only pay attention to presses or repeats; ignoring other input types
	// NOTE: Ensure repeats only occur with arrow keys
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;
	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
		case class'UIUtilities_Input'.const.FXS_ARROW_LEFT:
			SelectAbility(0);
			break;
		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
		case class'UIUtilities_Input'.const.FXS_ARROW_RIGHT:
			SelectAbility(1);
			break;
		case class'UIUtilities_Input'.const.FXS_DPAD_UP:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_UP:
		case class'UIUtilities_Input'.const.FXS_ARROW_UP:
			if (self != UIArmory_Promotion(Screen).ClassRowItem)
			{
				UIArmory_Promotion(Screen).SelectedAbilityIndex = SelectedAbility;
				OnChildMouseEvent(AbilityIcon1, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				OnChildMouseEvent(AbilityIcon2, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				OnChildMouseEvent(AbilityIcon3, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				SelectedAbility = -1;
			}

			break;

		case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_DOWN:
		case class'UIUtilities_Input'.const.FXS_ARROW_DOWN:
			if (UIArmory_Promotion(Screen).List.SelectedIndex < UIArmory_Promotion(Screen).List.GetItemCount() - 1)
			{
				UIArmory_Promotion(Screen).SelectedAbilityIndex = SelectedAbility;
				OnChildMouseEvent(AbilityIcon1, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				OnChildMouseEvent(AbilityIcon2, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				OnChildMouseEvent(AbilityIcon3, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				SelectedAbility = -1;
			}

			break;
		default:
			bHandled = false;
			break;
	}

	return bHandled || super(UIPanel).OnUnrealCommand(cmd, arg);
}

defaultproperties
{
	//Package = "/ package/gfxArmory_LW/Armory_Expanded";

	LibID = "PromotionListItem";
	width = 724;
	height = 74; //76;
	bCascadeFocus = false;
}
//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_AWCExpandedPromotion_LW
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Tweaked ability selection UI for LW expanded perk tree, modified version of UIArmory_Promotion
//			 Modified version used for displaying AWC abilities (not selecting in normal circumstances)
//
//--------------------------------------------------------------------------------------- 

class UIArmory_AWCExpandedPromotion_LW extends UIArmory_Promotion config (LW_AWCPack); 

const NUM_ABILITIES_PER_RANK_EXPANDED = 3;

var config bool ALWAYSSHOW;
var config bool ALLOWTRAININGINARMORY;
var config bool INSTANTTRAINING;

//var XComGameState PromotionState;

//var int PendingRank, PendingBranch;
//var bool bShownClassPopup;
//var bool bShownCorporalPopup, bShownAWCPopup; // necessary to prevent infinite popups if the soldier ability data isn't set up correctly.

//var bool bAfterActionPromotion;	//Set to TRUE if we need to make a pawn and move the camera to the armory
//var UIAfterAction AfterActionScreen; //If bAfterActionPromotion is true, this holds a reference to the after action screen
//var UIArmory_AWCExpandedPromotionItem_LW ClassRowItem;

//var localized string m_strSelectAbility;
//var localized string m_strAbilityHeader;

//var localized string m_strConfirmAbilityTitle;
//var localized string m_strConfirmAbilityText;

//var localized string m_strCorporalPromotionDialogTitle;
//var localized string m_strCorporalPromotionDialogText;

//var localized string m_strAWCUnlockDialogTitle;
//var localized string m_strAWCUnlockDialogText;

//var localized string m_strAbilityLockedTitle;
//var localized string m_strAbilityLockedDescription;

var UIList SummaryList;

var UIScrollingText LeftTitleText;
var UIScrollingText CenterTitleText;
var UIScrollingText RightTitleText;

var int SummaryTitleFontSize, SummaryBodyFontSize;
var int LastPreviewIndex;

var localized string strAWCTrainButton;
var UIButton AWCTrainButton;

//var config bool bTabToPromote;

simulated function InitPromotion(StateObjectReference UnitRef, optional bool bInstantTransition)
{
	
	// Don't show nav help during tutorial, or during the After Action sequence.
	bUseNavHelp = true;

	super(UIArmory).InitArmory(UnitRef,,,,,, bInstantTransition);

	LeftTitleText = Spawn(class'UIScrollingText', self).InitScrollingText(, "Title", 146,,,true);
	LeftTitleText.SetText(GetCenteredTitleText("LEFT ABILITY TITLE"));
	LeftTitleText.SetPosition(237, 160);

	CenterTitleText = Spawn(class'UIScrollingText', self).InitScrollingText(, "Title", 146,,,true);
	CenterTitleText.SetText(GetCenteredTitleText("CENTER ABILITY TITLE"));
	CenterTitleText.SetPosition(389, 160);

	RightTitleText = Spawn(class'UIScrollingText', self).InitScrollingText(, "Title", 146,,,true);
	RightTitleText.SetText(GetCenteredTitleText("RIGHT ABILITY TITLE"));
	RightTitleText.SetPosition(541, 160);

	List = Spawn(class'UIList', self).InitList('promoteList');
	List.OnSelectionChanged = PreviewRow;
	List.bStickyHighlight = false;
	List.bAutosizeItems = false;

	HideRowPreview();

	SummaryList = Spawn(class'UIList', self);
	SummaryList.bAnimateOnInit = false;
	SummaryList.BGPaddingLeft = 0;
	SummaryList.BGPaddingRight = 0;
	SummaryList.BGPaddingTop = 0;
	SummaryList.BGPaddingBottom = 0;
	SummaryList.itemPadding = 4;
	SummaryList.bAutoSizeItems = true;
	SummaryList.InitList(, 50.5, 804, 650, 168, true, false); // create horizontal list without background
	SummaryList.bStickyHighlight = false;
	SummaryList.Show();

	AWCTrainButton = Spawn(class'UIButton', self);
	AWCTrainButton.SetResizeToText(false);
	AWCTrainButton.bAnimateOnInit = false;
	AWCTrainButton.InitButton('AWCTrainingButton_LW', default.strAWCTrainButton, EnterAWCTraining).SetPosition(772-218-43-20, 14+96+19+4).SetWidth(200);
	AWCTrainButton.Hide();

	PopulateData();
	Navigator.Clear();
	Navigator.AddControl(List);
	Navigator.SetSelected(List);

	MC.FunctionVoid("animateIn");
}

// callback from clicking the AWC Train button
function EnterAWCTraining(UIButton Button)
{
	local XComGameState_Unit Unit;
	local XComGameState_StaffSlot StaffSlotState;

	Unit = GetUnit();
	
	if (CanUnitEnterAWCTraining(Unit))
	{
		StaffSlotState = GetEmptyAWCTrainingStaffSlot ();
		class'LWAWCUtilities'.static.UIChooseAWCAbility (Unit.GetReference(), StaffSlotState.GetReference(), true);
	}
}

simulated function string GetCenteredTitleText(string text)
{
	local string OutString;

	OutString = text;
	OutString = class'UIUtilities_Text'.static.AddFontInfo(OutString, true,,, SummaryTitleFontSize);
	OutString = class'UIUtilities_Text'.static.AlignCenter(OutString);

	return OutString;
}

simulated function OnLoseFocus()
{
	super(UIArmory).OnLoseFocus();
	//<workshop> FIX_FOR_PROMOTION_LOST_FOCUS_ISSUE kmartinez 2015-10-28
	// only set our variable if we're not trying to set a default value.
	//if( List.SelectedIndex != -1)
		//previousSelectedIndexOnFocusLost = List.SelectedIndex;
	//AbilityList.SetSelectedIndex(-1);
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

static function UIScreen GetScreen(name TestScreenClass )
{
	local UIScreenStack ScreenStack;
	local int Index;

	ScreenStack = `SCREENSTACK;
	for(Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(ScreenStack.Screens[Index].IsA(TestScreenClass))
			return ScreenStack.Screens[Index];
	}
	return none; 
}

simulated function bool IsInScreenStack(name ScreenName)
{
	local UIScreenStack ScreenStack;
	local int Index;

	ScreenStack = Movie.Pres.ScreenStack;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if( ScreenStack.Screens[Index].IsA(ScreenName) )
			return true;
	}
	return false;
}

simulated function string PromoCaps(string s)
{
	return s;
}

simulated function bool CanUnitEnterAWCTraining(XComGameState_Unit Unit)
{
	local StaffUnitInfo UnitInfo;
	local XComGameState_StaffSlot StaffSlotState;

	UnitInfo.UnitRef = Unit.GetReference();

	StaffSlotState = GetEmptyAWCTrainingStaffSlot();
	if (StaffSlotState != none && class'X2StrategyElement_AWC_TrainingStaffSlot_LW'.static.IsUnitValidForAWCTrainingSlot(StaffSlotState, UnitInfo)) 
	{ 
		return true; 
	}

	return false;
}

simulated function PopulateData()
{
	local int Rank, maxRank, previewIndex, idx;
	local string HeaderString;
	local array<string> AbilityIcons, AbilityNames;
	local array<ClassAgnosticAbility> AWCAbilities;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_AWC_LW AWCState;
	local array<X2AbilityTemplate> AbilityTemplates;
	local array<name> AbilityDataNames;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local UIArmory_AWCExpandedPromotionItem_LW Item;
	local Vector ZeroVec;
	local Rotator UseRot;
	local XComUnitPawn UnitPawn;
	local array<bool> AbilitiesLocked;
	local bool DisplayOnly;

	// We don't need to clear the List, or recreate the pawn here
	//super(UIArmory).PopulateData();
	Unit = GetUnit();
	DisplayOnly = !CanUnitEnterAWCTraining(Unit);
	AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);

	if (DisplayOnly)
	{
		AWCTrainButton.Hide();
	}
	else
	{
		AWCTrainButton.Show();
	}

	HeaderString = m_strAbilityHeader;

	//clear left/right ability titles
	AS_SetTitle("", HeaderString, "", "", "");

	LeftTitleText.SetText(GetCenteredTitleText(PromoCaps(class'LWAWCUtilities'.default.LeftAbilityTreeTitle)));
	CenterTitleText.SetText(GetCenteredTitleText(PromoCaps(class'LWAWCUtilities'.default.CenterAbilityTreeTitle)));
	RightTitleText.SetText(GetCenteredTitleText(PromoCaps(class'LWAWCUtilities'.default.RightAbilityTreeTitle)));

	if(ActorPawn == none) 
	{
		//Get the current pawn so we can extract its rotation
		UnitPawn = Movie.Pres.GetUIPawnMgr().RequestPawnByID(AfterActionScreen, UnitReference.ObjectID, ZeroVec, UseRot);
		UseRot = UnitPawn.Rotation;

		//Free the existing pawn, and then create the ranked up pawn. This may not be strictly necessary since most of the differences between the classes are in their equipment. However, it is easy to foresee
		//having class specific soldier content and this covers that possibility
		Movie.Pres.GetUIPawnMgr().ReleasePawn(AfterActionScreen, UnitReference.ObjectID);
		CreateSoldierPawn(UseRot);
	}

	//Init but then hide the first row, since it's set up for both class and single ability
	if (ClassRowItem == none)
	{
		ClassRowItem = Spawn(class'UIArmory_PromotionItem', self);
		ClassRowItem.MCName = 'classRow';
		ClassRowItem.InitPromotionItem(0);
	}
	ClassRowItem.Hide();

	List.SetPosition(58, 185); // shift the list object to cover the gap from hiding the ClassRow and the left/right ability titles

	previewIndex = -1;
	if(AWCState != none)
		maxRank = AWCState.GetMaxAbilitiesOfAnyType();

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilitiesLocked.Add(3);

	for(Rank = 0; Rank < maxRank; ++Rank)
	{
		AbilityTemplates.Length = 0;
		AWCAbilities.Length = 0;

		AbilityTemplates.Length = 3;
		AWCAbilities.Length = 3;

		Item = UIArmory_AWCExpandedPromotionItem_LW(List.GetItem(Rank));
		if(Item == none)
		{
			Item = UIArmory_AWCExpandedPromotionItem_LW(List.CreateItem(class'UIArmory_AWCExpandedPromotionItem_LW'));
			Item.InitPromotionItem(Rank);
		}
		Item.Rank = Rank;

		Item.SetRankData(class'LWAWCUtilities'.static.GetAWCLevelIcon(Item.Rank), Caps(class'LWAWCUtilities'.static.GetAWCLevelName(Item.Rank)));

		for(idx = 0; idx < 3; idx++)
		{
			if(AWCState != none)
			{
				AbilityTemplates[idx] = AbilityTemplateManager.FindAbilityTemplate(AWCState.GetAbilityName(Item.Rank, idx));
				if(AbilityTemplates[idx] != none)
				{
					AWCAbilities[idx] = AWCState.GetAbility(Item.Rank, AWCTrainingType(idx));
					if(default.ALWAYSSHOW || AWCAbilities[idx].bUnlocked || !AbilitiesLocked[idx])
					{
						AbilityNames[idx] = PromoCaps(AbilityTemplates[idx].LocFriendlyName);
						AbilityIcons[idx] = AbilityTemplates[idx].IconImage;
						AbilityDataNames[idx] = AbilityTemplates[idx].DataName;
						if (!AWCAbilities[idx].bUnlocked)
							AbilitiesLocked[idx] = true;
					}
					else
					{
						AbilityNames[idx] = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled);
						AbilityIcons[idx] = class'UIUtilities_Image'.const.UnknownAbilityIcon;
						AbilityDataNames[idx] = '';
					}
				}
				else
				{
					AbilityNames[idx] = "";
					AbilityIcons[idx] = "";
					AbilityDataNames[idx] = '';
				}
			}
			else
			{
				AbilityNames[idx] = "";
				AbilityIcons[idx] = "";
				AbilityDataNames[idx] = '';
			}
		}
		
		Item.AbilityName1 = AbilityDataNames[0];
		Item.AbilityName2 = AbilityDataNames[1];
		Item.AbilityName3 = AbilityDataNames[2];
		
		if(AWCState != none)
		{
			Item.SetEquippedAbilities3(AWCAbilities[0].bUnlocked, AWCAbilities[1].bUnlocked, AWCAbilities[2].bUnlocked);
			Item.SetAbilityData3(AbilityIcons[0], AbilityNames[0], AbilityIcons[1], AbilityNames[1], AbilityIcons[2], AbilityNames[2]);
			if(AWCAbilities[0].bUnlocked || AWCAbilities[1].bUnlocked || AWCAbilities[2].bUnlocked)
				Item.SetDisabled(false);
			else
				Item.SetDisabled(true);
		}
		else
		{
			Item.SetEquippedAbilities3(false, false, false);
			Item.SetAbilityData3(AbilityIcons[0], AbilityNames[0], AbilityIcons[1], AbilityNames[1], AbilityIcons[2], AbilityNames[2]);
			Item.SetDisabled(true);
		}

		if(default.ALLOWTRAININGINARMORY) 
		{
			Item.SetPromote3(true);
		}
		else 
		{
			Item.SetPromote3(false);
		}
		Item.RealizeVisuals();
	}

	PopulateAbilitySummary(Unit);
	List.SetSelectedIndex(-1);
	PreviewRow(List, previewIndex);
}

simulated function PopulateAbilitySummary(XComGameState_Unit Unit)
{
	local int i, Index;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_Unit_AWC_LW AWCState;
	local array<ClassAgnosticAbility> AWCAbilities;

	Movie.Pres.m_kTooltipMgr.RemoveTooltipsByPartialPath(string(MCPath) $ ".abilitySummaryList");

	AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);
	if( AWCState == none || AWCState.GetMaxAbilitiesOfAnyType() == 0 )
	{
		MC.FunctionVoid("hideAbilityList");
		return;
	}

	MC.FunctionString("setSummaryTitle", class'LWAWCUtilities'.default.strAWCMenuOption);

	// Populate ability list (multiple param function call: image then title then description)
	MC.BeginFunctionOp("setAbilitySummaryList");

	Index = 0;

	AWCAbilities = AWCState.GetAllTrainedAWCAbilities();
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	for(i = 0; i < AWCAbilities.Length; ++i)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AWCAbilities[i].AbilityType.AbilityName);
		if( AbilityTemplate != none && !AbilityTemplate.bDontDisplayInAbilitySummary )
		{
			class'UIUtilities_Strategy'.static.AddAbilityToSummary(self, AbilityTemplate, Index++, Unit, none);
		}
	}

	MC.EndOp();
}

simulated function PreviewRow(UIList ContainerList, int ItemIndex)
{
	local int i, Rank; 
	local string TmpIconPath, TmpClassPath, TmpTitleText, TmpSummaryText;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local ClassAgnosticAbility AWCAbility, PrevAWCAbility, EmptyAbility;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_AWC_LW AWCState;
	local UIArmory_AWCExpandedSummaryItem_LW Item;

	Unit = GetUnit();
	AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);

	`LOG("PreviewRow : ItemIndex = " $ ItemIndex);

	if(ItemIndex == INDEX_NONE)
		return;
	else if(ItemIndex == -2)
		Rank = 0;
	else
		Rank = UIArmory_AWCExpandedPromotionItem_LW(List.GetItem(ItemIndex)).Rank;

	if(Rank == LastPreviewIndex)
		return;

	LastPreviewIndex = Rank;
	SummaryList.ClearItems();

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	for(i = 0; i < NUM_ABILITIES_PER_RANK_EXPANDED; i++)
	{
		if(AWCState == none)
		{
			Item = GetNextSummaryItem(i);
			Item.Hide();
			continue;
		}
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AWCState.GetAbilityName(Rank, i));
		AWCAbility = AWCState.GetAbility(Rank, AWCTrainingType(i));
		PrevAWCAbility = EmptyAbility;
		if (Rank > 0)
			PrevAWCAbility = AWCState.GetAbility(Rank-1, AWCTrainingType(i));
		if(!default.ALWAYSSHOW && (AWCAbility.AbilityType.AbilityName == '' || !AWCAbility.bUnlocked) &&  (Rank > 0 && !PrevAWCAbility.bUnlocked))
		{
			TmpIconPath = class'UIUtilities_Image'.const.LockedAbilityIcon;
			TmpClassPath = "";
			TmpTitleText = class'UIUtilities_Text'.static.GetColoredText(Caps(m_strAbilityLockedTitle), eUIState_Disabled, SummaryTitleFontSize);
			TmpSummaryText = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedDescription, eUIState_Disabled, SummaryBodyFontSize);
			Item = GetNextSummaryItem(i);
			Item.SetSummaryData(TmpIconPath, TmpClassPath, TmpTitleText, TmpSummaryText);
			if(AWCAbility.AbilityType.AbilityName == '')
			{
				Item.Hide();
				continue;
			}
		} 
		else 
		{
			Item = GetNextSummaryItem(i);
			if(AbilityTemplate != none)
			{
				TmpIconPath = AbilityTemplate.IconImage;
				TmpClassPath = "";
				TmpTitleText = AbilityTemplate.LocFriendlyName != "" ? AbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for " $ AbilityTemplate.DataName);
				TmpSummaryText = AbilityTemplate.HasLongDescription() ? AbilityTemplate.GetMyLongDescription(, Unit) : ("Missing 'LocLongDescription' for " $ AbilityTemplate.DataName);
				TmpTitleText = class'UIUtilities_Text'.static.GetColoredText(Caps(TmpTitleText), eUIState_Normal, SummaryTitleFontSize);
				TmpSummaryText = class'UIUtilities_Text'.static.GetColoredText(TmpSummaryText, eUIState_Normal, SummaryBodyFontSize);
				Item.SetSummaryData(TmpIconPath, TmpClassPath, TmpTitleText, TmpSummaryText);
			}
			else
			{
				Item.Hide();
				TmpIconPath = "";
				TmpClassPath = "";
				TmpTitleText = string(AWCAbility.AbilityType.AbilityName); 
				TmpSummaryText = "Missing template for ability '" $ AWCAbility.AbilityType.AbilityName $ "'"; 
			}
		}
	}
}

simulated function UIArmory_AWCExpandedSummaryItem_LW GetNextSummaryItem(int count)
{
	local UIArmory_AWCExpandedSummaryItem_LW Item;
	Item = UIArmory_AWCExpandedSummaryItem_LW(SummaryList.GetItem(count));
	if (Item == none)
		Item = UIArmory_AWCExpandedSummaryItem_LW(SummaryList.CreateItem(class'UIArmory_AWCExpandedSummaryItem_LW')).InitSummaryItem();

	return Item;

}

simulated function HideRowPreview()
{
	MC.FunctionVoid("hideAbilityPreview");
}

simulated function ClearRowPreview()
{
	MC.FunctionVoid("clearAbilityPreview");
}

simulated function UpdateNavHelp()
{
	//<workshop> SCI 2016/4/12
	//INS:
	local int i;
	local string PrevKey, NextKey;
	local XGParamTag LocTag;
	if(!bIsFocused)
	{
		return;
	}

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.ClearButtonHelp();
	//</workshop>

	if(UIAfterAction(GetScreen('UIAfterAction')) != none)
	{
		//<workshop> SCI 2016/3/1
		//WAS:
		//`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
		//`HQPRES.m_kAvengerHUD.NavHelp.AddContinueButton(OnCancel);
		NavHelp.AddBackButton(OnCancel);
		if (`ISCONTROLLERACTIVE && !UIArmory_PromotionItem(List.GetSelectedItem()).bIsDisabled)
		{
			NavHelp.AddLeftHelp(m_strInfo, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LSCLICK_L3);
		}

		if (`ISCONTROLLERACTIVE && !XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID)).ShowPromoteIcon())
		{
			NavHelp.AddContinueButton(OnCancel);
		}
		else if (UIArmory_PromotionItem(List.GetSelectedItem()).bEligibleForPromotion)
		{
			NavHelp.AddLeftHelp(m_strSelect, class'UIUtilities_Input'.static.GetAdvanceButtonIcon());
		}

		if( `ISCONTROLLERACTIVE )
		{
			if (IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
			{
				NavHelp.AddLeftHelp(class'UIUtilities_Input'.static.InsertGamepadIcons("%LB %RB" @ m_strTabNavHelp));
			}

			NavHelp.AddLeftHelp(class'UIUtilities_Input'.static.InsertGamepadIcons("%RS" @ m_strRotateNavHelp));
		}
	}
	else
	{
		//<workshop> SCI 2016/4/12
		//WAS:
		//super.UpdateNavHelp();
		NavHelp.AddBackButton(OnCancel);
		
		if (XComHQPresentationLayer(Movie.Pres) != none)
		{
			LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_PrevUnit);
			PrevKey = `XEXPAND.ExpandString(PrevSoldierKey);
			LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_NextUnit);
			NextKey = `XEXPAND.ExpandString(NextSoldierKey);

			if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M7_WelcomeToGeoscape') != eObjectiveState_InProgress &&
				RemoveMenuEvent == '' && NavigationBackEvent == '' && !`ScreenStack.IsInStack(class'UISquadSelect'))
			{
				NavHelp.AddGeoscapeButton();
			}

			if (Movie.IsMouseActive() && IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
			{
				NavHelp.SetButtonType("XComButtonIconPC");
				i = eButtonIconPC_Prev_Soldier;
				NavHelp.AddCenterHelp( string(i), "", PrevSoldier, false, PrevKey);
				i = eButtonIconPC_Next_Soldier; 
				NavHelp.AddCenterHelp( string(i), "", NextSoldier, false, NextKey);
				NavHelp.SetButtonType("");
			}
		}

	    if (UIArmory_PromotionItem(List.GetSelectedItem()).bEligibleForPromotion)
		{
			NavHelp.AddSelectNavHelp();
		}

		if (`ISCONTROLLERACTIVE && !UIArmory_PromotionItem(List.GetSelectedItem()).bIsDisabled)
		{
			NavHelp.AddLeftHelp(m_strInfo, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LSCLICK_L3);
		}

		if( `ISCONTROLLERACTIVE )
		{
			if (IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
			{
				NavHelp.AddLeftHelp(class'UIUtilities_Input'.static.InsertGamepadIcons("%LB %RB" @ m_strTabNavHelp));
			}

			NavHelp.AddLeftHelp(class'UIUtilities_Input'.static.InsertGamepadIcons("%RS" @ m_strRotateNavHelp));
		}

		NavHelp.Show();
		//</workshop>
	}
}

//==============================================================================
// Ability selection - this should only happen when debug log statements are enabled
//==============================================================================

simulated function ConfirmAbilitySelection(int Rank, int Branch)
{
	local XGParamTag LocTag;
	local TDialogueBoxData DialogData;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_AWC_LW AWCState;
	//local XComGameState_StaffSlot StaffSlotState;

	Unit = GetUnit();
	AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);
	//
	//if (CanUnitEnterAWCTraining(Unit))
	//{
		//StaffSlotState = GetEmptyAWCTrainingStaffSlot ();
		//class'LWAWCUtilities'.static.UIChooseAWCAbility (Unit.GetReference(), StaffSlotState.GetReference(), true);
		//return;
	//}

	// the rest of this is for when debugging config entries are active
	PendingRank = Rank;
	PendingBranch = Branch;

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);

	DialogData.eType = eDialog_Alert;
	DialogData.bMuteAcceptSound = true;
	DialogData.strTitle = m_strConfirmAbilityTitle;
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNO;
	DialogData.fnCallback = ComfirmAbilityCallback;
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AWCState.GetAbilityName(Rank, Branch));

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = AbilityTemplate.LocFriendlyName;
	DialogData.strText = `XEXPAND.ExpandString(m_strConfirmAbilityText);
	Movie.Pres.UIRaiseDialog(DialogData);
}

simulated function XComGameState_StaffSlot GetEmptyAWCTrainingStaffSlot()
{
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_StaffSlot SlotState;
	local int idx;

	FacilityState = `XCOMHQ.GetFacilityByName('RecoveryCenter');
	if (FacilityState == none)
	{
		return none;
	}

	for(idx = 0; idx < FacilityState.StaffSlots.Length; idx++)
	{
		SlotState = FacilityState.GetStaffSlot(idx);
		if(SlotState != none 
			&& SlotState.GetMyTemplateName() == 'AWCTrainingSlot_LW' 
			&& SlotState.IsSlotEmpty()
			&& !SlotState.bIsLocked)
		{
			return SlotState;
		}
	}
	return none;
}

simulated function ComfirmAbilityCallback(Name Action)
{
	local XComGameStateHistory History;
	local XComGameState UpdateState;
	local XComGameState_Unit_AWC_LW AWCState, UpdateAWCState;
	local XComGameState_Unit  Unit;
	local XComGameStateContext_ChangeContainer ChangeContainer;

	if(Action == 'eUIAction_Accept')
	{
		Unit = GetUnit();
		AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);

		History = `XCOMHISTORY;
		ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Soldier Promotion");
		UpdateState = History.CreateNewGameState(true, ChangeContainer);

		UpdateAWCState = XComGameState_Unit_AWC_LW(UpdateState.CreateStateObject(class'XComGameState_Unit_AWC_LW', AWCState.ObjectID));
		UpdateAWCState.TrainAbility(PendingRank, AWCTrainingType(PendingBranch));

		UpdateState.AddStateObject(UpdateAWCState);
		`GAMERULES.SubmitGameState(UpdateState);

		Header.PopulateData();
		PopulateData();

		Movie.Pres.PlayUISound(eSUISound_SoldierPromotion);
	}
	else
		Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	// Only pay attention to presses or repeats; ignoring other input types
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;
	if (List.GetSelectedItem().OnUnrealCommand(cmd, arg))
	{
		UpdateNavHelp();
		return true;
	}

	bHandled = true;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			break;
		default:
			bHandled = false;
			break;
	}

	return bHandled || super.OnUnrealCommand(cmd, arg);
}

simulated function OnReceiveFocus()
{
	local int i;
	local XComHQPresentationLayer HQPres;

	super(UIArmory).OnReceiveFocus();

	HQPres = XComHQPresentationLayer(Movie.Pres);

	if(HQPres != none)
	{
		HQPres.CAMLookAtNamedLocation(CameraTag, `HQINTERPTIME);
	}

	for(i = 0; i < List.ItemCount; ++i)
	{
		UIArmory_PromotionItem(List.GetItem(i)).RealizePromoteState();
	}

	Navigator.SetSelected(List);
	List.SetSelectedIndex(previousSelectedIndexOnFocusLost);
	UIArmory_PromotionItem(List.GetSelectedItem()).SetSelectedAbility(SelectedAbilityIndex);

	UpdateNavHelp();

	PopulateData();
}

//==============================================================================
// Soldier cycling
//==============================================================================

simulated function bool IsAllowedToCycleSoldiers()
{
	return true;
}

simulated static function bool CanCycleTo(XComGameState_Unit Soldier)
{
	return class'LWAWCUtilities'.static.GetAWCComponent(Soldier) != none;
}

simulated static function CycleToSoldier(StateObjectReference UnitRef)
{
	local UIArmory_AWCExpandedPromotion_LW Promotion;


	super(UIArmory).CycleToSoldier(UnitRef);

	// manually set the preview row when switching
	Promotion = UIArmory_AWCExpandedPromotion_LW(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory_AWCExpandedPromotion_LW'));
	if (Promotion != none)
	{
		Promotion.LastPreviewIndex = -1;
		Promotion.PreviewRow(Promotion.List, 0);

	}
}

//==============================================================================

defaultproperties
{
	Package         = "/ package/gfxArmory_LW/Armory_Expanded";

	LibID = "PromotionScreenMC";
	bHideOnLoseFocus = false;
	bAutoSelectFirstNavigable = false;
	DisplayTag = "UIBlueprint_Promotion";
	CameraTag = "UIBlueprint_Promotion";
	SummaryTitleFontSize = 22
	SummaryBodyFontSize = 18

}
//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_LWOfficerPromotion
//  AUTHOR:  Amineri (Long War Studios)
//
//  PURPOSE: Tweaked ability selection UI for LW officer system
//
//--------------------------------------------------------------------------------------- 

class UIArmory_LWOfficerPromotion extends UIArmory_Promotion config(LW_OfficerPack);

var config bool ALWAYSSHOW;
var config bool ALLOWTRAININGINARMORY;
var config bool INSTANTTRAINING;

simulated function PopulateData()
{
	local int i, MaxRank;
	local string AbilityIcon1, AbilityIcon2, AbilityName1, AbilityName2, HeaderString;
	local bool bHasAbility1, bHasAbility2;
	local XComGameState_Unit Unit;
	local X2AbilityTemplate AbilityTemplate1, AbilityTemplate2;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local UIArmory_LWOfficerPromotionItem Item;
	local XComGameState_Unit_LWOfficer OfficerState;
	local int RankToPromote;

	local bool DisplayOnly;

	`LOG("LW Officer Pack, UIArmory_LWOfficerPromotion, PopulateData");

	//AlwaysShow = true; // Debug switch to always show all perks

	// We don't need to clear the list, or recreate the pawn here -sbatista
	//super.PopulateData();
	Unit = GetUnit();
	DisplayOnly = !`SCREENSTACK.IsInStack(class'UIFacility_Academy');
	MaxRank = class'LWOfficerUtilities'.static.GetMaxRank();
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if (default.ALLOWTRAININGINARMORY)
		DisplayOnly = false;

	//Differentiate Header based on whether is in Armory or in OTS Facility
	if (DisplayOnly)
	{
		HeaderString = m_strAbilityHeader;
	} else {
		HeaderString = m_strSelectAbility;
	}

	//clear left/right ability titles
	AS_SetTitle("", HeaderString, "", "", "");

	//Init but then hide the first row, since it's set up for both class and single ability
	if (ClassRowItem == none)
	{
		ClassRowItem = Spawn(class'UIArmory_PromotionItem', self);
		ClassRowItem.MCName = 'classRow';
		ClassRowItem.InitPromotionItem(0);
	}
	ClassRowItem.Hide();

	List.SetPosition(58, 170); // shift the list object to cover the gap from hiding the ClassRow and the left/right ability titles

	//loop over rows
	for (i = 0; i < MaxRank; ++i)
	{
		Item = UIArmory_LWOfficerPromotionItem(List.GetItem(i));
		if (Item == none)
		{
			Item = UIArmory_LWOfficerPromotionItem(UIArmory_LWOfficerPromotionItem(List.CreateItem(class'UIArmory_LWOfficerPromotionItem')).InitPromotionItem(i));
		}
		Item.Rank = i + 1;
		Item.SetRankData(class'LWOfficerUtilities'.static.GetRankIcon(Item.Rank), Caps(class'LWOfficerUtilities'.static.GetLWOfficerRankName(Item.Rank)));

		AbilityTemplate1 = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(Item.Rank, 0));
		AbilityTemplate2 = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(Item.Rank, 1));
		//`log("LW Officer Pack : Display Ability:" @ string(AbilityTemplate1.DataName) @ "at Rank:" @ Item.Rank $ ", Option: 0");
		//`log("LW Officer Pack : Display Ability:" @ string(AbilityTemplate2.DataName) @ "at Rank:" @ Item.Rank $ ", Option: 1");
		
		OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
		if(OfficerState != none)
		{
			bHasAbility1 = OfficerState.HasOfficerAbility(AbilityTemplate1.DataName);
			bHasAbility2 = OfficerState.HasOfficerAbility(AbilityTemplate2.DataName);
		}
		if (DisplayOnly)
		{
			RankToPromote = -1;
		} else 	if (OfficerState == none) 
		{
			RankToPromote = 1;
			//`log("LW Officer Pack : Did not find Unit Officer Component");
		} else {
			RankToPromote = OfficerState.GetOfficerRank() + 1;
			//`log("LW Officer Pack : Found Unit Officer Component, Rank=" $ string(OfficerState.GetOfficerRank()));
		}

		//get left-side ability
		if (AbilityTemplate1 != none)
		{
			Item.AbilityName1 = AbilityTemplate1.DataName;
			if (default.ALWAYSSHOW || Item.Rank <= OfficerState.GetOfficerRank() || (!DisplayOnly && Item.Rank == RankToPromote))
			{
				AbilityName1 = Caps(AbilityTemplate1.LocFriendlyName);
				AbilityIcon1 = AbilityTemplate1.IconImage;
			} else {
				AbilityName1 = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled);
				AbilityIcon1 = class'UIUtilities_Image'.const.UnknownAbilityIcon;
			}
		}

		//get right-side ability
		if (AbilityTemplate2 != none)
		{
			Item.AbilityName2 = AbilityTemplate2.DataName;
			if (default.ALWAYSSHOW || Item.Rank <= OfficerState.GetOfficerRank() || (!DisplayOnly && Item.Rank == RankToPromote))
			{
				AbilityName2 = Caps(AbilityTemplate2.LocFriendlyName);
				AbilityIcon2 = AbilityTemplate2.IconImage;
			} else {
				AbilityName2 = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled);
				AbilityIcon2 = class'UIUtilities_Image'.const.UnknownAbilityIcon;
			}
		}

		Item.SetAbilityData(AbilityIcon1, AbilityName1, AbilityIcon2, AbilityName2);
		Item.SetEquippedAbilities(bHasAbility1, bHasAbility2);

		if (Item.Rank == RankToPromote)
		{
			Item.SetPromote(true);
			Item.SetDisabled(false);
		} else {
			Item.SetPromote(false);
		}

		//if (bHasRankAbility || default.ALWAYSSHOW)
		//{
			//Item.SetDisabled(false);
		//} else {
			//Item.SetDisabled(true);
		//}

		if((Item.Rank <= OfficerState.GetOfficerRank()) || ((Item.Rank == RankToPromote)) || default.ALWAYSSHOW)
		{
			Item.SetDisabled(false);
		}
		else
		{
			Item.SetDisabled(true);
		}
		Item.RealizeVisuals();
	}

	//updates right-side ability panel
	class'UIUtilities_Strategy'.static.PopulateAbilitySummary(self, Unit);

	List.SetSelectedIndex(-1); // initial selection

	PreviewRow(List, 1); // initial abilities shown at bottom of panel
}

simulated function OnLoseFocus()
{
	super(UIArmory).OnLoseFocus();
	//List.SetSelectedIndex(-1);
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}


simulated function PreviewRow(UIList ContainerList, int ItemIndex)
{
	local int i, Rank, EffectiveRank;
	local string TmpStr;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_Unit Unit; 
	local bool DisplayOnly;

	DisplayOnly = !`SCREENSTACK.IsInStack(class'UIFacility_Academy');
	Unit = GetUnit();

	if (ItemIndex == INDEX_NONE)
	{
		Rank = 1;
		return;
	} else {
		Rank = UIArmory_LWOfficerPromotionItem(List.GetItem(ItemIndex)).Rank;
	}

	MC.BeginFunctionOp("setAbilityPreview");

	if(class'LWOfficerUtilities'.static.GetOfficerComponent(Unit) != none)
		EffectiveRank = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit).GetOfficerRank();
	else
		EffectiveRank = 0;

	if (!DisplayOnly) {	EffectiveRank++; }

	if((Rank > EffectiveRank) && !default.ALWAYSSHOW)
	{
		for(i = 0; i < NUM_ABILITIES_PER_RANK; ++i)
		{
			MC.QueueString(class'UIUtilities_Image'.const.LockedAbilityIcon); // icon
			MC.QueueString(class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled)); // name
			MC.QueueString(class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedDescription, eUIState_Disabled)); // description
			MC.QueueBoolean(false); // isClassIcon
		}
	}
	else
	{
		AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

		for(i = 0; i < NUM_ABILITIES_PER_RANK; ++i)
		{
			AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(Rank, i));

			if(AbilityTemplate != none)
			{
				MC.QueueString(AbilityTemplate.IconImage); // icon

				TmpStr = AbilityTemplate.LocFriendlyName != "" ? AbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for " $ AbilityTemplate.DataName);
				MC.QueueString(Caps(TmpStr)); // name

				TmpStr = AbilityTemplate.HasLongDescription() ? AbilityTemplate.GetMyLongDescription() : ("Missing 'LocLongDescription' for " $ AbilityTemplate.DataName);
				MC.QueueString(TmpStr); // description
				MC.QueueBoolean(false); // isClassIcon
			}
			else
			{
				MC.QueueString(""); // icon
				MC.QueueString(string(class'LWOfficerUtilities'.static.GetAbilityName(Rank, i))); // name
				MC.QueueString("Missing template for ability '" $ class'LWOfficerUtilities'.static.GetAbilityName(Rank, i) $ "'"); // description
				MC.QueueBoolean(false); // isClassIcon
			}
		}
	}

	MC.EndOp();
}

simulated function ConfirmAbilitySelection(int Rank, int Branch)
{
	local XGParamTag LocTag;
	local TDialogueBoxData DialogData;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;

	PendingRank = Rank;
	PendingBranch = Branch;

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);

	DialogData.eType = eDialog_Alert;
	DialogData.bMuteAcceptSound = true;
	DialogData.strTitle = m_strConfirmAbilityTitle;
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNO;
	DialogData.fnCallback = ConfirmAbilityCallback;
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(PendingRank, PendingBranch));

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = AbilityTemplate.LocFriendlyName;
	DialogData.strText = `XEXPAND.ExpandString(m_strConfirmAbilityText);
	Movie.Pres.UIRaiseDialog(DialogData);
}

simulated function ConfirmAbilityCallback(Name Action) // Previously Action was of type eUIAction
{
	local XComGameStateHistory History;
	local XComGameState UpdateState;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit Unit;
	local StaffUnitInfo UnitInfo;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local ClassAgnosticAbility NewOfficerAbility;
	local SoldierClassAbilityType Ability;
	local XComGameState_Unit_LWOfficer OfficerState;
	local int NewOfficerRank;
	local bool bTrainingSuccess;
	local XComGameState_HeadquartersProjectTrainLWOfficer TrainLWOfficerProject;
	local XComGameState_StaffSlot StaffSlotState;

	if(Action == 'eUIAction_Accept') // Previously without single-quotes
	{
		Unit = GetUnit();

		//TODO: remove usage of AWCAbilities once delegates added to XComGameState_Unit.GatherUnitAbilitiesForInit
		//Build ClassAgnosticAbility to allow instant training into AWCAbility
		Ability.AbilityName = class'LWOfficerUtilities'.static.GetAbilityName(PendingRank, PendingBranch);
		Ability.ApplyToWeaponSlot = eInvSlot_Unknown;
		Ability.UtilityCat = '';
		NewOfficerAbility.AbilityType = Ability;
		NewOfficerAbility.iRank = 0;
		NewOfficerAbility.bUnlocked = true;

		//Build GameState change container
		History = `XCOMHISTORY;
		ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Staffing Train Officer Slot");
		UpdateState = History.CreateNewGameState(true, ChangeContainer);
		UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', GetUnit().ObjectID));

		//Try to retrieve new OfficerComponent from Unit -- note that it may not have been created for non-officers yet
		OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);

		if (OfficerState == none) 
		{
			//first promotion, create component gamestate and attach it
			OfficerState = XComGameState_Unit_LWOfficer(UpdateState.CreateStateObject(class'XComGameState_Unit_LWOfficer'));
			OfficerState.InitComponent();
			if (default.INSTANTTRAINING) 
			{
				OfficerState.SetOfficerRank(1);
			} else {
				NewOfficerRank = 1;
			}
			UpdatedUnit.AddComponentObject(OfficerState);
		} else {
			//subsequent promotion, update existing component gamestate
			NewOfficerRank = OfficerState.GetOfficerRank() + 1;
			OfficerState = XComGameState_Unit_LWOfficer(UpdateState.CreateStateObject(class'XComGameState_Unit_LWOfficer', OfficerState.ObjectID));
			if (default.INSTANTTRAINING) 
			{
				OfficerState.SetOfficerRank(NewOfficerRank);
			} else {
				
			}
		}

		if (default.INSTANTTRAINING) 
		{
			`log("LW Officer Pack: Adding ability:" @ NewOfficerAbility.AbilityType.AbilityName);
			OfficerState.OfficerAbilities.AddItem(NewOfficerAbility);
			UpdatedUnit = class'LWOfficerUtilities'.static.AddInitialAbilities(UpdatedUnit, OfficerState, UpdateState);
			bTrainingSuccess = true;
		} else {
			bTrainingSuccess = OfficerState.SetRankTraining(NewOfficerRank, Ability.AbilityName);
		}

		if (!default.INSTANTTRAINING)
		{
			StaffSlotState = GetEmptyOfficerTrainingStaffSlot();
			if (StaffSlotState != none)
			{
				UnitInfo.UnitRef = UpdatedUnit.GetReference();
				//StaffSlotState.FillSlot(UpdateState, UnitInfo); // The Training project is started when the staff slot is filled
				StaffSlotState.FillSlot(UnitInfo, UpdateState); // REALLY? REALLY FXS? REALLY? WAS THIS REALLY NECESSARY!? DID WOTC ABSOLUTELY REQUIRE THIS CHANGE!?
		
				// Find the new Training Project which was just created by filling the staff slot and set the rank and ability
				foreach UpdateState.IterateByClassType(class'XComGameState_HeadquartersProjectTrainLWOfficer', TrainLWOfficerProject)
				{
					if (TrainLWOfficerProject.ProjectFocus.ObjectID == GetUnit().ObjectID) //handle possible cases of multiple officer training slots
					{
						TrainLWOfficerProject.AbilityName = Ability.AbilityName;
						TrainLWOfficerProject.NewRank = NewOfficerRank;

						// have to recompute time for project after rank is set in order to handle completion time based on rank
						TrainLWOfficerProject.ProjectPointsRemaining = TrainLWOfficerProject.CalculatePointsToTrain(); 
						TrainLWOfficerProject.InitialProjectPoints = TrainLWOfficerProject.CalculatePointsToTrain();
						TrainLWOfficerProject.SetProjectedCompletionDateTime(TrainLWOfficerProject.StartDateTime);
						break;
					}
				}

				//RefreshAcademyFacility();
			} else {
				`Redscreen("LW Officer Pack : Failed to find StaffSlot in UIArmory_LWOfficerPromotion.ConfirmAbilityCallback");
				bTrainingSuccess = false;
			}
		}

		//submit or clear update state based on success/failure
		if (bTrainingSuccess) 
		{
			UpdateState.AddStateObject(UpdatedUnit);
			UpdateState.AddStateObject(OfficerState);
			`GAMERULES.SubmitGameState(UpdateState);

			Header.PopulateData();
			PopulateData();
		} else {
			History.CleanupPendingGameState(UpdateState);
		}
		Movie.Pres.PlayUISound(eSUISound_SoldierPromotion);
		Movie.Pres.ScreenStack.PopUntilClass(class'UIFacility_Academy', true);
	}
	else
		Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
}

simulated function XComGameState_StaffSlot GetEmptyOfficerTrainingStaffSlot()
{
	local UIScreenStack ScreenStack;
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_StaffSlot SlotState;
	local UIFacility_Academy AcademyUI;
	local UIScreen CurrScreen;
	local int idx;

	ScreenStack = Movie.Pres.ScreenStack;

	//find the class UIFacilityAcademy that invoked this (just in case there's more than 1)
	AcademyUI = UIFacility_Academy(ScreenStack.GetScreen(class'UIFacility_Academy'));
	if(AcademyUI == none)
	{
		//search for override classes
		foreach ScreenStack.Screens(CurrScreen)
		{
			AcademyUI = UIFacility_Academy(CurrScreen);
			if(AcademyUI != none)
				break;
		}
	}
	if(AcademyUI == none)
	{
		FacilityState = `XCOMHQ.GetFacilityByName('OfficerTrainingSchool');
	}
	else
	{
		FacilityState = AcademyUI.GetFacility();
	}

	for(idx = 0; idx < FacilityState.StaffSlots.Length; idx++)
	{
		SlotState = FacilityState.GetStaffSlot(idx);
		if(SlotState != none && SlotState.GetMyTemplateName() == 'OTSOfficerSlot' && SlotState.IsSlotEmpty())
			return SlotState;
	}
	return none;
}

//disable prev/next buttons when Officer abilities displayed
simulated function PrevSoldier();
simulated function NextSoldier();

//simulated function RefreshAcademyFacility()
//{
	//local UIScreen QueueScreen;
//
	//QueueScreen = Movie.Stack.GetScreen(class'UIFacility_Academy');
	//if (QueueScreen != None)
		//UIFacility_Academy(QueueScreen).RealizeFacility();
//}
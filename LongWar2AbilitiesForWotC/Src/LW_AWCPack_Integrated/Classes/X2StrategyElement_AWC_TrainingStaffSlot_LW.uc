//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_AWC_TrainingStaffSlot_LW.uc
//  AUTHOR:  Amineri
//  PURPOSE: This adds templates and updates AWC Facility Template
//				Adds AWC Training staffslot and upgrade to AWC to allow AWC training
//---------------------------------------------------------------------------------------
class X2StrategyElement_AWC_TrainingStaffSlot_LW extends X2StrategyElement config(LW_AWCPack);

var config int AWCTRAININGUPGRADE_SLOT2_UNLOCKRANK;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateAWCTrainingSlotTemplate());  // add StaffSlot type
	Templates.AddItem(CreateAWCTrainingUpgradeTemplate_Slot2());	//add facility upgrade to unlock slot

	return Templates;
}

static function X2DataTemplate CreateAWCTrainingSlotTemplate()
{
	local X2StaffSlotTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StaffSlotTemplate', Template, 'AWCTrainingSlot_LW');
	Template.bSoldierSlot = true;
	Template.bRequireConfirmToEmpty = true;
	Template.FillFn = FillAWCTrainingSlot;
	Template.EmptyFn = class'X2StrategyElement_DefaultStaffSlots'.static.EmptySlotDefault;
	Template.EmptyStopProjectFn = EmptyStopProjectAWCTrainingSlot;
	Template.ShouldDisplayToDoWarningFn = ShouldDisplayAWCTrainingToDoWarning;
	Template.GetContributionFromSkillFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetContributionDefault;
	Template.GetAvengerBonusAmountFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetAvengerBonusDefault;
	Template.GetNameDisplayStringFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetNameDisplayStringDefault;
	Template.GetSkillDisplayStringFn = GetAWCSkillDisplayString;
	Template.GetBonusDisplayStringFn = GetAWCBonusDisplayString;
	//Template.GetLocationDisplayStringFn = GetOTSLocationDisplayString;
	Template.GetLocationDisplayStringFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetLocationDisplayStringDefault;
	Template.IsUnitValidForSlotFn = IsUnitValidForAWCTrainingSlot;
	Template.IsStaffSlotBusyFn = class'X2StrategyElement_DefaultStaffSlots'.static.IsStaffSlotBusyDefault;
	Template.MatineeSlotName = "AWC";

	return Template;
}

//---------------------------------------------------------------------------------------
// AWC Facility UPGRADE
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateAWCTrainingUpgradeTemplate_Slot2()
{
	local X2FacilityUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2FacilityUpgradeTemplate', Template, 'AWCTrainingUpgrade_SecondSlot_LW');
	//Template.MapName = "";
	Template.PointsToComplete = 0;
	Template.MaxBuild = 1;
	Template.iPower = -2;
	Template.UpkeepCost = 10;
	Template.strImage = "img:///UILibrary_StrategyImages.FacilityIcons.ChooseFacility_RecoveryCenter";
	Template.OnUpgradeAddedFn = AWCTrainingUpgradeAdded;

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = default.AWCTRAININGUPGRADE_SLOT2_UNLOCKRANK;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 150;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


static function AWCTrainingUpgradeAdded(XComGameState NewGameState, XComGameState_FacilityUpgrade Upgrade, XComGameState_FacilityXCom Facility)
{
	Facility.PowerOutput += Upgrade.GetMyTemplate().iPower;
	Facility.UpkeepCost += Upgrade.GetMyTemplate().UpkeepCost;
	Facility.UnlockStaffSlot(NewGameState);
}

static function bool IsGTSProjectActive(StateObjectReference FacilityRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_StaffSlot StaffSlot;
	local XComGameState_HeadquartersProjectTrainRookie RookieProject;
	local int i;

	History = `XCOMHISTORY;
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	FacilityState = XComGameState_FacilityXCom(History.GetGameStateForObjectID(FacilityRef.ObjectID));

	for (i = 0; i < FacilityState.StaffSlots.Length; i++)
	{
		StaffSlot = FacilityState.GetStaffSlot(i);
		if (StaffSlot.IsSlotFilled())
		{
			RookieProject = XComHQ.GetTrainRookieProject(StaffSlot.GetAssignedStaffRef());
			if (RookieProject != none)
			{
				return true;
			}
		}
	}
	return false;
}

//---------------------------------------------------------------------------------------
// Second slot helper functions

static function FillAWCTrainingSlot(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
	local XComGameState_Unit NewUnitState;
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_HeadquartersXCom NewXComHQ;
	//local XComGameState_HeadquartersProjectTrainAWC_LW ProjectState;
	local StateObjectReference EmptyRef;
	local int SquadIndex;

	class'X2StrategyElement_DefaultStaffSlots'.static.FillSlot(NewGameState, SlotRef, UnitInfo, NewSlotState, NewUnitState);
	NewXComHQ = class'X2StrategyElement_DefaultStaffSlots'.static.GetNewXComHQState(NewGameState);

	NewUnitState.SetStatus(eStatus_Training);

	// If the unit undergoing training is in the squad, remove them
	SquadIndex = NewXComHQ.Squad.Find('ObjectID', UnitInfo.UnitRef.ObjectID);
	if (SquadIndex != INDEX_NONE)
	{
		// Remove their gear, excepting super soldiers
		if(!NewUnitState.bIsSuperSoldier && !class'UISquadSelect'.default.NoStripOnTraining) 
		{
			NewUnitState.MakeItemsAvailable(NewGameState, false);
		}

		// Remove them from the squad
		NewXComHQ.Squad[SquadIndex] = EmptyRef;
	}
}

static function EmptyStopProjectAWCTrainingSlot(StateObjectReference SlotRef)
{
	local XComGameState_StaffSlot SlotState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectTrainAWC_LW TrainAWCProject;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	SlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(SlotRef.ObjectID));

	TrainAWCProject = XComGameState_HeadquartersProjectTrainAWC_LW(XComHQ.GetTrainRookieProject(SlotState.GetAssignedStaffRef()));
	if (TrainAWCProject != none)
	{
		class'LWAWCUtilities'.static.CancelAWCTrainingProject(TrainAWCProject.GetReference());
	}
}

static function bool ShouldDisplayAWCTrainingToDoWarning(StateObjectReference SlotRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_StaffSlot SlotState;
	local StaffUnitInfo UnitInfo;
	local int i;

	History = `XCOMHISTORY;
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	SlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(SlotRef.ObjectID));

	for (i = 0; i < XComHQ.Crew.Length; i++)
	{
		UnitInfo.UnitRef = XComHQ.Crew[i];

		if (IsUnitValidForAWCTrainingSlot(SlotState, UnitInfo))
		{
			return true;
		}
	}

	return false;
}

static function bool IsUnitValidForAWCTrainingSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;
	local bool HasEligibleRegularRank;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));

	HasEligibleRegularRank = Unit.GetRank() >= class'LWAWCUtilities'.default.RequiredRankForAWCTraining[1];

	if (Unit.IsSoldier()
		&& !Unit.IsInjured()
		&& !Unit.IsTraining()
		&& !Unit.IsPsiTraining()
		&& !Unit.IsPsiAbilityTraining()
		&& !Unit.CanRankUpSoldier()
		&& HasEligibleRegularRank
		&& Unit.GetStatus() != eStatus_OnMission // don't use DLC helpers here since sparks can't train as officers
		&& Unit.GetSoldierClassTemplate() != none
		&& class'LWAWCUtilities'.default.ClassCannotGetAWCTraining.Find(Unit.GetSoldierClassTemplateName()) == -1)
	{
		return true;
	}

	return false;
}

static function string GetAWCSkillDisplayString(XComGameState_StaffSlot SlotState)
{
	return "";
}

static function string GetAWCBonusDisplayString(XComGameState_StaffSlot SlotState, optional bool bPreview)
{
	local XComGameState_HeadquartersProjectTrainAWC_LW TrainProject;
	local string Contribution;

	if (SlotState.IsSlotFilled())
	{
		TrainProject = GetAWCTrainingProject(SlotState.GetAssignedStaffRef(), SlotState);
		Contribution = Caps(TrainProject.GetTrainingAbilityFriendlyName());
	}

	return class'X2StrategyElement_DefaultStaffSlots'.static.GetBonusDisplayString(SlotState, "%SKILL", Contribution);
}

static function XComGameState_HeadquartersProjectTrainAWC_LW GetAWCTrainingProject(StateObjectReference UnitRef, XComGameState_StaffSlot SlotState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectTrainAWC_LW TrainProject;
	local int idx;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	for (idx = 0; idx < XComHQ.Projects.Length; idx++)
	{
		TrainProject = XComGameState_HeadquartersProjectTrainAWC_LW(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));

		if (TrainProject != none)
		{
			if (SlotState.GetAssignedStaffRef() == TrainProject.ProjectFocus)
			{
				return TrainProject;
			}
		}
	}
}

DefaultProperties
{
	bShouldCreateDifficultyVariants = true
}

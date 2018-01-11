//---------------------------------------------------------------------------------------
//  FILE:    LWAWCUtilities.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This container holds config, localization, and utility code for the LW AWC system
//
//---------------------------------------------------------------------------------------
class LWAWCUtilities extends Object config(LW_AWCPack);

enum AWCTrainingType
{
	AWCTT_Offense,
	AWCTT_Pistol,
	AWCTT_Defense,
};

struct AWCAbilityConfig
{
	var int Level;
	var name AbilityName;
	var EInventorySlot ApplyToWeaponSlot;
	var name UtilityCat;
	var float Weight;
};

struct AWCAbilityRestriction
{
	var name AWCAbility;
	var name RestrictedClass;
	var name RestrictedAbility;
	var array<name> AllowedWeapons;
	var name RequiredAbility;
};

///////////////////////////////
// Ability tree
var config int NUM_OFFENSE_ABILITIES;
var config int NUM_DEFENSE_ABILITIES;
var config int NUM_PISTOL_ABILITIES;

var config array<AWCAbilityConfig> AWCAbilityTree_Offense;
var config array<AWCAbilityConfig> AWCAbilityTree_Pistol;
var config array<AWCAbilityConfig> AWCAbilityTree_Defense;

var config array<AWCAbilityRestriction> AWCRestrictions;

var config float PistolTrainingMultiplier; // all pistol ability training times are multiplied by this amount, then rounded down to nearest hour
var config float QuickStudyTrainingMultiplier; // for soldiers with the ability

///////////////////////////////
// Content

var config array<string> AWCLevelIcons;			//imagepaths to level icons

///////////////////////////////
// Config

var config array<int> RequiredRankForAWCTraining;		//  the minimum regular soldier rank required
var config array<float> TrainingDaysForAWCLevel;		// number of days required to train each AWC Level
var config array<name> ClassCannotGetAWCTraining;		// Class names that cannot train AWC perks

///////////////////////////////
// Localization

var localized array<string> AWCLevelNames;       //  there should be one name for each row in Armory UI
var localized string LeftAbilityTreeTitle;
var localized string CenterAbilityTreeTitle;
var localized string RightAbilityTreeTitle;

var localized string strAWCMenuOption;
var localized string strAWCListItemDescription;

///////////////////////////////
// Accessor and helper functions

// Number of days required to train to a the supplied rank
static function float GetAWCTrainingDays(int Level)
{
	local float Days;

	if(Level < 0)
	{
		Days = default.TrainingDaysForAWCLevel[0];
	}
	else
	{
		if(Level > default.TrainingDaysForAWCLevel.Length - 1)
		{
			Days = default.TrainingDaysForAWCLevel[default.TrainingDaysForAWCLevel.Length - 1];
		}
		else
		{
			Days = default.TrainingDaysForAWCLevel[Level];
		}
	}

	return Days;
}

//checks if a unit has any AWC abilities
static function bool HasAWCTraining(XComGameState_Unit Unit)
{
	local XComGameState_Unit_AWC_LW AWCState;
	local ClassAgnosticAbility Ability;

	AWCState = GetAWCComponent(Unit);
	if (AWCState == none) return false;

	foreach AWCState.OffenseAbilities(Ability)
	{
		if(Ability.bUnlocked)
			return true;
	}
	foreach AWCState.DefenseAbilities(Ability)
	{
		if(Ability.bUnlocked)
			return true;
	}
	foreach AWCState.PistolAbilities(Ability)
	{
		if(Ability.bUnlocked)
			return true;
	}
	return false;
}

// Returns the AWC component attached to the supplied Unit GameState
static function XComGameState_Unit_AWC_LW GetAWCComponent(XComGameState_Unit Unit, optional XComGameState NewGameState)
{
	local XComGameState_Unit_AWC_LW AWCState;

	if(Unit == none)
		return none;

	if(NewGameState != none)
	{
		foreach NewGameState.IterateByClassType(class'XComGameState_Unit_AWC_LW', AWCState)
		{
			if(AWCState.OwningObjectID == Unit.ObjectID)
				return AWCState;
		}
	}
	return XComGameState_Unit_AWC_LW(Unit.FindComponentObject(class'XComGameState_Unit_AWC_LW'));
}

//Returns the path to the AWC rank icon of the given rank
static function string GetAWCLevelIcon(const int Level)
{
	if(Level < 0 || Level > default.AWCLevelIcons.Length - 1)
		return "";
	return default.AWCLevelIcons[Level];
}

//Returns the localized string rank name of the given rank
static function string GetAWCLevelName(const int Level)
{
	if(Level < 0 || Level > default.AWCLevelNames.Length - 1)
		return "";
	return default.AWCLevelNames[Level];
}

static function GCandValidationChecks()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState, UpdatedUnit;
	local XComGameState_Unit_AWC_LW AWCState, UpdatedAWC;
	//local XComGameState_HeadquartersProjectTrainAWC_LW TrainAWCState;

	`LOG("LWAWCUtilities: Starting Garbage Collection and Validation.");

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("AWC States cleanup");
	foreach History.IterateByClassType(class'XComGameState_Unit_AWC_LW', AWCState,,true)
	{
		`LOG("LWAWCUtilities: Found AWCState, OwningObjectID=" $ AWCState.OwningObjectId $ ", Deleted=" $ AWCState.bRemoved);
		//check and see if the OwningObject is still alive and exists
		if(AWCState.OwningObjectId > 0)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AWCState.OwningObjectID));
			if(UnitState == none)
			{
				`LOG("LWAWCUtilities: AWC Component has no current owning unit, cleaning up state.");
				// Remove disconnected AWC state
				NewGameState.RemoveStateObject(AWCState.ObjectID);
			}
			else
			{
				`LOG("LWAWCUtilities: Found Owning Unit=" $ UnitState.GetFullName() $ ", Deleted=" $ UnitState.bRemoved);
				if(UnitState.bRemoved)
				{
					`LOG("LWAWCUtilities: Owning Unit was removed, Removing and unlinking AWCState");
					UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
					UpdatedAWC = XComGameState_Unit_AWC_LW(NewGameState.CreateStateObject(class'XComGameState_Unit_AWC_LW', AWCState.ObjectID));
					NewGameState.RemoveStateObject(UpdatedAWC.ObjectID);
					UpdatedUnit.RemoveComponentObject(UpdatedAWC);
					NewGameState.AddStateObject(UpdatedAWC);
					NewGameState.AddStateObject(UpdatedUnit);
				}
			}
		}
	}
	//foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectTrainAWC_LW', TrainAWCState,,true)
	//{
		////check and see if the OwningObject is still alive and exists
		//`LOG("LWAWCUtilities: Found TrainAWCState, ObjectID=" $  TrainAWCState.ObjectId);
	//}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

static function CancelAWCTrainingProject(StateObjectReference ProjectRef)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersProjectTrainAWC_LW ProjectState;
	local XComGameState_HeadquartersXCom XComHQ, NewXComHQ;
	local XComGameState_Unit UnitState;
	local XComGameState_StaffSlot StaffSlotState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Cancel AWC Training Project");

	ProjectState = XComGameState_HeadquartersProjectTrainAWC_LW(`XCOMHISTORY.GetGameStateForObjectID(ProjectRef.ObjectID));

	if (ProjectState != none)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ProjectState.ProjectFocus.ObjectID));

		if (UnitState != none)
		{
			// Set the soldier status back to active
			UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
			UnitState.SetStatus(eStatus_Active);
			NewGameState.AddStateObject(UnitState);

			// Remove the soldier from the staff slot
			StaffSlotState = UnitState.GetStaffSlot();
			if (StaffSlotState != none)
			{
				StaffSlotState.EmptySlot(NewGameState);
			}
		}

		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		if (XComHQ != none)
		{
			NewXComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			NewGameState.AddStateObject(NewXComHQ);
			NewXComHQ.Projects.RemoveItem(ProjectState.GetReference());
			NewGameState.RemoveStateObject(ProjectState.ObjectID);
		}
	}
	`GAMERULES.SubmitGameState(NewGameState);
}

/////////////////////////////////////
///////// Presentation helper

static function UIChooseAWCAbility(StateObjectReference UnitRef, StateObjectReference StaffSlotRef, optional bool b3DMovie = false)
{
	local XComHQPresentationLayer HQPres;
	local UIChooseAWCAbility_LW AWCScreen;

	HQPres = `HQPRES;
	if (`SCREENSTACK.IsNotInStack(class'UIChooseAWCAbility_LW'))
	{
		AWCScreen = HQPres.Spawn(class'UIChooseAWCAbility_LW', HQPres);
		AWCScreen.m_UnitRef = UnitRef;
		AWCScreen.m_StaffSlotRef = StaffSlotRef;
		`SCREENSTACK.Push(AWCScreen, (b3DMovie ? HQPres.Get3DMovie() : none));
	}
}

function static array<ClassAgnosticAbility> GetValidAWCAbilitiesForUnit(XComGameState_Unit UnitState, array<AWCAbilityConfig> SourceAbilities, int AWCLevel, optional XComGameState_Unit_AWC_LW AWCComponent)
{
	local array<ClassAgnosticAbility> Abilities;
	local ClassAgnosticAbility NewAbility;
	local AWCAbilityConfig PossibleAbility;
    local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;

	if (AWCComponent == none)
	{
		AWCComponent = GetAWCComponent(UnitState); // retrieve from history if it wasn't passed
	}

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach SourceAbilities(PossibleAbility)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(PossibleAbility.AbilityName);
		if (AbilityTemplate == none)
			continue;

		if(PossibleAbility.Level != AWCLevel)
			continue;

		if(RestrictedAbility(UnitState, AWCComponent, PossibleAbility.AbilityName))
			continue;

		if(HasClassAbility(UnitState, PossibleAbility.AbilityName))
			continue;

        if (HasEarnedAbility(UnitState, PossibleAbility.AbilityName))
            continue;

		if(AWCComponent != none && AWCComponent.HasAWCAbility(UnitState, PossibleAbility.AbilityName))
			continue;

		NewAbility.iRank = PossibleAbility.Level;
		NewAbility.bUnlocked = false;
		NewAbility.AbilityType.AbilityName = PossibleAbility.AbilityName;
		NewAbility.AbilityType.ApplyToWeaponSlot = PossibleAbility.ApplyToWeaponSlot;
		NewAbility.AbilityType.UtilityCat = PossibleAbility.UtilityCat;
		Abilities.AddItem(NewAbility);
	}
	return Abilities;
}

// Is the given ability restricted for the given unit? Takes a possibly-none AWCComponent.
function static bool RestrictedAbility(XComGameState_Unit Unit, XComGameState_Unit_AWC_LW AWCComponent, name AbilityName)
{
	local AWCAbilityRestriction Restriction;
	local X2SoldierClassTemplate SoldierClassTemplate;

	SoldierClassTemplate = Unit.GetSoldierClassTemplate();

	foreach default.AWCRestrictions(Restriction)
	{
		if(Restriction.AWCAbility != AbilityName)
			continue;

		if(Restriction.RestrictedClass == Unit.GetSoldierClassTemplateName())
			return true;

		if (Restriction.RestrictedAbility != '')
		{
			if(AWCComponent != none && AWCComponent.HasAWCAbility(Unit, Restriction.RestrictedAbility) || HasClassAbility(Unit, Restriction.RestrictedAbility) || HasEarnedAbility(Unit, Restriction.RestrictedAbility))
				return true;
		}

		if (Restriction.AllowedWeapons.Length > 0)
		{
			if (SoldierClassTemplate == none)
				return true;

			if (!HasAllowedWeapon(SoldierClassTemplate, Restriction.AllowedWeapons))
				return true;
		}

		if (Restriction.RequiredAbility != '' && !HasClassAbility(Unit, Restriction.RequiredAbility))
			return true;
	}

	return false;
}

function static bool HasAllowedWeapon(X2SoldierClassTemplate SoldierClassTemplate, array<name> AllowedWeapons)
{
	local SoldierClassWeaponType Weapon;

	foreach SoldierClassTemplate.AllowedWeapons(Weapon)
	{
		if (AllowedWeapons.Find(Weapon.WeaponType) != INDEX_NONE)
			return true;
	}

	return false;
}

function static bool HasClassAbility(XComGameState_Unit Unit, name AbilityName)
{
	local X2SoldierClassTemplate SoldierClassTemplate;
	local array<SoldierClassAbilityType> AllPossibleAbilities;
	local int iRank, iBranch;

	SoldierClassTemplate = Unit.GetSoldierClassTemplate();
    if (SoldierClassTemplate != None)
    {
	    //for(iRank = 0; iRank < SoldierClassTemplate.GetMaxConfiguredRank(); iRank++)
	    //{
		    //AbilityTree = SoldierClassTemplate.GetAbilityTree(iRank);
		    //for(iBranch = 0; iBranch < AbilityTree.Length; iBranch++)
		    //{
			    //if(AbilityTree[iBranch].AbilityName == AbilityName)
				    //return true;
		    //}
	    //}
		// JOC THINK I FIXED THIS
		AllPossibleAbilities = SoldierClassTemplate.GetAllPossibleAbilities();

		if(AllPossibleAbilities.Find('AbilityName', AbilityName) != INDEX_NONE) 
		{
			return true;
		}
    }
	return false;
}

function static bool HasEarnedAbility(XComGameState_Unit Unit, name AbilityName)
{
    local array<SoldierClassAbilityType> EarnedAbilities;
    local int i;

    EarnedAbilities = Unit.GetEarnedSoldierAbilities();
    for (i = 0; i < EarnedAbilities.Length; ++i)
    {
        if (EarnedAbilities[i].AbilityName == AbilityName)
            return true;
    }

    return false;
}

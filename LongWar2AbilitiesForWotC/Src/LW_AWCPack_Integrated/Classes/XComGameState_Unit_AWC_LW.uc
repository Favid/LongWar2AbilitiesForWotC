//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Unit_AWC_LW.uc
//  AUTHOR:  Amineri
//  PURPOSE: This is a component extension for Unit GameStates, containing 
//				additional data used for AWC.
//---------------------------------------------------------------------------------------
class XComGameState_Unit_AWC_LW extends XComGameState_BaseObject dependson(LWAWCUtilities) config(LW_AWCPack);

var AWCTrainingType CurrentTrainingType;
var int CurrentTrainingIndex;
var name LastAbilityTrainedName;
var name AbilityTrainingName;

//randomized set of trainable AWC abilities -- created once per soldier, then stored persistently
var array<ClassAgnosticAbility> OffenseAbilities;
var array<ClassAgnosticAbility> DefenseAbilities;
var array<ClassAgnosticAbility> PistolAbilities;


function XComGameState_Unit_AWC_LW InitComponent()
{
	CurrentTrainingIndex = 0;
	return self;
}

function XComGameState_Unit GetUnit()
{
	return XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectID));
}

function TrainAbility(int index, AWCTrainingType Option)
{
	switch (Option)
	{
		case AWCTT_Offense:
			OffenseAbilities[Index].bUnlocked = true;
			break;
		case AWCTT_Pistol:
			PistolAbilities[Index].bUnlocked = true;
			break;
		case AWCTT_Defense:
			DefenseAbilities[Index].bUnlocked = true;
			break;
		default:
			break;
	}
}

// Returns the ability of the given type at the given level
function ClassAgnosticAbility GetAbility(const int Index, const AWCTrainingType Option)
{
	local XComGameState NewGameState;
	local ClassAgnosticAbility EmptyAbility, ReturnAbility;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;
	local int LoopCounter;
	local bool bAbilityInvalid;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_AWC_LW UpdatedAWCState;

	Unit = GetUnit();
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	switch (Option)
	{
		case AWCTT_Offense:
			if (Index < OffenseAbilities.Length)
			{
				ReturnAbility = OffenseAbilities[Index];
			}
			else
			{
				ReturnAbility = EmptyAbility;
				LoopCounter = 10;
			}
			break;
		case AWCTT_Pistol:
			if (Index < PistolAbilities.Length)
			{
				ReturnAbility = PistolAbilities[Index];
			}
			else
			{
				ReturnAbility = EmptyAbility;
				LoopCounter = 10;
			}
			break;
		case AWCTT_Defense:
			if (Index < DefenseAbilities.Length)
			{
				ReturnAbility = DefenseAbilities[Index];
			}
			else
			{
				ReturnAbility = EmptyAbility;
				LoopCounter = 10;
			}
			break;
		default:
			ReturnAbility = EmptyAbility;
			LoopCounter = 10;
			break;
	}
	while (AbilityTemplate == none && LoopCounter < 10)
	{
		++LoopCounter;
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(ReturnAbility.AbilityType.AbilityName);
		if (AbilityTemplate == none)
		{
			bAbilityInvalid = true;
			ReturnAbility = ChooseSoldierAWCOption(Unit, Index, Option);
		}
	}
	if (bAbilityInvalid && AbilityTemplate != none) // the original ability was invalid, but we found a new one, so save it off
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Re-choose invalid AWC Ability");
		UpdatedAWCState = XComGameState_Unit_AWC_LW(NewGameState.CreateStateObject(class, ObjectID));
		NewGameState.AddStateObject(UpdatedAWCState);
		
		switch (Option)
		{
			case AWCTT_Offense:
				UpdatedAWCState.OffenseAbilities[Index] = ReturnAbility;
				break;
			case AWCTT_Pistol:
				UpdatedAWCState.PistolAbilities[Index] = ReturnAbility;
				break;
			case AWCTT_Defense:
				UpdatedAWCState.DefenseAbilities[Index] = ReturnAbility;
				break;
			default:
				break;
		}	

		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

	return ReturnAbility;
}

function name GetAbilityName(int Index, int Option)
{
	local ClassAgnosticAbility Ability;

	Ability = GetAbility(Index, AWCTrainingType(Option));
	return Ability.AbilityType.AbilityName;
}

function int GetMaxAbilitiesOfAnyType()
{
	local int Num;

	Num = OffenseAbilities.Length;
	Num = Max(Num, DefenseAbilities.Length);
	Num = Max(Num, PistolAbilities.Length);

	return Num;
}

//This uses the config data in LWAWCUtilities to select a set of AWC abilities for a soldier
function ChooseSoldierAWCOptions(XComGameState_Unit UnitState, optional bool bForce=false)
{
	local int idx;
	local array<ClassAgnosticAbility> PossibleAbilities;
	local int NumPistolAbilities;

	if(bForce)
	{
		OffenseAbilities.Length = 0;
		DefenseAbilities.Length = 0;
		PistolAbilities.Length = 0;
	}
	else
	{
		if(OffenseAbilities.Length > 0 || DefenseAbilities.Length > 0 || PistolAbilities.Length > 0)
			return;
	}

	//Fill out with randomized abilities
	for(idx = 0; idx < class'LWAWCUtilities'.default.NUM_OFFENSE_ABILITIES; idx++)
	{
		OffenseAbilities[idx] = ChooseSoldierAWCOption(UnitState, idx, AWCTT_Offense);
	}

	for(idx = 0; idx < class'LWAWCUtilities'.default.NUM_DEFENSE_ABILITIES; idx++)
	{
		DefenseAbilities[idx] = ChooseSoldierAWCOption(UnitState, idx, AWCTT_Defense);
	}

	PossibleAbilities = WeightedSort(class'LWAWCUtilities'.default.AWCAbilityTree_Pistol);
	NumPistolAbilities = Min(class'LWAWCUtilities'.default.AWCAbilityTree_Pistol.Length, class'LWAWCUtilities'.default.NUM_PISTOL_ABILITIES);
	for(idx = 0; idx < NumPistolAbilities; idx++)
	{
		PistolAbilities[idx] = PossibleAbilities[idx];
	}
}

function ClassAgnosticAbility ChooseSoldierAWCOption(XComGameState_Unit UnitState, const int idx, const AWCTrainingType Option)
{
	local ClassAgnosticAbility EmptyAbility, NewAbility;
	local array<ClassAgnosticAbility> PossibleAbilities;

	switch (Option)
	{
		case AWCTT_Offense:
			PossibleAbilities = GetValidAWCAbilities(class'LWAWCUtilities'.default.AWCAbilityTree_Offense, idx + 1);
			NewAbility = PossibleAbilities[`SYNC_RAND(PossibleAbilities.Length)];
			break;
		case AWCTT_Defense:
			PossibleAbilities = GetValidAWCAbilities(class'LWAWCUtilities'.default.AWCAbilityTree_Defense, idx + 1);
			NewAbility = PossibleAbilities[`SYNC_RAND(PossibleAbilities.Length)];
			break;
		case AWCTT_Pistol:
			PossibleAbilities = WeightedSort(class'LWAWCUtilities'.default.AWCAbilityTree_Pistol);
			NewAbility = PossibleAbilities[Min(idx, PossibleAbilities.Length)];
			break;
		default:
			NewAbility = EmptyAbility;
			break;
	}
	return NewAbility;
}

function array<ClassAgnosticAbility> WeightedSort(const array<AWCAbilityConfig> SourceAbilities)
{
	local array<ClassAgnosticAbility> Abilities;
	local array<AWCAbilityConfig> RemainingAbilities;
	local int ArrayLength, idx, Selection;

	ArrayLength = SourceAbilities.Length;
	RemainingAbilities = SourceAbilities;

	for(idx = 0; idx < ArrayLength; idx++)
	{
		Selection = WeightedSelect(RemainingAbilities);
		Abilities.AddItem(BuildAbility(RemainingAbilities[Selection]));
		RemainingAbilities.Remove(Selection, 1);
	}

	return Abilities;
}

function int WeightedSelect(array<AWCAbilityConfig> SourceAbilities)
{
	local float SumWeight, RandWeight;
	local AWCAbilityConfig AbilityConfig;
	local float TotalWeight;
	local int iCount;

	TotalWeight = 0;
	foreach SourceAbilities(AbilityConfig)
	{
		TotalWeight += AbilityConfig.Weight;
	}

	RandWeight = `SYNC_FRAND() * TotalWeight;
	SumWeight = 0;
	foreach SourceAbilities(AbilityConfig, iCount)
	{
		SumWeight += AbilityConfig.Weight;
		if(RandWeight <= SumWeight)
			return iCount;
	}
	return SourceAbilities.Length-1;
}

function ClassAgnosticAbility BuildAbility(AWCAbilityConfig AbilityConfig)
{
	local ClassAgnosticAbility Ability;

	Ability.bUnlocked = false;
	Ability.iRank = AbilityConfig.Level;
	Ability.AbilityType.AbilityName = AbilityConfig.AbilityName;
	Ability.AbilityType.ApplyToWeaponSlot = AbilityConfig.ApplyToWeaponSlot;
	Ability.AbilityType.UtilityCat = AbilityConfig.UtilityCat;

	return Ability;
}

function array<ClassAgnosticAbility> GetValidAWCAbilities(array<AWCAbilityConfig> SourceAbilities, int AWCLevel)
{
    return class'LWAWCUtilities'.static.GetValidAWCAbilitiesForUnit(GetUnit(), SourceAbilities, AWCLevel, self);
}

function bool HasAWCAbility(XComGameState_Unit Unit, name AbilityName)
{
	local ClassAgnosticAbility Ability;

	foreach OffenseAbilities(Ability)
	{
		if(Ability.AbilityType.AbilityName == AbilityName)
			return true;
	}
	foreach DefenseAbilities(Ability)
	{
		if(Ability.AbilityType.AbilityName == AbilityName)
			return true;
	}
	foreach PistolAbilities(Ability)
	{
		if(Ability.AbilityType.AbilityName == AbilityName)
			return true;
	}
	return false;
}

function array<ClassAgnosticAbility> GetAllTrainedAWCAbilities()
{
	local array<ClassAgnosticAbility> ReturnArray;
	local ClassAgnosticAbility Ability;

	foreach OffenseAbilities(Ability)
	{
		if(Ability.bUnlocked)
		{
			ReturnArray.AddItem(Ability);
		}
	}
	foreach DefenseAbilities(Ability)
	{
		if(Ability.bUnlocked)
		{
			ReturnArray.AddItem(Ability);
		}
	}
	foreach PistolAbilities(Ability)
	{
		if(Ability.bUnlocked)
		{
			ReturnArray.AddItem(Ability);
		}
	}
	return ReturnArray;
}
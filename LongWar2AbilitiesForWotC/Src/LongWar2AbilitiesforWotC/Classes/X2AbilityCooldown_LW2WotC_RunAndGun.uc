class X2AbilityCooldown_LW2WotC_RunAndGun extends X2AbilityCooldown config(LW_SoldierSkills);

var int BaseCooldown;
var int ExtraConditioningCooldownReduction;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{

	if (XComGameState_Unit(AffectState).HasSoldierAbility('LW2WotC_ExtraConditioning'))
	{
		return BaseCooldown - ExtraConditioningCooldownReduction;
	}

	return BaseCooldown;
}


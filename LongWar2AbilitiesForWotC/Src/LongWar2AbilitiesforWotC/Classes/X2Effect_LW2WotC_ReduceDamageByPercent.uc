//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_AbsorptionFields
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up damage mitigation from AF
//--------------------------------------------------------------------------------------- 

class X2Effect_LW2WotC_ReduceDamageByPercent extends X2Effect_BonusArmor;

var float DamageReductionPercent;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
    return int(-1.0 * float(CurrentDamage) * DamageReductionPercent / 100.0);    
}

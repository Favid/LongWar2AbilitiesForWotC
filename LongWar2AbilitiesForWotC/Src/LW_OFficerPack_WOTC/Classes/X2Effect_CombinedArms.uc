//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_CombinedArms
//  AUTHOR:  John Lumpkin / Long War Studios
//  PURPOSE: Combined Arms effect
//--------------------------------------------------------------------------------------- 
class X2Effect_CombinedArms extends X2Effect_LWOfficerCommandAura 
	config (LW_OfficerPack);

var config float COMBINEDARMS_DAMAGE_BONUS;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{

	//`Log("Combined Arms: Checking relevance");
	if (IsEffectCurrentlyRelevant(EffectState, Attacker))
	{
		switch (AppliedData.AbilityResultContext.HitResult)
		{
			case eHit_Crit:
			case eHit_Success:
				return int(default.COMBINEDARMS_DAMAGE_BONUS);
			default:
				return 0;
		}
	}
	return 0;
}

defaultproperties
{
 	EffectName=CombinedArms;

}
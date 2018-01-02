//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ArcthrowerStun.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Stunning effect with tech dependendent stun duration
//---------------------------------------------------------------------------------------
class X2Effect_ArcthrowerStunned extends X2Effect_Stunned config(GameData_SoldierSkills);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit		SourceUnit, TargetUnit;
	local XComGameState_Item		SourceWeapon;
	local X2WeaponTemplate			WeaponTemplate;
	local int						TechStunLevel;

	// Set Stun Level to minimum tech level to start
	StunLevel = class'X2Item_ArcthrowerWeapon'.default.Arcthrower_CONVENTIONAL_ICLIPSIZE;

	SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if(SourceWeapon != none)
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	if(WeaponTemplate != none)
		TechStunLevel = WeaponTemplate.iClipSize;

	// If SourceUnit has the 'Arcthrower_PreventNegativeEffectsOnAlliesEffect' effect and the Target is an ally, only apply the minimum stun duration
	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (SourceUnit.AppliedEffectNames.Find('Arcthrower_PreventNegativeEffectsOnAlliesEffect') != -1)
	{
		// SourceUnit has effect to prevent negative effects on allies - check if the target is an ally
		if (SourceUnit.ControllingPlayer != TargetUnit.ControllingPlayer && !TargetUnit.IsMindControlled())
		{
			// Target is not an ally - apply tech boosts to stun duration
			StunLevel = TechStunLevel;
		}
	}
	else
	{
		StunLevel = TechStunLevel;
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
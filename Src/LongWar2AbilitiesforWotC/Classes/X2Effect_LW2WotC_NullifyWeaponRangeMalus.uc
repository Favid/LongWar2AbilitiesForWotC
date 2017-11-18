class X2Effect_LW2WotC_NullifyWeaponRangeMalus extends XMBEffect_ConditionalBonus config (LW_SoldierSkills);

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item	SourceWeapon;
	local X2WeaponTemplate		WeaponTemplate;
	local ShotModifierInfo		ShotInfo;
    local int					Tiles, Modifier;
	local array<int>			RangeTable;

    if (ValidateAttack(EffectState, Attacker, Target, AbilityState) == 'AA_Success')
    {
        SourceWeapon = AbilityState.GetSourceWeapon();    
        if(SourceWeapon != none)
        {
            WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
            RangeTable = WeaponTemplate.RangeAccuracy;
            Tiles = Attacker.TileDistanceBetween(Target);       
            if(Tiles < RangeTable.Length)
            {
                Modifier = -RangeTable[Tiles];
            }            
            else //Use last value
            {
                Modifier = -RangeTable[RangeTable.Length - 1];
            }
            if (Modifier > 0)
            {
                ShotInfo.Value = Modifier;
            }
            ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotModifiers.AddItem(ShotInfo);
        }
    }
	
}
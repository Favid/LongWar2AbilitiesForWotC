class X2Effect_LW2WotC_MovementBasedBonusDamage extends XMBEffect_ConditionalBonus config(LW_SoldierSkills);

var float BonusDmgPerTile;
var array<name> AbilityNames;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{ 
    local XComWorldData WorldData;
    local XComGameState_Unit TargetUnit;
    local XComGameState_Destructible TargetObject;
    local float BonusDmg;
    local float Dist;
    local vector StartLoc, TargetLoc;

    TargetUnit = XComGameState_Unit(TargetDamageable);
    TargetObject = XComGameState_Destructible(TargetDamageable);

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if ((TargetUnit != none || TargetObject != none) && AbilityNames.Find(AbilityState.GetMyTemplate().DataName) != -1)
        {
            WorldData = `XWORLD;
            StartLoc = WorldData.GetPositionFromTileCoordinates(Attacker.TurnStartLocation);
            if (TargetUnit != none)
            {
                TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
            }
            else if (TargetObject != none)
            {
                TargetLoc = WorldData.GetPositionFromTileCoordinates(TargetObject.TileLocation);
            }
            Dist = VSize(StartLoc - TargetLoc);
            BonusDmg = BonusDmgPerTile * VSize(StartLoc - TargetLoc)/ WorldData.WORLD_StepSize;
            return int(BonusDmg);
        }
    }
    return 0; 
}
class X2Effect_LW2WotC_BonusArmor extends X2Effect_BonusArmor;

var int BonusArmor;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return 100;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return BonusArmor;
}
class X2AbilityCharges_BonusCharges extends X2AbilityCharges;

var int BonusCharges;
var name BonusAbility;
var name BonusItem;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
    local int Charges;

    Charges = InitialCharges;
    if (Unit.HasSoldierAbility(BonusAbility, true) || Unit.HasItemOfTemplateType (BonusItem))
    {
        Charges += BonusCharges;
    }
    return Charges;
}

defaultproperties
{
    InitialCharges=1
}
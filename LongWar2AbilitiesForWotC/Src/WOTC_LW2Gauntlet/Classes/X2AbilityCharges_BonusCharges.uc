//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityCharges_BonusCharges.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Subclass of X2AbilityCharges that lets a different item or ability grant additonal charges
//---------------------------------------------------------------------------------------

class X2AbilityCharges_BonusCharges extends X2AbilityCharges;

var int BonusAbilityCharges;
var name BonusAbility;
var name BonusItem;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
    local int Charges;

    Charges = InitialCharges;
    if (Unit.HasSoldierAbility(BonusAbility, true) || Unit.HasItemOfTemplateType (BonusItem))
    {
        Charges += BonusAbilityCharges;
    }
    return Charges;
}

defaultproperties
{
    InitialCharges=1
}
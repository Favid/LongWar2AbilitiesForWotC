class X2Effect_LW2WotC_AddGrenadeSlotCharges extends XMBEffect_AddItemCharges;

var bool bDamagingGrenadesOnly;
var bool bNonDamagingGrenadesOnly;

function int GetItemChargeModifier(XComGameState NewGameState, XComGameState_Unit NewUnit, XComGameState_Item ItemIter)
{
    local X2WeaponTemplate WeaponTemplate;

    WeaponTemplate = X2WeaponTemplate(ItemIter.GetMyTemplate());

    if(WeaponTemplate == none)
    {
        return 0;
    }

    if(bDamagingGrenadesOnly)
    {
        if(WeaponTemplate.BaseDamage.Damage <= 0)
        {
            return 0;
        }
    }
    
    if(bNonDamagingGrenadesOnly)
    {
        if(WeaponTemplate.BaseDamage.Damage > 0)
        {
            return 0;
        }
    }

    return super.GetItemChargeModifier(NewGameState, NewUnit, ItemIter);
}

defaultproperties
{
    ApplyToSlots[0]=eInvSlot_GrenadePocket;
}
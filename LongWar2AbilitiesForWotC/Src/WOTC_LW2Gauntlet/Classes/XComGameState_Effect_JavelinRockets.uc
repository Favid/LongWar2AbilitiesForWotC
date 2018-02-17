//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_JavelinRockets.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is an effect component extension listening for OnGetItemRange to apply the JavelinRockets bonus range to rockets
//---------------------------------------------------------------------------------------

class XComGameState_Effect_JavelinRockets extends XComGameState_BaseObject config(LW_SoldierSkills);

function XComGameState_Effect_JavelinRockets InitComponent()
{
    return self;
}

function XComGameState_Effect GetOwningEffect()
{
    return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

//this is triggered when checking range on an item
function EventListenerReturn OnGetItemRange(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple                   OverrideTuple;
    local XComGameState_Item        Item;
    //local int                     Range;  // in tiles -- either bonus or override
    local XComGameState_Ability     Ability;
    local name                      AbilityName;
    //local bool                        bOverride; // if true, replace the range, if false, just add to it
    local XComGameState_Item        SourceWeapon;
    local X2MultiWeaponTemplate     WeaponTemplate;

    if(EventData == none)
    {
        `REDSCREEN("OnGetItemRange event triggered with empty EventData.");
        return ELR_NoInterrupt;
    }

    OverrideTuple = XComLWTuple(EventData);
    if(OverrideTuple == none)
    {
        `REDSCREEN("OnGetItemRange event triggered with invalid event data.");
        return ELR_NoInterrupt;
    }
    //`LOG("OverrideTuple : Parsed XComLWTuple.");

    Item = XComGameState_Item(EventSource);
    if(Item == none)
        return ELR_NoInterrupt;
    //`LOG("OverrideTuple : EventSource valid.");

    if(OverrideTuple.Id != 'GetItemRange')
        return ELR_NoInterrupt;

    //bOverride = OverrideTuple.Data[0].b;  // override? (true) or add? (false)
    //Range = OverrideTuple.Data[1].i;  // override/bonus range
    Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability

    //verify the owner of the item matches
    if(Item.OwnerStateObject != GetOwningEffect().ApplyEffectParameters.SourceStateObjectRef)
        return ELR_NoInterrupt;

    if(Ability == none)
        return ELR_NoInterrupt;

    AbilityName = Ability.GetMyTemplateName();

    //get the source weapon and weapon template
    SourceWeapon = Ability.GetSourceWeapon();
    WeaponTemplate = X2MultiWeaponTemplate(SourceWeapon.GetMyTemplate());
    
    if(WeaponTemplate == none)
        return ELR_NoInterrupt;

    // make sure the weapon is a gauntlet and that we are using a rocket ability
    if(WeaponTemplate != none)
    {
        if(AbilityName == 'LW2WotC_RocketLauncher' || AbilityName == 'LW2WotC_BlasterLauncher' || class'X2Ability_LW_TechnicalAbilitySet'.default.JAVELIN_ROCKETS_VALID_ABILITIES.Find (AbilityName) != -1)
        {
            OverrideTuple.Data[1].i += class'X2Ability_LW_TechnicalAbilitySet'.default.JAVELIN_ROCKETS_BONUS_RANGE_TILES;
        }
    }
    
    return ELR_NoInterrupt;
}

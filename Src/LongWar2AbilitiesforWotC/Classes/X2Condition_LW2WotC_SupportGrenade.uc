class X2Condition_LW2WotC_SupportGrenade extends X2Condition config (LW_SoldierSkills);

var config array<name> VALID_ABILITIES;
var config array<name> VALID_GRENADE_ABILITIES;
var config array<name> VALID_GRENADE_TYPES;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local name                      AbilityName;
    local XComGameState_Item        SourceWeapon;
    local X2WeaponTemplate          SourceWeaponAmmoTemplate;

    if(kAbility == none)
        return 'AA_InvalidAbilityName';

    SourceWeapon = kAbility.GetSourceWeapon();
    AbilityName = kAbility.GetMyTemplateName();

    if (SourceWeapon == none)
        return 'AA_InvalidAbilityName';

    if (default.VALID_ABILITIES.Find(AbilityName) != INDEX_NONE)
        return 'AA_Success';

    if(default.VALID_GRENADE_ABILITIES.Find(AbilityName) != INDEX_NONE)
    {
        if (default.VALID_GRENADE_TYPES.Find(SourceWeapon.GetMyTemplateName()) != INDEX_NONE)
        {
            return 'AA_Success';
        }

        SourceWeaponAmmoTemplate = X2WeaponTemplate(SourceWeapon.GetLoadedAmmoTemplate(kAbility));
        if (SourceWeaponAmmoTemplate != none )
        {
            if (default.VALID_GRENADE_TYPES.Find(SourceWeaponAmmoTemplate.DataName) != INDEX_NONE)
            {
                return 'AA_Success';
            }
        }
    }

    return 'AA_InvalidAbilityName';
}
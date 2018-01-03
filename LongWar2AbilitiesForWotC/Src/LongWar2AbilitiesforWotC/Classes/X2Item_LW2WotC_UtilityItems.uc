class X2Item_LW2WotC_UtilityItems extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Items;

    Items.AddItem(GhostGrenade());

    return Items;
}


// We need a dummy grenade so that the Ghost Grenade ability can be treated like a grenade
static function X2GrenadeTemplate GhostGrenade()
{
    local X2GrenadeTemplate Template;

    `CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'LW2WotC_GhostGrenade');

    Template.WeaponCat = 'Utility';
    Template.ItemCat = 'Utility';

    Template.iRange = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RANGE;
    Template.iRadius = 0.75;
    Template.iSoundRange = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_ISOUNDRANGE;
    Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_IENVIRONMENTDAMAGE;
    Template.iClipSize = 0;
    Template.Tier = 2;

    Template.Abilities.AddItem('VanishingAct');

    Template.GameArchetype = "WP_Grenade_Smoke.WP_Grenade_Smoke";
    Template.OnThrowBarkSoundCue = 'SmokeGrenade';

    Template.CanBeBuilt = false;

    return Template;
}
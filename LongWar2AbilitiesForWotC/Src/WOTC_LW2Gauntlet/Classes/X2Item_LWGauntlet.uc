//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWGauntlet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for Technical class Gauntlet weapon
//           
//---------------------------------------------------------------------------------------
class X2Item_LWGauntlet extends X2Item config(GameData_WeaponData);

var bool bFiniteItems;

// ***** UI Image definitions  *****
var config string Gauntlet_CV_UIImage;
var config string Gauntlet_MG_UIImage;
var config string Gauntlet_CG_UIImage;
var config string Gauntlet_BM_UIImage;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Gauntlet_Primary_CONVENTIONAL_BASEDAMAGE;  // Rocket
var config WeaponDamageValue Gauntlet_Secondary_CONVENTIONAL_BASEDAMAGE;  // Flamethrower

// ***** Core properties and variables for weapons *****
var config int Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE;
var config int Gauntlet_Primary_CONVENTIONAL_ISOUNDRANGE;
var config int Gauntlet_Primary_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int Gauntlet_Primary_CONVENTIONAL_RANGE;
var config int Gauntlet_Primary_CONVENTIONAL_RADIUS;

var config int Gauntlet_Secondary_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_CONVENTIONAL_OPPOSED_STAT_STRENTH;
var config int Gauntlet_Secondary_CONVENTIONAL_RANGE;
var config int Gauntlet_Secondary_CONVENTIONAL_RADIUS;
var config int Gauntlet_Secondary_CONVENTIONAL_ISOUNDRANGE;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Gauntlet_Primary_MAG_BASEDAMAGE;  // Rocket
var config WeaponDamageValue Gauntlet_Secondary_MAG_BASEDAMAGE;  // Flamethrower

// ***** Core properties and variables for weapons *****
var config int Gauntlet_Primary_MAG_ICLIPSIZE;
var config int Gauntlet_Primary_MAG_ISOUNDRANGE;
var config int Gauntlet_Primary_MAG_IENVIRONMENTDAMAGE;
var config int Gauntlet_Primary_MAG_RANGE;
var config int Gauntlet_Primary_MAG_RADIUS;

var config int Gauntlet_Secondary_MAG_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_MAG_OPPOSED_STAT_STRENTH;
var config int Gauntlet_Secondary_MAG_RANGE;
var config int Gauntlet_Secondary_MAG_RADIUS;
var config int Gauntlet_Secondary_MAG_ISOUNDRANGE;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Gauntlet_Primary_BEAM_BASEDAMAGE;  // Rocket
var config WeaponDamageValue Gauntlet_Secondary_BEAM_BASEDAMAGE;  // Flamethrower

// ***** Core properties and variables for weapons *****
var config int Gauntlet_Primary_BEAM_ICLIPSIZE;
var config int Gauntlet_Primary_BEAM_ISOUNDRANGE;
var config int Gauntlet_Primary_BEAM_IENVIRONMENTDAMAGE;
var config int Gauntlet_Primary_BEAM_RANGE;
var config int Gauntlet_Primary_BEAM_RADIUS;

var config int Gauntlet_Secondary_BEAM_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_BEAM_OPPOSED_STAT_STRENTH;
var config int Gauntlet_Secondary_BEAM_RANGE;
var config int Gauntlet_Secondary_BEAM_RADIUS;
var config int Gauntlet_Secondary_BEAM_ISOUNDRANGE;

// ***** Schematic/Item cost properties *****
var config int Gauntlet_MAGNETIC_SCHEMATIC_SUPPLYCOST;
var config int Gauntlet_MAGNETIC_SCHEMATIC_ALLOYCOST;
var config int Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCOST;
var config int Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;

var config int Gauntlet_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
var config int Gauntlet_MAGNETIC_INDIVIDUAL_ALLOYCOST;
var config int Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
var config int Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
var config int Gauntlet_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;

var config array<name> Gauntlet_MAGNETIC_REQUIRED_TECHS;

var config int Gauntlet_BEAM_SCHEMATIC_SUPPLYCOST;
var config int Gauntlet_BEAM_SCHEMATIC_ALLOYCOST;
var config int Gauntlet_BEAM_SCHEMATIC_ELERIUMCOST;
var config int Gauntlet_BEAM_SCHEMATIC_ELERIUMCORECOST;

var config int Gauntlet_BEAM_INDIVIDUAL_SUPPLYCOST;
var config int Gauntlet_BEAM_INDIVIDUAL_ALLOYCOST;
var config int Gauntlet_BEAM_INDIVIDUAL_ELERIUMCOST;
var config int Gauntlet_BEAM_INDIVIDUAL_ELERIUMCORECOST;
var config int Gauntlet_BEAM_INDIVIDUAL_ITEMCOST;
var config int Gauntlet_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;

var config array<name> Gauntlet_BEAM_REQUIRED_TECHS;

var localized string PrimaryRangeLabel;
var localized string PrimaryRadiusLabel;
var localized string SecondaryRangeLabel;
var localized string SecondaryRadiusLabel;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreateTemplate_Gauntlet_Conventional());
    Templates.AddItem(CreateTemplate_Gauntlet_Mag());
    Templates.AddItem(CreateTemplate_Gauntlet_Beam());
    Templates.AddItem(CreateNapalmDamageType());

		// Create two schematics used to upgrade weapons (If Finite Items is FALSE)
	if (!default.bFiniteItems)
	{
		Templates.AddItem(CreateTemplate_Gauntlet_Magnetic_Schematic());
		Templates.AddItem(CreateTemplate_Gauntlet_Beam_Schematic());
	}

    return Templates;
}

static function X2DamageTypeTemplate CreateNapalmDamageType()
{
    local X2DamageTypeTemplate Template;

    `CREATE_X2TEMPLATE(class'X2DamageTypeTemplate', Template, 'Napalm');

    Template.bCauseFracture = false;
    Template.MaxFireCount = 0; //Fire damage is the result of fire, not a cause
    Template.bAllowAnimatedDeath = true;

    return Template;
}

// Initial Gauntlet uses Pistol model and artwork until new artwork is complete
static function X2DataTemplate CreateTemplate_Gauntlet_Conventional()
{
    local X2MultiWeaponTemplate Template;

    `CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_CV');
    Template.EquipSound = "Conventional_Weapon_Equip";

    Template.ItemCat = 'weapon';
    Template.WeaponCat = 'lw_gauntlet';
    Template.WeaponTech = 'conventional';
    Template.strImage = default.Gauntlet_CV_UIImage; 
    Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
    Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
    Template.Tier = 0;

    Template.BaseDamage = default.Gauntlet_Primary_CONVENTIONAL_BASEDAMAGE;
    Template.iSoundRange = default.Gauntlet_Primary_CONVENTIONAL_ISOUNDRANGE;
    Template.iEnvironmentDamage = default.Gauntlet_Primary_CONVENTIONAL_IENVIRONMENTDAMAGE;
    Template.iClipSize = default.Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE;
    Template.iRange = default.Gauntlet_Primary_CONVENTIONAL_RANGE;
    Template.iRadius = default.Gauntlet_Primary_CONVENTIONAL_RADIUS;
    Template.PointsToComplete = 0;
    Template.DamageTypeTemplateName = 'Explosion';
    Template.iStatStrength=0;
    Template.bMergeAmmo=true;
    Template.bSoundOriginatesFromOwnerLocation=false;

    Template.AltBaseDamage = default.Gauntlet_Secondary_CONVENTIONAL_BASEDAMAGE;
    Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_CONVENTIONAL_IENVIRONMENTDAMAGE;
    Template.iAltStatStrength=default.Gauntlet_Secondary_CONVENTIONAL_OPPOSED_STAT_STRENTH;
    Template.iAltRange = default.Gauntlet_Secondary_CONVENTIONAL_RANGE;
    Template.iAltRadius = default.Gauntlet_Secondary_CONVENTIONAL_RADIUS;
    Template.iAltSoundRange = default.Gauntlet_Secondary_CONVENTIONAL_ISOUNDRANGE;

    Template.InventorySlot = eInvSlot_SecondaryWeapon;
    Template.StowedLocation = eSlot_HeavyWeapon;
    
    // This all the resources; sounds, animations, models, physics, the works.
    Template.GameArchetype = "LWGauntlet.Archetypes.WP_Gauntlet_RocketLauncher_CV";

    Template.Abilities.AddItem('LWRocketLauncher');
    Template.Abilities.AddItem('RocketFuse');
    Template.Abilities.AddItem('LWFlamethrower');

    Template.iPhysicsImpulse = 5;

    Template.StartingItem = true;
    Template.CanBeBuilt = false;
    
    Template.DamageTypeTemplateName = 'Electrical';

    Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_CONVENTIONAL_RANGE);
    Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_CONVENTIONAL_RADIUS);
    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RADIUS);

    return Template;
}

static function X2DataTemplate CreateTemplate_Gauntlet_Mag()
{
    local X2MultiWeaponTemplate Template;
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;
	local name				TechRequirement;

    `CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_MG');
    Template.EquipSound = "MAG_Weapon_Equip";

    Template.ItemCat = 'weapon';
    Template.WeaponCat = 'lw_gauntlet';
    Template.WeaponTech = 'Magnetic';
    Template.strImage = default.Gauntlet_MG_UIImage; 
    Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
    //Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
    Template.Tier = 2;

    Template.BaseDamage = default.Gauntlet_Primary_MAG_BASEDAMAGE;
    Template.iSoundRange = default.Gauntlet_Primary_MAG_ISOUNDRANGE;
    Template.iEnvironmentDamage = default.Gauntlet_Primary_MAG_IENVIRONMENTDAMAGE;
    Template.iClipSize = default.Gauntlet_Primary_MAG_ICLIPSIZE;
    Template.iRange = default.Gauntlet_Primary_MAG_RANGE;
    Template.iRadius = default.Gauntlet_Primary_MAG_RADIUS;
    Template.PointsToComplete = 0;
    Template.DamageTypeTemplateName = 'Explosion';
    Template.iStatStrength=0;
    Template.bMergeAmmo=true;
    Template.bSoundOriginatesFromOwnerLocation=false;

    Template.AltBaseDamage = default.Gauntlet_Secondary_MAG_BASEDAMAGE;
    Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_MAG_IENVIRONMENTDAMAGE;
    Template.iAltStatStrength=default.Gauntlet_Secondary_MAG_OPPOSED_STAT_STRENTH;
    Template.iAltRange = default.Gauntlet_Secondary_MAG_RANGE;
    Template.iAltRadius = default.Gauntlet_Secondary_MAG_RADIUS;
    Template.iAltSoundRange = default.Gauntlet_Secondary_MAG_ISOUNDRANGE;

    Template.InventorySlot = eInvSlot_SecondaryWeapon;
    Template.StowedLocation = eSlot_HeavyWeapon;
    
    // This all the resources; sounds, animations, models, physics, the works.
    Template.GameArchetype = "LWGauntlet.Archetypes.WP_Gauntlet_RocketLauncher_MG";

    Template.Abilities.AddItem('LWRocketLauncher');
    Template.Abilities.AddItem('RocketFuse');
    Template.Abilities.AddItem('LWFlamethrower');

    Template.iPhysicsImpulse = 5;

	if (!default.bFiniteItems)
	{
		Template.CreatorTemplateName = 'Gauntlet_MG_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'LWGauntlet_CV'; // Which item this will be upgraded from
		Template.HideIfPurchased = 'Gauntlet_BM_Schematic';
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.Gauntlet_MAGNETIC_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}
		
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Gauntlet_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Gauntlet_MAGNETIC_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Gauntlet_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Gauntlet_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Gauntlet_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;
		}

		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}
    
    Template.DamageTypeTemplateName = 'Electrical';

    Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_MAG_RANGE);
    Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_MAG_RADIUS);
    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_MAG_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_MAG_RADIUS);

    return Template;
}

static function X2DataTemplate CreateTemplate_Gauntlet_Beam()
{
    local X2MultiWeaponTemplate Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;
	local name					TechRequirement;

    `CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_BM');
    Template.EquipSound = "Beam_Weapon_Equip";

    Template.ItemCat = 'weapon';
    Template.WeaponCat = 'lw_gauntlet';
    Template.WeaponTech = 'beam';
    Template.strImage = default.Gauntlet_BM_UIImage; 
    Template.EquipSound = "Secondary_Weapon_Equip_Beam";
    //Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
    Template.Tier = 4;

    Template.BaseDamage = default.Gauntlet_Primary_BEAM_BASEDAMAGE;
    Template.iSoundRange = default.Gauntlet_Primary_BEAM_ISOUNDRANGE;
    Template.iEnvironmentDamage = default.Gauntlet_Primary_BEAM_IENVIRONMENTDAMAGE;
    Template.iClipSize = default.Gauntlet_Primary_BEAM_ICLIPSIZE;
    Template.iRange = default.Gauntlet_Primary_BEAM_RANGE;
    Template.iRadius = default.Gauntlet_Primary_BEAM_RADIUS;
    Template.PointsToComplete = 0;
    Template.DamageTypeTemplateName = 'Explosion';
    Template.iStatStrength=0;
    Template.bMergeAmmo=true;
    Template.bSoundOriginatesFromOwnerLocation=false;

    Template.AltBaseDamage = default.Gauntlet_Secondary_BEAM_BASEDAMAGE;
    Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_BEAM_IENVIRONMENTDAMAGE;
    Template.iAltStatStrength=default.Gauntlet_Secondary_BEAM_OPPOSED_STAT_STRENTH;
    Template.iAltRange = default.Gauntlet_Secondary_BEAM_RANGE;
    Template.iAltRadius = default.Gauntlet_Secondary_BEAM_RADIUS;
    Template.iAltSoundRange = default.Gauntlet_Secondary_BEAM_ISOUNDRANGE;

    Template.InventorySlot = eInvSlot_SecondaryWeapon;
    Template.StowedLocation = eSlot_HeavyWeapon;
    
    // This all the resources; sounds, animations, models, physics, the works.
    Template.GameArchetype = "LWGauntlet.Archetypes.WP_Gauntlet_BlasterLauncher_BM";

    Template.Abilities.AddItem('LWBlasterLauncher');
    Template.Abilities.AddItem('RocketFuse');
    Template.Abilities.AddItem('LWFlamethrower');

    Template.iPhysicsImpulse = 5;

	if (!default.bFiniteItems)
	{
		Template.CreatorTemplateName = 'Gauntlet_BM_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'LWGauntlet_MG'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.Gauntlet_BEAM_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}

		if (default.Gauntlet_BEAM_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'LWGauntlet_MG';
			ItemCost.Quantity = default.Gauntlet_BEAM_INDIVIDUAL_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.Gauntlet_BEAM_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.Gauntlet_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;
		}

		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}
    
    Template.DamageTypeTemplateName = 'Electrical';

    Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_BEAM_RANGE);
    Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_BEAM_RADIUS);
    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_BEAM_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_BEAM_RADIUS);

    return Template;
}

// ***** Magnetic Gauntlet Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_Gauntlet_Magnetic_Schematic()
{
	local X2SchematicTemplate	Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Gauntlet_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Gauntlet_MG_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'LWGauntlet_MG';
	Template.HideIfPurchased = 'LWGauntlet_BM';

	// Requirements
	foreach default.Gauntlet_MAGNETIC_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	if (default.Gauntlet_MAGNETIC_SCHEMATIC_SUPPLYCOST > 0)
	{
		SupplyCost.ItemTemplateName = 'Supplies';
		SupplyCost.Quantity = default.Gauntlet_MAGNETIC_SCHEMATIC_SUPPLYCOST;
		Template.Cost.ResourceCosts.AddItem(SupplyCost);
	}
	if (default.Gauntlet_MAGNETIC_SCHEMATIC_ALLOYCOST > 0)
	{
		AlloyCost.ItemTemplateName = 'AlienAlloy';
		AlloyCost.Quantity = default.Gauntlet_MAGNETIC_SCHEMATIC_ALLOYCOST;
		Template.Cost.ResourceCosts.AddItem(AlloyCost);
	}
	if (default.Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0)
	{
		EleriumCost.ItemTemplateName = 'EleriumDust';
		EleriumCost.Quantity = default.Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(EleriumCost);
	}
	if (default.Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCORECOST > 0)
	{
		CoreCost.ItemTemplateName = 'EleriumCore';
		CoreCost.Quantity = default.Gauntlet_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;
		Template.Cost.ResourceCosts.AddItem(CoreCost);
	}

	return Template;
}


// ***** Beam Gauntlet Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_Gauntlet_Beam_Schematic()
{
	local X2SchematicTemplate	Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Gauntlet_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Gauntlet_BM_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'LWGauntlet_BM';

	// Requirements
	foreach default.Gauntlet_BEAM_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredItems.AddItem('Gauntlet_MG_Schematic');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	if (default.Gauntlet_BEAM_SCHEMATIC_SUPPLYCOST > 0)
	{
		SupplyCost.ItemTemplateName = 'Supplies';
		SupplyCost.Quantity = default.Gauntlet_BEAM_SCHEMATIC_SUPPLYCOST;
		Template.Cost.ResourceCosts.AddItem(SupplyCost);
	}
	if (default.Gauntlet_BEAM_SCHEMATIC_ALLOYCOST > 0)
	{
		AlloyCost.ItemTemplateName = 'AlienAlloy';
		AlloyCost.Quantity = default.Gauntlet_BEAM_SCHEMATIC_ALLOYCOST;
		Template.Cost.ResourceCosts.AddItem(AlloyCost);
	}
	if (default.Gauntlet_BEAM_SCHEMATIC_ELERIUMCOST > 0)
	{
		EleriumCost.ItemTemplateName = 'EleriumDust';
		EleriumCost.Quantity = default.Gauntlet_BEAM_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(EleriumCost);
	}
	if (default.Gauntlet_BEAM_SCHEMATIC_ELERIUMCORECOST > 0)
	{
		CoreCost.ItemTemplateName = 'EleriumCore';
		CoreCost.Quantity = default.Gauntlet_BEAM_SCHEMATIC_ELERIUMCORECOST;
		Template.Cost.ResourceCosts.AddItem(CoreCost);
	}

	return Template;
}


defaultproperties
{
    bShouldCreateDifficultyVariants = true
}

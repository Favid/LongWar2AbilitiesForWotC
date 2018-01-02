//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWCombatKnife.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for CombatKnife secondary weapon
//
//  ***** Modified to work outside LW2 *****
//---------------------------------------------------------------------------------------
class X2Item_LWCombatKnife extends X2Item config(GameData_WeaponData);

var bool bFiniteItems;

// ***** UI Image definitions  *****
var config string CombatKnife_CV_UIImage;
var config string CombatKnife_MG_UIImage;
var config string CombatKnife_BM_UIImage;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue CombatKnife_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue CombatKnife_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue CombatKnife_BEAM_BASEDAMAGE;

// ***** Core properties and variables for weapons *****
var config int CombatKnife_CONVENTIONAL_AIM;
var config int CombatKnife_CONVENTIONAL_CRITCHANCE;
var config int CombatKnife_CONVENTIONAL_ICLIPSIZE;
var config int CombatKnife_CONVENTIONAL_ISOUNDRANGE;
var config int CombatKnife_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int CombatKnife_MAGNETIC_AIM;
var config int CombatKnife_MAGNETIC_CRITCHANCE;
var config int CombatKnife_MAGNETIC_ICLIPSIZE;
var config int CombatKnife_MAGNETIC_ISOUNDRANGE;
var config int CombatKnife_MAGNETIC_IENVIRONMENTDAMAGE;

var config int CombatKnife_BEAM_AIM;
var config int CombatKnife_BEAM_CRITCHANCE;
var config int CombatKnife_BEAM_ICLIPSIZE;
var config int CombatKnife_BEAM_ISOUNDRANGE;
var config int CombatKnife_BEAM_IENVIRONMENTDAMAGE;

// ***** Schematic/Item cost properties *****
var config int CombatKnife_MAGNETIC_SCHEMATIC_SUPPLYCOST;
var config int CombatKnife_MAGNETIC_SCHEMATIC_ALLOYCOST;
var config int CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCOST;
var config int CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;

var config int CombatKnife_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
var config int CombatKnife_MAGNETIC_INDIVIDUAL_ALLOYCOST;
var config int CombatKnife_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
var config int CombatKnife_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
var config int CombatKnife_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;

var config array<name> CombatKnife_MAGNETIC_REQUIRED_TECHS;

var config int CombatKnife_BEAM_SCHEMATIC_SUPPLYCOST;
var config int CombatKnife_BEAM_SCHEMATIC_ALLOYCOST;
var config int CombatKnife_BEAM_SCHEMATIC_ELERIUMCOST;
var config int CombatKnife_BEAM_SCHEMATIC_ELERIUMCORECOST;

var config int CombatKnife_BEAM_INDIVIDUAL_SUPPLYCOST;
var config int CombatKnife_BEAM_INDIVIDUAL_ALLOYCOST;
var config int CombatKnife_BEAM_INDIVIDUAL_ELERIUMCOST;
var config int CombatKnife_BEAM_INDIVIDUAL_ELERIUMCORECOST;
var config int CombatKnife_BEAM_INDIVIDUAL_ITEMCOST;
var config int CombatKnife_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;

var config array<name> CombatKnife_BEAM_REQUIRED_TECHS;


// ***** Create Item Templates *****
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Create all three tech tiers of weapons
	Templates.AddItem(CreateTemplate_CombatKnife_Conventional());
	Templates.AddItem(CreateTemplate_CombatKnife_Magnetic());
	Templates.AddItem(CreateTemplate_CombatKnife_Beam());

	// Create two schematics used to upgrade weapons (If Finite Items is FALSE)
	if (!default.bFiniteItems)
	{
		Templates.AddItem(CreateTemplate_CombatKnife_Magnetic_Schematic());
		Templates.AddItem(CreateTemplate_CombatKnife_Beam_Schematic());
	}
	
	return Templates;
}


// ***** Conventional Combat Knife Item Details *****
static function X2DataTemplate CreateTemplate_CombatKnife_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CombatKnife_CV');
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'combatknife';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.CombatKnife_CV_UIImage;
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 1;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CombatKnife_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.CombatKnife_CONVENTIONAL_AIM;
	Template.CritChance = default.CombatKnife_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.CombatKnife_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.CombatKnife_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CombatKnife_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.bHideClipSizeStat = true;
	Template.InfiniteAmmo = true;

	Template.Abilities.AddItem('KnifeFighter');
	
	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWCombatKnifeWOTC.Archetypes.WP_CombatKnife_CV";

	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;

	if (!default.bFiniteItems)
	{
		Template.HideIfPurchased = 'CombatKnife_MG_Schematic';
	}
	
	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;
}


// ***** Magnetic Combat Knife Item Details *****
static function X2DataTemplate CreateTemplate_CombatKnife_Magnetic()
{
	local X2WeaponTemplate	Template;
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost;
	local name				TechRequirement;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CombatKnife_MG');

	Template.WeaponCat = 'combatknife';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = default.CombatKnife_MG_UIImage; 
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 2;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CombatKnife_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.CombatKnife_MAGNETIC_AIM;
	Template.CritChance = default.CombatKnife_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.CombatKnife_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.CombatKnife_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CombatKnife_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.bHideClipSizeStat = true;
	Template.InfiniteAmmo = true;

	Template.Abilities.AddItem('KnifeFighter');
	
	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWCombatKnifeWOTC.Archetypes.WP_CombatKnife_MG";
	
	if (!default.bFiniteItems)
	{
		Template.CreatorTemplateName = 'CombatKnife_MG_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'CombatKnife_CV'; // Which item this will be upgraded from
		Template.HideIfPurchased = 'CombatKnife_BM_Schematic';
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.CombatKnife_MAGNETIC_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}

		if (default.CombatKnife_MAGNETIC_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.CombatKnife_MAGNETIC_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.CombatKnife_MAGNETIC_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.CombatKnife_MAGNETIC_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.CombatKnife_MAGNETIC_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.CombatKnife_MAGNETIC_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.CombatKnife_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.CombatKnife_MAGNETIC_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.CombatKnife_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.CombatKnife_MAGNETIC_INDIVIDUAL_TRADINGPOSTVALUE;
		}

		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}


// ***** Beam Combat Knife Item Details *****
static function X2DataTemplate CreateTemplate_CombatKnife_Beam()
{
	local X2WeaponTemplate	Template;
	local ArtifactCost		SupplyCost, AlloyCost, EleriumCost, CoreCost, ItemCost;
	local name				TechRequirement;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CombatKnife_BM');

	Template.WeaponCat = 'combatknife';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = default.CombatKnife_BM_UIImage; 
	Template.EquipSound = "Sword_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CombatKnife_BEAM_BASEDAMAGE;
	Template.Aim = default.CombatKnife_BEAM_AIM;
	Template.CritChance = default.CombatKnife_BEAM_CRITCHANCE;
	Template.iClipSize = default.CombatKnife_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.CombatKnife_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CombatKnife_BEAM_IENVIRONMENTDAMAGE;
	Template.bHideClipSizeStat = true;
	Template.InfiniteAmmo = true;

	Template.Abilities.AddItem('KnifeFighter');
	
	// This contains all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWCombatKnifeWOTC.Archetypes.WP_CombatKnife_BM";

	
	if (!default.bFiniteItems)
	{
		Template.CreatorTemplateName = 'CombatKnife_BM_Schematic'; // The schematic which creates this item
		Template.BaseItem = 'CombatKnife_MG'; // Which item this will be upgraded from
		Template.CanBeBuilt = false;
		Template.bInfiniteItem = true;
	}
	else
	{
		foreach default.CombatKnife_BEAM_REQUIRED_TECHS(TechRequirement)
		{
			Template.Requirements.RequiredTechs.AddItem(TechRequirement);
		}
		
		if (default.CombatKnife_BEAM_INDIVIDUAL_SUPPLYCOST > 0)
		{
			SupplyCost.ItemTemplateName = 'Supplies';
			SupplyCost.Quantity = default.CombatKnife_BEAM_INDIVIDUAL_SUPPLYCOST;
			Template.Cost.ResourceCosts.AddItem(SupplyCost);
		}
		if (default.CombatKnife_BEAM_INDIVIDUAL_ALLOYCOST > 0)
		{
			AlloyCost.ItemTemplateName = 'AlienAlloy';
			AlloyCost.Quantity = default.CombatKnife_BEAM_INDIVIDUAL_ALLOYCOST;
			Template.Cost.ResourceCosts.AddItem(AlloyCost);
		}
		if (default.CombatKnife_BEAM_INDIVIDUAL_ELERIUMCOST > 0)
		{
			EleriumCost.ItemTemplateName = 'EleriumDust';
			EleriumCost.Quantity = default.CombatKnife_BEAM_INDIVIDUAL_ELERIUMCOST;
			Template.Cost.ResourceCosts.AddItem(EleriumCost);
		}
		if (default.CombatKnife_BEAM_INDIVIDUAL_ELERIUMCORECOST > 0)
		{
			CoreCost.ItemTemplateName = 'EleriumCore';
			CoreCost.Quantity = default.CombatKnife_BEAM_INDIVIDUAL_ELERIUMCORECOST;
			Template.Cost.ResourceCosts.AddItem(CoreCost);
		}
		if (default.CombatKnife_BEAM_INDIVIDUAL_ITEMCOST > 0)
		{
			ItemCost.ItemTemplateName = 'CombatKnife_MG';
			ItemCost.Quantity = default.CombatKnife_BEAM_INDIVIDUAL_ITEMCOST;
			Template.Cost.ResourceCosts.AddItem(ItemCost);
		}
		if (default.CombatKnife_BEAM_INDIVIDUAL_TRADINGPOSTVALUE > 0)
		{
			Template.TradingPostValue = default.CombatKnife_BEAM_INDIVIDUAL_TRADINGPOSTVALUE;
		}

		Template.CanBeBuilt = true;
		Template.bInfiniteItem = false;
	}

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}


// ***** Magnetic Combat Knife Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_CombatKnife_Magnetic_Schematic()
{
	local X2SchematicTemplate	Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'CombatKnife_MG_Schematic');
	
	Template.ItemCat = 'weapon';
	Template.strImage = default.CombatKnife_MG_UIImage; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.HideIfPurchased = 'CombatKnife_BM';
	Template.ReferenceItemTemplate = 'CombatKnife_MG';

	// Requirements
	foreach default.CombatKnife_MAGNETIC_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	if (default.CombatKnife_MAGNETIC_SCHEMATIC_SUPPLYCOST > 0)
	{
		SupplyCost.ItemTemplateName = 'Supplies';
		SupplyCost.Quantity = default.CombatKnife_MAGNETIC_SCHEMATIC_SUPPLYCOST;
		Template.Cost.ResourceCosts.AddItem(SupplyCost);
	}
	if (default.CombatKnife_MAGNETIC_SCHEMATIC_ALLOYCOST > 0)
	{
		AlloyCost.ItemTemplateName = 'AlienAlloy';
		AlloyCost.Quantity = default.CombatKnife_MAGNETIC_SCHEMATIC_ALLOYCOST;
		Template.Cost.ResourceCosts.AddItem(AlloyCost);
	}
	if (default.CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0)
	{
		EleriumCost.ItemTemplateName = 'EleriumDust';
		EleriumCost.Quantity = default.CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(EleriumCost);
	}
	if (default.CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCORECOST > 0)
	{
		CoreCost.ItemTemplateName = 'EleriumCore';
		CoreCost.Quantity = default.CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCORECOST;
		Template.Cost.ResourceCosts.AddItem(CoreCost);
	}

	return Template;
}


// ***** Beam Combat Knife Upgrade Schematic *****
static function X2DataTemplate CreateTemplate_CombatKnife_Beam_Schematic()
{
	local X2SchematicTemplate	Template;
	local ArtifactCost			SupplyCost, AlloyCost, EleriumCost, CoreCost;
	local name					TechRequirement;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'CombatKnife_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.CombatKnife_MG_UIImage; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'CombatKnife_BM';

	// Requirements
	foreach default.CombatKnife_BEAM_REQUIRED_TECHS(TechRequirement)
	{
		Template.Requirements.RequiredTechs.AddItem(TechRequirement);
	}
	Template.Requirements.RequiredItems.AddItem('CombatKnife_MG_Schematic');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	if (default.CombatKnife_BEAM_SCHEMATIC_SUPPLYCOST > 0)
	{
		SupplyCost.ItemTemplateName = 'Supplies';
		SupplyCost.Quantity = default.CombatKnife_BEAM_SCHEMATIC_SUPPLYCOST;
		Template.Cost.ResourceCosts.AddItem(SupplyCost);
	}
	if (default.CombatKnife_BEAM_SCHEMATIC_ALLOYCOST > 0)
	{
		AlloyCost.ItemTemplateName = 'AlienAlloy';
		AlloyCost.Quantity = default.CombatKnife_BEAM_SCHEMATIC_ALLOYCOST;
		Template.Cost.ResourceCosts.AddItem(AlloyCost);
	}
	if (default.CombatKnife_BEAM_SCHEMATIC_ELERIUMCOST > 0)
	{
		EleriumCost.ItemTemplateName = 'EleriumDust';
		EleriumCost.Quantity = default.CombatKnife_BEAM_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(EleriumCost);
	}
	if (default.CombatKnife_BEAM_SCHEMATIC_ELERIUMCORECOST > 0)
	{
		CoreCost.ItemTemplateName = 'EleriumCore';
		CoreCost.Quantity = default.CombatKnife_BEAM_SCHEMATIC_ELERIUMCORECOST;
		Template.Cost.ResourceCosts.AddItem(CoreCost);
	}

	return Template;
}


defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
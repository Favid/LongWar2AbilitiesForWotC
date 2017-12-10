class X2Item_LW2WotC_PCS extends X2Item_DefaultResources;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Resources;

    Resources.AddItem(CreateDepthPerceptionPCS());
    Resources.AddItem(CreateHyperReactivePupilsPCS());
    Resources.AddItem(CreateCombatRushPCS());
    Resources.AddItem(CreateCombatAwarenessPCS());
    Resources.AddItem(CreateDamageControlPCS());
    Resources.AddItem(CreateImpactFieldsPCS());
    Resources.AddItem(CreateBodyShieldPCS());
    Resources.AddItem(CreateEmergencyLifeSupportPCS());
    Resources.AddItem(CreateIronSkinPCS());
    Resources.AddItem(CreateSmartMacrophagesPCS());

    Return Resources;
}


static function X2DataTemplate CreateDepthPerceptionPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'DepthPerceptionPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_DepthPerception";
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDepthPerception";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 40;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;  
    Template.Abilities.AddItem('LW2WotC_DepthPerception');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}

static function X2DataTemplate CreateHyperReactivePupilsPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'HyperReactivePupilsPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_HyperReactivePupils"; 
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHyperReactivePupils";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 40;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;
    Template.Abilities.AddItem('LW2WotC_HyperReactivePupils');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}

static function X2DataTemplate CreateCombatAwarenessPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'CombatAwarenessPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_CombatAwareness";
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityThreatAssesment";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 40;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;  
    Template.Abilities.AddItem('LW2WotC_CombatAwareness');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;
    
    return Template;
}

static function X2DataTemplate CreateCombatRushPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'CombatRushPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_CombatRush"; 
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAdrenalNeurosympathy";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 40;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;  
    Template.Abilities.AddItem('LW2WotC_CombatRush');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}

static function X2DataTemplate CreateDamageControlPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'DamageControlPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_DamageControl"; 
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 50;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;  
    Template.Abilities.AddItem('LW2WotC_DamageControl');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}

static function X2DataTemplate CreateImpactFieldsPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'ImpactFieldsPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_AbsorptionFields"; 
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAbsorptionFields";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 50;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;  
    Template.Abilities.AddItem('LW2WotC_ImpactFields');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}

static function X2DataTemplate CreateBodyShieldPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'BodyShieldPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_BodyShield"; 
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBodyShield";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 50;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;  
    Template.Abilities.AddItem('LW2WotC_BodyShield');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}

static function X2DataTemplate CreateEmergencyLifeSupportPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'EmergencyLifeSupportPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_EmergencyLifeSupport"; 
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityEmergencyLifeSupport";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 35;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;  
    Template.Abilities.AddItem('LW2WotC_EmergencyLifeSupport');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}

static function X2DataTemplate CreateIronSkinPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'IronSkinPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_IronSkin";
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilityIronSkin";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 50;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;
    Template.Abilities.AddItem('LW2WotC_IronSkin');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}

static function X2DataTemplate CreateSmartMacrophagesPCS()
{
    local X2EquipmentTemplate Template;

    `CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'SmartMacrophagesPCS');

    Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
    Template.strImage = "img:///UILibrary_LW_PerkPack.LW_Inv_CombatSim_SmartMacrophages"; 
    Template.strInventoryImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySmartMacrophages";
    Template.ItemCat = 'combatsim';
    Template.TradingPostValue = 40;
    Template.bAlwaysUnique = false;
    Template.Tier = 4;  
    Template.Abilities.AddItem('LW2WotC_SmartMacrophages');
    Template.InventorySlot = eInvSlot_CombatSim;
    Template.BlackMarketTexts = default.PCSBlackMarketTexts;

    return Template;
}
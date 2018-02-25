//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW2WotC_GauntletAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Gauntlet-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW2WotC_GauntletAbilitySet extends X2Ability
    dependson (XComGameStateContext_Ability) config(LW2GauntletWOTC);
    
var config bool SUPPRESSION_PREVENTS_ABILITIES;
var config array<name> SUPPRESSION_EFFECTS;

var config int FLAMETHROWER_BURNING_BASE_DAMAGE;
var config int FLAMETHROWER_BURNING_DAMAGE_SPREAD;
var config int FLAMETHROWER_DIRECT_APPLY_CHANCE;
var config int FLAMETHROWER_CHARGES;
var config int FLAMETHROWER_HIGH_PRESSURE_CHARGES;

var config float ROUST_CONEEND_DIAMETER_MODIFIER;
var config float ROUST_CONELENGTH_MODIFIER;
var config int ROUST_DIRECT_APPLY_CHANCE;
var config int ROUST_CHARGES;
var config float ROUST_DAMAGE_PENALTY;
var config int ROUST_HIGH_PRESSURE_CHARGES;

var config int INCINERATOR_CONEEND_DIAMETER_MODIFIER;
var config int INCINERATOR_CONELENGTH_MODIFIER;
var config int FIRESTORM_NUM_CHARGES;
var config int FIRESTORM_HIGH_PRESSURE_CHARGES;
var config int FIRESTORM_RADIUS_METERS;
var config float FIRESTORM_DAMAGE_BONUS;
var config int SHOCK_AND_AWE_BONUS_CHARGES;

var config int JAVELIN_ROCKETS_BONUS_RANGE_TILES;
var config array<name> JAVELIN_ROCKETS_VALID_ABILITIES;

var config WeaponDamageValue BUNKER_BUSTER_DAMAGE_VALUE;
var config float BUNKER_BUSTER_RADIUS_METERS;
var config int BUNKER_BUSTER_ENV_DAMAGE;
var config int FIRE_AND_STEEL_DAMAGE_BONUS;
var config int CONCUSSION_ROCKET_RADIUS_TILES;
var config int CONCUSSION_ROCKET_TARGET_WILL_MALUS_DISORIENT;
var config int CONCUSSION_ROCKET_TARGET_WILL_MALUS_STUN;
var config WeaponDamageValue CONCUSSION_ROCKET_DAMAGE_VALUE;
var config int CONCUSSION_ROCKET_ENV_DAMAGE;
var config float BURNOUT_RADIUS;
var config int MOVEMENT_SCATTER_AIM_MODIFIER;
var config int MOVEMENT_SCATTER_TILE_MODIFIER;
var config int NUM_AIM_SCATTER_ROLLS;
var config array<name> SCATTER_REDUCTION_ABILITIES;
var config array<int> SCATTER_REDUCTION_MODIFIERS;
var config array<int> ROCKET_RANGE_PROFILE;
var config int QUICKBURN_COOLDOWN;
var config int PHOSPHORUS_BONUS_SHRED;

var name PanicImpairingAbilityName;

var localized string strMaxScatter;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    // This ability doesn't actually do anything - it's just for show for the player
    // The Rocket Launcher and Flamethrower abilities are granted by the Gauntlet items themselves
    Templates.AddItem(PurePassive('LW2WotC_HeavyArmaments', "img:///UILibrary_LW_PerkPack.LW_AbilityHeavyArmaments"));
    
    Templates.AddItem(RocketLauncher());
    Templates.AddItem(BlasterLauncher());
    Templates.AddItem(PurePassive('LW2WotC_FireInTheHole', "img:///UILibrary_LW_PerkPack.LW_AbilityFireInTheHole"));
    Templates.AddItem(JavelinRockets());
    Templates.AddItem(ShockAndAwe());
    Templates.AddItem(ConcussionRocket());
    Templates.AddItem(BunkerBuster());

    Templates.AddItem(Flamethrower());

    Templates.AddItem(PurePassive('LW2WotC_Phosphorus', "img:///UILibrary_LW_PerkPack.LW_AbilityPhosphorus"));
    Templates.AddItem(PurePassive('LW2WotC_NapalmX', "img:///UILibrary_LW_PerkPack.LW_AbilityNapalmX"));
    Templates.AddItem(PurePassive('LW2WotC_Incinerator', "img:///UILibrary_LW_PerkPack.LW_AbilityHighPressure"));
    Templates.AddItem(Quickburn());
    Templates.AddItem(Roust());
    Templates.AddItem(Burnout());
    Templates.AddItem(BurnoutPassive());
    Templates.AddItem(RoustDamage());
    Templates.AddItem(Firestorm());
    Templates.AddItem(FirestormDamage());
    Templates.AddItem(FirestormFireImmunity());
    Templates.AddItem(HighPressure());
    Templates.AddItem(PhosphorusBonus());

    Templates.AddItem(CreateNapalmXPanicEffectAbility());

    Templates.AddItem(FireAndSteel());

    return Templates;
}

//--------------------------------------------------------------------------------------------
//-----------------------  ROCKET ABILITIES --------------------------------------------------
//--------------------------------------------------------------------------------------------

// Perk name:		Rocket Launcher
// Perk effect:		Fire a rocket at target area with the Gauntlet. Can scatter. 
// Localized text:	"Fire a rocket at target area. <Ability:ROCKETSCATTER/>"
// Config:			(AbilityName="LW2WotC_RocketLauncher", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate RocketLauncher()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_RocketLauncher');
    Template.Hostility = eHostility_Offensive;
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";

    // Activated ability
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    // Uses weapon ammo instead of ability charges
    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);
    Template.bUseAmmoAsChargesForHUD = true;

    // Ends turn unless the user has Salvo
    ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
    Template.AbilityCosts.AddItem(ActionPointCost);

    // Cannot miss or crit
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    // Gets damage from the equipped Gauntlet
    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(WeaponDamageEffect);

    // Target with mouse cursor
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    // Radius based on equipped Gauntlet
    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    // Ignores the dead
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    // Cannot be used while disoriented, burning, etc.
    Template.AddShooterEffectExclusions();
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    // Controls rocket pathing and scatter
    Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
    
    // Typical heavy weapon visualizations
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    Template.ActivationSpeech = 'RocketLauncher';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";
    
    // Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

    return Template;
}

// Perk name:		Blaster Launcher
// Perk effect:		Fire a guided Blaster Bomb at a target area with the Gauntlet. Can scatter. 
// Localized text:	"Fire a guided Blaster Bomb at a target area. <Ability:ROCKETSCATTER/>"
// Config:			(AbilityName="LW2WotC_BlasterLauncher", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate BlasterLauncher()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_BlasterLauncher');
    Template.Hostility = eHostility_Offensive;
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_blasterlauncher";

    // Activated ability
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    
    // Uses weapon ammo instead of ability charges
    AmmoCost = new class'X2AbilityCost_Ammo';
    AmmoCost.iAmmo = 1;
    Template.AbilityCosts.AddItem(AmmoCost);
    Template.bUseAmmoAsChargesForHUD = true;
    
    // Ends turn unless the user has Salvo
    ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    // Cannot miss or crit
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;
    
    // Gets damage from the equipped Gauntlet
    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(WeaponDamageEffect);
    
    // Target with mouse cursor
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;
    
    // Radius based on equipped Gauntlet
    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;
    
    // Ignores the dead
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    
    // Cannot be used while disoriented, burning, etc.
    Template.AddShooterEffectExclusions();
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);
    
    // Controls blaster bomb pathing and scatter
    Template.TargetingMethod = class'X2TargetingMethod_LWBlasterLauncher';
    
    // Typical heavy weapon visualizations
    Template.ActivationSpeech = 'BlasterLauncher';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    
    // Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

    return Template;
}

// Perk name:		Javelin Rockets
// Perk effect:		Increases the range of the Gauntlet's rockets
// Localized text:	"The range of your rockets is increased by <Ability:JAVELIN_ROCKETS_BONUS_RANGE_TILES> tiles and you may hit targets beyond your visual range."
// Config:			(AbilityName="LW2WotC_JavelinRockets", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate JavelinRockets()
{
    local X2AbilityTemplate             Template;
    local X2Effect_JavelinRockets       JavelinRocketsEffect;

    // Standard passive ability setup
    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_JavelinRockets');
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityJavelinRockets";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    Template.bIsPassive = true;

    // Effect that grants bonus range to valid abilities
    JavelinRocketsEffect = new class 'X2Effect_JavelinRockets';
    JavelinRocketsEffect.BuildPersistentEffect (1, true, false);
    JavelinRocketsEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
    Template.AddTargetEffect (JavelinRocketsEffect);

    Template.bCrossClassEligible = false;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

// Perk name:		Shock and Awe
// Perk effect:		You equip one additional rocket.
// Localized text:	"You equip one additional rocket."
// Config:			(AbilityName="LW2WotC_ShockAndAwe", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate ShockAndAwe()
{
    local X2AbilityTemplate             Template;
    local X2Effect_BonusRocketCharges   RocketChargesEffect;
    
    // Standard passive ability setup
    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_ShockAndAwe');
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityShockAndAwe";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    Template.bIsPassive = true;

    // Effect granting a bonus rocket
    RocketChargesEffect = new class 'X2Effect_BonusRocketCharges';
    RocketChargesEffect.BonusUses=default.SHOCK_AND_AWE_BONUS_CHARGES;
    RocketChargesEffect.SlotType=eInvSlot_SecondaryWeapon;
    RocketChargesEffect.BuildPersistentEffect (1, true, false);
    RocketChargesEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
    Template.AddTargetEffect (RocketChargesEffect);

    Template.bCrossClassEligible = false;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

// Perk name:		Concussion Rocket
// Perk effect:		Fire a special rocket that does limited damage but has a chance to stun or disorient organic enemies within its area of effect and leaves a cloud of smoke.
// Localized text:	"Fire a special rocket that does limited damage but has a chance to stun or disorient organic enemies within its area of effect and leaves a cloud of smoke."
// Config:			(AbilityName="LW2WotC_ConcussionRocket", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate ConcussionRocket()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCharges                  Charges;
    local X2AbilityCost_Charges             ChargeCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Effect_PersistentStatChange     DisorientedEffect;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;
    local X2Effect_Stunned                  StunnedEffect;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Condition_UnitType              ImmuneUnitCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_ConcussionRocket');
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityConcussionRocket";
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
    Template.AbilityCosts.AddItem(ActionPointCost);

    Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = 1;
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeOrganic = false;
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = true;
    UnitPropertyCondition.RequireWithinRange = true;
    Template.AbilityTargetConditions.AddItem (UnitPropertyCondition);
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

    ImmuneUnitCondition = new class'X2Condition_UnitType';
    ImmuneUnitCondition.ExcludeTypes.AddItem('PsiZombie');
    ImmuneUnitCondition.ExcludeTypes.AddItem('AdvPsiWitchM2');
    ImmuneUnitCondition.ExcludeTypes.AddItem('AdvPsiWitchM3');
    Template.AbilityTargetConditions.AddItem(ImmuneUnitCondition);
    Template.AbilityMultiTargetConditions.AddItem(ImmuneUnitCondition);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = false;
    RadiusMultiTarget.fTargetRadius = default.CONCUSSION_ROCKET_RADIUS_TILES * 1.5; // meters
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bIgnoreBaseDamage = true;
    WeaponDamageEffect.EffectDamageValue=default.CONCUSSION_ROCKET_DAMAGE_VALUE;
    WeaponDamageEffect.bExplosiveDamage = true;
    WeaponDamageEffect.EnvironmentalDamageAmount=default.CONCUSSION_ROCKET_ENV_DAMAGE;
    Template.AddMultiTargetEffect(WeaponDamageEffect);

    StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2,100,false);
    StunnedEffect.bRemoveWhenSourceDies = false;
    StunnedEffect.ApplyChanceFn = ApplyChance_Concussion_Stunned;
    Template.AddMultiTargetEffect(StunnedEffect);

    DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
    DisorientedEffect.ApplyChanceFn = ApplyChance_Concussion_Disoriented;
    Template.AddMultiTargetEffect(DisorientedEffect);

    WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
    Template.AddMultiTargetEffect (WeaponEffect);

    Template.AddMultiTargetEffect (class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());

    Template.ActivationSpeech = 'Explosion';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    
    // Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

    return Template;
}

static function name ApplyChance_Concussion_Stunned (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local XComGameState_Unit UnitState;
    local int RandRoll;

    UnitState = XComGameState_Unit(kNewTargetState);
    RandRoll = `SYNC_RAND_STATIC(100);
    if (UnitState != none)
    {
        if (RandRoll >= UnitState.GetCurrentStat (eStat_Will) - default.CONCUSSION_ROCKET_TARGET_WILL_MALUS_STUN)
        {
            return 'AA_Success';
        }
    }
    return 'AA_EffectChanceFailed';
}

static function name ApplyChance_Concussion_Disoriented (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local XComGameState_Unit UnitState;
    local int RandRoll;

    UnitState = XComGameState_Unit(kNewTargetState);
    RandRoll = `SYNC_RAND_STATIC(100);

    if (UnitState != none)
    {
        if (!UnitState.IsStunned())
        {
            if (RandRoll >= UnitState.GetCurrentStat (eStat_Will) - default.CONCUSSION_ROCKET_TARGET_WILL_MALUS_DISORIENT)
            {
            return 'AA_Success';
            }
        }
    }
    return 'AA_EffectChanceFailed';
}

// Perk name:		Bunker Buster
// Perk effect:		"Fire a Bunker Buster. <Ability:ROCKETSCATTER/>"
// Localized text:	"Fire a Bunker Buster. <Ability:ROCKETSCATTER/>"
// Config:			(AbilityName="LW2WotC_BunkerBuster", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate BunkerBuster()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityCharges                  Charges;
    local X2AbilityCost_Charges             ChargeCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
    local X2AbilityTarget_Cursor            CursorTarget;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_BunkerBuster');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_heavy_rockets";
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 2;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = 1;
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = false;
    RadiusMultiTarget.fTargetRadius = default.BUNKER_BUSTER_RADIUS_METERS; // meters
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bIgnoreBaseDamage = true;
    WeaponDamageEffect.EffectDamageValue=default.BUNKER_BUSTER_DAMAGE_VALUE;
    WeaponDamageEffect.bExplosiveDamage = true;
    WeaponDamageEffect.EnvironmentalDamageAmount=default.BUNKER_BUSTER_ENV_DAMAGE;
    Template.AddMultiTargetEffect(WeaponDamageEffect);

    Template.ActivationSpeech = 'Explosion';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    
    // Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

    return Template;
}

//--------------------------------------------------------------------------------------------
//-----------------------  ROCKET SCATTER UTILITY  -------------------------------------------
//--------------------------------------------------------------------------------------------

static function vector GetScatterAmount(XComGameState_Unit Unit, vector ScatteredTargetLoc)
{
    local vector ScatterVector, ReturnPosition;
    local float EffectiveOffense;
    local int Idx, NumAimRolls, TileDistance, TileScatter;
    local float AngleRadians;
    local XComWorldData WorldData;

    //`LWTRACE("GetScatterAmount: Starting Calculation");

    WorldData = `XWORLD;

    NumAimRolls = GetNumAimRolls(Unit);
    TileDistance = TileDistanceBetween(Unit, ScatteredTargetLoc);
    NumAimRolls = Min(NumAimRolls, TileDistance);   //clamp the scatter for short range

    EffectiveOffense = GetEffectiveOffense(Unit, TileDistance);

    //`LWTRACE("GetScatterAmount: (Distance) Offense=" $ EffectiveOffense $ ", Rolls=" $ NumAimRolls $ ", Tiles=" $ TileDistance);

    for(Idx=0 ; Idx < NumAimRolls  ; Idx++)
    {
        if(`SYNC_RAND_STATIC(100) >= EffectiveOffense)
            TileScatter += 1;
    }

    //`LWTRACE("GetScatterAmount: (Select) TileScatter=" $ TileScatter);

    //pick a random direction in radians
    AngleRadians = `SYNC_FRAND_STATIC() * 2.0 * 3.141592653589793;
    ScatterVector.x = Cos(AngleRadians) * TileScatter * WorldData.WORLD_StepSize;
    ScatterVector.y = Sin(AngleRadians) * TileScatter * WorldData.WORLD_StepSize;
    ReturnPosition = ScatteredTargetLoc + ScatterVector;

    //`LWTRACE("GetScatterAmount: (FracResult) OutVector=" $ string(ReturnPosition) $ ", InVector=" $ string(ScatteredTargetLoc) $ ", ScatterVec=" $ string(ScatterVector) $ ", Angle=" $ AngleRadians);

    ReturnPosition = WorldData.FindClosestValidLocation(ReturnPosition, true, true);

    //`LWTRACE("GetScatterAmount: (ValidResult) OutVector=" $ string(ReturnPosition) $ ", InVector=" $ string(ScatteredTargetLoc) $ ", ScatterVec=" $ string(ScatterVector) $ ", Angle=" $ AngleRadians);

    return ReturnPosition;
}

static function float GetExpectedScatter(XComGameState_Unit Unit, vector TargetLoc)
{
    local float ExpectedScatter;
    local int TileDistance;

    TileDistance = TileDistanceBetween(Unit, TargetLoc);
    ExpectedScatter = (100.0 - GetEffectiveOffense(Unit, TileDistance))/100.0 * float(GetNumAimRolls(Unit));

    return ExpectedScatter;
}

static function float GetEffectiveOffense(XComGameState_Unit Unit, int TileDistance)
{
    local float EffectiveOffense;

    EffectiveOffense = Unit.GetCurrentStat(eStat_Offense);
    if(Unit.ActionPoints.Length <= 1)
        EffectiveOffense += default.MOVEMENT_SCATTER_AIM_MODIFIER;

    //adjust effective aim for distance
    if(default.ROCKET_RANGE_PROFILE.Length > 0)
    {
        if(TileDistance < default.ROCKET_RANGE_PROFILE.Length)
            EffectiveOffense += default.ROCKET_RANGE_PROFILE[TileDistance];
        else  //  if this tile is not configured, use the last configured tile
            EffectiveOffense += default.ROCKET_RANGE_PROFILE[default.ROCKET_RANGE_PROFILE.Length-1];
    }
    return EffectiveOffense;
}

static function int GetNumAimRolls(XComGameState_Unit Unit)
{
    local int NumAimRolls;
    local name AbilityName;
    local int Idx;

    //set up baseline value
    NumAimRolls = default.NUM_AIM_SCATTER_ROLLS;

    foreach default.SCATTER_REDUCTION_ABILITIES(AbilityName, Idx)
    {
        if(Unit.FindAbility(AbilityName).ObjectID > 0)
            NumAimRolls += default.SCATTER_REDUCTION_MODIFIERS[Idx];
    }

    if(Unit.ActionPoints.Length <= 1)
        NumAimRolls += default.MOVEMENT_SCATTER_TILE_MODIFIER;

    return NumAimRolls;
}

static function int TileDistanceBetween(XComGameState_Unit Unit, vector TargetLoc)
{
    local XComWorldData WorldData;
    local vector UnitLoc;
    local float Dist;
    local int Tiles;

    WorldData = `XWORLD;
    UnitLoc = WorldData.GetPositionFromTileCoordinates(Unit.TileLocation);
    Dist = VSize(UnitLoc - TargetLoc);
    Tiles = Dist / WorldData.WORLD_StepSize;
    return Tiles;
}

//--------------------------------------------------------------------------------------------
//-----------------------  FLAMETHROWER ABILITIES --------------------------------------------
//--------------------------------------------------------------------------------------------

// Perk name:		Flamethrower
// Perk effect:		Spray flames in a cone-shaped area.
// Localized text:	"Spray flames in a cone-shaped area."
// Config:			(AbilityName="LW2WotC_Flamethrower", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Flamethrower()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2AbilityMultiTarget_Cone             ConeMultiTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2AbilityTrigger_PlayerInput          InputTrigger;
    local X2Effect_ApplyFireToWorld_Limited             FireToWorldEffect;
    local X2AbilityToHitCalc_StandardAim        StandardAim;
    local X2Effect_Burning                      BurningEffect;
    local X2AbilityCharges_BonusCharges         Charges;
    local X2AbilityCost_Charges                 ChargeCost;
    local AbilityGrantedBonusCone               IncineratorBonusCone;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Flamethrower');

    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

    InputTrigger = new class'X2AbilityTrigger_PlayerInput';
    Template.AbilityTriggers.AddItem(InputTrigger);

    // Configurable charges, but if the user has the HighPressure ability or the HighPressureTanks item, they get bonus charges
    Charges = new class'X2AbilityCharges_BonusCharges';
    Charges.InitialCharges = default.FLAMETHROWER_CHARGES;
    Charges.BonusAbility = 'LW2WotC_HighPressure';
    Charges.BonusItem = 'HighPressureTanks';
    Charges.BonusAbilityCharges =  default.FLAMETHROWER_HIGH_PRESSURE_CHARGES;
    Template.AbilityCharges = Charges;

    // Each attack costs one charge
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    // Costs one action point and ends turn
    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

    // Cannot miss
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    // Cannot be used while disoriented, burning, etc.
    Template.AddShooterEffectExclusions();
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    // Player aims with the mouse cursor
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    // Flamethrower can wrap around cover.
    Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

    // Allows different Gauntlet tiers to have a different cone length/radius, and some other stuff.
    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
    ConeMultiTarget.bUseWeaponRadius = true;
    ConeMultiTarget.bIgnoreBlockingCover = true;

    // Allow the Incinerator ability to increase the cone length/radius
    IncineratorBonusCone.RequiredAbility = 'LW2WotC_Incinerator';
    IncineratorBonusCone.fBonusDiameter = default.INCINERATOR_CONEEND_DIAMETER_MODIFIER;
    IncineratorBonusCone.fBonusLength = default.INCINERATOR_CONELENGTH_MODIFIER;
    ConeMultiTarget.AbilityBonusCones.AddItem(IncineratorBonusCone);
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    // Can't use it while you're dead
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    // Grants ability that checks if user has the panic-causing ability
    Template.AdditionalAbilities.AddItem(default.PanicImpairingAbilityName);

    // Panic effects need to come before the damage. This is needed for proper visualization ordering.
    // Effect on a successful flamethrower attack is triggering the Apply Panic Effect Ability
    Template.AddMultiTargetEffect(CreateNapalmXPanicEffect());

    // Grants ability that checks if user can damage robots
    Template.AdditionalAbilities.AddItem('LW2WotC_Phosphorus_Bonus');

    // Sets fire to targeted world tiles - fire effect is more limited than most fire sources
    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.25f;
    FireToWorldEffect.FireChance_Level2 = 0.15f;
    FireToWorldEffect.FireChance_Level3 = 0.10f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
    Template.AddMultiTargetEffect(FireToWorldEffect);

    // Chance to burn targets
    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
    BurningEffect.ApplyChance = default.FLAMETHROWER_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    // The damage caused to the targets. Special because it works off of secondary stats of the equipped Gauntlet
    Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());

    // 
    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    // Flamthrower animations and stuff
    Template.ActionFireClass = class'X2Action_Fire_Flamethrower_LW';
    Template.ActivationSpeech = 'Flamethrower';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";
    Template.PostActivationEvents.AddItem('FlamethrowerActivated');

    // Trick to allow a different custom firing animation depending on which tier Gauntlet is equipped
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = LWFlamethrower_BuildVisualization;

    // Interactions with the Chosen and Shadow
    // NOTE: Does NOT increase rate of Lost spawns
    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    return Template;
}

static function X2Effect_ApplyAltWeaponDamage CreateFlamethrowerDamageAbility()
{
    local X2Effect_ApplyAltWeaponDamage WeaponDamageEffect;
    local X2Condition_UnitProperty      Condition_UnitProperty;
    local X2Condition_Phosphorus        PhosphorusCondition;

    WeaponDamageEffect = new class'X2Effect_ApplyAltWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;

    PhosphorusCondition = new class'X2Condition_Phosphorus';
    WeaponDamageEffect.TargetConditions.AddItem(PhosphorusCondition);

    Condition_UnitProperty = new class'X2Condition_UnitProperty';
    Condition_UnitProperty.ExcludeFriendlyToSource = false;
    WeaponDamageEffect.TargetConditions.AddItem(Condition_UnitProperty);

    return WeaponDamageEffect;
}

// This ability is granted automatically by the LW2WotC_Flamethrower
// It checks if the user of the Flamethrower ability has the LW2WotC_Phosphorus ability, and if so, lets the Flamethrower damage robots
static function X2AbilityTemplate PhosphorusBonus()
{
    local X2AbilityTemplate         Template;
    local X2Effect_Phosphorus       PhosphorusEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Phosphorus_Bonus');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Neutral;
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityPhosphorus";
    Template.bDontDisplayInAbilitySummary = true;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    PhosphorusEffect = new class'X2Effect_Phosphorus';
    PhosphorusEffect.BuildPersistentEffect (1, true, false);
    PhosphorusEffect.bDisplayInUI = false;
    PhosphorusEffect.BonusShred = default.PHOSPHORUS_BONUS_SHRED;
    Template.AddTargetEffect(PhosphorusEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

// Perk name:		Roust
// Perk effect:		Special Flamethrower shot that does limited damage but forces enemies to change their position.
// Localized text:	"Special Flamethrower shot that does limited damage but forces enemies to change their position."
// Config:			(AbilityName="LW2WotC_Roust", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Roust()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2AbilityMultiTarget_Cone             ConeMultiTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition, ShooterCondition;
    local X2AbilityTrigger_PlayerInput          InputTrigger;
    local X2Effect_ApplyFireToWorld_Limited             FireToWorldEffect;
    local X2AbilityToHitCalc_StandardAim        StandardAim;
    local X2Effect_Burning                      BurningEffect;
    local X2AbilityCharges_BonusCharges         Charges;
    local X2AbilityCost_Charges                 ChargeCost;
    local X2Effect_LW2WotC_FallBack             FallBackEffect;
    local AbilityGrantedBonusCone               IncineratorBonusCone;
    local AbilityGrantedBonusCone               RoustBonusCone;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Roust');

    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityRoust";

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.bCrossClassEligible = false;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY - 1;
    InputTrigger = new class'X2AbilityTrigger_PlayerInput';
    Template.AbilityTriggers.AddItem(InputTrigger);
    Template.bPreventsTargetTeleport = false;

    // Configurable charges, but if the user has the HighPressure ability or the HighPressureTanks item, they get bonus charges
    Charges = new class 'X2AbilityCharges_BonusCharges';
    Charges.InitialCharges = default.ROUST_CHARGES;
    Charges.BonusAbility = 'LW2WotC_HighPressure';
    Charges.BonusItem = 'HighPressureTanks';
    Charges.BonusAbilityCharges =  default.ROUST_HIGH_PRESSURE_CHARGES;
    Template.AbilityCharges = Charges;

    // Each attack costs one charge
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    // Costs one action point and ends turn
    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

    // Cannot miss
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;

    // Cannot be used while disoriented, burning, etc.
    Template.AddShooterEffectExclusions();

    // Cannot be used while suppressed
    ShooterCondition=new class'X2Condition_UnitProperty';
    ShooterCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(ShooterCondition);
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    // Player aims with the mouse cursor
    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;
    
    // Flamethrower can wrap around cover.
    Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';
    
    // Allows different Gauntlet tiers to have a different cone length/radius, and some other stuff.
    ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
    ConeMultiTarget.bUseWeaponRadius = true;
    ConeMultiTarget.bIgnoreBlockingCover = true;

    // Allow the Incinerator ability to increase the cone length/radius
    IncineratorBonusCone.RequiredAbility = 'LW2WotC_Incinerator';
    IncineratorBonusCone.fBonusDiameter = default.INCINERATOR_CONEEND_DIAMETER_MODIFIER;
    IncineratorBonusCone.fBonusLength = default.INCINERATOR_CONELENGTH_MODIFIER;
    ConeMultiTarget.AbilityBonusCones.AddItem(IncineratorBonusCone);

    // Allow the Roust ability to increase the cone length/radius
    RoustBonusCone.RequiredAbility = 'LW2WotC_Roust';
    RoustBonusCone.fBonusDiameter = default.ROUST_CONEEND_DIAMETER_MODIFIER;
    RoustBonusCone.fBonusLength = default.ROUST_CONELENGTH_MODIFIER;
    ConeMultiTarget.AbilityBonusCones.AddItem(RoustBonusCone);

    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    // Can't use it while you're dead
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
    
    // Sets fire to targeted world tiles - fire effect is more limited than most fire sources
    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.20f;
    FireToWorldEffect.FireChance_Level2 = 0.00f;
    FireToWorldEffect.FireChance_Level3 = 0.00f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
    Template.AddMultiTargetEffect(FireToWorldEffect);

    // Chance to burn targets
    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
    BurningEffect.ApplyChance = default.ROUST_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    // The damage caused to the targets. Special because it works off of secondary stats of the equipped Gauntlet
    Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());

    // Effect that causes the targets to run away
    FallBackEffect = new class'X2Effect_LW2WotC_FallBack';
    FallBackEffect.BehaviorTree = 'FlushRoot';
    Template.AddMultiTargetEffect(FallBackEffect);

    //
    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    // Flamthrower animations and stuff
    Template.ActionFireClass = class'X2Action_Fire_Flamethrower_LW';
    Template.ActivationSpeech = 'Flamethrower';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";
    Template.PostActivationEvents.AddItem('FlamethrowerActivated');

    // Trick to allow a different custom firing animation depending on which tier Gauntlet is equipped
    Template.BuildVisualizationFn = LWFlamethrower_BuildVisualization;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    // Interactions with the Chosen and Shadow
    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    // This contains the damage reduction
    Template.AdditionalAbilities.AddItem('RoustDamage');

    return Template;
}

// Ability granted by LW2WotC_Roust that reduces its damage
static function X2AbilityTemplate RoustDamage()
{
    local X2AbilityTemplate                     Template;
    local X2Effect_RoustDamage                  DamagePenalty;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'RoustDamage');
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityRoust";
    Template.bDontDisplayInAbilitySummary = true;
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    Template.bDisplayInUITacticalText = false;
    Template.bIsPassive = true;

    DamagePenalty = new class'X2Effect_RoustDamage';
    DamagePenalty.Roust_Damage_Modifier = default.ROUST_DAMAGE_PENALTY;
    DamagePenalty.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(DamagePenalty);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

// Perk name:		Firestorm
// Perk effect:		Once per battle, attack all units in a complete circle around the soldier's position. Also grants immunity to fire damage.
// Localized text:	"Once per battle, attack all units in a complete circle around the soldier's position. Also grants immunity to fire damage."
// Config:			(AbilityName="LW2WotC_Firestorm", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Firestorm()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityCharges_BonusCharges         Charges;
    local X2AbilityCost_Charges                 ChargeCost;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2AbilityMultiTarget_Radius           RadiusMultiTarget;
    local X2Condition_UnitProperty              UnitPropertyCondition;
    local X2AbilityTrigger_PlayerInput          InputTrigger;
    local X2Effect_ApplyFireToWorld_Limited             FireToWorldEffect;
    local X2AbilityToHitCalc_StandardAim        StandardAim;
    local X2Effect_Burning                      BurningEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Firestorm');

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFirestorm";

    InputTrigger = new class'X2AbilityTrigger_PlayerInput';
    Template.AbilityTriggers.AddItem(InputTrigger);

    Charges = new class 'X2AbilityCharges_BonusCharges';
    Charges.InitialCharges = default.FIRESTORM_NUM_CHARGES;
    Charges.BonusAbility = 'LW2WotC_HighPressure';
    Charges.BonusItem = 'HighPressureTanks';
    Charges.BonusAbilityCharges = default.FIRESTORM_HIGH_PRESSURE_CHARGES;
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;
    
    // Adds Suppression restrictions to the ability, depending on config values
	HandleSuppressionRestriction(Template);

    Template.AdditionalAbilities.AddItem(default.PanicImpairingAbilityName);
    //Panic effects need to come before the damage. This is needed for proper visualization ordering.
    Template.AddMultiTargetEffect(CreateNapalmXPanicEffect());
    
    // Sets fire to targeted world tiles - fire effect is more limited than most fire sources
    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.10f;
    FireToWorldEffect.FireChance_Level2 = 0.25f;
    FireToWorldEffect.FireChance_Level3 = 0.60f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
    BurningEffect.ApplyChance = default.FLAMETHROWER_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());
    Template.AddMultiTargetEffect(FireToWorldEffect);

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = false;
    CursorTarget.FixedAbilityRange = 1;
    Template.AbilityTargetStyle = CursorTarget;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = default.FIRESTORM_RADIUS_METERS;
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

    Template.AddShooterEffectExclusions();

    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    Template.ActionFireClass = class'X2Action_Fire_Firestorm';
    Template.TargetingMethod = class'X2TargetingMethod_Grenade';

    Template.ActivationSpeech = 'Flamethrower';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";

    Template.AdditionalAbilities.AddItem('LW2WotC_Firestorm_FireImmunity');
    Template.AdditionalAbilities.AddItem('LW2WotC_Firestorm_Damage');

    Template.PostActivationEvents.AddItem('FlamethrowerActivated');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    Template.CustomFireAnim = 'FF_FireFlameThrower';

    // Interactions with the Chosen and Shadow
    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    return Template;
}

// Granted by LW2WotC_Firestorm 
// Handles the damage for the Firestorm ability
static function X2AbilityTemplate FirestormDamage()
{
    local X2AbilityTemplate                     Template;
    local X2Effect_AbilityDamageMult            DamageBonus;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_Firestorm_Damage');
    Template.bDontDisplayInAbilitySummary = true;
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFirestorm";
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    Template.bDisplayInUITacticalText = false;
    Template.bIsPassive = true;

    DamageBonus = new class'X2Effect_AbilityDamageMult';
    DamageBonus.Penalty = false;
    DamageBonus.Mult = false;
    DamageBonus.DamageMod = default.FIRESTORM_DAMAGE_BONUS;
    DamageBonus.ActiveAbility = 'LW2WotC_Firestorm';
    DamageBonus.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(DamageBonus);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

// Granted by LW2WotC_Firestorm 
// Provides immunity to fire
static function X2AbilityTemplate FirestormFireImmunity()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_DamageImmunity           DamageImmunity;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Firestorm_FireImmunity');
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFirestorm";

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bDisplayInUITacticalText = true;
    Template.bIsPassive = true;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    DamageImmunity = new class'X2Effect_DamageImmunity';
    DamageImmunity.ImmuneTypes.AddItem('Fire');
    DamageImmunity.BuildPersistentEffect(1, true, false, false);
    DamageImmunity.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
    Template.AddTargetEffect(DamageImmunity);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;
}

// Perk name:		Burnout
// Perk effect:		Activating your Flamethrower leaves a small smoke cloud around your position, providing a defensive bonus.
// Localized text:	"Activating your Flamethrower leaves a small smoke cloud around your position, providing a defensive bonus."
// Config:			(AbilityName="LW2WotC_Burnout", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Burnout()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Burnout');
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityIgnition";

    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bDisplayInUITacticalText = true;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.bDontDisplayInAbilitySummary = true;

    Template.bSkipFireAction = true;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'FlamethrowerActivated';
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bUseWeaponRadius = false;
    RadiusMultiTarget.bUseSourceWeaponLocation = false;
    RadiusMultiTarget.fTargetRadius = default.BURNOUT_RADIUS * 1.5; // meters
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
    Template.AddTargetEffect (WeaponEffect);

    Template.AddMultiTargetEffect(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());

    Template.AdditionalAbilities.AddItem('LW2WotC_Burnout_Passive');
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}

// Dummy ability granted by LW2WotC_Burnout so that Burnout shows up as a passive ability
static function X2AbilityTemplate BurnoutPassive()
{
    return PurePassive('LW2WotC_Burnout_Passive', "img:///UILibrary_LW_PerkPack.LW_AbilityIgnition", false, 'eAbilitySource_Perk', true);
}

// Effect that is added to Gauntlet flamethrower abilities to handle the panic roll if the user has LW2WotC_NapalmX
static function X2Effect_ImmediateMultiTargetAbilityActivation CreateNapalmXPanicEffect()
{
    local X2Effect_ImmediateMultiTargetAbilityActivation    NapalmXEffect;
    local X2Condition_AbilityProperty                       NapalmXCondition;
    local X2Condition_UnitProperty                          UnitCondition;

    NapalmXEffect = new class 'X2Effect_ImmediateMultiTargetAbilityActivation';

    NapalmXEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
    NapalmXEffect.EffectName = 'ImmediateDisorientOrPanic';
    NapalmXEffect.AbilityName = default.PanicImpairingAbilityName;
    NapalmXEffect.bRemoveWhenTargetDies = true;

    UnitCondition = new class'X2Condition_UnitProperty';
    UnitCondition.ExcludeOrganic = false;
    UnitCondition.ExcludeRobotic = true;
    UnitCondition.ExcludeAlive = false;
    UnitCondition.ExcludeDead = true;
    UnitCondition.FailOnNonUnits = true;
    UnitCondition.ExcludeFriendlyToSource = true;

    NapalmXCondition = new class'X2Condition_AbilityProperty';
    NapalmXCondition.OwnerHasSoldierAbilities.AddItem('LW2WotC_NapalmX');

    NapalmXEffect.TargetConditions.AddItem(UnitCondition);
    NapalmXEffect.TargetConditions.AddItem(NapalmXCondition);

    return NapalmXEffect;
}

// Effect that is added to Gauntlet flamethrower abilities to handle the panic roll if the user has LW2WotC_NapalmX
static function X2DataTemplate CreateNapalmXPanicEffectAbility()
{
    local X2AbilityTemplate             Template;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Effect_Panicked             PanicEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, default.PanicImpairingAbilityName);

    Template.bDontDisplayInAbilitySummary = true;
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');      //  ability is activated by another ability that hits

    // Target Conditions
    //
    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    // Shooter Conditions
    //
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AddShooterEffectExclusions();

    Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_LWFlamethrower';

    //  Panic effect for 3-4 unblocked psi hits
    PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
    PanicEffect.MinStatContestResult = 1;
    PanicEffect.MaxStatContestResult = 0;
    PanicEffect.bRemoveWhenSourceDies = false;
    Template.AddTargetEffect(PanicEffect);

    Template.bSkipPerkActivationActions = true;
    Template.bSkipFireAction = true;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}

// Perk name:		Fire and Steel
// Perk effect:		Attacks with your gauntlet, and fires set by gauntlet weapons, do +1 damage.
// Localized text:	"Attacks with your gauntlet, and fires set by gauntlet weapons, do +1 damage."
// Config:			(AbilityName="LW2WotC_FireAndSteel", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate FireAndSteel()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_BonusWeaponDamage        DamageEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_FireAndSteel');
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFireandSteel";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    Template.bIsPassive = true;

    DamageEffect = new class'X2Effect_BonusWeaponDamage';
    DamageEffect.BonusDmg = default.FIRE_AND_STEEL_DAMAGE_BONUS;
    DamageEffect.BuildPersistentEffect(1, true, false, false);
    DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
    Template.AddTargetEffect(DamageEffect);

    Template.bCrossClassEligible = false;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

// Perk name:		High Pressure
// Perk effect:	    Your Flamethrower gains +2 charges.
// Localized text:	"Your Flamethrower gains +2 charges."
// Config:			(AbilityName="LW2WotC_HighPressure", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate HighPressure()
{
    local X2AbilityTemplate                     Template;
    local X2AbilityTrigger_UnitPostBeginPlay    PostBeginPlayTrigger;
    local X2Effect_Persistent                   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_HighPressure');

    PostBeginPlayTrigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
    PostBeginPlayTrigger.Priority = 40;
    Template.AbilityTriggers.AddItem(PostBeginPlayTrigger);
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityInferno";
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.bCrossClassEligible =false;
    return Template;
}


// Perk name:		Quickburn
// Perk effect:	    Activate so your next use of the flamethrower will not cost an action.
// Localized text:	"Activate so your next use of the flamethrower will not cost an action."
// Config:			(AbilityName="LW2WotC_HighPressure", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Quickburn()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_Quickburn            QuickburnEffect;
    local X2AbilityCooldown                 Cooldown;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Quickburn');
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityQuickburn";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STASIS_LANCE_PRIORITY;
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.AddShooterEffectExclusions();
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.QUICKBURN_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

    Template.AbilityCosts.AddItem(default.FreeActionCost);

    QuickburnEffect = new class 'X2Effect_Quickburn';
    QuickburnEffect.BuildPersistentEffect (1, false, false, true, eGameRule_PlayerTurnEnd);
    QuickburnEFfect.EffectName = 'QuickburnEffect';
    QuickburnEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
    Template.AddTargetEffect (QuickburnEffect);

    Template.bCrossClassEligible = false;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.bShowActivation = true;
    Template.bSkipFireAction = true;

    return Template;
}

//--------------------------------------------------------------------------------------------
//----------------------- FLAMETHROWER UTILITY -----------------------------------------------
//--------------------------------------------------------------------------------------------

function LWFlamethrower_BuildVisualization(XComGameState VisualizeGameState)
{
    local X2AbilityTemplate                 AbilityTemplate;
    local AbilityInputContext               AbilityContext;
    local XComGameStateContext_Ability      Context;
    local X2WeaponTemplate                  WeaponTemplate;
    local XComGameState_Item                SourceWeapon;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    AbilityContext = Context.InputContext;
    AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);
    SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.ItemObject.ObjectID));
    if (SourceWeapon != None)
    {
        WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
    }
    AbilityTemplate.CustomFireAnim = 'FF_FireFlameThrower'; // default to something safe
    if(WeaponTemplate != none)
    {
        switch (WeaponTemplate.DataName)
        {
            case 'LWGauntlet_CG':
            case 'LWGauntlet_BM':
                AbilityTemplate.CustomFireAnim = 'FF_FireFlameThrower_Lv2'; // use the fancy animation
                break;
            default:
                break;
        }
    }

    //Continue building the visualization as normal.
    TypicalAbility_BuildVisualization(VisualizeGameState);
}

// Helper function for adding Suppression restrictions to abilities
static function HandleSuppressionRestriction(X2AbilityTemplate Template)
{
    local X2Condition_UnitEffects SuppressedCondition;
    local name SuppressionEffect;

    if(default.SUPPRESSION_PREVENTS_ABILITIES)
	{   
        SuppressedCondition = new class'X2Condition_UnitEffects';

        foreach default.SUPPRESSION_EFFECTS(SuppressionEffect)
	    {
		    SuppressedCondition.AddExcludeEffect(SuppressionEffect, 'AA_UnitIsSuppressed');
	    }

		Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	}
}

defaultProperties
{
    PanicImpairingAbilityName = "NapalmPanic"
}
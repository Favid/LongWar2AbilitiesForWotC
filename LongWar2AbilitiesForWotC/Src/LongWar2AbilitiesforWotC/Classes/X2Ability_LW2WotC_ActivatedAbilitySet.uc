//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW2WotC_ActivatedAbilitySet
//  PURPOSE: Defines ability templates for activated abilities
//--------------------------------------------------------------------------------------- 

class X2Ability_LW2WotC_ActivatedAbilitySet extends XMBAbility config (LW_SoldierSkills);

var config int WALK_FIRE_AIM_BONUS;
var config int WALK_FIRE_CRIT_MALUS;
var config int WALK_FIRE_COOLDOWN;
var config int WALK_FIRE_AMMO_COST;
var config int WALK_FIRE_DAMAGE_PERCENT_MALUS;
var config int PRECISION_SHOT_COOLDOWN;
var config int PRECISION_SHOT_AMMO_COST;
var config int PRECISION_SHOT_CRIT_BONUS;
var config int PRECISION_SHOT_CRIT_DAMAGE_PERCENT_BONUS;
var config int CYCLIC_FIRE_COOLDOWN;
var config int CYCLIC_FIRE_AIM_MALUS;
var config int CYCLIC_FIRE_MIN_ACTION_REQ;
var config int CYCLIC_FIRE_SHOTS;
var config int CYCLIC_FIRE_AMMO;
var config int TRENCH_GUN_AMMO_COST;
var config int TRENCH_GUN_COOLDOWN;
var config int TRENCH_GUN_TILE_WIDTH;
var config float TRENCH_GUN_CONE_LENGTH;
var config int SLUG_SHOT_COOLDOWN;
var config int SLUG_SHOT_AMMO_COST;
var config int SLUG_SHOT_MIN_ACTION_REQ;
var config int SLUG_SHOT_PIERCE;
var config int STEADY_WEAPON_AIM_BONUS;
var config int INTERFERENCE_CV_CHARGES;
var config int INTERFERENCE_MG_CHARGES;
var config int INTERFERENCE_BM_CHARGES;
var config int INTERFERENCE_ACTION_POINTS;
var config float GHOSTWALKER_DETECTION_RANGE_REDUCTION;
var config int GHOSTWALKER_DURATION;
var config int GHOSTWALKER_COOLDOWN;
var config int KUBIKURI_COOLDOWN;
var config int KUBIKURI_AMMO_COST;
var config int KUBIKURI_MIN_ACTION_REQ;
var config float KUBIKURI_MAX_HP_PCT;
var config int IRON_CURTAIN_MIN_ACTION_REQ;
var config int IRON_CURTAIN_COOLDOWN;
var config int IRON_CURTAIN_ACTION_POINTS;
var config int IRON_CURTAIN_AMMO_COST;
var config int IRON_CURTAIN_TILE_WIDTH;
var config int IRON_CURTAIN_MOB_DAMAGE_DURATION;
var config int IRON_CURTAIN_MOBILITY_DAMAGE;
var config int IRON_CURTAIN_DAMAGE_MODIFIER;
var config int BODY_SHIELD_DEF_BONUS;
var config int BODY_SHIELD_ENEMY_CRIT_MALUS;
var config int BODY_SHIELD_COOLDOWN;
var config int BODY_SHIELD_DURATION;
var config int MIND_MERGE_MIN_ACTION_POINTS;
var config int MIND_MERGE_DURATION;
var config int MIND_MERGE_COOLDOWN;
var config int SOUL_MERGE_COOLDOWN_REDUCTION;
var config float MIND_MERGE_WILL_DIVISOR;
var config float MIND_MERGE_SHIELDHP_DIVISOR;
var config float SOUL_MERGE_WILL_DIVISOR;
var config float SOUL_MERGE_SHIELDHP_DIVISOR;
var config float MIND_MERGE_AMP_MG_WILL_BONUS;
var config float MIND_MERGE_AMP_MG_SHIELDHP_BONUS;
var config float MIND_MERGE_AMP_BM_WILL_BONUS;
var config float MIND_MERGE_AMP_BM_SHIELDHP_BONUS;
var config float MIND_MERGE_CRIT_DIVISOR;
var config float SOUL_MERGE_CRIT_DIVISOR;
var config float MIND_MERGE_AMP_MG_CRIT_BONUS;
var config float SOUL_MERGE_AMP_BM_CRIT_BONUS;
var config int MAX_ABLATIVE_FROM_SOULSTEAL;
var config int STREET_SWEEPER_AMMO_COST;
var config int STREET_SWEEPER_COOLDOWN;
var config int STREET_SWEEPER_CONE_LENGTH;
var config int STREET_SWEEPER_TILE_WIDTH;
var config float STREET_SWEEPER_UNARMORED_DAMAGE_MULTIPLIER;
var config int STREET_SWEEPER_UNARMORED_DAMAGE_BONUS;
var config int NUM_AIRDROP_CHARGES;
var config int RAPID_DEPLOYMENT_COOLDOWN;
var config float FLECHE_BONUS_DAMAGE_PER_TILES;
var config bool NO_MELEE_ATTACKS_WHEN_ON_FIRE;
var config int FORTIFY_DEFENSE;
var config int FORTIFY_COOLDOWN;
var config int RUN_AND_GUN_COOLDOWN;
var config int EXTRA_CONDITIONING_COOLDOWN_REDUCTION;
var config float KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT;
var config int RESCUE_CV_CHARGES;
var config int RESCUE_MG_CHARGES;
var config int RESCUE_BM_CHARGES;
var config int IMPACT_FIELDS_COOLDOWN;
var config int IMPACT_FIELDS_DURATION;
var config int IMPACT_FIELDS_DAMAGE_REDUCTION_PCT;
var config name DOUBLE_TAP_ACTION_POINT_NAME;
var config array<name> DOUBLE_TAP_ABILITIES;
var config int DOUBLE_TAP_COOLDOWN;
var config bool SNAPSHOT_REDUCES_AP_COST_FOR_SPECIAL_SHOTS;
var config array<name> SNAPSHOT_REDUCED_AP_COST_SPECIAL_SHOTS;
var config int VANISHINGACT_CHARGES;
var config int FLUSH_COOLDOWN;
var config int FLUSH_AMMO_COST;
var config int FLUSH_AIM_BONUS;
var config int FLUSH_STATEFFECT_DURATION;
var config int FLUSH_DODGE_REDUCTION;
var config int FLUSH_DEFENSE_REDUCTION;
var config int FLUSH_DAMAGE_PERCENT_MALUS;
var config int CLUTCH_SHOT_CHARGES;
var config int GUNSLINGER_COOLDOWN;
var config int GUNSLINGER_TILES_RANGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(ShootAnyone());

	Templates.AddItem(WalkFire());
	Templates.AddItem(PrecisionShot());
	Templates.AddItem(TrenchGun());
	Templates.AddItem(SlugShot());
	Templates.AddItem(RapidDeployment());
	Templates.AddItem(Fleche());
	Templates.AddItem(Slash());
	Templates.AddItem(StreetSweeper());
	Templates.AddItem(Fortify());
	Templates.AddItem(RunAndGun());
	Templates.AddItem(ExtraConditioning());
	Templates.AddItem(KillerInstinct());
	Templates.AddItem(Interference());
	Templates.AddItem(RescueProtocol());
	Templates.AddItem(Airdrop());
	Templates.AddItem(CyclicFire());
	Templates.AddItem(Kubikuri());
	Templates.AddItem(Ghostwalker());
	Templates.AddItem(IronCurtain());
	Templates.AddItem(BodyShield());
	Templates.AddItem(ImpactFields());
	Templates.AddItem(DoubleTap());
	Templates.AddItem(SnapShot());
	Templates.AddItem(GhostGrenade());
	Templates.AddItem(VanishingAct());
	Templates.AddItem(Flush());
	Templates.AddItem(ClutchShot());
	Templates.AddItem(Gunslinger());
	Templates.AddItem(GunslingerShot());
	Templates.AddItem(SteadyWeapon());
	Templates.AddItem(MindMerge());
	Templates.AddItem(SoulMerge());
	
	return Templates;
}

// For testing purposes. Useful for seeing if defensive bonuses apply properly
static function X2AbilityTemplate ShootAnyone()
{
	local X2AbilityTemplate Template;
	local X2Condition_Visibility            VisibilityCondition;

	// Create a standard attack that doesn't cost an action.
	Template = Attack('LW2WotC_ShootAnyone', "img:///UILibrary_LW_PerkPack.LW_Ability_WalkingFire", false, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free, 1, true);

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;

	Template.AbilityTargetConditions.Length = 0;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetOnlyProperty);

	return Template;
}

// Perk name:		Walk Fire
// Perk effect:		Take a highly accurate shot with +30 bonus to hit but for half damage and -30 crit. Uses 2 ammo.
// Localized text:	"Take a highly accurate shot with +<Ability:WALK_FIRE_AIM_BONUS> bonus to hit but for half damage and -<Ability:WALK_FIRE_CRIT_MALUS> crit. Uses <Ability:WALK_FIRE_AMMO_COST> ammo."
// Config:			(AbilityName="LW2WotC_WalkFire", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate WalkFire()
{
	local X2AbilityTemplate Template;
	local X2Condition_UnitInventory	NoShotgunsCondition;
    local X2Condition_UnitInventory NoSniperRiflesCondition;

	// Create the template using a helper function
	Template = Attack('LW2WotC_WalkFire', "img:///UILibrary_LW_PerkPack.LW_Ability_WalkingFire", false, none, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, eCost_WeaponConsumeAll, default.WALK_FIRE_AMMO_COST, true);

	// Add a cooldown.
	AddCooldown(Template, default.WALK_FIRE_COOLDOWN);

	// Add a secondary ability to provide bonuses on the shot
	AddSecondaryAbility(Template, WalkFireBonuses());

    // Do not allow this ability to be used with Shotguns
    NoShotgunsCondition = new class'X2Condition_UnitInventory';
	NoShotgunsCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	NoShotgunsCondition.ExcludeWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(NoShotgunsCondition);

    // Do not allow this ability to be used with Sniper Rifles
	NoSniperRiflesCondition = new class'X2Condition_UnitInventory';
	NoSniperRiflesCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	NoSniperRiflesCondition.ExcludeWeaponCategory = 'sniper_rifle';
	Template.AbilityShooterConditions.AddItem(NoSniperRiflesCondition);

	return Template;
}

// This is part of the Walk Fire effect, above
static function X2AbilityTemplate WalkFireBonuses()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'LW2WotC_WalkFire_Bonuses';
    
	// The bonus increases hit chance
	Effect.AddToHitModifier(default.WALK_FIRE_AIM_BONUS, eHit_Success);

	// The bonus reduces Crit chance
	Effect.AddToHitModifier(-1 * default.WALK_FIRE_CRIT_MALUS, eHit_Crit);

	// The bonus reduces damage by a percentage
	Effect.AddPercentDamageModifier(-1 * default.WALK_FIRE_DAMAGE_PERCENT_MALUS);

	// The bonus only applies to the Walk Fire ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('LW2WotC_WalkFire');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('LW2WotC_WalkFire_Bonuses', "img:///UILibrary_LW_PerkPack.LW_Ability_WalkingFire", false, Effect);

	// Walk Fire will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Perk name:		Precision Shot
// Perk effect:		Take a special shot with a bonus to critical chance and critical damage. Cooldown-based.
// Localized text:	"Take a special shot with +<Ability:PRECISION_SHOT_CRIT_BONUS> bonus to critical chance and <Ability:PRECISION_SHOT_CRIT_DAMAGE_PERCENT_BONUS>% bonus critical damage. <Ability:PRECISION_SHOT_COOLDOWN> turn cooldown. Uses <Ability:PRECISION_SHOT_AMMO_COST> ammo."
// Config:			(AbilityName="LW2WotC_PrecisionShot", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate PrecisionShot()
{
	local X2AbilityTemplate Template;

	// Create the template using a helper function
	Template = Attack('LW2WotC_PrecisionShot', "img:///UILibrary_LW_PerkPack.LW_AbilityPrecisionShot", true, none, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, eCost_WeaponConsumeAll, default.PRECISION_SHOT_AMMO_COST, true);

	// Add a cooldown.
	AddCooldown(Template, default.PRECISION_SHOT_COOLDOWN);

	// Add a secondary ability to provide bonuses on the shot
	AddSecondaryAbility(Template, PrecisionShotBonuses());

	return Template;
}

// This is part of the Precision Shot effect, above
static function X2AbilityTemplate PrecisionShotBonuses()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'LW2WotC_PrecisionShot_Bonuses';
    
	// The bonus increases crit chance
	Effect.AddToHitModifier(default.PRECISION_SHOT_CRIT_BONUS, eHit_Crit);

	// The bonus increases crit damage by a percentage
	Effect.AddPercentDamageModifier(default.PRECISION_SHOT_CRIT_DAMAGE_PERCENT_BONUS, eHit_Crit);

	// The bonus only applies to the Precision Shot ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('LW2WotC_PrecisionShot');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('LW2WotC_PrecisionShot_Bonuses', "img:///UILibrary_LW_PerkPack.LW_Ability_PrecisionShot", false, Effect);

	// Precision Shot will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Perk name:		Slug Shot
// Perk effect:		Armor-piercing special shotgun shot with no range penalties.
// Localized text:	"Special shot for primary-weapon shotguns only: Fire a shot that pierces <Ability:SLUG_SHOT_PIERCE> armor and has no range penalties. Uses <Ability:SelfAmmoCost/> ammo. <Ability:SLUG_SHOT_COOLDOWN/> turn cooldown."
// Config:			(AbilityName="LW2WotC_SlugShot", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate SlugShot()
{
	local X2AbilityTemplate Template;
	local X2Effect_Knockback KnockbackEffect;
	local X2Condition_UnitInventory ShotgunOnlyCondition;
	
	// Create the template using a helper function
	Template = Attack('LW2WotC_SlugShot', "img:///UILibrary_LW_PerkPack.LW_AbilitySlugShot", false, none, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, eCost_WeaponConsumeAll, default.SLUG_SHOT_AMMO_COST, true);

	// Create that sweet knockback effect for kills
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

    // Only allow this ability to be used with Shotguns
    ShotgunOnlyCondition = new class'X2Condition_UnitInventory';
	ShotgunOnlyCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	ShotgunOnlyCondition.RequireWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(ShotgunOnlyCondition);

	// Add a cooldown.
	AddCooldown(Template, default.SLUG_SHOT_COOLDOWN);

	// Add a secondary ability to provide bonuses on the shot
	AddSecondaryAbility(Template, SlugShotBonuses());

	return Template;
}

// This is part of the Slug Shot effect, above
static function X2AbilityTemplate SlugShotBonuses()
{
	local X2AbilityTemplate Template;
	local X2Effect_LW2WotC_NullifyWeaponRangeMalus SlugShotEffect;
	local XMBCondition_AbilityName Condition;

	// Creates the effect to ignore weapon range penalty and grant armor piercing
	SlugShotEffect = new class'X2Effect_LW2WotC_NullifyWeaponRangeMalus';
	SlugShotEffect.AddArmorPiercingModifier(default.SLUG_SHOT_PIERCE);

	// The bonuses only apply to the Slug Shot ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('LW2WotC_SlugShot');
	SlugShotEffect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('LW2WotC_SlugShot_Bonuses', "img:///UILibrary_LW_PerkPack.LW_AbilitySlugShot", false, SlugShotEffect);

	// Slug Shot will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Perk name:		Rapid Deployment
// Perk effect:		Activate this ability before throwing or launching a support grenade, and the throw will not cost an action. Cooldown-based.
// Localized text:	"Activate this ability before throwing or launching a support grenade, and the throw will not cost an action. <Ability:RAPID_DEPLOYMENT_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_RapidDeployment")
static function X2AbilityTemplate RapidDeployment()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AbilityCostRefund Effect;
	local X2Condition_LW2WotC_SupportGrenade Condition;

	// Create effect that will refund actions points
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.TriggeredEvent = 'LW2WotC_RapidDeployment';
	Effect.bShowFlyOver = true;
	Effect.CountValueName = 'LW2WotC_RapidDeployment_Uses';
	Effect.MaxRefundsPerTurn = 1;
	Effect.bFreeCost = true;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);

	// Action points are only refunded if using a support grenade (or battlescanner)
	Condition = new class'X2Condition_LW2WotC_SupportGrenade';
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Show a flyover over the target unit when the effect is added
	Effect.VisualizationFn = EffectFlyOver_Visualization;

	// Create activated ability that adds the refund effect
	Template = SelfTargetActivated('LW2WotC_RapidDeployment', "img:///UILibrary_LW_PerkPack.LW_AbilityRapidDeployment", true, Effect,, eCost_Free);
	AddCooldown(Template, default.RAPID_DEPLOYMENT_COOLDOWN);

	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	return Template;
}

// Perk name:		Fleche
// Perk effect:		Attack any enemy within movement range with your sword. Deals bonus damage depending on how far you move for the attack.
// Localized text:	"Attack any enemy within movement range with your sword. Deals +1 damage for every <Ability:FLECHE_BONUS_DAMAGE_PER_TILES/> tiles between your starting position and the target."
// Config:			(AbilityName="LW2WotC_Fleche", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Fleche()
{
	local X2AbilityTemplate                 Template;
	local array<name>                       SkipExclusions;

	// Fleche is just a copy of the vanilla Ranger's Slash ability, but with a bonus damage effect and new icon
	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('LW2WotC_Fleche');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";

	// Add secondary ability for bonus damage
	AddSecondaryAbility(Template, FlecheBonuses());

	// In LW2, melee attacks are allowed when disoriented, so we have to redo the shooter conditions from the base ability, which disables them while disoriented
	Template.AbilityShooterConditions.Length = 0;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);

	// NOTE: Mimicing LW2 functionality where Fleche is disabling while burning. Uncomment code below if you want it to follow the same logic as other melee attacks
	// if (!default.NO_MELEE_ATTACKS_WHEN_ON_FIRE)
	// {
	// 	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	// }

	Template.AddShooterEffectExclusions(SkipExclusions);

	return Template;
}

// This is part of Fleche effect, above
static function X2AbilityTemplate FlecheBonuses()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_MovementBasedBonusDamage			FlecheBonusDamageEffect;

	// Creates the effect to deal more damage the further the unit moved
	FlecheBonusDamageEffect = new class 'X2Effect_LW2WotC_MovementBasedBonusDamage';
	FlecheBonusDamageEffect.AbilityNames.AddItem('LW2WotC_Fleche');
	FlecheBonusDamageEffect.BonusDmgPerTile = default.FLECHE_BONUS_DAMAGE_PER_TILES;
	FlecheBonusDamageEffect.BuildPersistentEffect (1, true, false);

	// Create the template using a helper function
	Template = Passive('LW2WotC_Fleche_Bonuses', "img:///UILibrary_LW_PerkPack.LW_AbilityFleche", false, FlecheBonusDamageEffect);

	// Fleche will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Perk name:		Slash
// Perk effect:		Attack an adjacent target with your sword. Uses one action.
// Localized text:	"Attack an adjacent target with your sword. Uses one action."
// Config:			(AbilityName="LW2WotC_Slash", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Slash()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Slash');

	// Standard melee attack setup
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	// Costs one action and doesn't end turn
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	// Targetted melee attack against a single target
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target must be alive and adjacent
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	if (!default.NO_MELEE_ATTACKS_WHEN_ON_FIRE)
	{
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	}

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	// Typical melee visualizations
	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	// Standard interactions with Shadow, Chosen, and the Lost
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

// Perk name:		Trench Gun
// Perk effect:		Special shot for primary-weapon shotguns only: Fire a short-range cone-based attack at nearby targets. Cooldown-based.
// Localized text:	"Special shot for primary-weapon shotguns only: Fire a short-range cone-based attack at nearby targets. <Ability:TRENCH_GUN_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_TrenchGun", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate TrenchGun()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitInventory			InventoryCondition;
	local X2Effect_Shredder					WeaponDamageEffect;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_TrenchGun');

	// Boilerplate setup
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityStreetSweeper";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	// Boilerplate setup
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	
	// Ammo effects apply
	Template.bAllowAmmoEffects = true;

	// Requires one action point and ends turn
	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Configurable ammo cost
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.TRENCH_GUN_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Configurable cooldown
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.TRENCH_GUN_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Can hurt allies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Shotguns only
	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	// Cannot be used while disoriented, burning, etc.
	Template.AddShooterEffectExclusions();
	
	// Cannot use while suppressed
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	// Standard aim calculation
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = false; 
	StandardAim.bGuaranteedHit = false;
	StandardAim.bOnlyMultiHitWithSuccess = false;
	StandardAim.bAllowCrit = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.bOverrideAim = false;

	// Manual targetting
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	// Can shred
	WeaponDamageEffect = new class'X2Effect_Shredder';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.bFragileDamageOnly = true;
	Template.bCheckCollision = true;

	// Cone style target, does not go through full cover
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.TRENCH_GUN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bUseWeaponRangeForLength = false;
	ConeMultiTarget.ConeLength=default.TRENCH_GUN_CONE_LENGTH;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	// Standard visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Standard interactions with Shadow, Chosen, and the Lost
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

// Perk name:		Street Sweeper
// Perk effect:		Cone-based shotgun attack that does bonus damage to unarmored targets. Blocked by heavy cover.
// Localized text:	"Cone-based shotgun attack that does bonus damage to unarmored targets. Blocked by heavy cover."
// Config:			(AbilityName="LW2WotC_StreetSweeper", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate StreetSweeper()
{
	local X2AbilityTemplate					Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitInventory			InventoryCondition;
	local X2Effect_Shredder					WeaponDamageEffect;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_StreetSweeper');

	// Boilerplate setup
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityStreetSweeper2";
	Template.ActivationSpeech = 'Reaper';
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Cone';
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	// Boilerplate setup
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);

	// Can shred
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// Ammo effects apply
	Template.bAllowAmmoEffects = true;

	// Requires one action point and ends turn
	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Configurable ammo cost
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.STREET_SWEEPER_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Configurable cooldown
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.STREET_SWEEPER_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Can hit allies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	// Cannot be used while suppressed
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	// Shotgun only
	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	// Cannot be used while disoriented, burning, etc.
	Template.AddShooterEffectExclusions();

	// Standard aim calculation
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = false; 
	StandardAim.bGuaranteedHit = false;
	StandardAim.bOnlyMultiHitWithSuccess = false;
	StandardAim.bAllowCrit = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.bOverrideAim = false;

	// Manual targetting
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	// Can shred
	WeaponDamageEffect = new class'X2Effect_Shredder';
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.bFragileDamageOnly = true;
	Template.bCheckCollision = true;

	// Cone style target, does not go through full cover
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.STREET_SWEEPER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bUseWeaponRangeForLength = false;
	ConeMultiTarget.ConeLength=default.STREET_SWEEPER_CONE_LENGTH;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;
	
	// Standard visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Standard interactions with Shadow, Chosen, and the Lost
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	// Add secondary ability that provides the unarmored damage bonus
	AddSecondaryAbility(Template, LW2WotC_StreetSweeperBonus());

	return Template;
}

static function X2AbilityTemplate LW2WotC_StreetSweeperBonus()
{
	local X2AbilityTemplate							Template;	
	local X2Effect_LW2WotC_StreetSweeper			StreetSweeperEffect;

	// Effect granting bonus damage against unarmored targets
	StreetSweeperEffect = new class 'X2Effect_LW2WotC_StreetSweeper';
	StreetSweeperEffect.Unarmored_Damage_Multiplier = default.STREET_SWEEPER_UNARMORED_DAMAGE_MULTIPLIER;
	StreetSweeperEffect.Unarmored_Damage_Bonus = default.STREET_SWEEPER_UNARMORED_DAMAGE_BONUS;

	// Create the template using a helper function
	Template = Passive('LW2WotC_StreetSweeper_Bonus', "img:///UILibrary_LW_PerkPack.LW_AbilityStreetSweeper2", false, StreetSweeperEffect);

	// Street Sweeper will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);
	
	return Template;
}

// Perk name:		Fortify
// Perk effect:		Activate to grant bonus defense until the beginning of the next turn. Does not cost an action. Cooldown-based.
// Localized text:	"Activate to grant +<ABILITY:FORTIFY_DEFENSE_LW/> defense until the beginning of the next turn. Does not cost an action. Has a <ABILITY:FORTIFY_COOLDOWN_LW/>-turn cooldown."
// Config:			(AbilityName="LW2WotC_Fortify")
static function X2AbilityTemplate Fortify()
{
	local X2Effect_PersistentStatChange Effect;
	local X2AbilityTemplate Template;

	// Create an effect that will grant defense bonus
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'LW2WotC_Fortify';
	Effect.AddPersistentStatChange(eStat_Defense, default.FORTIFY_DEFENSE);
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Effect.VisualizationFn = EffectFlyOver_Visualization;

	// Create the template as a helper function. This is an activated ability that doesn't cost an action.
	Template = SelfTargetActivated('LW2WotC_Fortify', "img:///UILibrary_LW_PerkPack.LW_AbilityFortify", true, Effect, class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY, eCost_Free);

	// Add a cooldown
	AddCooldown(Template, default.FORTIFY_COOLDOWN);

	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	return Template;
}

// Perk name:		Run And Gun
// Perk effect:		Take an action after dashing. Differs from Vanilla version by offering support for Killer Instinct and Extra Conditioning
// Localized text:	"Take an action after dashing."
// Config:			(AbilityName="LW2WotC_RunAndGun")
static function X2AbilityTemplate RunAndGun()
{
	local X2AbilityTemplate                 	Template;
	local X2AbilityCooldown_LW2WotC_RunAndGun 	Cooldown;
	local X2Effect_LW2WotC_KillerInstinct 		CritDamageEffect;
	local X2Condition_UnitValue					ActionRefundCondition;

	// Start with a copy of the vanilla Ranger's Run and Gun ability
	Template = class'X2Ability_RangerAbilitySet'.static.RunAndGunAbility('LW2WotC_RunAndGun');

	// Replace exising cooldown with one that will check for Extra Conditioning
	Cooldown = new class'X2AbilityCooldown_LW2WotC_RunAndGun';
	Cooldown.BaseCooldown = default.RUN_AND_GUN_COOLDOWN;
	Cooldown.ExtraConditioningCooldownReduction = default.EXTRA_CONDITIONING_COOLDOWN_REDUCTION;
	Template.AbilityCooldown = Cooldown;

	// Add a bonus damage effect that will check for Killer Instinct
	CritDamageEffect = new class'X2Effect_LW2WotC_KillerInstinct';
	CritDamageEffect.BuildPersistentEffect(1,false,false,false,eGameRule_PlayerTurnEnd);
	CritDamageEffect.CritDamageBonusPercent = default.KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT;
	Template.AddTargetEffect(CritDamageEffect);

	// Do not let Run and Gun be used if Hit and Run or Close Encounters were activated this turn
	ActionRefundCondition = new class 'X2Condition_UnitValue';
	ActionRefundCondition.AddCheckValue ('LW2WotC_CloseEncountersUses', 0, eCheck_Exact,,,'AA_AbilityUnavailable');
	ActionRefundCondition.AddCheckValue ('LW2WotC_HitandRunUses', 0, eCheck_Exact,,,'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(ActionRefundCondition); 

	return Template;
}

// Perk name:		Extra Conditioning
// Perk effect:		Run and Gun cooldown is reduced.
// Localized text:	"Run and Gun cooldown is reduced by <Ability:EXTRA_CONDITIONING_COOLDOWN_REDUCTION> turn."
// Config:			(AbilityName="LW2WotC_ExtraConditioning")
static function X2AbilityTemplate ExtraConditioning()
{
	// This ability is a passive with no effects. Run and Gun will simply check if the soldier has it and reduce cooldown if it's found
	return Passive('LW2WotC_ExtraConditioning', "img:///UILibrary_PerkIcons.UIPerk_stickandmove", false, none);
}

// Perk name:		Killer Instinct
// Perk effect:		Activating Run & Gun grants bonus critical damage for the rest of the turn.
// Localized text:	"Activating Run & Gun grants +<Ability:KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT>% critical damage for the rest of the turn."
// Config:			(AbilityName="LW2WotC_KillerInstinct")
static function X2AbilityTemplate KillerInstinct()
{
	// This ability is a passive with no effects. Run and Gun will simply check if the soldier has it and increase crit damage if it's found
	return Passive('LW2WotC_KillerInstinct', "img:///UILibrary_LW_PerkPack.LW_AbilityKillerInstinct", false, none);
}

// Perk name:		Interference
// Perk effect:		GREMLIN cancels overwatch on targeted unit.
// Localized text:	"GREMLIN cancels overwatch on targeted unit. Use <Ability:INTERFERENCE_CV_CHARGES> times per battle."
// Config:			(AbilityName="LW2WotC_Interference", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Interference()
{
	local X2AbilityTemplate									Template;	
	local X2AbilityCost_ActionPoints            			ActionPointCost;
	local X2AbilityCharges_LW2WotC_GremlinTierBased         Charges;
	local X2AbilityCost_Charges                 			ChargeCost;
	local X2Condition_Visibility                			VisCondition;
	local X2Effect_LW2WotC_RemoveReserveActionPoints		ActionPointsEffect;
	local X2Condition_UnitActionPoints						ValidTargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Interference');

	// Boilerplate setup
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityInterference";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.bStationaryWeapon = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.bSkipPerkActivationActions = true;
	Template.bCrossClassEligible = false;

	// Total charges based on Gremlin tier
	Charges = new class 'X2AbilityCharges_LW2WotC_GremlinTierBased';
	Charges.CV_Charges = default.INTERFERENCE_CV_CHARGES;
	Charges.MG_Charges = default.INTERFERENCE_MG_CHARGES;
	Charges.BM_Charges = default.INTERFERENCE_BM_CHARGES;
	Template.AbilityCharges = Charges;

	// Uses consume one charge
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);
	
	// Single target, can't miss
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Does not end turn. Configurable action point cost
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.INTERFERENCE_ACTION_POINTS;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Can't use it when you're dead, disoriented, burning, etc.
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Can only target living targets, squadsight ok
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);
	
	// Can only target those with reserve action points
	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(1,class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint,true,eCheck_GreaterThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	// Effect that removes the reserve action points
	ActionPointsEffect = new class'X2Effect_LW2WotC_RemoveReserveActionPoints';
	Template.AddTargetEffect (ActionPointsEffect);
	
	// Gremlin animation stuff
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.CinescriptCameraType = "Specialist_CombatProtocol";
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;

	return Template;
}

// Perk name:		Rescue Protocol
// Perk effect:		Use your Gremlin to grant a movement action to an ally.
// Localized text:	"Use your Gremlin to grant a movement action to an ally."
// Config:			(AbilityName="LW2WotC_RescueProtocol", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate RescueProtocol()
{
	local X2AbilityTemplate							Template;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local X2AbilityCost_Charges						ChargeCost;
	local X2AbilityCharges_LW2WotC_GremlinTierBased	Charges;
	local X2Condition_UnitEffects					CommandRestriction;
	local X2Effect_GrantActionPoints				ActionPointEffect;
	local X2Effect_Persistent						ActionPointPersistEffect;
	local X2Condition_UnitProperty					UnitPropertyCondition;
	local X2Condition_UnitActionPoints				ValidTargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_RescueProtocol');

	// Boilerplate setup
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_defensiveprotocol";
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bStationaryWeapon = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipPerkActivationActions = true;
	Template.bCrossClassEligible = false;

	// Total charges based on Gremlin tier
	Charges = new class 'X2AbilityCharges_LW2WotC_GremlinTierBased';
	Charges.CV_Charges = default.RESCUE_CV_CHARGES;
	Charges.MG_Charges = default.RESCUE_MG_CHARGES;
	Charges.BM_Charges = default.RESCUE_BM_CHARGES;
	Template.AbilityCharges = Charges;

	// Uses consume one charge
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	// Single target or self, can't miss
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Does not end turn. Costs one action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Can't use it when you're dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Cannot target allies with any sort of non-standard/reserve action pionts
	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,'Suppression',true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2Ability_SharpshooterAbilitySet'.default.KillZoneReserveType,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.StandardActionPoint,false,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.RunAndGunActionPoint,false,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.MoveActionPoint,false,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	// More rules for valid targets
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeUnrevealedAI = true;
	UnitPropertyCondition.ExcludeConcealed = true;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludePanicked = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeStunned = true;
	UnitPropertyCondition.ExcludeNoCover = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = false;
	UnitPropertyCondition.ExcludeTurret = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// More rules for valid targets
	CommandRestriction = new class'X2Condition_UnitEffects';
	CommandRestriction.AddExcludeEffect('Command', 'AA_UnitIsCommanded');
	CommandRestriction.AddExcludeEffect('Rescued', 'AA_UnitIsCommanded');
	CommandRestriction.AddExcludeEffect('HunkerDown', 'AA_UnitIsCommanded');
    CommandRestriction.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(CommandRestriction);

	// Effect that grants a movement action point
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Template.AddTargetEffect(ActionPointEffect);

	// So that a unit can't have Rescue Protocol used on them twice in a turn
	ActionPointPersistEffect = new class'X2Effect_Persistent';
    ActionPointPersistEffect.EffectName = 'Rescued';
    ActionPointPersistEffect.BuildPersistentEffect(1, false, true, false, 8);
    ActionPointPersistEffect.bRemoveWhenTargetDies = true;
    Template.AddTargetEffect(ActionPointPersistEffect);
	Template.bShowActivation = true;

	// Gremlin animation stuff
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.ActivationSpeech = 'DefensiveProtocol';
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;

	return Template;
}

// Perk name:		Airdrop
// Perk effect:		The Gremlin grants an explosive grenade to the targeted ally.
// Localized text:	"The Gremlin grants an explosive grenade to the targeted ally. <NUM_AIRDROP_CHARGES> uses per mission."
// Config:			(AbilityName="LW2WotC_Airdrop", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Airdrop()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitProperty			TargetProperty;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges                  Charges;
	local XMBEffect_AddUtilityItem 			ItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Airdrop');

	// Boilerplate setup
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAirdrop";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;

	// Configurable charges
	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.NUM_AIRDROP_CHARGES;
	Template.AbilityCharges = Charges;

	// Uses consume one charge
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	// Does not end turn. Costs one action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Can't use it when you're dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Targets organic allies only
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	TargetProperty.RequireSquadmates = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeAlien = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	// Effect that gives the grenade
	ItemEffect = new class'XMBEffect_AddUtilityItem';
	ItemEffect.EffectName = 'AirdropGrenadeEffect';
	ItemEffect.DataName = 'FragGrenade';
	ItemEffect.BuildPersistentEffect(1, true, false);
	ItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	ItemEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(ItemEffect);

	// Gremlin animation stuff
	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.CinescriptCameraType = "Specialist_CombatProtocol";

	return Template;
}

// Perk name:		Cyclic Fire
// Perk effect:		Special Shot: Fire multiple shots at a target in a single attack. All shots have aim penalties. Cooldown-based.
// Localized text:	"Special Shot: Fire <Ability:CYCLIC_FIRE_SHOTS> shots at a target in a single attack. Requires <Ability:CYCLIC_FIRE_MIN_ACTION_REQ> actions and all shots have aim penalties. <Ability:CYCLIC_FIRE_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_CyclicFire", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate CyclicFire()
{
	local X2AbilityTemplate 				Template;
	local EActionPointCost					ActionPointCost;
	local X2Condition_UnitInventory			NoShotgunsCondition;
	local X2Condition_UnitInventory			NoSniperRiflesCondition;
	local X2AbilityToHitCalc_StandardAim	ToHitCalc;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityMultiTarget_BurstFire	BurstFireMultiTarget;
	local X2Effect_Shredder					WeaponDamageEffect;

	// Action point cost will be one or two, depending on config
	ActionPointCost = eCost_SingleConsumeAll;
	if(default.CYCLIC_FIRE_MIN_ACTION_REQ == 2)
	{
		ActionPointCost = eCost_DoubleConsumeAll;
	}

	// Create template with helper function - normally we could pass in none for the effect and let the function give this ability template the default weapon damage effect
	// However, the game will not display the damage numbers for the additional hits properly unless the first shot and the following burst shots use the same instance of of the damage effect
	Template = Attack('LW2WotC_CyclicFire', "img:///UILibrary_LW_PerkPack.LW_AbilityCyclicFire", false, class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect(), class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY, ActionPointCost, default.CYCLIC_FIRE_AMMO, true);

    // Do not allow this ability to be used with Shotguns
    NoShotgunsCondition = new class'X2Condition_UnitInventory';
	NoShotgunsCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	NoShotgunsCondition.ExcludeWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(NoShotgunsCondition);

    // Do not allow this ability to be used with Sniper Rifles
	NoSniperRiflesCondition = new class'X2Condition_UnitInventory';
	NoSniperRiflesCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	NoSniperRiflesCondition.ExcludeWeaponCategory = 'sniper_rifle';
	Template.AbilityShooterConditions.AddItem(NoSniperRiflesCondition);

	// Configurable ability cooldown
	AddCooldown(Template, default.CYCLIC_FIRE_COOLDOWN);
 	
 	// Configurable aim penalty
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = -default.CYCLIC_FIRE_AIM_MALUS;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	// Knockback effect on kill
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	// Add the burst fire effect. This is for the additional shots after the first, hence the -1
	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
    BurstFireMultiTarget.NumExtraShots = default.CYCLIC_FIRE_SHOTS-1;
    Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	// Assign the same weapon damage effect instance to both types of shots, so that damage numbers appear properly
	// The extra burst fire shots are considered multi-target, so we need to add the effect to it separately for those shots to do damage
	WeaponDamageEffect = new class'X2Effect_Shredder';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

    return Template;
}

// Perk name:		Kubikuri
// Perk effect:		Special shot against most enemies who have taken any damage: Any critical hit kills them, but regular hits do half damage. Cooldown-based.
// Localized text:	"Special shot against most enemies who have taken any damage: Any critical hit kills them, but regular hits do half damage. Requires <Ability:KUBIKURI_MIN_ACTION_REQ> actions and has a <Ability:KUBIKURI_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_Kubikuri", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate Kubikuri()
{
	local X2AbilityTemplate					Template;
	local EActionPointCost        			ActionPointCost;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_UnitStatCheck			TargetHPCondition;

	// Action point cost will be one or two, depending on config
	ActionPointCost = eCost_SingleConsumeAll;
	if(default.KUBIKURI_MIN_ACTION_REQ == 2)
	{
		ActionPointCost = eCost_DoubleConsumeAll;
	}

	// Create the template using a helper function
	Template = Attack('LW2WotC_Kubikuri', "img:///UILibrary_LW_PerkPack.LW_AbilityKubikuri", false, none, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, ActionPointCost, default.KUBIKURI_AMMO_COST, true);

	// Specific voice line
	Template.ActivationSpeech = 'Reaper';

	// Can only target enemies that have taken damage
	TargetHPCondition = new class 'X2Condition_UnitStatCheck';
	TargetHPCondition.AddCheckStat(eStat_HP,default.KUBIKURI_MAX_HP_PCT,eCheck_LessThanOrEqual,,,true);
	Template.AbilityTargetConditions.AddItem(TargetHPCondition);

	// Knockback effect on kill
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	// Configurable cooldown
	AddCooldown(Template, default.KUBIKURI_COOLDOWN);

	// Add a secondary ability to provide bonuses on the shot
	AddSecondaryAbility(Template, KubikuriShotBonuses());

	return Template;
}

// This is part of the Kubikuri effect, above
static function X2AbilityTemplate KubikuriShotBonuses()
{
	local X2AbilityTemplate Template;
	local X2Effect_LW2WotC_Kubikuri	DamageEffect;

	// Effect granting the damage bonus on crit
	DamageEffect = new class'X2Effect_LW2WotC_Kubikuri';

	// Create template with helper function
	Template = Passive('LW2WotC_Kubikuri_Bonuses', "img:///UILibrary_LW_PerkPack.LW_AbilityKubikuri", false, DamageEffect);

	// Kubikuri will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Perk name:		Ghostwalker
// Perk effect:		Activate this ability to reduce enemy detection range against you by almost 25% for the rest of your turn as well as the following turn. Cooldown-based."
// Localized text:	"Activate this ability to reduce enemy detection range against you by almost 25% for the rest of your turn as well as the following turn. <Ability:GHOSTWALKER_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_Ghostwalker")
static function X2AbilityTemplate Ghostwalker()
{
	local X2AbilityTemplate					Template;
	local X2Effect_PersistentStatChange		StealthyEffect;
	local XMBCondition_Concealed			ConcealedCondition;

	// The reduced detection radius effect that occurs when the ability is activated
	StealthyEffect = new class'X2Effect_PersistentStatChange';
	StealthyEffect.BuildPersistentEffect(default.GHOSTWALKER_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	StealthyEffect.AddPersistentStatChange(eStat_DetectionModifier, default.GHOSTWALKER_DETECTION_RANGE_REDUCTION);

	// Show a flyover over the target unit when the effect is added
	StealthyEffect.VisualizationFn = EffectFlyOver_Visualization;

	// Create template with a helper function
	Template = SelfTargetActivated('LW2WotC_Ghostwalker', "img:///UILibrary_LW_PerkPack.LW_AbilityGhostwalker", true, StealthyEffect, default.AUTO_PRIORITY, eCost_Free);

	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	// Custom voice line
	Template.ActivationSpeech = 'ActivateConcealment';
	
	// Can only be used while conealed
	ConcealedCondition = new class'XMBCondition_Concealed';
	Template.AbilityTargetConditions.AddItem(ConcealedCondition);

	// Configurable cooldown
	AddCooldown(Template, default.GHOSTWALKER_COOLDOWN);

	return Template;
}

// Perk name:		Iron Curtain
// Perk effect:		Special shot that does reduced damage but reduces target mobility for the following turns. Cone-based attack with primary weapon. Cooldown-based.
// Localized text:	"Special shot that does <Ability:IRON_CURTAIN_DAMAGE_MODIFIER> damage but reduces target mobility for the following <Ability:IRON_CURTAIN_MOB_DAMAGE_DURATION> turns. Cone-based attack with primary weapon. <Ability:IRON_CURTAIN_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_IronCurtain")
static function X2AbilityTemplate IronCurtain()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitInventory			NoShotgunsCondition;
    local X2Condition_UnitInventory			NoSniperRiflesCondition;
	local X2Effect_PersistentStatChange		MobilityDamageEffect;
	local X2Effect_Shredder					RegularDamage;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_IronCurtain');	

	// Boilerplate setup
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityIronCurtain";
    Template.ActivationSpeech = 'SaturationFire';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	// Applies holotargeting and ammo effects
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.bAllowAmmoEffects = true;

	// Configurable action point cost
	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.IRON_CURTAIN_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Configurable ammo cost
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.IRON_CURTAIN_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Configurable cooldown
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.IRON_CURTAIN_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Standard multitarget aim calculation
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = false; 
	StandardAim.bGuaranteedHit = false;
	StandardAim.bOnlyMultiHitWithSuccess = false; 
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;
	Template.bOverrideAim = false;

	// Cursor targeting for a cone attack
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange=true;
	Template.AbilityTargetStyle = CursorTarget;
	Template.bFragileDamageOnly = false;
	Template.bCheckCollision = true; 
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	// Details for the size of the cone
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.IRON_CURTAIN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bUseWeaponRangeForLength = true;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	// Cannot be used while burning, disoriented, etc.
	Template.AddShooterEffectExclusions();

	// Can hit allies. Cannot hit the dead
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	// Cannot be used with shotguns
	NoShotgunsCondition = new class'X2Condition_UnitInventory';
	NoShotgunsCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	NoShotgunsCondition.ExcludeWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(NoShotgunsCondition);

	// Cannot be used with sniper rifles
	NoSniperRiflesCondition = new class'X2Condition_UnitInventory';
	NoSniperRiflesCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	NoSniperRiflesCondition.ExcludeWeaponCategory = 'sniper_rifle';
	Template.AbilityShooterConditions.AddItem(NoSniperRiflesCondition);

	// Effect that applies the damage
	RegularDamage = new class'X2Effect_Shredder';
	RegularDamage.bApplyOnHit = true;
	RegularDamage.bApplyOnMiss = false;
	RegularDamage.bIgnoreBaseDamage = false;
	Template.AddTargetEffect(RegularDamage);
	Template.AddMultiTargetEffect(RegularDamage);
	
	// Effect that applies the mobility penalty
	MobilityDamageEffect = new class 'X2Effect_PersistentStatChange';
	MobilityDamageEffect.BuildPersistentEffect (default.IRON_CURTAIN_MOB_DAMAGE_DURATION, false, false, false, eGameRule_PlayerTurnEnd);
	MobilityDamageEffect.SetDisplayInfo(ePerkBuff_Penalty,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	MobilityDamageEffect.AddPersistentStatChange (eStat_Mobility, -default.IRON_CURTAIN_MOBILITY_DAMAGE);
	MobilityDamageEffect.DuplicateResponse = eDupe_Allow;
	MobilityDamageEffect.EffectName = 'IronCurtainEffect';
	MobilityDamageEffect.VisualizationFn = EffectFlyOver_Visualization;
	Template.AddTargetEffect(MobilityDamageEffect);
	Template.AddMultiTargetEffect(MobilityDamageEffect);

	// Typical visualization
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.bUsesFiringCamera = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Add a secondary ability to provide bonuses on the shot
	AddSecondaryAbility(Template, IronCurtainBonuses());

	return Template;
}

// This is part of the Iron Curtain effect, above
static function X2AbilityTemplate IronCurtainBonuses()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'LW2WotC_IronCurtain_Bonuses';

	// The bonus reduces damage by a percentage
	Effect.AddPercentDamageModifier(-1 * default.IRON_CURTAIN_DAMAGE_MODIFIER);

	// The bonus only applies to the Iron Curtain ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('LW2WotC_IronCurtain');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('LW2WotC_IronCurtain_Bonuses', "img:///UILibrary_LW_PerkPack.LW_AbilityIronCurtain", false, Effect);

	// Iron Curtain will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Perk name:		Body Shield
// Perk effect:		A targeted enemy receives reduced aim and critical chance against the soldier. Cooldown-based.
// Localized text:	"A targeted enemy receives -<Ability:BODY_SHIELD_DEF_BONUS> aim and -<Ability:BODY_SHIELD_ENEMY_CRIT_MALUS> critical chance against the soldier. <Ability:BODY_SHIELD_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_BodyShield")
static function X2AbilityTemplate BodyShield()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_BodyShield		BodyShieldEffect;

	// Effect on the target that reduces their aim and crit against the user
	BodyShieldEffect = new class'X2Effect_LW2WotC_BodyShield';
	BodyShieldEffect.BodyShieldDefBonus = default.BODY_SHIELD_DEF_BONUS;
	BodyShieldEffect.BodyShieldCritMalus = default.BODY_SHIELD_ENEMY_CRIT_MALUS;
	BodyShieldEffect.BuildPersistentEffect(default.BODY_SHIELD_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	BodyShieldEffect.EffectName='LW2WotC_BodyShield';

	// Create template with a helper function
	Template = TargetedDebuff('LW2WotC_BodyShield', "img:///UILibrary_LW_PerkPack.LW_AbilityBodyShield", false, BodyShieldEffect, default.AUTO_PRIORITY, eCost_Free);

	// Helper function adds a custom fire animation, but we don't want one for this ability
	Template.CustomFireAnim = '';

	// Doesn't break concealment or provoke hostile actions
	Template.Hostility = eHostility_Neutral;

	// Show activation, but don't treat it like a gunshot attack
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	// Configurable cooldown
	AddCooldown(Template, default.BODY_SHIELD_COOLDOWN);

	return Template;
}

// Perk name:		Impact Fields
// Perk effect:		Activate a force field that reduces incoming damage for a few turns. Cooldown-based.
// Localized text:	"Activate a force field that reduces incoming damage by <Ability:IMPACT_FIELDS_DAMAGE_REDUCTION_PCT>% for <Ability:IMPACT_FIELDS_DURATION> turns. <Ability:IMPACT_FIELDS_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_ImpactFields")
static function X2AbilityTemplate ImpactFields()
{
	local X2AbilityTemplate 						Template;
	local X2Effect_LW2WotC_ReduceDamageByPercent	ReduceDamageEffect;
	local array<name>                       		SkipExclusions;

	// Effect that reduces damage taken
	ReduceDamageEffect = new class'X2Effect_LW2WotC_ReduceDamageByPercent';
	ReduceDamageEffect.EffectName='LW2WotC_ImpactFields';
	ReduceDamageEffect.DamageReductionPercent = default.IMPACT_FIELDS_DAMAGE_REDUCTION_PCT;
	ReduceDamageEffect.BuildPersistentEffect(default.IMPACT_FIELDS_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	ReduceDamageEffect.VisualizationFn = EffectFlyOver_Visualization;

	// Create the template as a helper function. This is an activated ability that costs one action, but does not end the turn
	Template = SelfTargetActivated('LW2WotC_ImpactFields', "img:///UILibrary_LW_PerkPack.LW_AbilityAbsorptionFields", false, ReduceDamageEffect, default.AUTO_PRIORITY, eCost_Single);

	// Configurable cooldown
	AddCooldown(Template, default.IMPACT_FIELDS_COOLDOWN);

	// Cannot be used while burning, etc. Disorient is okay though
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	return Template;
}

// Perk name:		Double Tap
// Perk effect:		Activate to fire a standard shot and gain a second action restricted to an additional shot or overwatching.
// Localized text:	"Activate to fire a standard shot and gain a second action restricted to an additional shot or overwatching."
// Config:			(AbilityName="LW2WotC_DoubleTap")
static function X2AbilityTemplate DoubleTap()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Knockback				KnockbackEffect;

	// Create the template using a helper function
	Template = Attack('LW2WotC_DoubleTap', "img:///UILibrary_LW_PerkPack.LW_AbilityDoubleTap", false, none, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_DoubleConsumeAll, 1, true);

	// Knockback effect on kill
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	// Configurable cooldown
	AddCooldown(Template, default.DOUBLE_TAP_COOLDOWN);

	// Additional ability that grants the double tap action points
	AddSecondaryAbility(Template, DoubleTapBonus());

	return Template;
}

// This is part of the Double Tap effect, above
static function X2AbilityTemplate DoubleTapBonus()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;

	// Adds two action points that can only be used for gunshots
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 2;
	Effect.PointType = default.DOUBLE_TAP_ACTION_POINT_NAME;

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('LW2WotC_DoubleTap_Bonus', "img:///UILibrary_LW_PerkPack.LW_AbilityDoubleTap", false, Effect, 'AbilityActivated');

	// Only activates when Double Tap is used
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('LW2WotC_DoubleTap');
	AddTriggerTargetCondition(Template, NameCondition);

	// Show a flyover when activated
	Template.bShowActivation = true;

	return Template;
}

// Perk name:		Snap Shot
// Perk effect:		You may take standard shots with your sniper rifle after moving, but you suffer severe range penalties beyond 5 tiles of squadsight range.
// Localized text:	"You may take standard shots with your sniper rifle after moving, but you suffer severe range penalties beyond 5 tiles of squadsight range."
// Config:			(AbilityName="LW2WotC_SnapShot", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate SnapShot()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Knockback				KnockbackEffect;

	// Create the template using a helper function
	Template = Attack('LW2WotC_SnapShot', "img:///UILibrary_LW_PerkPack.LW_AbilitySnapShot", false, none, class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY, eCost_SingleConsumeAll, 1, true);

	// Knockback effect on kill
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	// Only show SnapShot if StandardShot is not available
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('SniperStandardFire');

	// Applies the aim penalty at extreme distances
	AddSecondaryAbility(Template, SnapShotAimModifier());

	return Template;
}

// This is part of the SnapShot effect, above
static function X2AbilityTemplate SnapShotAimModifier()
{
	local X2AbilityTemplate 			Template;
	local X2Effect_LW2WotC_SnapShotAimModifier  Effect;

	// This effect lowers the user's aim at extreme ranges when using SnapShot
	Effect = new class'X2Effect_LW2WotC_SnapShotAimModifier';

	// Create the template using a helper function
	Template = Passive('LW2WotC_SnapShot_AimModifier', "img:///UILibrary_LW_PerkPack.LW_AbilitySnapShot", false, Effect);

	// SnapShot will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Reduces AP cost if user has LW2WotC_SnapShot
// Applied to various abilities if feature is turned on in the config
// NOTE: This method may not work with abilities that already have intricate cooldown definitions
static function X2AbilityCost_LW2WotC_ReducedActionCostByAbility SnapShotReducedAbilityCost()
{
	local X2AbilityCost_LW2WotC_ReducedActionCostByAbility AbilityCost;

	AbilityCost = new class'X2AbilityCost_LW2WotC_ReducedActionCostByAbility';
	AbilityCost.iNumPoints = 0; 
	AbilityCost.bAddWeaponTypicalCost = true; 
	AbilityCost.bConsumeAllPoints = true;
	AbilityCost.AbilitiesThatReduceCost.AddItem('LW2WotC_SnapShot');

	return AbilityCost;
}

// Perk name:		Ghost Grenade
// Perk effect:		A specialized smoke grenade that causes the targeted ally to enter concealment.
// Localized text:	"A specialized smoke grenade that causes the targeted ally to enter concealment."
// Config:			(AbilityName="LW2WotC_GhostGrenade")
static function X2AbilityTemplate GhostGrenade()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AddUtilityItem ItemEffect;

	// Adds a free ghost grenade
	ItemEffect = new class'XMBEffect_AddUtilityItem';
	ItemEffect.DataName = 'LW2WotC_GhostGrenade';

	// Create the template using a helper function
	Template = Passive('LW2WotC_GhostGrenade', "img:///UILibrary_PerkIcons.UIPerk_ghost", false, ItemEffect);

	return Template;
}

// This is the ability that the Ghost Grenade item grants
static function X2AbilityTemplate VanishingAct()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty		TargetProperty, ShooterProperty;
	local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;
	local X2Effect_SmokeGrenade				SmokeEffect;	
	local X2Effect_RangerStealth		StealthEffect;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2Condition_UnitEffects			NotCarryingCondition;

	// Standard setup for an ability granted by an item
	`CREATE_X2ABILITY_TEMPLATE(Template, 'VanishingAct');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ghost"; 
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.bCrossClassEligible = false;
	Template.bIsPassive = false;
	Template.bDisplayInUITacticalText = false;
	Template.bLimitTargetIcons = true;
	Template.bUseLaunchedGrenadeEffects = true;

	// Costs one action point and ends the turn
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

    // Standard active ability actions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	
	// Cannot be used while concealed
	ShooterProperty = new class'X2Condition_UnitProperty';
	ShooterProperty.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterProperty);

	// Lots of coniditions for who the ability can target
	TargetProperty = new class'X2Condition_UnitProperty';
    TargetProperty.ExcludeDead = true;
    TargetProperty.ExcludeHostileToSource = true;
    TargetProperty.ExcludeFriendlyToSource = false;
    TargetProperty.RequireSquadmates = true;
	TargetProperty.ExcludeConcealed = true;
	TargetProperty.ExcludeCivilian = true;
	TargetProperty.ExcludeImpaired = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.IsAdvent = false;
	TargetProperty.ExcludePanicked = true;
	TargetProperty.ExcludeAlien = true;
	TargetProperty.IsBleedingOut = false;
	TargetProperty.IsConcealed = false;
	TargetProperty.ExcludeStunned = true;
	TargetProperty.IsImpaired = false;
    Template.AbilityTargetConditions.AddItem(TargetProperty);
	
	// Cannot target anyone who is carrying someone, burning, or bound
	NotCarryingCondition = new class'X2Condition_UnitEffects';
	NotCarryingCondition.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
	NotCarryingCondition.AddExcludeEffect(class'X2StatusEffects'.default.BurningName, 'AA_UnitIsBurning');
	NotCarryingCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	Template.AbilityTargetConditions.AddItem(NotCarryingCondition);

	// Configurable charges
	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = default.VANISHINGACT_CHARGES;
    Template.AbilityCharges = Charges;
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    // Area of effect radius for the smoke
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.bUseSourceWeaponLocation = false;
	RadiusMultiTarget.fTargetRadius = 2; // meters
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	
	// Applies smoke cloud to the world
	WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
	Template.AddTargetEffect (WeaponEffect);

	// Smoke grenade defense bonus
	SmokeEffect = new class'X2Effect_SmokeGrenade';
	SmokeEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
    SmokeEffect.SetDisplayInfo(1, class'X2Item_DefaultGrenades'.default.SmokeGrenadeEffectDisplayName, class'X2Item_DefaultGrenades'.default.SmokeGrenadeEffectDisplayDesc, "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
    SmokeEffect.HitMod = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_HITMOD;
    SmokeEffect.DuplicateResponse = eDupe_Refresh;
	Template.AddTargetEffect (SmokeEffect);

	// Coneals the primary target
	StealthEffect = new class'X2Effect_RangerStealth';
    StealthEffect.BuildPersistentEffect(1, true, false, false, 8);
    StealthEffect.SetDisplayInfo(1, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
    StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
    Template.AddTargetEffect(StealthEffect);
    Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

    // For the visualization
	Template.TargetingMethod = class'X2TargetingMethod_OvertheShoulder';
    Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";

    // Primary target uses the activate concealment voice line
	Template.TargetHitSpeech = 'ActivateConcealment';

	// More visualization stuff
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}

// Perk name:		Flush
// Perk effect:		Special shot with a bonus to hit that does little or no damage but confers defense and dodge penalties and forces target to change position if it hits.
// Localized text:	"Special shot with a bonus to hit that does little or no damage but confers defense and dodge penalties and forces target to change position if it hits."
// Config:			(AbilityName="LW2WotC_Flush", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate Flush()
{
	local X2AbilityTemplate Template;
	local X2AbilityToHitCalc_StandardAim ToHitCalc;
	local X2Effect_LW2WotC_FallBack FallBackEffect;
	local X2Effect_PersistentStatChange NerfEffect;
	local X2Condition_UnitProperty NotConcealedCondition;

	// Create the template using a helper function
	Template = Attack('LW2WotC_Flush', "img:///UILibrary_LW_PerkPack.LW_AbilityFlush", false, none, class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY - 1, eCost_WeaponConsumeAll, default.FLUSH_AMMO_COST, true);

	// Ammo effects are not applied to Flush
	Template.bAllowAmmoEffects = false;

	// Disallow crits and add an aim bonus
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.FLUSH_AIM_BONUS;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	// Forces the target to seek new cover
	FallBackEffect = new class'X2Effect_LW2WotC_FallBack';
	FallBackEffect.BehaviorTree = 'FlushRoot';
	Template.AddTargetEffect(FallBackEffect);

	// Effect that lowers the target's defense and mobility - stackable
	NerfEffect = new class'X2Effect_PersistentStatChange';
	NerfEffect.BuildPersistentEffect(default.FLUSH_STATEFFECT_DURATION, false, false, true, eGameRule_PlayerTurnBegin);
	NerfEffect.AddPersistentStatChange(eStat_Dodge, -float(default.FLUSH_DODGE_REDUCTION));
	NerfEffect.AddPersistentStatChange(eStat_Defense, -float(default.FLUSH_DEFENSE_REDUCTION));
	NerfEffect.SetDisplayInfo (ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	NerfEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(NerfEffect);

	// Cannot be used while concealed
	NotConcealedCondition = new class'X2Condition_UnitProperty';
	NotConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(NotConcealedCondition);

	// Add a cooldown.
	AddCooldown(Template, default.FLUSH_COOLDOWN);

	// Add a secondary ability to provide bonuses on the shot
	AddSecondaryAbility(Template, FlushBonuses());

	return Template;
}

// This is part of the Flush effect, above
static function X2AbilityTemplate FlushBonuses()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'LW2WotC_Flush_Bonuses';

	// The bonus reduces damage by a percentage
	Effect.AddPercentDamageModifier(-1 * default.FLUSH_DAMAGE_PERCENT_MALUS);

	// The bonus only applies to the Flush ability
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('LW2WotC_Flush');
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Create the template using a helper function
	Template = Passive('LW2WotC_Flush_Bonuses', "img:///UILibrary_LW_PerkPack.LW_AbilityFlush", false, Effect);

	// Flush will show up as an active ability, so hide the icon for the passive damage effect
	HidePerkIcon(Template);

	return Template;
}

// Perk name:		Clutch Shot
// Perk effect:		Once per mission, fire a pistol shot that cannot miss.
// Localized text:	"Once per mission, fire a pistol shot that cannot miss."
// Config:			(AbilityName="LW2WotC_ClutchShot", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate ClutchShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_Visibility			VisibilityCondition;
	local X2Effect_Knockback				KnockbackEffect;

	// Create the template using a helper function
	Template = Attack('LW2WotC_ClutchShot', "img:///UILibrary_LW_PerkPack.LW_AbilityClutchShot", false, none, class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY, eCost_WeaponConsumeAll, 0, true);

	// Squadsight should not apply
	Template.AbilityTargetConditions.Length = 0;
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = false;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Attack always hits
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = true;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	// Knockback effect on kill
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	// Configurable charges
	AddCharges(Template, default.CLUTCH_SHOT_CHARGES);

	return Template;
}

// Perk name:		Gunslinger
// Perk effect:		Take a reaction shot with your pistol against any enemy that moves or attacks within a wide cone of fire. Cooldown-based.
// Localized text:	"Take a reaction shot with your pistol against any enemy that moves or attacks within <Ability:GUNSLINGER_TILES_RANGE> tiles and a wide cone of fire. <Ability:GUNSLINGER_COOLDOWN> turn cooldown."
// Config:			(AbilityName="LW2WotC_Gunslinger", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Gunslinger()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2Effect_ReserveActionPoints		ReservePointsEffect;
	local X2Effect_MarkValidActivationTiles MarkTilesEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_Gunslinger');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityGunslinger";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Defensive;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
	Template.bSkipFireAction = true;
    Template.bShowActivation = true;
	Template.ActivationSpeech = 'KillZone';
	Template.bCrossClassEligible = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;   
	ActionPointCost.bFreeCost = true;    
	Template.AbilityCosts.AddItem(ActionPointCost);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.GUNSLINGER_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = 48 * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.GUNSLINGER_TILES_RANGE * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
	ReservePointsEffect.ReserveType = class'X2Ability_SharpshooterAbilitySet'.default.KillZoneReserveType;
	Template.AddShooterEffect(ReservePointsEffect);

	MarkTilesEffect = new class'X2Effect_MarkValidActivationTiles';
	MarkTilesEffect.AbilityToMark = 'GunslingerShot';
	Template.AddShooterEffect(MarkTilesEffect);

	Template.AdditionalAbilities.AddItem('GunslingerShot');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// The shot fired when a target moves in the Gunslinger area of effect
static function X2AbilityTemplate GunslingerShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_AbilityProperty       AbilityCondition;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_Event	        Trigger;
	local X2Effect_Persistent               GunslingerEffect;
	local X2Condition_UnitEffectsWithAbilitySource  GunslingerCondition;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2Condition_UnitProperty          ShooterCondition;
	// local X2Condition_RequiredToHitChance	RequiredHitChanceCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GunslingerShot');	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	// RequiredHitChanceCondition = new class'X2Condition_RequiredToHitChance';
	// RequiredHitChanceCondition.MinimumRequiredHitChance = class'X2Ability_PerkPackAbilitySet2'.default.REQUIRED_TO_HIT_FOR_OVERWATCH;  
	// Template.AbilityTargetConditions.AddItem(RequiredHitChanceCondition);

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.bFreeCost = true;
	ReserveActionPointCost.AllowedTypes.AddItem('KillZone');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = false;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.TargetMustBeInValidTiles = true;
	Template.AbilityTargetConditions.AddItem(AbilityCondition);

	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	GunslingerCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	GunslingerCondition.AddExcludeEffect('GunslingerTarget', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(GunslingerCondition);

	GunslingerEffect = new class'X2Effect_Persistent';
	GunslingerEffect.EffectName = 'GunslingerTarget';
	GunslingerEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	GunslingerEffect.SetupEffectOnShotContextResult(true, true);      //  mark them regardless of whether the shot hit or missed
	Template.AddTargetEffect(GunslingerEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// Perk name:		Steady Weapon
// Perk effect:		Gain bonus aim on your next shot with your primary weapon. Multiple uses will stack bonus. Bonus is lost if you use actions or are wounded.
// Localized text:	"Gain +<Ability:STEADY_WEAPON_AIM_BONUS> aim on your next shot with your primary weapon. Multiple uses will stack bonus. Bonus is lost if you use actions or are wounded."
// Config:			(AbilityName="LW2WotC_SteadyWeapon", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate SteadyWeapon()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_LW2WotC_SteadyWeapon		ToHitModifier;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_SteadyWeapon');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySteadyWeapon";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bSkipFireAction=true;
	Template.bShowActivation=true;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
	Template.bCrossClassEligible = false;
	//Template.DefaultKeyBinding = 539;
	//Template.bNoConfirmationWithHotKey = true;
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;    
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.AddShooterEffectExclusions();
	Template.CinescriptCameraType = "Overwatch";
	ToHitModifier = new class'X2Effect_LW2WotC_SteadyWeapon';
	ToHitModifier.BuildPersistentEffect(2, false, true, false, eGameRule_UseActionPoint);
	ToHitModifier.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ToHitModifier.Aim_Bonus = default.STEADY_WEAPON_AIM_BONUS;
	ToHitModifier.DuplicateResponse=eDupe_Refresh;
	Template.AddTargetEffect(ToHitModifier);	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// Perk name:		Mind Merge
// Perk effect:		Grants bonus will, critical chance and ablative hit points to an ally until the beginning of the player's next turn.
// Localized text:	"Grants bonus will, critical chance and ablative hit points to an ally until the beginning of the player's next turn."
// Config:			(AbilityName="LW2WotC_MindMerge", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate MindMerge()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown_LW2WotC_MindMerge	Cooldown;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty		TargetCondition;
	local X2Effect_LW2WotC_MindMerge			MindMergeEffect;	
	local X2Condition_UnitEffects		MMCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_MindMerge');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityMindMerge";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = 320;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;

	TargetCondition = new class'X2Condition_UnitProperty';
    TargetCondition.ExcludeHostileToSource = true;
    TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.TreatMindControlledSquadmateAsHostile = true;
    TargetCondition.RequireSquadmates = true;
    TargetCondition.FailOnNonUnits = true;
    TargetCondition.ExcludeDead = true;
    TargetCondition.ExcludeRobotic = true;
    Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.MIND_MERGE_MIN_ACTION_POINTS;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LW2WotC_MindMerge';
	Cooldown.MIND_MERGE_COOLDOWN = default.MIND_MERGE_COOLDOWN;
	Cooldown.SOUL_MERGE_COOLDOWN_REDUCTION = default.SOUL_MERGE_COOLDOWN_REDUCTION;
	Template.AbilityCooldown = Cooldown;

	MMCondition = new class'X2Condition_UnitEffects';
	MMCondition.AddExcludeEffect('MindMergeEffect', 'AA_UnitIsMindMerged');
	Template.AbilityTargetConditions.AddItem(MMCondition);

	MindMergeEffect = new class 'X2Effect_LW2WotC_MindMerge';
	MindMergeEffect.EffectName = 'MindMergeEffect';
	MindMergeEffect.BaseWillIncrease = 0;
	MindMergeEffect.BaseShieldHPIncrease = 1;
	MindMergeEffect.MindMergeWillDivisor = default.MIND_MERGE_WILL_DIVISOR;
	MindMergeEffect.MindMergeShieldHPDivisor = default.MIND_MERGE_SHIELDHP_DIVISOR;
	MindMergeEffect.SoulMergeWillDivisor = default.SOUL_MERGE_WILL_DIVISOR;
	MindMergeEffect.SoulMergeShieldHPDivisor = default.SOUL_MERGE_SHIELDHP_DIVISOR;
	MindMergeEffect.AmpMGWillBonus = default.MIND_MERGE_AMP_MG_WILL_BONUS;
	MindMergeEffect.AmpMGShieldHPBonus = default.MIND_MERGE_AMP_MG_SHIELDHP_BONUS;
	MindMergeEffect.AmpBMWillBonus = default.MIND_MERGE_AMP_BM_WILL_BONUS;
	MindMergeEffect.AmpBMShieldHPBonus = default.MIND_MERGE_AMP_BM_SHIELDHP_BONUS;
	MindMergeEffect.MindMergeCritDivisor= default.MIND_MERGE_CRIT_DIVISOR;
	MindMergeEffect.SoulMergeCritDivisor= default.SOUL_MERGE_CRIT_DIVISOR;
	MindMergeEffect.AmpMGCritBonus= default.MIND_MERGE_AMP_MG_CRIT_BONUS;
	MindMergeEffect.AMpBMCritBonus= default.SOUL_MERGE_AMP_BM_CRIT_BONUS;

	MindMergeEffect.bRemoveWhenTargetDies=true;
	MindMergeEffect.BuildPersistentEffect (default.MIND_MERGE_DURATION, false, true, true, eGameRule_PlayerTurnBegin);
	MindMergeEFfect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect (MindMergeEffect);

	Template.AssociatedPassives.AddItem('LW2WotC_SoulMerge');

	Template.ActivationSpeech = 'PsionicsInspiration';
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.CustomFireAnim = 'HL_Psi_ProjectileMerge';
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

// Perk name:		Soul Merge
// Perk effect:		Increases effectiveness of Mind Merge by conferring larger bonuses to critical chance, will and ablative hit points, and reducing its cooldown period.
// Localized text:	"Increases effectiveness of Mind Merge by conferring larger bonuses to critical chance, will and ablative hit points, and reducing its cooldown period."
// Config:			(AbilityName="LW2WotC_SoulMerge", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate SoulMerge()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('LW2WotC_SoulMerge', "img:///UILibrary_LW_PerkPack.LW_AbilitySoulMerge", false, 'eAbilitySource_Psionic');
	Template.PrerequisiteAbilities.AddItem('LW2WotC_MindMerge');

	return Template;
}
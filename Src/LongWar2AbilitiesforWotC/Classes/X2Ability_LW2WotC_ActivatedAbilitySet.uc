//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW2WotC_ActivatedAbilitySet
//  PURPOSE: Defines ability templates for activated abilities
//--------------------------------------------------------------------------------------- 

class X2Ability_LW2WotC_ActivatedAbilitySet extends XMBAbility config (LW_SoldierSkills);

var config int DOUBLE_TAP_1ST_SHOT_AIM;
var config int DOUBLE_TAP_2ND_SHOT_AIM;
var config int DOUBLE_TAP_COOLDOWN;
var config int DOUBLE_TAP_MIN_ACTION_REQ;
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
var config int STREET_SWEEPER_AMMO_COST;
var config int STREET_SWEEPER_COOLDOWN;
var config int STREET_SWEEPER_TILE_WIDTH;
var config int STREET_SWEEPER_MIN_ACTION_REQ;
var config float STREET_SWEEPER_CONE_LENGTH;
var config int SLUG_SHOT_COOLDOWN;
var config int SLUG_SHOT_AMMO_COST;
var config int SLUG_SHOT_MIN_ACTION_REQ;
var config int SLUG_SHOT_PIERCE;
var config int CLUTCH_SHOT_MIN_ACTION_REQ;
var config int CLUTCH_SHOT_AMMO_COST;
var config int CLUTCH_SHOT_CHARGES;
var config int GUNSLINGER_COOLDOWN;
var config int GUNSLINGER_TILES_RANGE;
var config int STEADY_WEAPON_AIM_BONUS;
var config int AREA_SUPPRESSION_AMMO_COST;
var config int AREA_SUPPRESSION_MAX_SHOTS;
var config int AREA_SUPPRESSION_SHOT_AMMO_COST;
var config float AREA_SUPPRESSION_RADIUS;
var config int SUPPRESSION_LW_SHOT_AIM_BONUS;
var config int AREA_SUPPRESSION_LW_SHOT_AIM_BONUS;
var config array<name> SUPPRESSION_LW_INVALID_WEAPON_CATEGORIES;
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
var config int ABSORPTION_FIELDS_COOLDOWN;
var config int ABSORPTION_FIELDS_ACTION_POINTS;
var config int ABSORPTION_FIELDS_DURATION;
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
var config int STREET_SWEEPER2_MIN_ACTION_REQ;
var config int STREET_SWEEPER2_AMMO_COST;
var config int STREET_SWEEPER2_COOLDOWN;
var config int STREET_SWEEPER2_CONE_LENGTH;
var config int STREET_SWEEPER2_TILE_WIDTH;
var config float STREET_SWEEPER2_UNARMORED_DAMAGE_MULTIPLIER;
var config int STREET_SWEEPER2_UNARMORED_DAMAGE_BONUS;
var config int NUM_AIRDROP_CHARGES;
var config int RAPID_DEPLOYMENT_COOLDOWN;
var config float FLECHE_BONUS_DAMAGE_PER_TILES;
var config bool NO_MELEE_ATTACKS_WHEN_ON_FIRE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//Templates.AddItem(AddDoubleTapAbility());
	//Templates.AddItem(DoubleTap2ndShot()); //Additional Ability
	Templates.AddItem(WalkFire());
	Templates.AddItem(PrecisionShot());
	//Templates.AddItem(AddCyclicFireAbility());
	//Templates.AddItem(AddTrenchGunAbility());
	Templates.AddItem(SlugShot());
	//Templates.AddItem(AddClutchShotAbility());
	//Templates.AddItem(AddCommissarAbility());
	//Templates.AddItem(AddGunslingerAbility());
	//Templates.AddItem(GunslingerShot()); //Additional Ability
	//Templates.AddItem(AddSteadyWeaponAbility());
	//Templates.AddItem(AddRunAndGun_LWAbility());
	//Templates.AddItem(AddSuppressionAbility_LW());
	//Templates.AddItem(SuppressionShot_LW()); //Additional Ability
	//Templates.AddItem(AddAreaSuppressionAbility());
	//Templates.AddItem(AreaSuppressionShot_LW()); //Additional Ability
	//Templates.AddItem(AddInterferenceAbility());
	//Templates.AddItem(AddGhostwalkerAbility()); 
	//Templates.AddItem(AddKubikuriAbility());
	//Templates.AddItem(KubikiriDamage());
	//Templates.AddItem(AddIronCurtainAbility());
	//Templates.AddItem(IronCurtainShot()); //Additional Ability
	//Templates.AddItem(AddSlash_LWAbility());
	//Templates.AddItem(AddAbsorptionFieldsAbility());
	//Templates.AddItem(AddBodyShieldAbility());
	//Templates.AddItem(AddMindMergeAbility());
	//Templates.AddItem(AddSoulMergeAbility());
	//Templates.AddItem(AddSnapShot());
	//Templates.AddItem(SnapShotOverwatch());
	//Templates.AddItem(AddSnapShotAimModifierAbility());
	Templates.AddItem(RapidDeployment());
	//Templates.AddItem(AddAirdrop());
	//Templates.AddItem(AddSwordSlice_LWAbility());
	//Templates.AddItem(AddFleche());
	Templates.AddItem(Fleche());
	Templates.AddItem(Slash());
	//Templates.AddItem(AddStreetSweeperAbility());
	//Templates.AddItem(AddStreetSweeperBonusDamageAbility());

	return Templates;
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
	Template = Attack('LW2WotC_WalkFire', "img:///UILibrary_LW_PerkPack.LW_Ability_WalkingFire", true, none, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, eCost_WeaponConsumeAll, default.WALK_FIRE_AMMO_COST);

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
	Template = Attack('LW2WotC_PrecisionShot', "img:///UILibrary_LW_PerkPack.LW_AbilityPrecisionShot", true, none, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, eCost_WeaponConsumeAll, default.PRECISION_SHOT_AMMO_COST);

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
	Template = Attack('LW2WotC_SlugShot', "img:///UILibrary_LW_PerkPack.LW_AbilitySlugShot", false, none, class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY, eCost_WeaponConsumeAll, default.SLUG_SHOT_AMMO_COST);

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

	return Template;
}

// Perk name:		Fleche
// Perk effect:		"Attack any enemy within movement range with your sword. Deals bonus damage depending on how far you move for the attack."
// Localized text:	"Attack any enemy within movement range with your sword. Deals +1 damage for every <Ability:FLECHE_BONUS_DAMAGE_PER_TILES/> tiles between your starting position and the target."
// Config:			(AbilityName="LW2WotC_Fleche", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Fleche()
{
	local X2AbilityTemplate                 Template;

	// Fleche is just a copy of the vanilla Ranger's Slash ability, but with a bonus damage effect
	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('LW2WotC_Fleche');
	AddSecondaryAbility(Template, FlecheBonuses());

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

	// Some WotC specific stuff
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}


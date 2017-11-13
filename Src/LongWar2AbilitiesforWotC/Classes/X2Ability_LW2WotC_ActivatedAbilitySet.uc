//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW2WotC_ActivatedAbilitySet
//  PURPOSE: Defines ability templates for activated abilities
//--------------------------------------------------------------------------------------- 

class X2Ability_LW2WotC_ActivatedAbilitySet extends X2Ability config (LW_SoldierSkills);

var config int DOUBLE_TAP_1ST_SHOT_AIM;
var config int DOUBLE_TAP_2ND_SHOT_AIM;
var config int DOUBLE_TAP_COOLDOWN;
var config int DOUBLE_TAP_MIN_ACTION_REQ;
var config int WALK_FIRE_AIM_BONUS;
var config int WALK_FIRE_CRIT_MALUS;
var config int WALK_FIRE_COOLDOWN;
var config int WALK_FIRE_AMMO_COST;
var config int WALK_FIRE_MIN_ACTION_REQ;
var config int PRECISION_SHOT_COOLDOWN;
var config int PRECISION_SHOT_AMMO_COST;
var config int PRECISION_SHOT_CRIT_BONUS;
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

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//Templates.AddItem(AddDoubleTapAbility());
	//Templates.AddItem(DoubleTap2ndShot()); //Additional Ability
	//Templates.AddItem(AddWalkFireAbility());
	//Templates.AddItem(WalkFireDamage()); //Additional Ability
	//Templates.AddItem(AddPrecisionShotAbility());
	//Templates.AddItem(PrecisionShotCritDamage()); //Additional Ability
	//Templates.AddItem(AddCyclicFireAbility());
	//Templates.AddItem(AddStreetSweeperAbility());
	//Templates.AddItem(AddSlugShotAbility());
	//Templates.AddItem(SlugShotRangeEffect()); //Additional Ability
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

	return Templates;
}
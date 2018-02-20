//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_LongWar2AbilitiesforWotC.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LongWar2AbilitiesforWotC extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	PatchAbilitiesForLightEmUp();
	PatchSmokeGrenades();
	PatchFlashbang();
	PatchBaseGameThrowGrenadeForLW2WotC_VolatileMix();
	PatchAbilitiesForDoubleTapActionPoint();

	if(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.SNAPSHOT_REDUCES_AP_COST_FOR_SPECIAL_SHOTS)
	{
		PatchAbilitiesForSnapshot();
	}

	`REDSCREEN("Long War 2 Abilities For WotC : Version 0.0.7");
}

/// <summary>
/// Patches the standard shot ability so that it won't end a soldier's turn if they have Light 'Em Up
/// </summary>
private static function PatchAbilitiesForLightEmUp()
{
    local X2AbilityTemplateManager TemplateManager;
	local X2AbilityTemplate AbilityTemplate;
    local X2AbilityCost_ActionPoints ActionPointCost;
    local int i;

    TemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
    AbilityTemplate = TemplateManager.FindAbilityTemplate('StandardShot');
    if (AbilityTemplate != none)
    {
        for (i = 0; i < AbilityTemplate.AbilityCosts.Length; i++)
	    {
		    ActionPointCost = X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[i]);
		    if (ActionPointCost != none)
		    {
                ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('LW2WotC_LightEmUp');
			    break;
		    }
	    }
    }
}

/// <summary>
/// Patches the Smoke Grenade and Smoke Bomb so that they function with Dense Smoke
/// </summary>
private static function PatchSmokeGrenades()
{
    PatchSmokeGrenade('SmokeGrenade');
	PatchSmokeGrenade('SmokeGrenadeMk2');
}

private static function PatchSmokeGrenade(name ItemName)
{
	local X2ItemTemplateManager		ItemManager;
	local array<X2DataTemplate>		TemplateAllDifficulties;
	local X2DataTemplate			Template;
	local X2GrenadeTemplate			GrenadeTemplate;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemManager.FindDataTemplateAllDifficulties(ItemName, TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		GrenadeTemplate = X2GrenadeTemplate(Template);
		GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2Ability_LW2WotC_PassiveAbilitySet'.static.DenseSmokeEffect());
		GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2Ability_LW2WotC_PassiveAbilitySet'.static.DenseSmokeEffect());
	}
}

/// <summary>
/// Patches the Flashbang so that they function with Sting Grenades and Bluescreen Bombs.
/// Also prevents them from dealing damage with Boosted Cores / Volatile Mix
/// </summary>
private static function PatchFlashbang()
{
    local X2ItemTemplateManager		ItemManager;
	local array<X2DataTemplate>		TemplateAllDifficulties;
	local X2DataTemplate			Template;
	local X2GrenadeTemplate			GrenadeTemplate;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemManager.FindDataTemplateAllDifficulties('FlashbangGrenade', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		GrenadeTemplate = X2GrenadeTemplate(Template);

		GrenadeTemplate.bAllowVolatileMix = false;

		GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2Ability_LW2WotC_PassiveAbilitySet'.static.StingGrenadesEffect());
		GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2Ability_LW2WotC_PassiveAbilitySet'.static.StingGrenadesEffect());

		GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2Ability_LW2WotC_PassiveAbilitySet'.static.BluescreenBombsDisorientEffect());
		GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2Ability_LW2WotC_PassiveAbilitySet'.static.BluescreenBombsDisorientEffect());

		GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2Ability_LW2WotC_PassiveAbilitySet'.static.BluescreenBombsHackReductionEffect());
		GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2Ability_LW2WotC_PassiveAbilitySet'.static.BluescreenBombsHackReductionEffect());
	}
}

/// <summary>
/// Updates grenade abilities to get radius bonus from our new Volatile Mix ability
/// </summary>
static function PatchBaseGameThrowGrenadeForLW2WotC_VolatileMix()
{
	local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate					ThrowGrenadeAbilityTemplate, LaunchGrenadeAbilityTemplate, ProximityMineAbilityTemplate;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	ThrowGrenadeAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('ThrowGrenade');
	LaunchGrenadeAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('LaunchGrenade');
	ProximityMineAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('ProximityMineDetonation');

	X2AbilityMultiTarget_Radius(ThrowGrenadeAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('LW2WotC_VolatileMix', 1.0);
	X2AbilityMultiTarget_Radius(LaunchGrenadeAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('LW2WotC_VolatileMix', 1.0);
	X2AbilityMultiTarget_Radius(ProximityMineAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('LW2WotC_VolatileMix', 1.0);
}

/// <summary>
/// Updates various abilities so that they can be used with the action point granted by Double Tap
/// </summary>
static function PatchAbilitiesForDoubleTapActionPoint()
{
	local X2AbilityTemplateManager			AbilityTemplateManager;
	local name 								AbilityName;
	local X2AbilityTemplate					AbilityTemplate;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	foreach class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.DOUBLE_TAP_ABILITIES(AbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);

		if(AbilityTemplate != none)
		{
			AddDoubleTapActionPoint(AbilityTemplate);
		}
	}
}

static function AddDoubleTapActionPoint(X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2AbilityCost                     Cost;

	foreach Template.AbilityCosts(Cost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(Cost);
        if (ActionPointCost != none)
        {
			ActionPointCost.AllowedTypes.AddItem(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.DOUBLE_TAP_ACTION_POINT_NAME);
		}
	}
}

/// <summary>
/// Updates special sniper shots so that they only cost one AP if the user has snapshot.
/// </summary>
static function PatchAbilitiesForSnapshot()
{
	local X2AbilityTemplateManager			AbilityTemplateManager;
	local name 								AbilityName;
	local X2AbilityTemplate					AbilityTemplate;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local int 								i;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	foreach class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.SNAPSHOT_REDUCED_AP_COST_SPECIAL_SHOTS(AbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);

		if(AbilityTemplate != none)
		{
			for (i = 0; i < AbilityTemplate.AbilityCosts.length; i++)
			{
				ActionPointCost = X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[i]);
				if (ActionPointCost != none)
				{
					AbilityTemplate.AbilityCosts[i] = class'X2Ability_LW2WotC_ActivatedAbilitySet'.static.SnapShotReducedAbilityCost();
				}
			}
		}
	}
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;
	local UITacticalHUD TacticalHUD;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local int NumTiles;

	Type = name(InString);
	switch(Type)
	{
		case 'CENTERMASS_DAMAGE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.CENTERMASS_DAMAGE);
			return true;
		case 'LETHAL_DAMAGE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.LETHAL_DAMAGE);
			return true;
		case 'HNR_USES_PER_TURN':
			OutString = getNumRefundsString(class'X2Effect_LW2WotC_HitandRun'.default.HNR_USES_PER_TURN);
			return true;
		case 'CCS_RANGE':
			OutString = getStringBasedOnValue(class'X2AbilityTarget_LW2WotC_Single_CCS'.default.CCS_RANGE, "tile", "tiles");
			return true;
		case 'CCS_AMMO_PER_SHOT':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.CCS_AMMO_PER_SHOT);
			return true;
		case 'DGG_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_DamnGoodGround'.default.DGG_AIM_BONUS);
			return true;
		case 'DGG_DEF_BONUS':
			OutString = string(class'X2Effect_LW2WotC_DamnGoodGround'.default.DGG_DEF_BONUS);
			return true;
		case 'EXECUTIONER_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_Executioner'.default.EXECUTIONER_AIM_BONUS);
			return true;
		case 'EXECUTIONER_CRIT_BONUS':
			OutString = string(class'X2Effect_LW2WotC_Executioner'.default.EXECUTIONER_CRIT_BONUS);
			return true;
		case 'RESILIENCE_CRITDEF_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.RESILIENCE_CRITDEF_BONUS);
			return true;
		case 'TACTICAL_SENSE_DEF_BONUS_PER_ENEMY':
			OutString = string(class'X2Effect_LW2WotC_TacticalSense'.default.TACTICAL_SENSE_DEF_BONUS_PER_ENEMY);
			return true;
		case 'TACTICAL_SENSE_MAX_DEF_BONUS':
			OutString = string(class'X2Effect_LW2WotC_TacticalSense'.default.TACTICAL_SENSE_MAX_DEF_BONUS);
			return true;
		case 'TS_SQUADSIGHT_ENEMIES_APPLY':
			OutString = getSquadsightString(class'X2Effect_LW2WotC_TacticalSense'.default.TS_SQUADSIGHT_ENEMIES_APPLY);
			return true;
		case 'AGGRESSION_CRIT_BONUS_PER_ENEMY':
			OutString = string(class'X2Effect_LW2WotC_Aggression'.default.AGGRESSION_CRIT_BONUS_PER_ENEMY);
			return true;
		case 'AGGRESSION_MAX_CRIT_BONUS':
			OutString = string(class'X2Effect_LW2WotC_Aggression'.default.AGGRESSION_MAX_CRIT_BONUS);
			return true;
		case 'AGG_SQUADSIGHT_ENEMIES_APPLY':
			OutString = getSquadsightString(class'X2Effect_LW2WotC_Aggression'.default.AGG_SQUADSIGHT_ENEMIES_APPLY);
			return true;
		case 'BEO_BONUS_CRIT_DAMAGE_PER_ENEMY':
			OutString = string(clamp(class'X2Effect_LW2WotC_BringEmOn'.default.BEO_BONUS_CRIT_DAMAGE_PER_ENEMY * 2, 0, class'X2Effect_LW2WotC_BringEmOn'.default.BEO_MAX_BONUS_CRIT_DAMAGE));
			return true;
		case 'BEO_MAX_BONUS_CRIT_DAMAGE':
			OutString = string(class'X2Effect_LW2WotC_BringEmOn'.default.BEO_MAX_BONUS_CRIT_DAMAGE);
			return true;
		case 'BEO_SQUADSIGHT_ENEMIES_APPLY':
			OutString = getSquadsightString(class'X2Effect_LW2WotC_BringEmOn'.default.BEO_SQUADSIGHT_ENEMIES_APPLY);
			return true;
		case 'HT_DODGE_BONUS_PER_ENEMY':
			OutString = string(class'X2Effect_LW2WotC_HardTarget'.default.HT_DODGE_BONUS_PER_ENEMY);
			return true;
		case 'HT_MAX_DODGE_BONUS':
			OutString = string(class'X2Effect_LW2WotC_HardTarget'.default.HT_MAX_DODGE_BONUS);
			return true;
		case 'HT_SQUADSIGHT_ENEMIES_APPLY':
			OutString = getSquadsightString(class'X2Effect_LW2WotC_HardTarget'.default.HT_SQUADSIGHT_ENEMIES_APPLY);
			return true;
		case 'INFIGHTER_DODGE_BONUS':
			OutString = string(class'X2Effect_LW2WotC_Infighter'.default.INFIGHTER_DODGE_BONUS);
			return true;
		case 'INFIGHTER_MAX_TILES':
			OutString = getStringBasedOnValue(class'X2Effect_LW2WotC_Infighter'.default.INFIGHTER_MAX_TILES, "tile", "tiles");
			return true;
		case 'DP_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_DepthPerception'.default.DP_AIM_BONUS);
			return true;
		case 'DP_ANTIDODGE_BONUS':
			OutString = string(class'X2Effect_LW2WotC_DepthPerception'.default.DP_ANTIDODGE_BONUS);
			return true;
		case 'WILLTOSURVIVE_WILLBONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.WILLTOSURVIVE_WILLBONUS);
			return true;
		case 'W2S_HIGH_COVER_ARMOR_BONUS':
			OutString = string(class'X2Effect_LW2WotC_WilltoSurvive'.default.W2S_HIGH_COVER_ARMOR_BONUS);
			return true;
		case 'W2S_LOW_COVER_ARMOR_BONUS':
			OutString = string(class'X2Effect_LW2WotC_WilltoSurvive'.default.W2S_LOW_COVER_ARMOR_BONUS);
			return true;
		case 'CE_MAX_TILES':
			OutString = getStringBasedOnValue(class'X2Effect_LW2WotC_CloseEncounters'.default.CE_MAX_TILES, "tile", "tiles");
			return true;
		case 'CE_USES_PER_TURN':
			OutString = getNumRefundsString(class'X2Effect_LW2WotC_CloseEncounters'.default.CE_USES_PER_TURN);
			return true;
		case 'LONEWOLF_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_LoneWolf'.default.LONEWOLF_AIM_BONUS);
			return true;
		case 'LONEWOLF_DEF_BONUS':
			OutString = string(class'X2Effect_LW2WotC_LoneWolf'.default.LONEWOLF_DEF_BONUS);
			return true;
		case 'LONEWOLF_MIN_DIST_TILES':
			OutString = string(class'X2Effect_LW2WotC_LoneWolf'.default.LONEWOLF_MIN_DIST_TILES);
			return true;
		case 'LONEWOLF_CRIT_BONUS':
			OutString = string(class'X2Effect_LW2WotC_LoneWolf'.default.LONEWOLF_CRIT_BONUS);
			return true;
		case 'HYPERREACTIVE_PUPILS_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_HyperReactivePupils'.default.HYPERREACTIVE_PUPILS_AIM_BONUS);
			return true;
		case 'LOCKEDON_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_LockedOn'.default.LOCKEDON_AIM_BONUS);
			return true;
		case 'LOCKEDON_CRIT_BONUS':
			OutString = string(class'X2Effect_LW2WotC_LockedOn'.default.LOCKEDON_CRIT_BONUS);
			return true;
		case 'SENTINEL_LW_USES_PER_TURN':
			OutString = string(class'X2Effect_LW2WotC_Sentinel'.default.SENTINEL_LW_USES_PER_TURN + 1);
			return true;
		case 'RAPID_REACTION_USES_PER_TURN':
			OutString = string(class'X2Effect_LW2WotC_RapidReaction'.default.RAPID_REACTION_USES_PER_TURN + 1);
			return true;
		case 'CUTTHROAT_BONUS_CRIT_CHANCE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.CUTTHROAT_BONUS_CRIT_CHANCE);
			return true;
		case 'CUTTHROAT_BONUS_CRIT_DAMAGE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.CUTTHROAT_BONUS_CRIT_DAMAGE);
			return true;
		case 'WALK_FIRE_AIM_BONUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.WALK_FIRE_AIM_BONUS);
			return true;
		case 'WALK_FIRE_CRIT_MALUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.WALK_FIRE_CRIT_MALUS);
			return true;
		case 'WALK_FIRE_AMMO_COST':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.WALK_FIRE_AMMO_COST);
			return true;
		case 'WALK_FIRE_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.WALK_FIRE_COOLDOWN);
			return true;
		case 'WALK_FIRE_DAMAGE_PERCENT_MALUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.WALK_FIRE_DAMAGE_PERCENT_MALUS);
			return true;
		case 'PRECISION_SHOT_AMMO_COST':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.PRECISION_SHOT_AMMO_COST);
			return true;
		case 'PRECISION_SHOT_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.PRECISION_SHOT_COOLDOWN);
			return true;
		case 'PRECISION_SHOT_CRIT_BONUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.PRECISION_SHOT_CRIT_BONUS);
			return true;
		case 'PRECISION_SHOT_CRIT_DAMAGE_PERCENT_BONUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.PRECISION_SHOT_CRIT_DAMAGE_PERCENT_BONUS);
			return true;
		case 'COVERT_DETECTION_RANGE_REDUCTION':
			OutString = string(int(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COVERT_DETECTION_RANGE_REDUCTION * 100));
			return true;
		case 'SLUG_SHOT_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.SLUG_SHOT_COOLDOWN);
			return true;
		case 'SLUG_SHOT_PIERCE':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.SLUG_SHOT_PIERCE);
			return true;
		case 'DAMAGE_CONTROL_DURATION':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.DAMAGE_CONTROL_DURATION);
			return true;
		case 'DAMAGE_CONTROL_BONUS_ARMOR':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.DAMAGE_CONTROL_BONUS_ARMOR);
			return true;
		case 'RAPID_DEPLOYMENT_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.RAPID_DEPLOYMENT_COOLDOWN);
			return true;
		case 'FLECHE_BONUS_DAMAGE_PER_TILES':
			OutString = getFlechePerTileDamageBonusString(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.FLECHE_BONUS_DAMAGE_PER_TILES);
			return true;
		case 'TRENCH_GUN_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.TRENCH_GUN_COOLDOWN);
			return true;
		case 'FORTIFY_DEFENSE':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.FORTIFY_DEFENSE);
			return true;
		case 'FORTIFY_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.FORTIFY_COOLDOWN);
			return true;
		case 'FORMIDABLE_ABLATIVE_HP':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.FORMIDABLE_ABLATIVE_HP);
			return true;
		case 'STREET_SWEEPER_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.STREET_SWEEPER_COOLDOWN);
			return true;
		case 'STREET_SWEEPER_UNARMORED_DAMAGE_BONUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.STREET_SWEEPER_UNARMORED_DAMAGE_BONUS);
			return true;
		case 'RUN_AND_GUN_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.RUN_AND_GUN_COOLDOWN);
			return true;
		case 'EXTRA_CONDITIONING_COOLDOWN_REDUCTION':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.EXTRA_CONDITIONING_COOLDOWN_REDUCTION);
			return true;
		case 'KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT':
			OutString = string(int(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT));
			return true;
		case 'DENSE_SMOKE_INVERSE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.DENSE_SMOKE_HITMOD * -1);
			return true;
		case 'DENSE_SMOKE_TOTAL':
			OutString = string(getInversedValue(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.DENSE_SMOKE_HITMOD) + getInversedValue(class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_HITMOD));
			return true;
		case 'GRAZING_FIRE_SUCCESS_CHANCE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.GRAZING_FIRE_SUCCESS_CHANCE);
			return true;
		case 'COMBAT_FITNESS_HP':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_FITNESS_HP);
			return true;
		case 'COMBAT_FITNESS_OFFENSE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_FITNESS_OFFENSE);
			return true;
		case 'COMBAT_FITNESS_MOBILITY':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_FITNESS_MOBILITY);
			return true;
		case 'COMBAT_FITNESS_DODGE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_FITNESS_DODGE);
			return true;
		case 'COMBAT_FITNESS_WILL':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_FITNESS_WILL);
			return true;
		case 'SPRINTER_MOBILITY':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.SPRINTER_MOBILITY);
			return true;
		case 'ALPHAMIKEFOXTROT_DAMAGE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.ALPHAMIKEFOXTROT_DAMAGE);
			return true;
		case 'COUP_DE_GRACE_HIT_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COUP_DE_GRACE_HIT_BONUS);
			return true;
		case 'COUP_DE_GRACE_CRIT_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COUP_DE_GRACE_CRIT_BONUS);
			return true;
		case 'COUP_DE_GRACE_DAMAGE_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COUP_DE_GRACE_DAMAGE_BONUS);
			return true;
		case 'INTERFERENCE_CV_CHARGES':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.INTERFERENCE_CV_CHARGES);
			return true;
		case 'INTERFERENCE_ACTION_POINTS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.INTERFERENCE_ACTION_POINTS);
			return true;
		case 'BOOSTED_CORES_DAMAGE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.BOOSTED_CORES_DAMAGE);
			return true;
		case 'NUM_AIRDROP_CHARGES':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.NUM_AIRDROP_CHARGES);
			return true;
		case 'ALPHAMIKEFOXTROT_DAMAGE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.ALPHAMIKEFOXTROT_DAMAGE);
			return true;
		case 'CYCLIC_FIRE_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.CYCLIC_FIRE_COOLDOWN);
			return true;
		case 'CYCLIC_FIRE_AIM_MALUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.CYCLIC_FIRE_AIM_MALUS);
			return true;
		case 'CYCLIC_FIRE_MIN_ACTION_REQ':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.CYCLIC_FIRE_MIN_ACTION_REQ);
			return true;
		case 'CYCLIC_FIRE_SHOTS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.CYCLIC_FIRE_SHOTS);
			return true;
		case 'KUBIKURI_MIN_ACTION_REQ':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.KUBIKURI_MIN_ACTION_REQ);
			return true;
		case 'KUBIKURI_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.KUBIKURI_COOLDOWN);
			return true;
		case 'IRON_SKIN_MELEE_DAMAGE_REDUCTION':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.IRON_SKIN_MELEE_DAMAGE_REDUCTION);
			return true;
		case 'COMBAT_AWARENESS_BONUS_ARMOR':
			OutString = string(class'X2Effect_LW2WotC_CombatAwareness'.default.COMBAT_AWARENESS_BONUS_ARMOR);
			return true;
		case 'COMBAT_AWARENESS_BONUS_DEFENSE':
			OutString = string(class'X2Effect_LW2WotC_CombatAwareness'.default.COMBAT_AWARENESS_BONUS_DEFENSE);
			return true;
		case 'COMBAT_RUSH_AIM_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_RUSH_AIM_BONUS);
			return true;
		case 'COMBAT_RUSH_CRIT_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_RUSH_CRIT_BONUS);
			return true;
		case 'COMBAT_RUSH_MOBILITY_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_RUSH_MOBILITY_BONUS);
			return true;
		case 'COMBAT_RUSH_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMBAT_RUSH_COOLDOWN);
			return true;
		case 'FULL_KIT_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.FULL_KIT_BONUS);
			return true;
		case 'GHOSTWALKER_DURATION':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.GHOSTWALKER_DURATION);
			return true;
		case 'GHOSTWALKER_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.GHOSTWALKER_COOLDOWN);
			return true;
		case 'SAVIOR_BONUS_HEAL_AMMOUNT':
			OutString = string(class'X2Effect_LW2WotC_Savior'.default.SAVIOR_BONUS_HEAL_AMMOUNT);
			return true;
		case 'HEAVY_ORDNANCE_BONUS_CHARGES':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.HEAVY_ORDNANCE_BONUS_CHARGES);
			return true;
		case 'PROTECTOR_BONUS_CHARGES':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.PROTECTOR_BONUS_CHARGES);
			return true;
		case 'HEAT_WARHEADS_PIERCE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.HEAT_WARHEADS_PIERCE);
			return true;
		case 'HEAT_WARHEADS_SHRED':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.HEAT_WARHEADS_SHRED);
			return true;
		case 'MAYHEM_DAMAGE_BONUS_PCT':
			OutString = string(int(class'X2Effect_LW2WotC_Mayhem'.default.MAYHEM_DAMAGE_BONUS_PCT));
			return true;
		case 'LOCKDOWN_TOHIT_BONUS':
			OutString = getLockdownAimBonusString(class'X2Effect_LW2WotC_Lockdown'.default.LOCKDOWN_TOHIT_BONUS);
			return true;
		case 'IRON_CURTAIN_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.IRON_CURTAIN_COOLDOWN);
			return true;
		case 'IRON_CURTAIN_MOB_DAMAGE_DURATION':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.IRON_CURTAIN_MOB_DAMAGE_DURATION);
			return true;
		case 'IRON_CURTAIN_MOBILITY_DAMAGE':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.IRON_CURTAIN_MOBILITY_DAMAGE);
			return true;
		case 'IRON_CURTAIN_DAMAGE_MODIFIER':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.IRON_CURTAIN_DAMAGE_MODIFIER);
			return true;
		case 'BODY_SHIELD_DEF_BONUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.BODY_SHIELD_DEF_BONUS);
			return true;
		case 'BODY_SHIELD_ENEMY_CRIT_MALUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.BODY_SHIELD_ENEMY_CRIT_MALUS);
			return true;
		case 'BODY_SHIELD_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.BODY_SHIELD_COOLDOWN);
			return true;
		case 'STING_GRENADE_STUN_CHANCE':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.STING_GRENADE_STUN_CHANCE);
			return true;
		case 'IMPACT_FIELDS_DAMAGE_REDUCTION_PCT':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.IMPACT_FIELDS_DAMAGE_REDUCTION_PCT);
			return true;
		case 'IMPACT_FIELDS_DURATION':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.IMPACT_FIELDS_DURATION);
			return true;
		case 'IMPACT_FIELDS_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.IMPACT_FIELDS_COOLDOWN);
			return true;
		case 'FLUSH_AIM_BONUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.FLUSH_AIM_BONUS);
			return true;
		case 'FLUSH_DODGE_REDUCTION':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.FLUSH_DODGE_REDUCTION);
			return true;
		case 'FLUSH_DEFENSE_REDUCTION':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.FLUSH_DEFENSE_REDUCTION);
			return true;
		case 'FLUSH_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.FLUSH_COOLDOWN);
			return true;
		case 'GUNSLINGER_TILES_RANGE':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.GUNSLINGER_TILES_RANGE);
			return true;
		case 'GUNSLINGER_COOLDOWN':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.GUNSLINGER_COOLDOWN);
			return true;
		case 'COMMISSAR_HIT_BONUS':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.COMMISSAR_HIT_BONUS);
			return true;
		case 'STEADY_WEAPON_AIM_BONUS':
			OutString = string(class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.STEADY_WEAPON_AIM_BONUS);
			return true;
		case 'BOMBARDIER_BONUS_RANGE_TILES':
			OutString = string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.BOMBARDIER_BONUS_RANGE_TILES);
			return true;
		default: 
			return false;
	}
}

private static function string getStringBasedOnValue(int value, string single, string plural)
{
	if(value > 1)
	{
		return string(value) @ plural;
	}

	return string(value) @ single;
}

private static function string getEndTurnString(bool value)
{
	if(value)
	{
		return "Ends the user's turn when used.";
	}

	return "Does not end the user's turn when used as a first action.";
}

private static function string getNumRefundsString(int maxRefunds)
{
	if(maxRefunds == 0)
	{
		return "Can activate an unlimited number of times per turn.";
	}
	else if(maxRefunds == 1)
	{
		return "Can activate 1 time per turn.";
	}
	
	return "Can activate" @ string(maxRefunds) @ "times per turn.";
}

private static function string getOneMinusFloatValueString(float modifier)
{
	local float result;
	local string returnString;

	result = 1 - modifier;
	returnString = string(int(result * 100)) $ "%";

	return returnString;
}

private static function int getInversedValue(int value)
{
	return -1 * value;
}

private static function string getInversedValueString(int value)
{
	return string(-1 * value);
}

private static function string getSquadsightString(bool squadsightValid)
{
    if(squadsightValid)
    {
        return "Units visible at squadsight ranges do confer bonus.";
    }
    else
    {
        return "Units visible at squadsight ranges do not confer bonus.";
    }
}

private static function string getFlechePerTileDamageBonusString(float bonusDamagePerTile)
{
	local float TempFloat;
	local int TempInt;

	TempFloat = 1 / class'X2Ability_LW2WotC_ActivatedAbilitySet'.default.FLECHE_BONUS_DAMAGE_PER_TILES;
	TempFloat = Round(TempFloat * 10.0) / 10.0;
	TempInt = int(TempFloat);
	if ( float(TempInt) ~= TempFloat)
	{
		return string(TempInt);
	}
	else
	{
		return Repl(string(TempFloat), "0", "");
	}
}

private static function string getLockdownAimBonusString(int BaseAimBonus)
{
	local int AfterReactionModAimBonus;

	// multiplies config value by *.70 (reaction fire aim mod) and rounds down
	AfterReactionModAimBonus = int(BaseAimBonus * 0.70f);

	return string(AfterReactionModAimBonus);
}

// Following stuff is for the improved perk tree

exec function PSSetXoffsetBG(int AdjustXOffset)
{
	local NPSBDP_UIArmory_PromotionHero UI;
	
	UI = NPSBDP_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'NPSBDP_UIArmory_PromotionHero'));
	UI.MC.ChildSetNum("bg", "_x", AdjustXOffset);
}

exec function PSSetWidth(int Width)
{
	local NPSBDP_UIArmory_PromotionHero UI;
	
	UI = NPSBDP_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'NPSBDP_UIArmory_PromotionHero'));
	UI.MC.SetNum("_width", Width);
}

exec function PSSetXOffset(int AdjustXOffset)
{
	local NPSBDP_UIArmory_PromotionHero UI;
	
	UI = NPSBDP_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'NPSBDP_UIArmory_PromotionHero'));
	UI.MC.SetNum("_x", UI.MC.GetNum("_x") + AdjustXOffset);
}

exec function PSSetColumnWidth(int Offset = 200, int Width = 120)
{
	local NPSBDP_UIArmory_PromotionHero UI;
	local int i;

	UI = NPSBDP_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'NPSBDP_UIArmory_PromotionHero'));
	for (i = 0; i < UI.Columns.Length; i++)
	{
		if (i == 5 || i ==6)
			UI.Columns[i].MC.SetNum("_width", Width);
		//UI.Columns[i].SetX(Offset + (i * Width));
		
	}
}

exec function PSScrollBarSetPos(int X, int Y, int Anchor = -1)
{
	local NPSBDP_UIArmory_PromotionHero UI;
	UI = NPSBDP_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'NPSBDP_UIArmory_PromotionHero'));

	UI.Scrollbar.SetX(X);
	UI.Scrollbar.SetY(Y);

	if (Anchor > -1)
	{
		UI.Scrollbar.SetAnchor(Anchor);
	}
}

exec function PSScrollBarSetSize(int Width = 0, int Height = 0)
{
	local NPSBDP_UIArmory_PromotionHero UI;
	UI = NPSBDP_UIArmory_PromotionHero(`SCREENSTACK.GetFirstInstanceOf(class'NPSBDP_UIArmory_PromotionHero'));

	if (Width > 0)
	{
		UI.Scrollbar.SetWidth(Width);
	}

	if (Height > 0)
	{
		UI.Scrollbar.SetHeight(Height);
	}
}
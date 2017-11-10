//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_PerkPackAbilitySet
//  AUTHOR:  Amineri / John Lumpkin (Pavonis Interactive)
//  PURPOSE: Defines general use ability templates
//--------------------------------------------------------------------------------------- 

class X2Ability_PerkPackAbilitySet extends X2Ability config (LW_SoldierSkills);

var config int CENTERMASS_DAMAGE;
var config int LETHAL_DAMAGE;
var config int DOUBLE_TAP_1ST_SHOT_AIM;
var config int DOUBLE_TAP_2ND_SHOT_AIM;
var config int DOUBLE_TAP_COOLDOWN;
var config int DOUBLE_TAP_MIN_ACTION_REQ;
var config int RESILIENCE_CRITDEF_BONUS;
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
var config int GRAZING_FIRE_SUCCESS_CHANCE;
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
var config float DANGER_ZONE_BONUS_RADIUS;
var config int INTERFERENCE_CV_CHARGES;
var config int INTERFERENCE_MG_CHARGES;
var config int INTERFERENCE_BM_CHARGES;
var config int INTERFERENCE_ACTION_POINTS;
var config int DAMAGE_CONTROL_DURATION; 
var config int DAMAGE_CONTROL_ABLATIVE_HP;
var config int DAMAGE_CONTROL_BONUS_ARMOR;
var config float COVERT_DETECTION_RANGE_REDUCTION;
var config float GHOSTWALKER_DETECTION_RANGE_REDUCTION;
var config int GHOSTWALKER_DURATION;
var config int GHOSTWALKER_COOLDOWN;
var config int KUBIKURI_COOLDOWN;
var config int KUBIKURI_AMMO_COST;
var config int KUBIKURI_MIN_ACTION_REQ;
var config float KUBIKURI_MAX_HP_PCT;
var config float COMBAT_RUSH_RADIUS;
var config int COMBAT_RUSH_COOLDOWN;
var config int COMBAT_RUSH_AIM_BONUS;
var config int COMBAT_RUSH_CRIT_BONUS;
var config int COMBAT_RUSH_MOBILITY_BONUS;
var config int COMBAT_RUSH_DEFENSE_BONUS;
var config int COMBAT_RUSH_DODGE_BONUS;
var config int COMBAT_RUSH_DURATION;
var config int HEAVY_FRAGS_DAMAGE;
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
var config int IRON_SKIN_MELEE_DAMAGE_REDUCTION;
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
var config float FORMIDABLE_EXPLOSIVES_DR;
var config int FORMIDABLE_ARMOR_MITIGATION;
var config int FORMIDABLE_ABLATIVE_HP;
var config int WILLTOSURVIVE_WILLBONUS;
var config int CUTTHROAT_BONUS_CRIT_CHANCE;
var config int CUTTHROAT_BONUS_CRIT_DAMAGE;
var config int MAX_ABLATIVE_FROM_SOULSTEAL;
var config int CCS_AMMO_PER_SHOT;
var config int COVERING_FIRE_OFFENSE_MALUS;
var localized string LocCoveringFire;
var localized string LocCoveringFireMalus;
var config bool NO_STANDARD_ATTACKS_WHEN_ON_FIRE;
var config bool NO_MELEE_ATTACKS_WHEN_ON_FIRE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddCenterMassAbility());
	Templates.AddItem(AddLethalAbility());
	Templates.AddItem(AddHitandRunAbility());
	Templates.AddItem(AddHitandSlitherAbility());
	Templates.AddItem(AddCloseCombatSpecialistAbility());
	Templates.AddItem(CloseCombatSpecialistAttack()); //Additional Ability
	Templates.AddItem(AddCloseandPersonalAbility());
	Templates.AddItem(AddDamnGoodGroundAbility());
	Templates.AddItem(AddExecutionerAbility());
	Templates.AddItem(AddResilienceAbility());
	//Templates.AddItem(AddTacticalSenseAbility());
	//Templates.AddItem(AddAggressionAbility());
	//Templates.AddItem(AddBringEmOnAbility());
	//Templates.AddItem(AddHardTargetAbility());
	//Templates.AddItem(AddInfighterAbility());
	//Templates.AddItem(AddDepthPerceptionAbility());
	//Templates.AddItem(AddWilltoSurviveAbility()); 
	//Templates.AddItem(AddLightEmUpAbility());
	//Templates.AddItem(AddCloseEncountersAbility());
	//Templates.AddItem(AddLoneWolfAbility());
	//Templates.AddItem(AddLowProfileAbility());
	//Templates.AddItem(AddDoubleTapAbility());
	//Templates.AddItem(DoubleTap2ndShot()); //Additional Ability
	//Templates.AddItem(AddTraverseFireAbility());
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
	//Templates.AddItem(AddHyperReactivePupilsAbility());
	//Templates.AddItem(AddSteadyWeaponAbility());
	//Templates.AddItem(AddLockedOnAbility());
	//Templates.AddItem(AddSentinel_LWAbility());
	//Templates.AddItem(AddRapidReactionAbility());
	//Templates.AddItem(AddLightningReflexes_LWAbility());
	//Templates.AddItem(AddCutthroatAbility());
	//Templates.AddItem(AddRunAndGun_LWAbility());
	//Templates.AddItem(AddKillerInstinctAbility());
	//Templates.AddItem(AddExtraConditioningAbility());
	//Templates.AddItem(AddSuppressionAbility_LW());
	//Templates.AddItem(SuppressionShot_LW()); //Additional Ability
	//Templates.AddItem(AddAreaSuppressionAbility());
	//Templates.AddItem(AreaSuppressionShot_LW()); //Additional Ability
	//Templates.AddItem(AddLockdownAbility());
	//Templates.AddItem(AddDangerZoneAbility());
	//Templates.AddItem(LockdownBonuses()); //Additional Ability
	//Templates.AddItem(PurePassive('Mayhem', "img:///UILibrary_LW_PerkPack.LW_AbilityMayhem", false, 'eAbilitySource_Perk'));
	//Templates.AddItem(MayhemBonuses()); // AdditionalAbility;
	//Templates.AddItem(AddInterferenceAbility());
	//Templates.AddItem(AddDamageControlAbility());
	//Templates.AddItem(AddDamageControlAbilityPassive()); //Additional Ability
	//Templates.AddItem(AddEvasiveAbility());
	//Templates.AddItem(RemoveEvasive()); // Additional Ability
	//Templates.AddItem(AddCovertAbility()); 
	//Templates.AddItem(AddGhostwalkerAbility()); 
	//Templates.AddItem(AddKubikuriAbility());
	//Templates.AddItem(KubikiriDamage());
	//Templates.AddItem(AddCombatAwarenessAbility());
	//Templates.AddItem(AddCombatRushAbility());
	//Templates.AddItem(BroadcastCombatRush()); //Additional Ability
	//Templates.AddItem(AddGrazingFireAbility());
	//Templates.AddItem(AddHeavyFragsAbility());
	//Templates.AddItem(AddIronCurtainAbility());
	//Templates.AddItem(IronCurtainShot()); //Additional Ability
	//Templates.AddItem(AddSlash_LWAbility());
	//Templates.AddItem(AddAbsorptionFieldsAbility());
	//Templates.AddItem(AddBodyShieldAbility());
	//Templates.AddItem(AddEmergencyLifeSupportAbility());
	//Templates.AddItem(AddSmartMacrophagesAbility());
	//Templates.AddItem(AddIronSkinAbility());
	//Templates.AddItem(AddMindMergeAbility());
	//Templates.AddItem(AddSoulMergeAbility());
	//Templates.AddItem(AddShadowstrike_LWAbility());
	//Templates.AddItem(AddFormidableAbility());
	//Templates.AddItem(AddSoulStealTriggered2());
	return Templates;
}

static function X2AbilityTemplate AddCenterMassAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_PrimaryHitBonusDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_CenterMass');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCenterMass";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageEffect = new class'X2Effect_LW2WotC_PrimaryHitBonusDamage';
	DamageEffect.BonusDmg = default.CENTERMASS_DAMAGE;
	DamageEffect.includepistols = true;
	DamageEffect.includesos = true;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	// NOTE: Limitation of this ability to PRIMARY weapons only must be configured in ClassData.ini, otherwise will apply to pistols/swords, etc., contrary to design and loc text
	// Ability parameter is ApplyToWeaponSlot=eInvSlot_PrimaryWeapon
	return Template;
}

static function X2AbilityTemplate AddLethalAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_PrimaryHitBonusDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_Lethal');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityKinetic";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageEffect = new class'X2Effect_LW2WotC_PrimaryHitBonusDamage';
	DamageEffect.BonusDmg = default.LETHAL_DAMAGE;
	DamageEffect.includepistols = false;
	DamageEffect.includesos = false;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// No visualization
	// NOTE: Limitation of this ability to PRIMARY weapons only must be configured in ClassData.ini, otherwise will apply to pistols/swords, etc., contrary to design and loc text
	// Ability parameter is ApplyToWeaponSlot=eInvSlot_PrimaryWeapon
	return Template;
}

static function X2AbilityTemplate AddHitandRunAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_HitandRun				HitandRunEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_HitandRun');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHitandRun";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	HitandRunEffect = new class'X2Effect_LW2WotC_HitandRun';
	HitandRunEffect.BuildPersistentEffect(1, true, false, false);
	HitandRunEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	HitandRunEffect.DuplicateResponse = eDupe_Ignore;
	HitandRunEffect.HITANDRUN_FULLACTION = true;
	Template.AddTargetEffect(HitandRunEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_LW2WotC_HitandRun
	return Template;
}

static function X2AbilityTemplate AddHitandSlitherAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_HitandRun				HitandRunEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_HitandSlither');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHitandRun";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	HitandRunEffect = new class'X2Effect_LW2WotC_HitandRun';
	HitandRunEffect.BuildPersistentEffect(1, true, false, false);
	HitandRunEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	HitandRunEffect.DuplicateResponse = eDupe_Ignore;
	HitandRunEffect.HITANDRUN_FULLACTION=false;
	Template.AddTargetEffect(HitandRunEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_LW2WotC_HitandRun
	return Template;
}

static function X2AbilityTemplate AddCloseCombatSpecialistAbility()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('LW2WotC_CloseCombatSpecialist', "img:///UILibrary_LW_PerkPack.LW_AbilityCloseCombatSpecialist", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('LW2WotC_CloseCombatSpecialistAttack');
	return Template;
}

static function X2AbilityTemplate CloseCombatSpecialistAttack()
{
	local X2AbilityTemplate								Template;
	local X2AbilityToHitCalc_StandardAim				ToHitCalc;
	local X2AbilityTrigger_Event						Trigger;
	local X2Effect_Persistent							CloseCombatSpecialistTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource		CloseCombatSpecialistTargetCondition;
	local X2AbilityTrigger_EventListener				EventListener;
	local X2Condition_UnitProperty						SourceNotConcealedCondition;
	local X2Condition_UnitEffects						SuppressedCondition;
	local X2Condition_Visibility						TargetVisibilityCondition;
	local X2AbilityCost_Ammo							AmmoCost;
	local X2AbilityTarget_LW2WotC_Single_CCS					SingleTarget;
	//local X2AbilityCooldown								Cooldown;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_CloseCombatSpecialistAttack');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseCombatSpecialist";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bCrossClassEligible = false;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bReactionFire = true;
	Template.AbilityToHitCalc = ToHitCalc;
	 
	//Cooldown = new class'X2AbilityCooldown';
	//Cooldown.iNumTurns = 1;
    //Template.AbilityCooldown = Cooldown;

	AmmoCost = new class 'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.CCS_AMMO_PER_SHOT;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	//  trigger on movement
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'PostBuildGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	//  trigger on an attack
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	//  it may be the case that enemy movement caused a concealment break, which made Bladestorm applicable - attempt to trigger afterwards
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = CloseCombatSpecialistConcealmentListener;
	EventListener.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(EventListener);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	//Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	SingleTarget = new class 'X2AbilityTarget_LW2WotC_Single_CCS';
	//SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	Template.bAllowBonusWeaponEffects = true;
	Template.AddTargetEffect(class 'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	//Prevent repeatedly hammering on a unit when CCS triggers.
	//(This effect does nothing, but enables many-to-many marking of which CCS attacks have already occurred each turn.)
	CloseCombatSpecialistTargetEffect = new class'X2Effect_Persistent';
	CloseCombatSpecialistTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	CloseCombatSpecialistTargetEffect.EffectName = 'CloseCombatSpecialistTarget';
	CloseCombatSpecialistTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(CloseCombatSpecialistTargetEffect);
	
	CloseCombatSpecialistTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	CloseCombatSpecialistTargetCondition.AddExcludeEffect('CloseCombatSpecialistTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(CloseCombatSpecialistTargetCondition);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;

	return Template;
}

//Must be static, because it will be called with a different object (an XComGameState_Ability)
//Used to trigger Bladestorm when the source's concealment is broken by a unit in melee range (the regular movement triggers get called too soon)
static function EventListenerReturn CloseCombatSpecialistConcealmentListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit ConcealmentBrokenUnit;
	local StateObjectReference CloseCombatSpecialistRef;
	local XComGameState_Ability CloseCombatSpecialistState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	ConcealmentBrokenUnit = XComGameState_Unit(EventSource);	
	if (ConcealmentBrokenUnit == None)
		return ELR_NoInterrupt;

	//Do not trigger if the CloseCombatSpecialist soldier himself moved to cause the concealment break - only when an enemy moved and caused it.
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
	if (AbilityContext != None && AbilityContext.InputContext.SourceObject != ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef)
		return ELR_NoInterrupt;

	CloseCombatSpecialistRef = ConcealmentBrokenUnit.FindAbility('LW2WotC_CloseCombatSpecialistAttack');
	if (CloseCombatSpecialistRef.ObjectID == 0)
		return ELR_NoInterrupt;

	CloseCombatSpecialistState = XComGameState_Ability(History.GetGameStateForObjectID(CloseCombatSpecialistRef.ObjectID));
	if (CloseCombatSpecialistState == None)
		return ELR_NoInterrupt;
	
	CloseCombatSpecialistState.AbilityTriggerAgainstSingleTarget(ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef, false);
	return ELR_NoInterrupt;
}

static function X2AbilityTemplate AddCloseandPersonalAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_CloseandPersonal				CritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_CloseandPersonal');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseandPersonal";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	CritModifier = new class 'X2Effect_LW2WotC_CloseandPersonal';
	CritModifier.BuildPersistentEffect (1, true, false);
	CritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (CritModifier);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddDamnGoodGroundAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_DamnGoodGround			AimandDefModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_DamnGoodGround');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDamnGoodGround";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandDefModifiers = new class 'X2Effect_LW2WotC_DamnGoodGround';
	AimandDefModifiers.BuildPersistentEffect (1, true, true);
	AimandDefModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandDefModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;		
}

static function X2AbilityTemplate AddExecutionerAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_Executioner				AimandCritModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Executioner');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityExecutioner";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandCritModifiers = new class 'X2Effect_LW2WotC_Executioner';
	AimandCritModifiers.BuildPersistentEffect (1, true, false);
	AimandCritModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandCritModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate AddResilienceAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_Resilience				MyCritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Resilience');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityResilience";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	MyCritModifier = new class 'X2Effect_LW2WotC_Resilience';
	MyCritModifier.CritDef_Bonus = default.RESILIENCE_CRITDEF_BONUS;
	MyCritModifier.BuildPersistentEffect (1, true, false, true);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyCritModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate AddTacticalSenseAbility()
{
	local X2AbilityTemplate				Template;
	local X2Effect_LW2WotC_TacticalSense		MyDefModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_TacticalSense');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityTacticalSense";	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bIsPassive = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	MyDefModifier = new class 'X2Effect_LW2WotC_TacticalSense';
	MyDefModifier.BuildPersistentEffect (1, true, false);
	MyDefModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyDefModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}



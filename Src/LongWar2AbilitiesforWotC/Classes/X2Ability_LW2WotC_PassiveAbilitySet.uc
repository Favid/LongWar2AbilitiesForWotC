//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW2WotC_PassiveAbilitySet
//  PURPOSE: Defines ability templates for passive abilities
//--------------------------------------------------------------------------------------- 

class X2Ability_LW2WotC_PassiveAbilitySet extends XMBAbility config (LW_SoldierSkills);

var config int CENTERMASS_DAMAGE;
var config int LETHAL_DAMAGE;
var config int RESILIENCE_CRITDEF_BONUS;
var config int GRAZING_FIRE_SUCCESS_CHANCE;
var config float DANGER_ZONE_BONUS_RADIUS;
var config int DAMAGE_CONTROL_DURATION; 
var config int DAMAGE_CONTROL_ABLATIVE_HP;
var config int DAMAGE_CONTROL_BONUS_ARMOR;
var config float COVERT_DETECTION_RANGE_REDUCTION;
var config float COMBAT_RUSH_RADIUS;
var config int COMBAT_RUSH_COOLDOWN;
var config int COMBAT_RUSH_AIM_BONUS;
var config int COMBAT_RUSH_CRIT_BONUS;
var config int COMBAT_RUSH_MOBILITY_BONUS;
var config int COMBAT_RUSH_DEFENSE_BONUS;
var config int COMBAT_RUSH_DODGE_BONUS;
var config int COMBAT_RUSH_DURATION;
var config int HEAVY_FRAGS_DAMAGE;
var config int IRON_SKIN_MELEE_DAMAGE_REDUCTION;
var config float FORMIDABLE_EXPLOSIVES_DR;
var config int FORMIDABLE_ARMOR_MITIGATION;
var config int FORMIDABLE_ABLATIVE_HP;
var config int WILLTOSURVIVE_WILLBONUS;
var config int CUTTHROAT_BONUS_CRIT_CHANCE;
var config int CUTTHROAT_BONUS_CRIT_DAMAGE;
var config int CUTTHROAT_BONUS_ARMOR_PIERCE;
var config int CCS_AMMO_PER_SHOT;
var config int DENSE_SMOKE_HITMOD;
var config int COVERING_FIRE_OFFENSE_MALUS;

var localized string LocCoveringFire;
var localized string LocCoveringFireMalus;
var localized string LocDenseSmokeEffect;
var localized string LocDenseSmokeEffectDescription;

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
	Templates.AddItem(AddTacticalSenseAbility());
	Templates.AddItem(AddAggressionAbility());
	Templates.AddItem(AddBringEmOnAbility());
	Templates.AddItem(AddHardTargetAbility());
	Templates.AddItem(AddInfighterAbility());
	Templates.AddItem(AddDepthPerceptionAbility());
	Templates.AddItem(AddWilltoSurviveAbility()); 
	Templates.AddItem(AddLightEmUpAbility());
	Templates.AddItem(AddCloseEncountersAbility());
	Templates.AddItem(AddLoneWolfAbility());
	Templates.AddItem(AddLowProfileAbility());
	Templates.AddItem(AddHyperReactivePupilsAbility());
	Templates.AddItem(AddLockedOnAbility());
	Templates.AddItem(AddSentinel_LWAbility());
	Templates.AddItem(AddRapidReactionAbility());
	//Templates.AddItem(AddKillerInstinctAbility());
	//Templates.AddItem(AddExtraConditioningAbility());
	//Templates.AddItem(AddLockdownAbility());
	//Templates.AddItem(AddDangerZoneAbility());
	//Templates.AddItem(LockdownBonuses()); //Additional Ability
	//Templates.AddItem(PurePassive('Mayhem', "img:///UILibrary_LW_PerkPack.LW_AbilityMayhem", false, 'eAbilitySource_Perk'));
	//Templates.AddItem(MayhemBonuses()); // AdditionalAbility;
	//Templates.AddItem(AddEvasiveAbility());
	//Templates.AddItem(RemoveEvasive()); // Additional Ability
	//Templates.AddItem(AddGhostwalkerAbility()); 
	//Templates.AddItem(AddCombatAwarenessAbility());
	//Templates.AddItem(AddCombatRushAbility());
	//Templates.AddItem(BroadcastCombatRush()); //Additional Ability
	//Templates.AddItem(AddGrazingFireAbility());
	//Templates.AddItem(AddHeavyFragsAbility());
	//Templates.AddItem(AddEmergencyLifeSupportAbility());
	//Templates.AddItem(AddSmartMacrophagesAbility());
	//Templates.AddItem(AddIronSkinAbility());
	//Templates.AddItem(AddShadowstrike_LWAbility());
	//Templates.AddItem(AddSoulStealTriggered2());
	//Templates.AddItem(AddTrojan());
	//Templates.AddItem(AddTrojanVirus());
	//Templates.AddItem(AddFlashbanger());
	//Templates.AddItem(AddSmokeGrenade());
	//Templates.AddItem(AddSavior());
	//Templates.AddItem(AddDenseSmoke());
	//Templates.AddItem(AddBastion());
	//Templates.AddItem(AddBastionPassive());
	//Templates.AddItem(AddBastionCleanse());
	//Templates.AddItem(AddFullKit());
	//Templates.AddItem(AddStingGrenades());
	//Templates.AddItem(AddFieldSurgeon());

    Templates.AddItem(TraverseFire());
    Templates.AddItem(Cutthroat());
	Templates.AddItem(Covert());
	Templates.AddItem(DamageControl());
	Templates.AddItem(Formidable());
	Templates.AddItem(LightningReflexes());
	Templates.AddItem(Smoker());
	Templates.AddItem(DenseSmoke());

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

static function X2AbilityTemplate AddAggressionAbility()
{
	local X2AbilityTemplate				Template;
	local X2Effect_LW2WotC_Aggression			MyCritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Aggression');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAggression";	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	MyCritModifier = new class 'X2Effect_LW2WotC_Aggression';
	MyCritModifier.BuildPersistentEffect (1, true, false);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyCritModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate AddBringEmOnAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_BringEmOn		            DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_BringEmOn');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBringEmOn";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageEffect = new class'X2Effect_LW2WotC_BringEmOn';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

static function X2AbilityTemplate AddHardTargetAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_HardTarget					DodgeBonus;
		
	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_HardTarget');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHardTarget";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DodgeBonus = new class 'X2Effect_LW2WotC_HardTarget';
	DodgeBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DodgeBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(DodgeBonus);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization

	return Template;
}

static function X2AbilityTemplate AddInfighterAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_Infighter					DodgeBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_Infighter');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityInfighter";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DodgeBonus = new class 'X2Effect_LW2WotC_Infighter';
	DodgeBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DodgeBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(DodgeBonus);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

static function X2AbilityTemplate AddDepthPerceptionAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_DepthPerception				AttackBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_DepthPerception');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDepthPerception";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.bIsPassive = true;
	AttackBonus = new class 'X2Effect_LW2WotC_DepthPerception';
	AttackBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	AttackBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(AttackBonus);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate AddWilltoSurviveAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_WilltoSurvive				ArmorBonus;
	local X2Effect_PersistentStatChange			WillBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_WilltoSurvive');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityWilltoSurvive";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	ArmorBonus = new class 'X2Effect_LW2WotC_WilltoSurvive';
	ArmorBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ArmorBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(ArmorBonus);

	WillBonus = new class'X2Effect_PersistentStatChange';
	WillBonus.AddPersistentStatChange(eStat_Will, float(default.WILLTOSURVIVE_WILLBONUS));
	WillBonus.BuildPersistentEffect (1, true, false, false, 7);
	Template.AddTargetEffect(WillBonus);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, default.WILLTOSURVIVE_WILLBONUS);

	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

static function X2AbilityTemplate AddLightEmUpAbility()
{
	local X2AbilityTemplate			Template;

	Template = PurePassive('LW2WotC_LightEmUp', "img:///UILibrary_LW_PerkPack.LW_AbilityLightEmUp");

	return Template;
}

static function X2AbilityTemplate AddCloseEncountersAbility()
{
	local X2AbilityTemplate							Template;
	local X2Effect_LW2WotC_CloseEncounters					ActionEffect;
	
	`CREATE_X2ABILITY_TEMPLATE (Template, 'LW2WotC_CloseEncounters');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseEncounters";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.bIsPassive = true;  // needs to be off to allow perks
	ActionEffect = new class 'X2Effect_LW2WotC_CloseEncounters';
	ActionEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ActionEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(ActionEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Visualization handled in Effect
	return Template;
}

static function X2AbilityTemplate AddLoneWolfAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_LoneWolf					AimandDefModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_LoneWolf');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityLoneWolf";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandDefModifiers = new class 'X2Effect_LW2WotC_LoneWolf';
	AimandDefModifiers.BuildPersistentEffect (1, true, false);
	AimandDefModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandDefModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//no visualization
	return Template;		
}

static function X2AbilityTemplate AddLowProfileAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_LowProfile			DefModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_LowProfile');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityLowProfile";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DefModifier = new class 'X2Effect_LW2WotC_LowProfile';
	DefModifier.BuildPersistentEffect (1, true, false);
	DefModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (DefModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//no visualization
	return Template;
}

static function X2AbilityTemplate AddHyperReactivePupilsAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_HyperReactivePupils		HyperReactivePupilsEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_HyperReactivePupils');	
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHyperreactivePupils";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);		
	HyperReactivePupilsEffect = new class'X2Effect_LW2WotC_HyperReactivePupils';
	HyperReactivePupilsEffect.BuildPersistentEffect(1, true, false,, eGameRule_TacticalGameStart);
	HyperReactivePupilsEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(HyperReactivePupilsEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate AddLockedOnAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_LockedOn					LockedOnEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_LockedOn');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityLockedOn";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;
	LockedOnEffect = new class'X2Effect_LW2WotC_LockedOn';
	LockedOnEffect.BuildPersistentEffect(1, true, false,, eGameRule_TacticalGameStart);
	LockedOnEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(LockedOnEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddSentinel_LWAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_Sentinel				PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Sentinel');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySentinel";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	PersistentEffect = new class'X2Effect_LW2WotC_Sentinel';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate AddRapidReactionAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_RapidReaction			PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_RapidReaction');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityRapidReaction3";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	PersistentEffect = new class'X2Effect_LW2WotC_RapidReaction';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = false;
	return Template;
}

// Perk name:		Traverse Fire
// Perk effect:		After taking a standard shot with your primary weapon with your first action, you may take an additional non-movement action.
// Localized text:	"After taking a standard shot with your primary weapon with your first action, you may take an additional non-movement action."
// Config:			(AbilityName="LW2WotC_TraverseFire")
static function X2AbilityTemplate TraverseFire()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityCost CostCondition;
	local XMBCondition_AbilityName NameCondition;

	// Add a single non-movement action point to the unit
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('LW2WotC_TraverseFire', "img:///UILibrary_LW_PerkPack.LW_AbilityTraverseFire", false, Effect, 'AbilityActivated');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Require that the activated ability costs 1 action point but actually spent at least 2
	CostCondition = new class'XMBCondition_AbilityCost';
	CostCondition.bRequireMaximumCost = true;
	CostCondition.MaximumCost = 1;
	CostCondition.bRequireMinimumPointsSpent = true;
	CostCondition.MinimumPointsSpent = 2;
	AddTriggerTargetCondition(Template, CostCondition);
    
	// The bonus only applies to standard shots
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('StandardShot');
	NameCondition.IncludeAbilityNames.AddItem('SniperStandardFire');
	AddTriggerTargetCondition(Template, NameCondition);

	// Show a flyover when Traverse Fire is activated
	Template.bShowActivation = true;

	return Template;
}

// Perk name:		Cutthroat
// Perk effect:		Your melee attacks against biological enemies ignore their armor, have increased critical chance, and do additional critical damage.
// Localized text:	"Your melee attacks against biological enemies ignore their armor, have a +<Ability:CUTTHROAT_BONUS_CRIT_CHANCE/> critical chance, and do +<Ability:CUTTHROAT_BONUS_CRIT_DAMAGE/> critical damage."
// Config:			(AbilityName="LW2WotC_Cutthroat")
static function X2AbilityTemplate Cutthroat()
{
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityProperty MeleeOnlyCondition;
	local X2Condition_UnitProperty OrganicCondition;

	// Create a conditional bonus
	Effect = new class'XMBEffect_ConditionalBonus';

    // The bonus adds critical hit chance
	Effect.AddToHitModifier(default.CUTTHROAT_BONUS_CRIT_CHANCE, eHit_Crit);

	// The bonus adds damage to critical hits
	Effect.AddDamageModifier(default.CUTTHROAT_BONUS_CRIT_DAMAGE, eHit_Crit);

    // The bonus ignores armor
    Effect.AddArmorPiercingModifier(default.CUTTHROAT_BONUS_ARMOR_PIERCE);
    
	// Only melee attacks
	MeleeOnlyCondition = new class'XMBCondition_AbilityProperty';
	MeleeOnlyCondition.bRequireMelee = true;
	Effect.AbilityTargetConditions.AddItem(MeleeOnlyCondition);
	
	// Only against organics
	OrganicCondition = new class'X2Condition_UnitProperty';
	OrganicCondition.ExcludeRobotic = true;
	Effect.AbilityTargetConditions.AddItem(OrganicCondition);

	// Create the template using a helper function
	return Passive('LW2WotC_Cutthroat', "img:///UILibrary_LW_PerkPack.LW_AbilityCutthroat", true, Effect);
}

// Perk name:		Covert
// Perk effect:		Enemies have reduced detection range against you.
// Localized text:	"Enemies have <Ability:COVERT_DETECTION_RANGE_REDUCTION>% smaller detection range against you."
// Config:			(AbilityName="LW2WotC_Covert")
static function X2AbilityTemplate Covert()
{
	local X2Effect_PersistentStatChange Effect;

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_DetectionModifier, default.COVERT_DETECTION_RANGE_REDUCTION);

	return Passive('LW2WotC_Covert', "img:///UILibrary_LW_PerkPack.LW_AbilityCovert", true, Effect);
}

// Perk name:		Damage Control
// Perk effect:		After taking damage, gain bonus armor through the end of the turn.
// Localized text:	"After taking damage, gain <Ability:DAMAGE_CONTROL_BONUS_ARMOR> armor through the end of the turn."
// Config:			(AbilityName="LW2WotC_DamageControl")
static function X2AbilityTemplate DamageControl()
{
	local X2Effect_LW2WotC_BonusArmor Effect;
	local X2AbilityTemplate Template;

	// Create a persistent effect for the bonus armor
	Effect = new class'X2Effect_LW2WotC_BonusArmor';
	Effect.EffectName = 'LW2WotC_DamageControl';

	// The effect duration
	Effect.BuildPersistentEffect(default.DAMAGE_CONTROL_DURATION, false, false, false, eGameRule_PlayerTurnBegin);

	// If the effect is added multiple times, it refreshes the duration of the existing effect
	Effect.DuplicateResponse = eDupe_Refresh;

	// Bonus armor
	Effect.BonusArmor = default.DAMAGE_CONTROL_BONUS_ARMOR;

	// Show a flyover over the target unit when the effect is added
	Effect.VisualizationFn = EffectFlyOver_Visualization;

	// Create the template using a helper function. This ability triggers when we take damage
	Template = SelfTargetTrigger('LW2WotC_DamageControl', "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl", true, Effect, 'UnitTakeEffectDamage');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	return Template;
}

// Perk name:		Formidable
// Perk effect:		Your gear includes an extra layer of protection, granting bonus ablative hit points and reduced damage from explosive attacks.
// Localized text:	"Your gear includes an extra layer of protection, granting <Ability:FORMIDABLE_ABLATIVE_HP/> bonus ablative hit points and <Ability:BlastPadding/>% less damage from explosive attacks."
// Config:			(AbilityName="LW2WotC_Formidable")
static function X2AbilityTemplate Formidable()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_LW2WotC_Formidable	                PaddingEffect;
	local X2EFfect_PersistentStatChange			HPEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Formidable');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_extrapadding";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	PaddingEffect = new class'X2Effect_LW2WotC_Formidable';
	PaddingEffect.ExplosiveDamageReduction = default.FORMIDABLE_EXPLOSIVES_DR;
	PaddingEffect.Armor_Mitigation = default.FORMIDABLE_ARMOR_MITIGATION;
	PaddingEffect.BuildPersistentEffect(1, true, false);
	PaddingEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(PaddingEffect);

	HPEFfect = new class'X2Effect_PersistentStatChange';
	HPEffect.BuildPersistentEffect(1, true, false);
	HPEffect.AddPersistentStatChange(eStat_ShieldHP, default.FORMIDABLE_ABLATIVE_HP);
	Template.AddTargetEFfect(HPEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = true;

	if (default.FORMIDABLE_ARMOR_MITIGATION > 0)
	{
		Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, PaddingEffect.ARMOR_MITIGATION);
	}

	return Template;
}

// Perk name:		Lightning Reflexes
// Perk effect:		Your gear includes an extra layer of protection, granting bonus ablative hit points and reduced damage from explosive attacks.
// Localized text:	"Your gear includes an extra layer of protection, granting <Ability:FORMIDABLE_ABLATIVE_HP/> bonus ablative hit points and <Ability:BlastPadding/>% less damage from explosive attacks."
// Config:			(AbilityName="LW2WotC_LightningReflexes")
static function X2AbilityTemplate LightningReflexes()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_LightningReflexes		PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_LightningReflexes');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningreflexes";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	PersistentEffect = new class'X2Effect_LW2WotC_LightningReflexes';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = true;
	return Template;
}

// Perk name:		Smoker
// Perk effect:		Grants one free smoke grenade item to your inventory.
// Localized text:	"Grants one free smoke grenade item to your inventory."
// Config:			(AbilityName="LW2WotC_Smoker")
static function X2AbilityTemplate Smoker()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AddUtilityItem ItemEffect;

	// Adds a free smoke grenade
	ItemEffect = new class'XMBEffect_AddUtilityItem';
	ItemEffect.DataName = 'SmokeGrenade';

	Template = Passive('LW2WotC_Smoker', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke", true, ItemEffect);

	return Template;
}

// Perk name:		Smoker
// Perk effect:		Your smoke grenades confer additional bonus defense.
// Localized text:	"Your smoke grenades confer an additional <Ability:DENSE_SMOKE_INVERSE/> defense."
// Config:			(AbilityName="LW2WotC_DenseSmoke")
static function X2AbilityTemplate DenseSmoke()
{
	return Passive('LW2WotC_DenseSmoke', "img:///UILibrary_LW_PerkPack.LW_AbilityDenseSmoke", false, none);
}

// This effect is applied to Smoke Grenades and Smoke Bombs in X2DownloadableContentInfo_LongWar2AbilitiesforWotC.uc
static function X2Effect DenseSmokeEffect()
{
	local X2Effect_LW2WotC_DenseSmokeGrenade Effect;
	local XMBCondition_SourceAbilities Condition;

	// Additional defense bonus for dense smoke
	Effect = new class'X2Effect_LW2WotC_DenseSmokeGrenade';
	Effect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, default.LocDenseSmokeEffect, default.LocDenseSmokeEffectDescription, "img:///UILibrary_LW_PerkPack.LW_AbilityDenseSmoke");
	Effect.HitMod = default.DENSE_SMOKE_HITMOD;
	Effect.DuplicateResponse = eDupe_Refresh;

	// Only applies if the thrower has Dense Smoke
	Condition = new class'XMBCondition_SourceAbilities';
	Condition.AddRequireAbility('LW2WotC_DenseSmoke', 'AA_UnitIsImmune');
	Effect.TargetConditions.AddItem(Condition);

	return Effect;
}
//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW2WotC_PassiveAbilitySet
//  PURPOSE: Defines ability templates for passive abilities
//--------------------------------------------------------------------------------------- 

class X2Ability_LW2WotC_PassiveAbilitySet extends XMBAbility config (LW_SoldierSkills);

var config int CENTERMASS_DAMAGE;
var config int LETHAL_DAMAGE;
var config int RESILIENCE_CRITDEF_BONUS;
var config int GRAZING_FIRE_SUCCESS_CHANCE;
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
var config int BOOSTED_CORES_DAMAGE;
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
var config int COMBAT_FITNESS_HP;
var config int COMBAT_FITNESS_OFFENSE;
var config int COMBAT_FITNESS_MOBILITY;
var config int COMBAT_FITNESS_DODGE;
var config int COMBAT_FITNESS_WILL;
var config int SPRINTER_MOBILITY;
var config int ALPHAMIKEFOXTROT_DAMAGE;
var config int COUP_DE_GRACE_HIT_BONUS;
var config int COUP_DE_GRACE_CRIT_BONUS;
var config int COUP_DE_GRACE_DAMAGE_BONUS;
var config bool COUP_DE_GRACE_HALF_FOR_DISORIENTED;
var config int FULL_KIT_BONUS;
var config array<name> FULL_KIT_ITEMS;
var config int PROTECTOR_BONUS_CHARGES;
var config int HEAVY_ORDNANCE_BONUS_CHARGES;
var config int HEAT_WARHEADS_PIERCE;
var config int HEAT_WARHEADS_SHRED;
var config int STING_GRENADE_STUN_CHANCE;
var config int STING_GRENADE_STUN_LEVEL;
var config int BLUESCREENBOMB_HACK_DEFENSE_CHANGE;
var config int COMMISSAR_HIT_BONUS;
var config int BOMBARDIER_BONUS_RANGE_TILES;
var config int FAILSAFE_PCT_CHANCE;
var config int SAPPER_BONUS_ENVIRONMENT_DAMAGE;

var localized string LocDenseSmokeEffect;
var localized string LocDenseSmokeEffectDescription;
var localized string LocTrojanVirus;
var localized string LocTrojanVirusTriggered;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CenterMass());
	Templates.AddItem(Lethal());
	Templates.AddItem(HitAndRun());
	Templates.AddItem(HitAndSlither());
	Templates.AddItem(CloseCombatSpecialist());
	Templates.AddItem(CloseCombatSpecialistAttack());
	Templates.AddItem(CloseAndPersonal());
	Templates.AddItem(DamnGoodGround());
	Templates.AddItem(Executioner());
	Templates.AddItem(Resilience());
	Templates.AddItem(TacticalSense());
	Templates.AddItem(Aggression());
	Templates.AddItem(BringEmOn());
	Templates.AddItem(HardTarget());
	Templates.AddItem(Infighter());
	Templates.AddItem(DepthPerception());
	Templates.AddItem(WillToSurvive()); 
	Templates.AddItem(LightEmUp());
	Templates.AddItem(CloseEncounters());
	Templates.AddItem(LoneWolf());
	Templates.AddItem(LowProfile());
	Templates.AddItem(HyperReactivePupils());
	Templates.AddItem(LockOn());
	Templates.AddItem(Sentinel());
	Templates.AddItem(RapidReaction());
    Templates.AddItem(TraverseFire());
    Templates.AddItem(Cutthroat());
	Templates.AddItem(Covert());
	Templates.AddItem(DamageControl());
	Templates.AddItem(Formidable());
	Templates.AddItem(LightningReflexes());
	Templates.AddItem(Smoker());
	Templates.AddItem(DenseSmoke());
	Templates.AddItem(GrazingFire());
	Templates.AddItem(CombatFitness());
	Templates.AddItem(Sprinter());
	Templates.AddItem(AlphaMikeFoxtrot());
	Templates.AddItem(CoupDeGrace());
	Templates.AddItem(BoostedCores());
	Templates.AddItem(VolatileMix());
	Templates.AddItem(Flashbanger());
	Templates.AddItem(Evasive());
	Templates.AddItem(IronSkin());
	Templates.AddItem(CombatAwareness());
	Templates.AddItem(CombatRush());
	Templates.AddItem(FullKit());
	Templates.AddItem(Savior());
	Templates.AddItem(HeavyOrdnance());
	Templates.AddItem(Protector());
	Templates.AddItem(HEATWarheads());
	Templates.AddItem(EmergencyLifeSupport());
	Templates.AddItem(SmartMacrophages());
	Templates.AddItem(FieldSurgeon());
	Templates.AddItem(Trojan());
	Templates.AddItem(TrojanVirus());
	Templates.AddItem(StingGrenades());
	Templates.AddItem(BluescreenBombs());
	Templates.AddItem(Whirlwind());
	Templates.AddItem(Commissar());
	Templates.AddItem(Bombardier());
	Templates.AddItem(Failsafe());
	Templates.AddItem(Bastion());
	Templates.AddItem(BastionPassive());
	Templates.AddItem(BastionCleanse());
	Templates.AddItem(Sapper());
	Templates.AddItem(NeedleGrenades());

	return Templates;
}

// Perk name:		Center Mass
// Perk effect:		You do increased base damage when using guns.
// Localized text:	"You do <Ability:CENTERMASS_DAMAGE/> additional point of base damage when using guns."
// Config:			(AbilityName="LW2WotC_CenterMass", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate CenterMass()
{
	local X2Effect_LW2WotC_PrimaryHitBonusDamage        DamageEffect;

	// Primary weapon bonus damage comes from XComClassData.ini setup. Secondary weapons are based on the includes below
	DamageEffect = new class'X2Effect_LW2WotC_PrimaryHitBonusDamage';
	DamageEffect.BonusDmg = default.CENTERMASS_DAMAGE;
	DamageEffect.includepistols = true;
	DamageEffect.includesos = true;
	DamageEffect.includemachinepistols = true;

	// Create the template using a helper function
	return Passive('LW2WotC_CenterMass', "img:///UILibrary_LW_PerkPack.LW_AbilityCenterMass", true, DamageEffect);
}

// Perk name:		Lethal
// Perk effect:		You do increased base damage with your primary weapon.
// Localized text:	"You do <Ability:LETHAL_DAMAGE/> additional points of base damage with your primary weapon."
// Config:			(AbilityName="LW2WotC_Lethal", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate Lethal()
{
	local X2Effect_LW2WotC_PrimaryHitBonusDamage        DamageEffect;

	// Primary weapon bonus damage comes from XComClassData.ini setup. Secondary weapons are based on the includes below
	DamageEffect = new class'X2Effect_LW2WotC_PrimaryHitBonusDamage';
	DamageEffect.BonusDmg = default.LETHAL_DAMAGE;
	DamageEffect.includepistols = false;
	DamageEffect.includesos = false;
	DamageEffect.includemachinepistols = false;

	// Create the template using a helper function
	return Passive('LW2WotC_Lethal', "img:///UILibrary_LW_PerkPack.LW_AbilityKinetic", true, DamageEffect);
}

// Perk name:		Hit and Run
// Perk effect:		Gain an additional action after taking a standard shot at a flanked or exposed target with your primary weapon.
// Localized text:	"Gain an additional action after taking a standard shot at a flanked or exposed target with your primary weapon. <Ability:HNR_USES_PER_TURN/>"
// Config:			(AbilityName="LW2WotC_HitandRun", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate HitAndRun()
{
	local X2Effect_LW2WotC_HitandRun				HitandRunEffect;

	// Hit and run effect that grants a full action
	HitandRunEffect = new class'X2Effect_LW2WotC_HitandRun';
	HitandRunEffect.DuplicateResponse = eDupe_Ignore;
	HitandRunEffect.HITANDRUN_FULLACTION = true;

	// Create the template using a helper function
	return Passive('LW2WotC_HitandRun', "img:///UILibrary_LW_PerkPack.LW_AbilityHitandRun", false, HitandRunEffect);
}

// Perk name:		Hit and Slither
// Perk effect:		Gain an additional move action after taking a standard shot at a flanked or exposed target with your primary weapon.
// Localized text:	"Gain an additional move action after taking a standard shot at a flanked or exposed target with your primary weapon. <Ability:HNR_USES_PER_TURN/>"
// Config:			(AbilityName="LW2WotC_HitandSlither", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate HitAndSlither()
{
	local X2Effect_LW2WotC_HitandRun				HitandRunEffect;

	// Hit and run effect that grants a movement action
	HitandRunEffect = new class'X2Effect_LW2WotC_HitandRun';
	HitandRunEffect.DuplicateResponse = eDupe_Ignore;
	HitandRunEffect.HITANDRUN_FULLACTION=false;

	// Create the template using a helper function
	return Passive('LW2WotC_HitandSlither', "img:///UILibrary_LW_PerkPack.LW_AbilityHitandRun", false, HitandRunEffect);
}

// Perk name:		Close Combat Specialist
// Perk effect:		During enemy turns, fire a free reaction shot with your primary weapon at any nearby visible enemy who moves or fires.
// Localized text:	"During enemy turns, fire a free reaction shot with your primary weapon at any visible enemy within <Ability:CCS_RANGE/> who moves or fires."
// Config:			(AbilityName="LW2WotC_CloseCombatSpecialist", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate CloseCombatSpecialist()
{
	local X2AbilityTemplate                 Template;

	// Pure passive, most of the functionality is in the additional ability
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
	local X2Condition_Visibility						TargetVisibilityCondition;
	local X2AbilityCost_Ammo							AmmoCost;
	local X2AbilityTarget_LW2WotC_Single_CCS			SingleTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_CloseCombatSpecialistAttack');

	// Boilerplate setup
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseCombatSpecialist";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bCrossClassEligible = false;

	// Standard aim calculation
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bReactionFire = true;
	Template.AbilityToHitCalc = ToHitCalc;
	 
	// Configurable ammo cost
	AmmoCost = new class 'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.CCS_AMMO_PER_SHOT;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	// Trigger on movement
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'PostBuildGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	// Trigger on an attack
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	// It may be the case that enemy movement caused a concealment break, which made Bladestorm applicable - attempt to trigger afterwards
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = CloseCombatSpecialistConcealmentListener;
	EventListener.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(EventListener);
	
	// Special target conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	// Don't trigger while disoriented, burning, etc.
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	// Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	// Don't trigger while suppressed, if configured
	HandleSuppressionRestriction(Template);

	// Effect that limits the range of the reaction shot
	SingleTarget = new class 'X2AbilityTarget_LW2WotC_Single_CCS';
	Template.AbilityTargetStyle = SingleTarget;

	// Can shred and apply ammo effects
	Template.bAllowBonusWeaponEffects = true;
	Template.AddTargetEffect(class 'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	// Prevent repeatedly hammering on a unit when CCS triggers.
	// (This effect does nothing, but enables many-to-many marking of which CCS attacks have already occurred each turn.)
	CloseCombatSpecialistTargetEffect = new class'X2Effect_Persistent';
	CloseCombatSpecialistTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	CloseCombatSpecialistTargetEffect.EffectName = 'CloseCombatSpecialistTarget';
	CloseCombatSpecialistTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(CloseCombatSpecialistTargetEffect);

	CloseCombatSpecialistTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	CloseCombatSpecialistTargetCondition.AddExcludeEffect('CloseCombatSpecialistTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(CloseCombatSpecialistTargetCondition);

	// Visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;

	// Standard interactions with Shadow, Chosen, and the Lost
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

// Must be static, because it will be called with a different object (an XComGameState_Ability)
// Used to trigger Bladestorm when the source's concealment is broken by a unit in melee range (the regular movement triggers get called too soon)
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

// Perk name:		Close and Personal
// Perk effect:		Confers bonus critical chance against adjacent targets. The bonus declines with distance from the target.
// Localized text:	"Confers +30 critical chance against adjacent targets. The bonus declines with distance from the target."
// Config:			(AbilityName="LW2WotC_CloseAndPersonal")
static function X2AbilityTemplate CloseAndPersonal()
{
	local X2Effect_LW2WotC_CloseandPersonal		CritModifier;

	// Effect granting bonus crit chance depending on range
	CritModifier = new class 'X2Effect_LW2WotC_CloseandPersonal';

	// Create the template using a helper function
	return Passive('LW2WotC_CloseandPersonal', "img:///UILibrary_LW_PerkPack.LW_AbilityCloseandPersonal", false, CritModifier);
}

// Perk name:		Damn Good Ground
// Perk effect:		Confers bonus aim and defense against targets at a lower elevation.
// Localized text:	"Confers +<Ability:DGG_AIM_BONUS/> aim and +<Ability:DGG_DEF_BONUS/> defense against targets at a lower elevation."
// Config:			(AbilityName="LW2WotC_DamnGoodGround", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate DamnGoodGround()
{
	local X2Effect_LW2WotC_DamnGoodGround			AimandDefModifiers;

	// Effect granting bonus aim and defense against lower elevation targets
	AimandDefModifiers = new class 'X2Effect_LW2WotC_DamnGoodGround';

	// Create the template using a helper function
	return Passive('LW2WotC_DamnGoodGround', "img:///UILibrary_LW_PerkPack.LW_AbilityDamnGoodGround", true, AimandDefModifiers);
}

// Perk name:		Executioner
// Perk effect:		Confers bonus aim and critical chance against targets at half or less of their original hit points.
// Localized text:	"Confers +<Ability:EXECUTIONER_AIM_BONUS/> aim and +<Ability:EXECUTIONER_CRIT_BONUS/> critical chance against targets at half or less of their original hit points."
// Config:			(AbilityName="LW2WotC_Executioner")
static function X2AbilityTemplate Executioner()
{
	local X2Effect_LW2WotC_Executioner		AimandCritModifiers;

	// Effect granting aim and crit bonuses against targets at half or less health
	AimandCritModifiers = new class 'X2Effect_LW2WotC_Executioner';

	// Create the template using a helper function
	return Passive('LW2WotC_Executioner', "img:///UILibrary_LW_PerkPack.LW_AbilityExecutioner", true, AimandCritModifiers);
}

// Perk name:		Resilience
// Perk effect:		Enemy attacks against you suffer a penalty to critical hit chances.
// Localized text:	"Enemy attacks against you suffer a -<Ability:RESILIENCE_CRITDEF_BONUS/> penalty to critical hit chances."
// Config:			(AbilityName="LW2WotC_Resilience")
static function X2AbilityTemplate Resilience()
{
	local X2Effect_LW2WotC_Resilience				CritModifierEffect;

	// Effect that reduces crit chance against the owner of this passive
	CritModifierEffect = new class 'X2Effect_LW2WotC_Resilience';
	CritModifierEffect.CritDef_Bonus = default.RESILIENCE_CRITDEF_BONUS;

	// Create the template using a helper function
	return Passive('LW2WotC_Resilience', "img:///UILibrary_LW_PerkPack.LW_AbilityResilience", true, CritModifierEffect);
}

// Perk name:		Tactical Sense
// Perk effect:		Gain bonus defense for each enemy you can see, up to a specified maximum.
// Localized text:	"Gain +<Ability:TACTICAL_SENSE_DEF_BONUS_PER_ENEMY/> defense for each enemy you can see, up to a maximum of +<Ability:TACTICAL_SENSE_MAX_DEF_BONUS/> defense."
// Config:			(AbilityName="LW2WotC_TacticalSense")
static function X2AbilityTemplate TacticalSense()
{
	local X2Effect_LW2WotC_TacticalSense		DefenseEffect;

	// Effect granting tactical sense defense bonuses
	DefenseEffect = new class 'X2Effect_LW2WotC_TacticalSense';

	// Create the template using a helper function
	return Passive('LW2WotC_TacticalSense', "img:///UILibrary_LW_PerkPack.LW_AbilityTacticalSense", true, DefenseEffect);
}

// Perk name:		Aggression
// Perk effect:		Gain bonus critical chance for each enemy you can see, up to a specified maximum.
// Localized text:	"Gain +<Ability:AGGRESSION_CRIT_BONUS_PER_ENEMY/> critical chance for each enemy you can see, up to a maximum of +<Ability:AGGRESSION_MAX_CRIT_BONUS/>."
// Config:			(AbilityName="LW2WotC_Aggression", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate Aggression()
{
	local X2Effect_LW2WotC_Aggression			CritEffect;

	// Effect graning aggression crit bonus
	CritEffect = new class 'X2Effect_LW2WotC_Aggression';

	// Create the template using a helper function
	return Passive('LW2WotC_Aggression', "img:///UILibrary_LW_PerkPack.LW_AbilityAggression", true, CritEffect);
}

// Perk name:		Bring 'Em On
// Perk effect:		Gain bonus critical damage for each enemy you can see, up to a specified maximum.
// Localized text:	"Gain +<Ability:BEO_BONUS_CRIT_DAMAGE_PER_ENEMY/> damage on critical hits for every two enemies you can see, up to a maximum of +<Ability:BEO_MAX_BONUS_CRIT_DAMAGE/>."
// Config:			(AbilityName="LW2WotC_BringEmOn", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate BringEmOn()
{
	local X2Effect_LW2WotC_BringEmOn		   DamageEffect;

	// Effect granting bring em on crit damage bonus
	DamageEffect = new class'X2Effect_LW2WotC_BringEmOn';

	// Create the template using a helper function
	return Passive('LW2WotC_BringEmOn', "img:///UILibrary_LW_PerkPack.LW_AbilityBringEmOn", true, DamageEffect);
}

// Perk name:		Hard Target
// Perk effect:		Gain bonus dodge for each enemy you can see, up to a specified maximum.
// Localized text:	"Gain +<Ability:HT_DODGE_BONUS_PER_ENEMY/> dodge per enemy you can see, up to a maximum of +<Ability:HT_MAX_DODGE_BONUS/>."
// Config:			(AbilityName="LW2WotC_HardTarget")
static function X2AbilityTemplate HardTarget()
{
	local X2Effect_LW2WotC_HardTarget			DodgeBonus;
		
	// Effect granting hard target dodge bonus
	DodgeBonus = new class 'X2Effect_LW2WotC_HardTarget';

	// Create the template using a helper function
	return Passive('LW2WotC_HardTarget', "img:///UILibrary_LW_PerkPack.LW_AbilityHardTarget", true, DodgeBonus);
}

// Perk name:		Infighter
// Perk effect:		Gain bonus dodge against close-range attacks.
// Localized text:	"Gain +<Ability:INFIGHTER_DODGE_BONUS/> dodge against attacks within <Ability:INFIGHTER_MAX_TILES/> tiles."
// Config:			(AbilityName="LW2WotC_Infighter")
static function X2AbilityTemplate Infighter()
{
	local X2Effect_LW2WotC_Infighter					DodgeBonus;

	// Effect granting infighter dodge bonus
	DodgeBonus = new class 'X2Effect_LW2WotC_Infighter';

	// Create the template using a helper function
	return Passive('LW2WotC_Infighter', "img:///UILibrary_LW_PerkPack.LW_AbilityInfighter", true, DodgeBonus);
}

// Perk name:		Depth Perception
// Perk effect:		Gain aim and reduce enemies' dodge when at a higher elevation than your target.
// Localized text:	"Gain <Ability:DP_AIM_BONUS/> aim and reduce enemies' dodge by <Ability:DP_ANTIDODGE_BONUS/> when at a higher elevation than your target."
// Config:			(AbilityName="LW2WotC_DepthPerception")
static function X2AbilityTemplate DepthPerception()
{
	local X2Effect_LW2WotC_DepthPerception				AttackBonus;

	// Effect granting bonuses
	AttackBonus = new class 'X2Effect_LW2WotC_DepthPerception';

	// Create the template using a helper function
	return Passive('LW2WotC_DepthPerception', "img:///UILibrary_LW_PerkPack.LW_AbilityDepthPerception", false, AttackBonus);
}

// Perk name:		Will to Survive
// Perk effect:		Enemy damage is reduced when in cover and attacked through that cover. Also grants bonus Will.
// Localized text:	"Enemy damage is reduced when in cover and attacked through that cover. High cover reduces damage by <Ability:W2S_HIGH_COVER_ARMOR_BONUS/>. Low cover reduces damage by <Ability:W2S_LOW_COVER_ARMOR_BONUS/>. Also grants <Ability:WILLTOSURVIVE_WILLBONUS/> will."
// Config:			(AbilityName="LW2WotC_WilltoSurvive")
static function X2AbilityTemplate WillToSurvive()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LW2WotC_WilltoSurvive		ArmorBonus;
	local X2Effect_PersistentStatChange			WillBonus;

	// The armor bonus through cover
	ArmorBonus = new class 'X2Effect_LW2WotC_WilltoSurvive';

	// Create the template using a helper function
	Template = Passive('LW2WotC_WilltoSurvive', "img:///UILibrary_LW_PerkPack.LW_AbilityWilltoSurvive", true, ArmorBonus);

	// The will bonus
	WillBonus = new class'X2Effect_PersistentStatChange';
	WillBonus.AddPersistentStatChange(eStat_Will, float(default.WILLTOSURVIVE_WILLBONUS));
	WillBonus.BuildPersistentEffect (1, true, false, false, 7);
	Template.AddTargetEffect(WillBonus);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, default.WILLTOSURVIVE_WILLBONUS);

	return Template;
}

// Perk name:		Light 'Em Up
// Perk effect:		Taking a standard shot with your primary weapon as your first action no longer ends your turn.
// Localized text:	"Taking a standard shot with your primary weapon as your first action no longer ends your turn."
// Config:			(AbilityName="LW2WotC_LightEmUp")
static function X2AbilityTemplate LightEmUp()
{
	local X2AbilityTemplate			Template;

	// The standard shot ability will check if the shooter has this ability. If they do, the shot won't end the shooter's turn
	Template = PurePassive('LW2WotC_LightEmUp', "img:///UILibrary_LW_PerkPack.LW_AbilityLightEmUp");

	return Template;
}

// Perk name:		Close Encounters
// Perk effect:		Gain a bonus action after taking a standard shot with your primary weapon at an enemy at close range.
// Localized text:	"Gain a bonus action after taking a standard shot with your primary weapon at an enemy within <Ability:CE_MAX_TILES/>. <Ability:CE_USES_PER_TURN/>"
// Config:			(AbilityName="LW2WotC_CloseEncounters",	ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate CloseEncounters()
{
	local X2AbilityTemplate							Template;
	local X2Effect_LW2WotC_CloseEncounters			ActionEffect;
	
	// The close encounters effect
	ActionEffect = new class 'X2Effect_LW2WotC_CloseEncounters';

	// Create the template using a helper function
	Template = Passive('LW2WotC_CloseEncounters', "img:///UILibrary_LW_PerkPack.LW_AbilityCloseEncounters", false, ActionEffect);

	// Needs to be off to allow perks
	Template.bIsPassive = false;  

	return Template;
}

// Perk name:		Lone Wolf
// Perk effect:		Gain bonus, aim, critical chance, and defense when distant from allies.
// Localized text:	"Gain +<Ability:LONEWOLF_AIM_BONUS/> aim, +<Ability:LONEWOLF_CRIT_BONUS/> critical chance, and +<Ability:LONEWOLF_DEF_BONUS/> defense when <Ability:LONEWOLF_MIN_DIST_TILES/> or more tiles distant from any ally."
// Config:			(AbilityName="LW2WotC_LoneWolf", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate LoneWolf()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_LoneWolf			AimandDefModifiers;

	// Lone wolf effect
	AimandDefModifiers = new class 'X2Effect_LW2WotC_LoneWolf';

	// Create the template using a helper function
	Template = Passive('LW2WotC_LoneWolf', "img:///UILibrary_LW_PerkPack.LW_AbilityLoneWolf", true, AimandDefModifiers);

	return Template;		
}

// Perk name:		Low Profile
// Perk effect:		Makes partial cover count as full.
// Localized text:	"Makes partial cover count as full."
// Config:			(AbilityName="LW2WotC_LowProfile")
static function X2AbilityTemplate LowProfile()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_LowProfile		DefModifier;

	// Low profile effect
	DefModifier = new class 'X2Effect_LW2WotC_LowProfile';

	// Create the template using a helper function
	Template = Passive('LW2WotC_LowProfile', "img:///UILibrary_LW_PerkPack.LW_AbilityLowProfile", true, DefModifier);

	return Template;
}

// Perk name:		Hyper-Reactive Pupils
// Perk effect:		Gain bonus aim for your next shot with your primary weapon after a miss.
// Localized text:	"Gain +<Ability:HYPERREACTIVE_PUPILS_AIM_BONUS/> aim for your next shot with your primary weapon after a miss."
// Config:			(AbilityName="LW2WotC_HyperReactivePupils")
static function X2AbilityTemplate HyperReactivePupils()
{
	local X2AbilityTemplate                 		Template;	
	local X2Effect_LW2WotC_HyperReactivePupils		HyperReactivePupilsEffect;

	// Effect granting aim after a miss
	HyperReactivePupilsEffect = new class'X2Effect_LW2WotC_HyperReactivePupils';

	// Create the template using a helper function
	Template = Passive('LW2WotC_HyperReactivePupils', "img:///UILibrary_LW_PerkPack.LW_AbilityHyperreactivePupils", false, HyperReactivePupilsEffect);

	return Template;
}

// Perk name:		Locked On
// Perk effect:		Gain bonus aim and crit for successive shots with your primary weapon at the same enemy unit.
// Localized text:	"Gain +<Ability:LOCKEDON_AIM_BONUS/> aim and +<Ability:LOCKEDON_CRIT_BONUS/> crit for successive shots with your primary weapon at the same enemy unit."
// Config:			(AbilityName="LW2WotC_LockedOn", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate LockOn()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_LockedOn			LockedOnEffect;

	// Locked on effect
	LockedOnEffect = new class'X2Effect_LW2WotC_LockedOn';

	// Create the template using a helper function
	Template = Passive('LW2WotC_LockedOn', "img:///UILibrary_LW_PerkPack.LW_AbilityLockedOn", true, LockedOnEffect);

	return Template;
}

// Perk name:		Sentinel
// Perk effect:		When in overwatch, you may take additional reaction shots.
// Localized text:	"When in overwatch, you may take <Ability:SENTINEL_LW_USES_PER_TURN/> reaction shots."
// Config:			(AbilityName="LW2WotC_Sentinel", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate Sentinel()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_Sentinel			PersistentEffect;

	// Sentinel effect
	PersistentEffect = new class'X2Effect_LW2WotC_Sentinel';

	// Create the template using a helper function
	Template = Passive('LW2WotC_Sentinel', "img:///UILibrary_LW_PerkPack.LW_AbilitySentinel", false, PersistentEffect);
	Template.bIsPassive = false;

	return Template;
}

// Perk name:		Rapid Reaction
// Perk effect:		When in overwatch, each shot you hit with grants another reaction fire shot, up to a specified maximum.
// Localized text:	"When in overwatch, each shot you hit with grants another reaction fire shot, up to a maximum of <Ability:RAPID_REACTION_USES_PER_TURN/> shots."
// Config:			(AbilityName="LW2WotC_RapidReaction", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate RapidReaction()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_RapidReaction	PersistentEffect;

	// Rapid reaction effect
	PersistentEffect = new class'X2Effect_LW2WotC_RapidReaction';

	// Create the template using a helper function
	Template = Passive('LW2WotC_RapidReaction', "img:///UILibrary_LW_PerkPack.LW_AbilityRapidReaction3", false, PersistentEffect);
	Template.bIsPassive = false;

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
	return Passive('LW2WotC_Cutthroat', "img:///UILibrary_LW_PerkPack.LW_AbilityCutthroat", false, Effect);
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

// Perk name:		Sting Grenades
// Perk effect:		Your flashbang grenades have a chance to stun enemies for one turn in the flashbang's Area of Effect.
// Localized text:	"Your flashbang grenades have a <Ability:STING_GRENADE_STUN_CHANCE>% chance to stun enemies for one turn in the flashbang's Area of Effect."
// Config:			(AbilityName="LW2WotC_StingGrenades")
static function X2AbilityTemplate StingGrenades()
{
	return Passive('LW2WotC_StingGrenades', "img:///UILibrary_LW_PerkPack.LW_AbilityStunGrenades", false, none);
}

// This effect is applied to Flashbangs in X2DownloadableContentInfo_LongWar2AbilitiesforWotC.uc
static function X2Effect StingGrenadesEffect()
{
	local X2Effect_Stunned 					StunnedEffect;
	local XMBCondition_SourceAbilities 		Condition;
	local X2Condition_UnitProperty			UnitCondition;

	// Stun effect for sting grenades
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.STING_GRENADE_STUN_LEVEL, default.STING_GRENADE_STUN_CHANCE);
	StunnedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.StunnedFriendlyName, class'X2StatusEffects'.default.StunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");

	// Stun effect will only apply to organics
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeRobotic = true;
	StunnedEffect.TargetConditions.AddItem(UnitCondition);

	// Only applies if the thrower has Sting Grenades
	Condition = new class'XMBCondition_SourceAbilities';
	Condition.AddRequireAbility('LW2WotC_StingGrenades', 'AA_UnitIsImmune');
	StunnedEffect.TargetConditions.AddItem(Condition);

	return StunnedEffect;
}

// Perk name:		Bluescreen Bombs
// Perk effect:		Your flashbang grenades now disorient robotic units and reduce their resistance to hacking.
// Localized text:	"Your flashbang grenades now disorient robotic units and reduce their resistance to hacking."
// Config:			(AbilityName="LW2WotC_BluescreenBombs")
static function X2AbilityTemplate BluescreenBombs()
{
	return Passive('LW2WotC_BluescreenBombs', "img:///UILibrary_LW_PerkPack.LW_AbilityBluescreenBombs", false, none);
}

// This effect is applied to Flashbangs in X2DownloadableContentInfo_LongWar2AbilitiesforWotC.uc
static function X2Effect BluescreenBombsDisorientEffect()
{
	local X2Effect_PersistentStatChange		DisorientEffect;
	local X2Condition_UnitProperty			UnitCondition;
	local XMBCondition_SourceAbilities 		Condition;

	// Create the disorient effect
	DisorientEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(false, 0.0f, false);

	// The vanilla CreateDisorientedStatusEffect() function will not work on robots, so remove those conditions so we can change that
	DisorientEffect.TargetConditions.Length = 0;

	// This effect will work on robots, but not organics. This is because the disorient effect that is already on the flashbang by default will handle organics
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = true;
	UnitCondition.ExcludeFriendlyToSource = true;
	DisorientEffect.TargetConditions.AddItem(UnitCondition);

	// Only applies if the thrower has Bluescreen Bombs
	Condition = new class'XMBCondition_SourceAbilities';
	Condition.AddRequireAbility('LW2WotC_BluescreenBombs', 'AA_UnitIsImmune');
	DisorientEffect.TargetConditions.AddItem(Condition);

	return DisorientEffect;
}

//This is an effect which will be added to the existing flashbang/sting grenade item/ability
static function X2Effect BluescreenBombsHackReductionEffect()
{
	local X2Effect_PersistentStatChange		HackDefenseChangeEffect;
	local XMBCondition_SourceAbilities 		Condition;
	local X2Condition_UnitProperty			UnitCondition;

	// Create the hack defense reduction effect
	HackDefenseChangeEffect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(default.BLUESCREENBOMB_HACK_DEFENSE_CHANGE);

	// This effect will only work on robots
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = true;
	UnitCondition.ExcludeFriendlyToSource = true;
	HackDefenseChangeEffect.TargetConditions.AddItem(UnitCondition);

	// Only applies if the thrower has Bluescreen Bombs
	Condition = new class'XMBCondition_SourceAbilities';
	Condition.AddRequireAbility('LW2WotC_BluescreenBombs', 'AA_UnitIsImmune');
	HackDefenseChangeEffect.TargetConditions.AddItem(Condition);

	return HackDefenseChangeEffect;
}

// Perk name:		Grazing Fire
// Perk effect:		Missed shots with your primary weapon have an additional roll to become a graze.
// Localized text:	"Missed shots with your primary weapon have an additional roll to become a graze."
// Config:			(AbilityName="LW2WotC_GrazingFire", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate GrazingFire()
{
	local X2Effect_LW2WotC_GrazingFire		GrazingEffect;

	GrazingEffect = new class'X2Effect_LW2WotC_GrazingFire';
	GrazingEffect.SuccessChance = default.GRAZING_FIRE_SUCCESS_CHANCE;

	return Passive('LW2WotC_GrazingFire', "img:///UILibrary_LW_PerkPack.LW_AbilityGrazingFire", true, GrazingEffect);
}

// Perk name:		Combat Fitness
// Perk effect:		Gain bonuses to aim, mobility, HP, will, and dodge.
// Localized text:	"Gain <ABILITY:COMBAT_FITNESS_OFFENSE/> aim, <ABILITY:COMBAT_FITNESS_MOBILITY/> mobility, <ABILITY:COMBAT_FITNESS_HP/> HP, <ABILITY:COMBAT_FITNESS_WILL/> will, and <ABILITY:COMBAT_FITNESS_DODGE/> dodge."
// Config:			(AbilityName="LW2WotC_CombatFitness")
static function X2AbilityTemplate CombatFitness()
{
	local X2Effect_PersistentStatChange			StatEffect;
	local X2AbilityTemplate 					Template;

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_HP, float(default.COMBAT_FITNESS_HP));
	StatEffect.AddPersistentStatChange(eStat_Offense, float(default.COMBAT_FITNESS_OFFENSE));
	StatEffect.AddPersistentStatChange(eStat_Mobility, float(default.COMBAT_FITNESS_MOBILITY));
	StatEffect.AddPersistentStatChange(eStat_Dodge, float(default.COMBAT_FITNESS_DODGE));
	StatEffect.AddPersistentStatChange(eStat_Will, float(default.COMBAT_FITNESS_WILL));

	Template = Passive('LW2WotC_CombatFitness', "img:///UILibrary_LW_PerkPack.LW_AbilityExtraConditioning", true, StatEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, default.COMBAT_FITNESS_HP);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, default.COMBAT_FITNESS_OFFENSE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.COMBAT_FITNESS_MOBILITY);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, default.COMBAT_FITNESS_DODGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, default.COMBAT_FITNESS_WILL);

	return Template;
}

// Perk name:		Sprinter
// Perk effect:		Gain bonus mobility.
// Localized text:	"Gain <ABILITY:SPRINTER_MOBILITY/> mobility."
// Config:			(AbilityName="LW2WotC_Sprinter")
static function X2AbilityTemplate Sprinter()
{
	local X2Effect_PersistentStatChange			StatEffect;
	local X2AbilityTemplate 					Template;

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_Mobility, float(default.SPRINTER_MOBILITY));

	Template = Passive('LW2WotC_Sprinter', "img:///UILibrary_LW_PerkPack.LW_AbilityExtraConditioning", true, StatEffect);;
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SPRINTER_MOBILITY);

	return Template;
}

// Perk name:		Alpha Mike Foxtrot
// Perk effect:		You do greatly increased damage with your primary weapon.
// Localized text:	"You do <Ability:ALPHAMIKEFOXTROT_DAMAGE/> additional points of base damage with your primary weapon."
// Config:			(AbilityName="LW2WotC_AlphaMikeFoxtrot", ApplyToWeaponSlot=eInvSlot_PrimaryWeapon)
static function X2AbilityTemplate AlphaMikeFoxtrot()
{
	local X2Effect_LW2WotC_PrimaryHitBonusDamage        DamageEffect;

	// Primary weapon bonus damage comes from XComClassData.ini setup. Secondary weapons are based on the includes below
	DamageEffect = new class'X2Effect_LW2WotC_PrimaryHitBonusDamage';
	DamageEffect.BonusDmg = default.ALPHAMIKEFOXTROT_DAMAGE;
	DamageEffect.includepistols = false;
	DamageEffect.includesos = false;
	DamageEffect.includemachinepistols = false;

	// Create the template using a helper function
	return Passive('LW2WotC_AlphaMikeFoxtrot', "img:///UILibrary_LW_PerkPack.LW_AbilityAMF", false, DamageEffect);
}

// Perk name:		Coup de Grace
// Perk effect:		Bonus to hit, damage, and critical chance with a melee weapon against a disoriented, stunned or panicking enemy.
// Localized text:	"Bonus to hit, damage, and critical chance with a melee weapon against a disoriented, stunned or panicking enemy."
// Config:			(AbilityName="LW2WotC_CoupDeGrace", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate CoupDeGrace()
{
	local X2Effect_LW2WotC_CoupDeGrace CoupDeGraceEffect;

	// Bonus granting aim, crit, and damage bonuses on secondary weapon attacks on afflicted targets
	CoupDeGraceEffect = new class'X2Effect_LW2WotC_CoupDeGrace';
	CoupDeGraceEffect.To_Hit_Modifier=default.COUP_DE_GRACE_HIT_BONUS;
	CoupDeGraceEffect.Crit_Modifier=default.COUP_DE_GRACE_CRIT_BONUS;
	CoupDeGraceEffect.Damage_Bonus=default.COUP_DE_GRACE_DAMAGE_BONUS;
	CoupDeGraceEffect.Half_for_Disoriented=default.COUP_DE_GRACE_HALF_FOR_DISORIENTED;

	// Create the template using a helper function
	return Passive('LW2WotC_CoupDeGrace', "img:///UILibrary_LW_PerkPack.LW_AbilityCoupDeGrace", false, CoupDeGraceEffect);
}

// Perk name:		Boosted Cores
// Perk effect:		Explosive grenades do additional damage.
// Localized text:	"Explosive grenades do <Ability:BOOSTED_CORES_DAMAGE> additional damage."
// Config:			(AbilityName="LW2WotC_BoostedCores")
static function X2AbilityTemplate BoostedCores()
{
	local X2Effect_VolatileMix				DamageEffect;

	// Effect that grants additional damage to grenades
	// This is confusing, but X2Effect_VolatileMix grants a damage bonus to grenades, and does not apply a radius bonus
	DamageEffect = new class'X2Effect_VolatileMix';
	DamageEffect.BonusDamage = default.BOOSTED_CORES_DAMAGE;

	// Create the template using a helper function
	return Passive('LW2WotC_BoostedCores', "img:///UILibrary_LW_PerkPack.LW_AbilityHeavyFrags", true, DamageEffect);
}

// Perk name:		Volatile Mix
// Perk effect:		Your grenades' area of effect is increased by one tile.
// Localized text:	"Your grenades' area of effect is increased by one tile."
// Config:			(AbilityName="LW2WotC_VolatileMix")
static function X2AbilityTemplate VolatileMix()
{
	// Create the template using a helper function
	// The range bonus is actually granted by X2DownloadableContentInfo_LongWar2AbilitiesforWotC.PatchBaseGameThrowGrenadeForLW2WotC_VolatileMix()
	return Passive('LW2WotC_VolatileMix', "img:///UILibrary_PerkIcons.UIPerk_volatilemix", true, none);
}

// Perk name:		Flashbanger
// Perk effect:		Grants one free flashbang grenade item to your inventory.
// Localized text:	"Grants one free flashbang grenade item to your inventory."
// Config:			(AbilityName="LW2WotC_Flashbanger")
static function X2AbilityTemplate Flashbanger()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AddUtilityItem ItemEffect;

	// Adds a free smoke grenade
	ItemEffect = new class'XMBEffect_AddUtilityItem';
	ItemEffect.DataName = 'FlashbangGrenade';

	// Create the template using a helper function
	Template = Passive('LW2WotC_Flashbanger', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash", true, ItemEffect);

	return Template;
}

// Perk name:		Evasive
// Perk effect:		Start each mission with 100 bonus dodge. The bonus is removed after you take damage for the first time.
// Localized text:	"Start each mission with 100 bonus dodge. The bonus is removed after you take damage for the first time."
// Config:			(AbilityName="LW2WotC_Evasive")
static function X2AbilityTemplate Evasive()
{
	local X2AbilityTemplate					Template;	
	local X2Effect_PersistentStatChange		DodgeBonus;

	// Effect grants 100 dodge, which should be enough to always guarentee a dodge
	DodgeBonus = new class'X2Effect_PersistentStatChange';
	DodgeBonus.EffectName='LW2WotC_Evasive_Passive';
	DodgeBonus.AddPersistentStatChange (eStat_Dodge, float (100));

	// Create the template using a helper function
	Template = Passive('LW2WotC_Evasive', "img:///UILibrary_LW_PerkPack.LW_AbilityEvasive", true, DodgeBonus);

	// Add a secondary ability that will remove the Evasive effect when taking damage
	AddSecondaryAbility(Template, EvasiveRemover(), false);

	return Template;
}

// The part of Evasive that removes the dodge bonus after taking damage
static function X2AbilityTemplate EvasiveRemover()
{
	local X2AbilityTemplate				Template;	
	local X2Effect_RemoveEffects		RemoveEffect;
	local X2Condition_UnitEffects		Condition;

	// Removes the Evasive dodge bonus, with a flyover
	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem('LW2WotC_Evasive_Passive');

	// Create the template using a helper function - the effects of this ability will activate when damage is taken
	Template = SelfTargetTrigger('LW2WotC_Evasive_Remover', "img:///UILibrary_LW_PerkPack.LW_AbilityEvasive", false, RemoveEffect, 'UnitTakeEffectDamage');

	// Show a flyover when Evasive is being removed
	Template.bShowActivation = true;

	// Prevents this ability from triggering if you've already lost the Evasive bonus
	Condition = new class'X2Condition_UnitEffects';
    Condition.AddRequireEffect('LW2WotC_Evasive_Passive', 'AA_EvasiveEffectPresent');
	AddTriggerTargetCondition(Template, Condition);

	return Template;
}

// Perk name:		Iron Skin
// Perk effect:		Incoming melee damage is reduced.
// Localized text:	"Incoming melee damage is reduced by <Ability:IRON_SKIN_MELEE_DAMAGE_REDUCTION>."
// Config:			(AbilityName="LW2WotC_IronSkin")
static function X2AbilityTemplate IronSkin()
{
	local X2Effect_LW2WotC_MeleeDamageAdjust	IronSkinEffect;

	// Effect that reduces incoming melee damage
	IronSkinEffect = new class'X2Effect_LW2WotC_MeleeDamageAdjust';
	IronSkinEffect.DamageMod = -default.IRON_SKIN_MELEE_DAMAGE_REDUCTION;

	// Create the template using a helper function
	return Passive('LW2WotC_IronSkin', "img:///UILibrary_LW_PerkPack.LW_AbilityIronSkin", false, IronSkinEffect);
}

// Perk name:		Combat Awareness
// Perk effect:		Grants bonus defense and bonus armor when in overwatch.
// Localized text:	"Grants <Ability:COMBAT_AWARENESS_BONUS_DEFENSE> defense <Ability:COMBAT_AWARENESS_BONUS_ARMOR> armor point when in overwatch."
// Config:			(AbilityName="LW2WotC_CombatAwareness")
static function X2AbilityTemplate CombatAwareness()
{
	local X2Effect_LW2WotC_CombatAwareness	DefenseEffect;

	// Effect that gives armor while you have reserve action points
	DefenseEffect = new class'X2Effect_LW2WotC_CombatAwareness';

	// Create the template using a helper function
	return Passive('LW2WotC_CombatAwareness', "img:///UILibrary_LW_PerkPack.LW_AbilityThreatAssesment", false, DefenseEffect);
}

// Perk name:		Combat Rush
// Perk effect:		When you kill an enemy, nearby allies temporarily receive bonuses to aim, critical chance and mobility. Has an activation cooldown.
// Localized text:	"When you kill an enemy, nearby allies temporarily receive bonuses to aim, critical chance and mobility. Five-turn cooldown."
// Config:			(AbilityName="LW2WotC_CombatRush")
static function X2AbilityTemplate CombatRush()
{
	local X2Effect_PersistentStatChange Effect;
	local X2AbilityTemplate Template;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2Condition_UnitProperty AllyCondition;

	// Create the template using a helper function. This ability triggers when we kill another unit.
	Template = SelfTargetTrigger('LW2WotC_CombatRush', "img:///UILibrary_LW_PerkPack.LW_AbilityAdrenalNeurosympathy", true, none, 'KillMail');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// The ability effects all nearby units that meet the conditions on the multitarget effect.
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.NumTargetsRequired = 1; 
	RadiusMultiTarget.bIgnoreBlockingCover = true; 
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = false; 
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	RadiusMultiTarget.bUseWeaponRadius = false; 
	RadiusMultiTarget.ftargetradius = default.COMBAT_RUSH_RADIUS * 1.5; 
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	
	// Effect only works on allies
	AllyCondition = new class'X2Condition_UnitProperty';
	AllyCondition.RequireSquadmates = true;
	AllyCondition.ExcludeAlien = true;
	AllyCondition.ExcludeRobotic = true;
	AllyCondition.ExcludeHostileToSource = true;
	AllyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(AllyCondition);

	// Create a persistent stat change effect
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'LW2WotC_CombatRush';

	// Configurable bonuses and duration
	Effect.AddPersistentStatChange (eStat_Offense, float(default.COMBAT_RUSH_AIM_BONUS));
	Effect.AddPersistentStatChange (eStat_CritChance, float(default.COMBAT_RUSH_CRIT_BONUS));
	Effect.AddPersistentStatChange (eStat_Mobility, float(default.COMBAT_RUSH_MOBILITY_BONUS));
	Effect.AddPersistentStatChange (eStat_Defense, float(default.COMBAT_RUSH_DEFENSE_BONUS));
	Effect.AddPersistentStatChange (eStat_Dodge, float(default.COMBAT_RUSH_DODGE_BONUS));
	Effect.BuildPersistentEffect(default.COMBAT_RUSH_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo (ePerkBuff_Bonus,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	Effect.DuplicateResponse = eDupe_Refresh;

	// The effect only applies to living, friendly targets
	Effect.TargetConditions.AddItem(default.LivingFriendlyTargetProperty);

	// Allies affected will get a flyover and an animation
	Effect.VisualizationFn = CombatRush_Visualization;

	// The multitargets are also affected by the persistent effect we created
	Template.AddMultiTargetEffect(Effect);

	// Configurable cooldown
	AddCooldown(Template, default.COMBAT_RUSH_COOLDOWN);

	return Template;
}

// Allies that are affected by Combat Rush will get a flyover and an animation
simulated static function CombatRush_Visualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local EWidgetColor					MessageColor;
	local XComGameState_Unit			SourceUnit;
	local bool							bGoodAbility;
    local X2Action_PlayAnimation			PlayAnimationAction;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	
	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.SourceObject.ObjectID));

	bGoodAbility = SourceUnit.IsFriendlyToLocalPlayer();
	MessageColor = bGoodAbility ? eColor_Good : eColor_Bad;

	if (EffectApplyResult == 'AA_Success' && XGUnit(ActionMetadata.VisualizeActor).IsAlive())
	{
		PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	    PlayAnimationAction.Params.AnimName = 'HL_SignalAngryA';
		PlayAnimationAction.bFinishAnimationWait = true;

		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', MessageColor, AbilityTemplate.IconImage);
	}
}

// Perk name:		Full Kit
// Perk effect:		Grants additional charges per grenade item in a utility slot.
// Localized text:	"Grants +<Ability:FULL_KIT_BONUS> charge per grenade item in a utility slot."
// Config:			(AbilityName="LW2WotC_FullKit")
static function X2AbilityTemplate FullKit()
{
	local XMBEffect_AddItemCharges BonusItemEffect;

	// The number of charges and the items that are affected are gotten from the config
	BonusItemEffect = new class'XMBEffect_AddItemCharges';
	BonusItemEffect.PerItemBonus = default.FULL_KIT_BONUS;
	BonusItemEffect.ApplyToNames = default.FULL_KIT_ITEMS;
	BonusItemEffect.ApplyToSlots.AddItem(eInvSlot_Utility);

	// Create the template using a helper function
	return Passive('LW2WotC_FullKit', "img:///UILibrary_LW_PerkPack.LW_AbilityFullKit", false, BonusItemEffect);
}


// Perk name:		Savior
// Perk effect:		Healing abilities restore additional hit points.
// Localized text:	"Healing abilities restore <Ability:SAVIOR_BONUS_HEAL_AMMOUNT> additional hit points."
// Config:			(AbilityName="LW2WotC_Savior")
static function X2AbilityTemplate Savior()
{
	local X2Effect_LW2WotC_Savior				SaviorEffect;

	// This effect will add a listener to the soldier that listens for them to apply a heal.
	// When the heal is applied XComGameState_Effect_LW2WotC_Savior.OnMedkitHeal() is called to increase the potency of the heal.
	SaviorEffect = new class 'X2Effect_LW2WotC_Savior';

	// Create the template using a helper function
	return Passive('LW2WotC_Savior', "img:///UILibrary_LW_PerkPack.LW_AbilitySavior", true, SaviorEffect);
}

// Perk name:		Heavy Ordnance
// Perk effect:		Any damaging grenade in your grenade-only slot gains bonus uses.
// Localized text:	"Any damaging grenade in your grenade-only slot gains <Ability:HEAVY_ORDNANCE_BONUS_CHARGES> bonus use."
// Config:			(AbilityName="LW2WotC_HeavyOrdnance")
static function X2AbilityTemplate HeavyOrdnance()
{
	local X2Effect_LW2WotC_AddGrenadeSlotCharges BonusItemEffect;

	// Applies to all damaging grenades
	BonusItemEffect = new class'X2Effect_LW2WotC_AddGrenadeSlotCharges';
	BonusItemEffect.PerItemBonus = default.HEAVY_ORDNANCE_BONUS_CHARGES;
	BonusItemEffect.bDamagingGrenadesOnly = true;

	// Create the template using a helper function
	return Passive('LW2WotC_HeavyOrdnance', "img:///UILibrary_PerkIcons.UIPerk_aceinthehole", false, BonusItemEffect);
}

// Perk name:		Protector
// Perk effect:		Any non-damaging grenade in your grenade-only slot gains bonus uses.
// Localized text:	"Any non-damaging grenade in your grenade-only slot gains <Ability:PROTECTOR_BONUS_CHARGES> bonus use."
// Config:			(AbilityName="LW2WotC_Protector")
static function X2AbilityTemplate Protector()
{
	local X2Effect_LW2WotC_AddGrenadeSlotCharges BonusItemEffect;

	// Applies to all non-damaging grenades
	BonusItemEffect = new class'X2Effect_LW2WotC_AddGrenadeSlotCharges';
	BonusItemEffect.PerItemBonus = default.PROTECTOR_BONUS_CHARGES;
	BonusItemEffect.bNonDamagingGrenadesOnly = true;

	// Create the template using a helper function
	return Passive('LW2WotC_Protector', "img:///UILibrary_LW_PerkPack.LW_AbilityProtector", false, BonusItemEffect);
}

// Perk name:		HEAT Warheads
// Perk effect:		Your grenades now pierce and shred some armor.
// Localized text:	"Your grenades now pierce up to <Ability:HEAT_WARHEADS_PIERCE> points of armor and shred <Ability:HEAT_WARHEADS_SHRED> additional point of armor."
// Config:			(AbilityName="LW2WotC_HEATWarheads")
static function X2AbilityTemplate HEATWarheads()
{
	local X2Effect_LW2WotC_HEATGrenades			HEATEffect;

	// Effect granting bonus pierce and shred to grenades
	HEATEffect = new class 'X2Effect_LW2WotC_HEATGrenades';
	HEATEffect.Pierce = default.HEAT_WARHEADS_PIERCE;
	HEATEffect.Shred = default.HEAT_WARHEADS_SHRED;

	// Create the template using a helper function
	return Passive('LW2WotC_HEATWarheads', "img:///UILibrary_LW_PerkPack.LW_AbilityHEATWarheads", false, HEATEffect);
}

// Perk name:		Emergency Life Support
// Perk effect:		Emergency Life Support ensures the first killing blow in a mission will not lead to instant death. It also extends the time before the soldier bleeds out and dies.
// Localized text:	"Emergency Life Support ensures the first killing blow in a mission will not lead to instant death. It also extends the time before the soldier bleeds out and dies."
// Config:			(AbilityName="LW2WotC_EmergencyLifeSupport")
static function X2AbilityTemplate EmergencyLifeSupport()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LW2WotC_EmergencyLifeSupport		LifeSupportEffect;

	// Effect that listenes for the UnitBleedingOut event and catches it, ensuring that the unit bleeds out on their first death that mission
	LifeSupportEffect = new class'X2Effect_LW2WotC_EmergencyLifeSupport';

	// Create the template using a helper function
	Template = Passive('LW2WotC_EmergencyLifeSupport', "img:///UILibrary_LW_PerkPack.LW_AbilityEmergencyLifeSupport", false, LifeSupportEffect);

	return Template;
}

// Perk name:		Smart Macrophages
// Perk effect:		Heals injuries after a battle, lowering wound recovery time, and confers immunity to poison and acid.
// Localized text:	"Heals injuries after a battle, lowering wound recovery time, and confers immunity to poison and acid."
// Config:			(AbilityName="LW2WotC_SmartMacrophages")
static function X2AbilityTemplate SmartMacrophages()
{
	local X2AbilityTemplate						Template;
	local X2Effect_DamageImmunity				DamageImmunity;
	local X2Effect_LW2WotC_SmartMacrophages		MacrophagesEffect;

	// Effect to reduce wound time
	MacrophagesEffect = new class'X2Effect_LW2WotC_SmartMacrophages';

	// Create the template using a helper function
	Template = Passive('LW2WotC_SmartMacrophages', "img:///UILibrary_LW_PerkPack.LW_AbilitySmartMacrophages", false, MacrophagesEffect);

	// Grants immunity to acid, poison, and chryssalid poison
	DamageImmunity = new class'X2Effect_DamageImmunity'; 
	DamageImmunity.ImmuneTypes.AddItem('Acid');
	DamageImmunity.ImmuneTypes.AddItem('Poison');
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	DamageImmunity.BuildPersistentEffect(1, true, false, true);
	Template.AddTargetEffect(DamageImmunity);

	return Template;
}

// Perk name:		Field Surgeon
// Perk effect:		Reduce wound recovery times for most soldiers.
// Localized text:	"Reduce wound recovery times for most soldiers."
// Config:			(AbilityName="LW2WotC_FieldSurgeon")
static function X2AbilityTemplate FieldSurgeon()
{
	local X2Effect_LW2WotC_FieldSurgeon		FieldSurgeonEffect;

	// Effect to reduce wound time
	FieldSurgeonEffect = new class'X2Effect_LW2WotC_FieldSurgeon';

	// Create the template using a helper function
	return Passive('LW2WotC_FieldSurgeon', "img:///UILibrary_LW_PerkPack.LW_AbilityFieldSurgeon", true, FieldSurgeonEffect);
}

// Perk name:		Trojan
// Perk effect:		Enemy units that are hacked take damage and lose their actions on the turn the hack effect ends.
// Localized text:	"Enemy units that are hacked take damage and lose their actions on the turn the hack effect ends."
// Config:			(AbilityName="LW2WotC_Trojan", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Trojan()
{
	local X2AbilityTemplate			Template;
	local X2Effect_LW2WotC_Trojan			TrojanEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Trojan');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityTrojan";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	TrojanEffect = new class 'X2Effect_LW2WotC_Trojan';
	TrojanEffect.BuildPersistentEffect (1, true, false);
	TrojanEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (TrojanEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.AdditionalAbilities.AddItem('LW2WotC_TrojanVirus');

	return Template;
}

// This ability is what gets triggered by a successful hack, and places the LW2WotC_TrojanVirus effect on the hacked unit
static function X2AbilityTemplate TrojanVirus()
{
	local X2AbilityTemplate                 Template;		
	local X2AbilityCost_ActionPoints        ActionPointCost;	
	local X2Condition_UnitProperty          ShooterPropertyCondition;	
	local X2Condition_UnitProperty          TargetUnitPropertyCondition;	
	//local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_Placeholder		UseTrigger;
	local X2Effect_LW2WotC_TrojanVirus				TrojanVirusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_TrojanVirus');
	
	// Triggered for free
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	// Can't evaluate stimuli while dead
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    	
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	// No triggering on dead, or friendlies
	TargetUnitPropertyCondition = new class'X2Condition_UnitProperty';	
	TargetUnitPropertyCondition.ExcludeDead = true;                    	
	TargetUnitPropertyCondition.ExcludeFriendlyToSource = false;	
	Template.AbilityTargetConditions.AddItem(TargetUnitPropertyCondition);

	// Note: No visibility requirement (matches intrusion protocol)
	// These must be the same or you can hack a robot and not have trojan apply.

	// Always applied when triggered
	Template.AbilityToHitCalc = default.DeadEye;

	// Single target ability
	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	// Triggered by persistent effect from Trojan
	UseTrigger = new class'X2AbilityTrigger_Placeholder';
	Template.AbilityTriggers.AddItem(UseTrigger);
	
	// The main effect
	TrojanVirusEffect = new class 'X2Effect_LW2WotC_TrojanVirus';
	// TrojanVirusEffect.BuildPersistentEffect (1, true, false /*Remove on Source Death*/,, eGameRule_PlayerTurnBegin);
	TrojanVirusEffect.BuildPersistentEffect (1, true, false /*Remove on Source Death*/,, eGameRule_UnitGroupTurnBegin);
	TrojanVirusEffect.bTickWhenApplied = false;
	TrojanVirusEffect.EffectRemovedVisualizationFn = TrojanVirusVisualizationRemoved;
	Template.AddTargetEffect (TrojanVirusEffect);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.Hostility = eHostility_Neutral;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = none; // no visualization on application on purpose -- it would be fighting with the hacking stuff

	return Template;	
}

// Plays Trojan Virus flyover and message when the effect is removed (which is when the meaningful effects are triggered)
static function TrojanVirusVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local XGParamTag kTag;
	local X2Action_PlayWorldMessage MessageAction;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState == none)
		return;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.LocTrojanVirus, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Haywire, 1.0);

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = UnitState.GetFullName();

	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	MessageAction.AddWorldMessage(`XEXPAND.ExpandString(default.LocTrojanVirusTriggered));
}

// Perk name:		Whirlwind
// Perk effect:		If you hit with a melee attack during your turn, gain a bonus move.
// Localized text:	"If you hit with a melee attack during your turn, gain a bonus move."
// Config:			(AbilityName="LW2WotC_Whirlwind")
static function X2AbilityTemplate Whirlwind()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityCost CostCondition;
	local X2Condition_UnitEffects ExcludeEffectsCondition;
	local X2Condition_UnitValue ValueCondition;
	local X2Condition_UnitValue ReaperCondition;
	local X2Effect_IncrementUnitValue ValueEffect;

	// Add a single movement action point to the unit
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the conditions
	Template = SelfTargetTrigger('LW2WotC_Whirlwind', "img:///UILibrary_PerkIcons.UIPerk_riposte", false, Effect, 'AbilityActivated');

	// Add an effect that will increment a counter for the number of times Whirlwind has activated this turn
	ValueEffect = new class'X2Effect_IncrementUnitValue';
	ValueEffect.UnitName = 'LW2WotC_Whirlwind_Activations';
	ValueEffect.NewValueToSet = 1;
	ValueEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(ValueEffect);

	// Requires that the ability costs at least one action point
	CostCondition = new class'XMBCondition_AbilityCost';
	CostCondition.bRequireMinimumCost = true;
	CostCondition.MinimumCost = 1;
	CostCondition.bRequireMinimumPointsSpent = true;
	CostCondition.MinimumPointsSpent = 1;
	AddTriggerTargetCondition(Template, CostCondition);
    
	// Only triggers on melee attacks
	AddTriggerTargetCondition(Template, default.MeleeCondition);

	// Require that Serial isn't active
	ExcludeEffectsCondition = new class'X2Condition_UnitEffects';
	ExcludeEffectsCondition.AddExcludeEffect(class'X2Effect_Serial'.default.EffectName, 'AA_UnitIsImmune');
	AddTriggerShooterCondition(Template, ExcludeEffectsCondition);

	// Require that Reaper wasn't activated
	ReaperCondition = new class'X2Condition_UnitValue';
	ReaperCondition.AddCheckValue(class'X2Effect_Reaper'.default.ReaperActivatedName, 1, eCheck_LessThan);
	AddTriggerShooterCondition(Template, ReaperCondition);

	// Require that Whirlwind hasn't already activated this turn
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('LW2WotC_Whirlwind_Activations', 1, eCheck_LessThan);
	AddTriggerShooterCondition(Template, ValueCondition);

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Show a flyover when Whirlwind is activated
	Template.bShowActivation = true;

	return Template;
}

// Perk name:		Commissar
// Perk effect:		If you hit with a melee attack during your turn, gain a bonus move.
// Localized text:	"If you hit with a melee attack during your turn, gain a bonus move."
// Config:			(AbilityName="LW2WotC_Commissar", ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Commissar()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LW2WotC_Commissar		DamageModifier;

	// Create the template using a helper function
	Template = Passive('LW2WotC_Commissar', "img:///UILibrary_LW_PerkPack.LW_AbilityCommissar", false, none);

	// Grants the aim and damage bonuses against mind controlled soldiers
	DamageModifier = new class 'X2Effect_LW2WotC_Commissar';
	DamageModifier.AimBonus = default.COMMISSAR_HIT_BONUS;
	DamageModifier.BuildPersistentEffect (1, true, true);
	DamageModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (DamageModifier);

	return Template;		
}

// Perk name:		Bombardier
// Perk effect:		You may throw or launch grenades with additional range.
// Localized text:	"You may throw or launch grenades <Ability:BOMBARDIER_BONUS_RANGE_TILES> additional tiles."
// Config:			(AbilityName="X2Effect_LW2WotC_Bombardier")
static function X2AbilityTemplate Bombardier()
{
	local X2Effect_LW2WotC_Bombardier	BombardierEffect;

    // Effect that grants additional throw range with grenades
	BombardierEffect = new class 'X2Effect_LW2WotC_Bombardier';

	// Create the template using a helper function
	return Passive('LW2WotC_Bombardier', "img:///UILibrary_LW_PerkPack.LW_AbilityBombard", false, BombardierEffect);
}

// Perk name:		Failsafe
// Perk effect:		If you fail a hack, you prevent any negative effects from occurring.
// Localized text:	"If you fail a hack, you prevent any negative effects from occurring."
// Config:			(AbilityName="LW2WotC_Failsafe")
static function X2AbilityTemplate Failsafe()
{
	local X2Effect_LW2WotC_Failsafe	FailsafeEffect;

    // Effect that grants the failsafe effect
	FailsafeEffect = new class 'X2Effect_LW2WotC_Failsafe';

	// Create the template using a helper function
	return Passive('LW2WotC_Failsafe', "img:///UILibrary_LW_PerkPack.LW_AbilityFailsafe", false, FailsafeEffect);
}

// Perk name:		Bastion
// Perk effect:		Fortress now provides immunity to nearby teammates.
// Localized text:	"Fortress now provides immunity to nearby teammates."
// Config:			(AbilityName="LW2WotC_Bastion",  ApplyToWeaponSlot=eInvSlot_SecondaryWeapon)
static function X2AbilityTemplate Bastion()
{
	local X2AbilityTemplate             Template;
	local X2Effect_LW2WotC_Bastion      Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Bastion');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBastion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bCrossClassEligible = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'X2Effect_LW2WotC_Bastion';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

	Template.AdditionalAbilities.AddItem('LW2WotC_Bastion_Cleanse');
	Template.AdditionalAbilities.AddItem('LW2WotC_Bastion_Passive');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.PrerequisiteAbilities.AddItem('Fortress');
	Template.PrerequisiteAbilities.AddItem('LW2WotC_Solace');

	return Template;
}

// Granted by LW2WotC_Bastion
// Its purpose is to simply add a passive icon for Bastion
static function X2AbilityTemplate BastionPassive()
{
	return PurePassive('LW2WotC_Bastion_Passive', "img:///UILibrary_LW_PerkPack.LW_AbilityBastion", , 'eAbilitySource_Psionic');
}

// Granted by LW2WotC_Bastion
// Removes physical status effects from nearby allies
static function X2AbilityTemplate BastionCleanse()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityTrigger_EventListener        EventListener;
	local X2Condition_UnitProperty              DistanceCondition;
	local X2Effect_RemoveEffects				FortressRemoveEffect;
	local X2Condition_UnitProperty              FriendCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW2WotC_Bastion_Cleanse');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBastion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SolaceCleanseListener;  // keep this, since it's generically just calling the associate ability
	Template.AbilityTriggers.AddItem(EventListener);

	//removes any ongoing effects
	FortressRemoveEffect = new class'X2Effect_RemoveEffects';
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.AcidBurningName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BurningName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.PoisonedName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2Effect_ParthenogenicPoison'.default.EffectName);
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	FortressRemoveEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(FortressRemoveEffect);

	DistanceCondition = new class'X2Condition_UnitProperty';
	DistanceCondition.RequireWithinRange = true;
	DistanceCondition.WithinRange = Sqrt(class'X2Effect_LW2WotC_Bastion'.default.BASTION_DISTANCE_SQ) *  class'XComWorldData'.const.WORLD_StepSize; // same as Solace for now
	DistanceCondition.ExcludeFriendlyToSource = false;
	DistanceCondition.ExcludeHostileToSource = false;
	Template.AbilityTargetConditions.AddItem(DistanceCondition);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// Perk name:		Sapper
// Perk effect:		Your explosives can destroy many cover objects.
// Localized text:	"Your explosives can destroy many cover objects."
// Config:			(AbilityName="LW2WotC_Sapper")
static function X2AbilityTemplate Sapper()
{
	local X2AbilityTemplate			Template;

	// Event listener defined in X2EventListener_Sapper will check for this ability before applying bonus environment damage
	Template = PurePassive('LW2WotC_Sapper', "img:///UILibrary_LW_PerkPack.LW_AbilitySapper");

	return Template;
}

// Perk name:		Needle Grenades
// Perk effect:		Your explosives do not destroy loot when they kill enemies.
// Localized text:	"Your explosives do not destroy loot when they kill enemies."
// Config:			(AbilityName="LW2WotC_NeedleGrenades")
static function X2AbilityTemplate NeedleGrenades()
{
	local X2AbilityTemplate			Template;
    
	// Event listener defined in X2EventListener_Sapper will check for this ability to override the boolean denoting that an enemy was killed by an explosion
	Template = PurePassive('LW2WotC_NeedleGrenades', "img:///UILibrary_LW_PerkPack.LW_AbilityNeedleGrenades");

	return Template;
}

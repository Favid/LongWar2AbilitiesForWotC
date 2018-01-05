// Implements all Arc-Thrower abilities
class X2Ability_ArcthrowerAbilitySet extends X2Ability config(GameData_SoldierSkills);

var config int STUN_COOLDOWN;
var config int EMPULSER_HACK_DEFENSE_CHANGE;
var config int CHAIN_LIGHTNING_COOLDOWN;
var config int CHAIN_LIGHTNING_MIN_ACTION_REQ;
var config array<name> VALID_WEAPON_CATEGORIES_FOR_SKILLS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AddArcthrowerStun());
	/*���*/	Templates.AddItem(AddArcthrowerPassive());
	Templates.AddItem(AddEMPulser());
	/*���*/	Templates.AddItem(EMPulserPassive());  
	Templates.AddItem(StunGunner());
	Templates.AddItem(Electroshock()); 
	Templates.AddItem(CreateChainLightningAbility());
	return Templates;
}


// Arc-Thrower Stun: Basic stun attack, which increases stun duration based on tech level
static function X2AbilityTemplate AddArcthrowerStun()
{

	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ArcthrowerStunned	    StunnedEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitType				ImmuneUnitCondition;
	local X2AbilityTarget_Single			AbilityTargetStyle;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ArcthrowerStun');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityArcthrowerStun";  
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.STUN_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	// Can't target these specific unit groups
	ImmuneUnitCondition = new class'X2Condition_UnitType';
	ImmuneUnitCondition.ExcludeTypes.AddItem('PsiZombie');
	ImmuneUnitCondition.ExcludeTypes.AddItem('Shadowbind');				// Shadowbound Units
	ImmuneUnitCondition.ExcludeTypes.AddItem('SpectralZombie');			// Spectral Zombie
	ImmuneUnitCondition.ExcludeTypes.AddItem('SpectralStunLancer');		// Spectral Units
	ImmuneUnitCondition.ExcludeTypes.AddItem('AdventPsiWitch');			// Avatars
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenAssassin');			// Chosen Assassin
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenWarlock');			// Chosen Warlock
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenSniper');			// Chosen Sniper
	ImmuneUnitCondition.ExcludeTypes.AddItem('TheLost');				// All Lost (Stun has no effect on them)
	Template.AbilityTargetConditions.AddItem(ImmuneUnitCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Can't target destrucible objects
	AbilityTargetStyle = new class'X2AbilityTarget_Single';
	AbilityTargetStyle.bAllowDestructibleObjects = false;
	Template.AbilityTargetStyle = AbilityTargetStyle;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	//Stun Effect
	StunnedEffect = new class'X2Effect_ArcthrowerStunned';
	StunnedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnBegin);
	StunnedEffect.ApplyChance = 100;
	StunnedEffect.StunLevel = 2;
	StunnedEffect.bIsImpairing = true;
	StunnedEffect.EffectName = class'X2AbilityTemplateManager'.default.StunnedName;
	//StunnedEffect.EffectName = 'arcthrowerstun';
	StunnedEffect.EffectHierarchyValue = class'X2StatusEffects'.default.STUNNED_HIERARCHY_VALUE;
	StunnedEffect.VisualizationFn = class'X2StatusEffects'.static.StunnedVisualization;
	StunnedEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationTicked;
	StunnedEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationRemoved;
	StunnedEffect.EffectRemovedFn = class'X2StatusEffects'.static.StunnedEffectRemoved;
	StunnedEffect.bRemoveWhenTargetDies = true;
	StunnedEffect.bCanTickEveryAction = true;
	Template.AddTargetEffect(StunnedEffect);

	Template.AssociatedPassives.AddItem('Electroshock');
	Template.AddTargetEffect(ElectroshockDisorientEffect());

	// Hit Calculation (Different weapons now have different calculations for range)
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = false;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;
			
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'StunTarget';
	Template.bUniqueSource = true;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('ArcthrowerPassive');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

// Arc-Thrower Passive: Associated passive that prevents the weapon from rolling a graze or crit
static function X2AbilityTemplate AddArcthrowerPassive()
{
	local X2AbilityTemplate					Template;	
	local X2Effect_Arcthrower				ArcthrowerEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ArcthrowerPassive');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityStunGunner";  
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);
	
	//prevents grazes and crits
	ArcthrowerEffect = new class'X2Effect_Arcthrower';
	ArcthrowerEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(ArcthrowerEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

// EM Pulser: Alternative attack which allows targeting and damaging robots
static function X2AbilityTemplate AddEMPulser()
{
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ArcthrowerStunned	    StunnedEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitType				ImmuneUnitCondition;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EMPulser');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityEMPulser"; 
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.STUN_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies -- must be enemy organic
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;  // change from basic stun to allow targeting robotic units
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	// Can't target these specific unit groups
	ImmuneUnitCondition = new class'X2Condition_UnitType';
	ImmuneUnitCondition.ExcludeTypes.AddItem('PsiZombie');
	ImmuneUnitCondition.ExcludeTypes.AddItem('Shadowbind');				// Shadowbound Units
	ImmuneUnitCondition.ExcludeTypes.AddItem('SpectralZombie');			// Spectral Zombie
	ImmuneUnitCondition.ExcludeTypes.AddItem('SpectralStunLancer');		// Spectral Units
	ImmuneUnitCondition.ExcludeTypes.AddItem('AdventPsiWitch');			// Avatars
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenAssassin');			// Chosen Assassin
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenWarlock');			// Chosen Warlock
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenSniper');			// Chosen Sniper
	ImmuneUnitCondition.ExcludeTypes.AddItem('TheLost');				// All Lost (Stun has no effect on them)
	Template.AbilityTargetConditions.AddItem(ImmuneUnitCondition);

	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range. Targeting of desctrucibles is allowed.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Hit Calculation (Different weapons now have different calculations for range)
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = false;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	// Stun Effect
	StunnedEffect = new class'X2Effect_ArcthrowerStunned';
	StunnedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnBegin);
	StunnedEffect.ApplyChance = 100;
	StunnedEffect.StunLevel = 2;
	StunnedEffect.bIsImpairing = true;
	//StunnedEffect.EffectName = 'empulserstun';
	StunnedEffect.EffectHierarchyValue = class'X2StatusEffects'.default.STUNNED_HIERARCHY_VALUE;
	StunnedEffect.VisualizationFn = class'X2StatusEffects'.static.StunnedVisualization;
	StunnedEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationTicked;
	StunnedEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationRemoved;
	StunnedEffect.EffectRemovedFn = class'X2StatusEffects'.static.StunnedEffectRemoved;
	StunnedEffect.bRemoveWhenTargetDies = true;
	StunnedEffect.bCanTickEveryAction = true;
	Template.AddTargetEffect(StunnedEffect);

	Template.AssociatedPassives.AddItem( 'Electroshock' );
	Template.AddTargetEffect(ElectroshockDisorientEffect());

	Template.AssociatedPassives.AddItem( 'EMPulserPassive' );
	Template.AddTargetEffect(EMPulserHackDefenseReductionEffect());
	Template.AddTargetEffect(EMPulserWeaponDamageEffect());

	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.ActivationSpeech = 'TeslaCannon';
	Template.bUniqueSource = true;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('ArcthrowerPassive');
	Template.AdditionalAbilities.AddItem('EMPulserPassive');
	Template.OverrideAbilities.AddItem('ArcthrowerStun');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

// EMPulser - Hack Defense Reduction: Associated effect that reduces a targeted robotic enemies hack defense
static function X2Effect_PersistentStatChange EMPulserHackDefenseReductionEffect()
{
	local X2Effect_PersistentStatChange HackDefenseReductionEffect;
	local X2Condition_UnitProperty Condition_UnitProperty;

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = true;
	Condition_UnitProperty.TreatMindControlledSquadmateAsHostile = true;
	HackDefenseReductionEffect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(default.EMPULSER_HACK_DEFENSE_CHANGE, Condition_UnitProperty);

	return HackDefenseReductionEffect;
}

// EMPulser - Apply Damage: Associated effect that applies damage to robotic enemies
static function X2Effect EMPulserWeaponDamageEffect()
{
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Condition_UnitProperty Condition_UnitProperty;

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = true;
	Condition_UnitProperty.TreatMindControlledSquadmateAsHostile = true;
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.TargetConditions.AddItem(Condition_UnitProperty);

	return WeaponDamageEffect;
}

// EMPulser - Passive: Empty ability to put attach a passive icon to the unit in tactical
static function X2AbilityTemplate EMPulserPassive()
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'EMPulserPassive');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityEMPulser";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Dummy effect to show a passive icon in the tactical UI for the SourceUnit
	IconEffect = new class'X2Effect_Persistent';
	IconEffect.BuildPersistentEffect(1, true, false);
	IconEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);

	Template.AddTargetEffect(IconEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}


// Electroshock - Passive: Empty ability to put attach a passive icon to the unit in tactical
static function X2AbilityTemplate Electroshock()
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Electroshock');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityElectroshock";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bUniqueSource = true;

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Dummy effect to show a passive icon in the tactical UI for the SourceUnit
	IconEffect = new class'X2Effect_Persistent';
	IconEffect.BuildPersistentEffect(1, true, false);
	IconEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);

	Template.AddTargetEffect(IconEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

// Electroshock: Passive effect that disorients the target on a miss
static function X2Effect_Persistent ElectroshockDisorientEffect()
{
	local X2Effect_PersistentStatChange		DisorientedEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Condition_UnitProperty			Condition_UnitProperty;

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.bApplyOnHit = false;
	DisorientedEffect.bApplyOnMiss = true;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Electroshock');
	DisorientedEffect.TargetConditions.AddItem(AbilityCondition);

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = false;
	Condition_UnitProperty.ExcludeRobotic = true;
	DisorientedEffect.TargetConditions.AddItem(Condition_UnitProperty);
	
	return DisorientedEffect;
}

// Stun Gunner: Passive ability that increases the change to hit the target with the Arc-Thrower
static function X2AbilityTemplate StunGunner()
{
	local X2AbilityTemplate					Template;	
	local X2Effect_StunGunner				StunGunnerEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'StunGunner');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityStunGunner";  
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bUniqueSource = true;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);
	
	// Conditional Bonus to Aim
	StunGunnerEffect = new class'X2Effect_StunGunner';
	StunGunnerEffect.BuildPersistentEffect(1, true, false, false);
	StunGunnerEffect.WeaponCategory = 'arcthrower';
	StunGunnerEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(StunGunnerEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

// Chain-Lightning: Bullshit ability that shoots the Arc-Thrower at all visible targets - Note: does not apply the effects of EMPulser!
static function X2AbilityTemplate CreateChainLightningAbility()
{
	local X2AbilityTemplate					Template;	
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitProperty			UnitPropertyCondition, UnitPropertyCondition2;
	local X2Effect_ArcthrowerStunned		StunnedEffect;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown					Cooldown;	
	local X2Condition_UnitType				ImmuneUnitCondition;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChainLightning');
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityChainLightning";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.ActivationSpeech = 'TeslaCannon';
	Template.bUniqueSource = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	//Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	// Can't target dead; Can't target friendlies -- must be enemy organic
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	UnitPropertyCondition2=new class'X2Condition_UnitProperty';
	UnitPropertyCondition2.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition2);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	// Can't target these specific unit groups
	ImmuneUnitCondition = new class'X2Condition_UnitType';
	ImmuneUnitCondition.ExcludeTypes.AddItem('PsiZombie');
	ImmuneUnitCondition.ExcludeTypes.AddItem('Shadowbind');				// Shadowbound Units
	ImmuneUnitCondition.ExcludeTypes.AddItem('SpectralZombie');			// Spectral Zombie
	ImmuneUnitCondition.ExcludeTypes.AddItem('SpectralStunLancer');		// Spectral Units
	ImmuneUnitCondition.ExcludeTypes.AddItem('AdventPsiWitch');			// Avatars
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenAssassin');			// Chosen Assassin
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenWarlock');			// Chosen Warlock
	ImmuneUnitCondition.ExcludeTypes.AddItem('ChosenSniper');			// Chosen Sniper
	Template.AbilityTargetConditions.AddItem(ImmuneUnitCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CHAIN_LIGHTNING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.CHAIN_LIGHTNING_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Arcthrower_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Stun Effect
	StunnedEffect = new class'X2Effect_ArcthrowerStunned';
	StunnedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnBegin);
	StunnedEffect.ApplyChance = 100;
	StunnedEffect.StunLevel = 2;
	StunnedEffect.bIsImpairing = true;
	StunnedEffect.EffectName = 'empulserstun';
	StunnedEffect.EffectHierarchyValue = class'X2StatusEffects'.default.STUNNED_HIERARCHY_VALUE;
	StunnedEffect.VisualizationFn = class'X2StatusEffects'.static.StunnedVisualization;
	StunnedEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationTicked;
	StunnedEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationRemoved;
	StunnedEffect.EffectRemovedFn = class'X2StatusEffects'.static.StunnedEffectRemoved;
	StunnedEffect.bRemoveWhenTargetDies = true;
	StunnedEffect.bCanTickEveryAction = true;
	Template.AddTargetEffect(StunnedEffect);
	Template.AddMultiTargetEffect(StunnedEffect);

	Template.AssociatedPassives.AddItem('Electroshock');
	Template.AddMultiTargetEffect(ElectroshockDisorientEffect());
	
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bOnlyMultiHitWithSuccess = false;
	Template.AbilityToHitCalc = ToHitCalc;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SharpshooterAbilitySet'.static.Faceoff_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

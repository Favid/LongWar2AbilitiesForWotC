
class X2Ability_HolotargeterAbilitySet extends X2Ability config(GameData_SoldierSkills);

var config int RAPID_TARGETING_COOLDOWN;
var config int MULTI_TARGETING_COOLDOWN;
var config array<name> VALID_WEAPON_CATEGORIES_FOR_SKILLS;
var config array<name> HOLOTARGETER_ABILITY_PERK_PACKAGES_TO_LOAD;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(LoadPerkPackages());
	Templates.AddItem(AddHolotarget());
	Templates.AddItem(AddRapidTargeting());
	/*���*/	Templates.AddItem(AddRapidTargeting_Passive());
	Templates.AddItem(AddMultiTargeting());
	Templates.AddItem(AddHDHolo());
	Templates.AddItem(AddIndependentTracking());
	Templates.AddItem(AddVitalPointTargeting());
	Templates.AddItem(AddRapidTargeting_Passive());

	return Templates;
}

static function X2AbilityTemplate LoadPerkPackages()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LoadPerks				LoadPerksEffect;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Holotargeter_LoadPerkPackages');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityHolotargeting";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bCrossClassEligible = false;
	Template.bIsPassive = true;

	// Passive effect that loads the Holotargeter perk packages
	LoadPerksEffect = new class'X2Effect_LoadPerks';
	LoadPerksEffect.BuildPersistentEffect(1, true);
	LoadPerksEffect.AbilitiesToLoad = default.HOLOTARGETER_ABILITY_PERK_PACKAGES_TO_LOAD;
	Template.AddTargetEffect(LoadPerksEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = false;
	return Template;
}

static function X2AbilityTemplate AddHolotarget()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_LWHoloTarget				Effect;
	local X2Effect_Persistent				DurationIconEffect;
	local X2Condition_AbilityProperty		DurationEffectCondition;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Holotarget');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityHolotargeting";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.Hostility = eHostility_Neutral;
	Template.bUniqueSource = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;
	//Template.ActivationSpeech = 'TracerBeams';

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Holotargeter_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Can only shoot visible enemies
	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Can't target dead; Can't target friendlies, can't target inanimate objects
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
		
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	//SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	// Holotarget Effect
	Effect = new class'X2Effect_LWHoloTarget';
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Effect_LWHolotarget'.default.HoloTargetEffectName, class'X2Effect_LWHolotarget'.default.HoloTargetEffectPenaltyDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Effect.bApplyOnHit = true;
	Effect.bApplyOnMiss = true;
	Template.AddTargetEffect(Effect);

	Template.AssociatedPassives.AddItem('HDHolo');
	Template.AssociatedPassives.AddItem('VitalPointTargeting');

	// Extended Duration Icon Effect
	DurationEffectCondition = new class'X2Condition_AbilityProperty';
	DurationEffectCondition.OwnerHasSoldierAbilities.AddItem('IndependentTracking');

	DurationIconEffect = new class'X2Effect_Persistent';
	DurationIconEffect.BuildPersistentEffect(class'X2Effect_LWHolotarget'.default.INDEPENDENT_TARGETING_NUM_BONUS_TURNS, false, false, false, eGameRule_PlayerTurnBegin);
	DurationIconEffect.EffectName = 'DurationEffect';
	DurationIconEffect.DuplicateResponse = eDupe_Refresh;
	DurationIconEffect.bRemoveWhenTargetDies = true;
	DurationIconEffect.bUseSourcePlayerState = true;
	DurationIconEffect.bApplyOnHit = true;
	DurationIconEffect.bApplyOnMiss = true;
	DurationIconEffect.TargetConditions.AddItem(DurationEffectCondition);
	Template.AddTargetEffect(DurationIconEffect);


    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddRapidTargeting()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_LWHoloTarget				Effect;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Persistent				DurationIconEffect;
	local X2Condition_AbilityProperty		DurationEffectCondition;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Rapidtargeting');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityRapidTargeting";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bUniqueSource = true;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;

	Template.AbilityCosts.AddItem(default.FreeActionCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RAPID_TARGETING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	// Targeting Details
	// Can only shoot visible enemies
	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	//SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);


	// Can't target dead; Can't target friendlies, can't target inanimate objects
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.AddShooterEffectExclusions();

	// Holotarget Effect
	Effect = new class'X2Effect_LWHoloTarget';
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Effect_LWHolotarget'.default.HoloTargetEffectName, class'X2Effect_LWHolotarget'.default.HoloTargetEffectPenaltyDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Effect.bApplyOnHit = true;
	Effect.bApplyOnMiss = true;
	Template.AddTargetEffect(Effect);

	Template.AssociatedPassives.AddItem('HDHolo');
	Template.AssociatedPassives.AddItem('VitalPointTargeting');

	// Extended Duration Icon Effect
	DurationEffectCondition = new class'X2Condition_AbilityProperty';
	DurationEffectCondition.OwnerHasSoldierAbilities.AddItem('IndependentTracking');

	DurationIconEffect = new class'X2Effect_Persistent';
	DurationIconEffect.BuildPersistentEffect(class'X2Effect_LWHolotarget'.default.INDEPENDENT_TARGETING_NUM_BONUS_TURNS, false, false, false, eGameRule_PlayerTurnBegin);
	DurationIconEffect.EffectName = 'DurationEffect';
	DurationIconEffect.DuplicateResponse = eDupe_Refresh;
	DurationIconEffect.bRemoveWhenTargetDies = true;
	DurationIconEffect.bUseSourcePlayerState = true;
	DurationIconEffect.bApplyOnHit = true;
	DurationIconEffect.bApplyOnMiss = true;
	DurationIconEffect.TargetConditions.AddItem(DurationEffectCondition);
	Template.AddTargetEffect(DurationIconEffect);

	Template.AdditionalAbilities.AddItem('RapidTargeting_Passive');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


static function X2AbilityTemplate AddRapidTargeting_Passive()
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				PassiveActionEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'RapidTargeting_Passive');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityRapidTargeting";
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

	// Passive effect that makes Holotargeting abilities not end the turn
	PassiveActionEffect = new class'X2Effect_Persistent';
	PassiveActionEffect.BuildPersistentEffect(1, true, false);
	PassiveActionEffect.EffectName = 'Holotargeter_DoNotConsumeAllActionsEffect';
	PassiveActionEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PassiveActionEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate AddMultiTargeting()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_LWHoloTarget				Effect;
	local X2Effect_Persistent				DurationIconEffect;
	local X2Condition_AbilityProperty		DurationEffectCondition;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2Condition_ValidWeaponType		WeaponCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Multitargeting');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityMultiTargeting";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.Hostility = eHostility_Neutral;
	Template.bUniqueSource = true;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MULTI_TARGETING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('Holotargeter_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	WeaponCondition = new class'X2Condition_ValidWeaponType';
	WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_SKILLS;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	//SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	// Can only shoot visible enemies
	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Can't target dead; Can't target friendlies, can't target inanimate objects
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AddShooterEffectExclusions();

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	//RadiusMultiTarget.NumTargetsRequired = 1; 
	RadiusMultiTarget.bIgnoreBlockingCover = true; 
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = false; 
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	RadiusMultiTarget.bUseWeaponRadius = true; 
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Holotarget Effect
	Effect = new class'X2Effect_LWHoloTarget';
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Effect_LWHolotarget'.default.HoloTargetEffectName, class'X2Effect_LWHolotarget'.default.HoloTargetEffectPenaltyDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Effect.bApplyOnHit = true;
	Effect.bApplyOnMiss = true;
	Template.AddTargetEffect(Effect);
	Template.AddMultiTargetEffect(Effect);

	Template.AssociatedPassives.AddItem('HDHolo');
	Template.AssociatedPassives.AddItem('VitalPointTargeting');

	// Extended Duration Icon Effect
	DurationEffectCondition = new class'X2Condition_AbilityProperty';
	DurationEffectCondition.OwnerHasSoldierAbilities.AddItem('IndependentTracking');

	DurationIconEffect = new class'X2Effect_Persistent';
	DurationIconEffect.BuildPersistentEffect(class'X2Effect_LWHolotarget'.default.INDEPENDENT_TARGETING_NUM_BONUS_TURNS, false, false, false, eGameRule_PlayerTurnBegin);
	DurationIconEffect.EffectName = 'DurationEffect';
	DurationIconEffect.bRemoveWhenTargetDies = true;
	DurationIconEffect.bUseSourcePlayerState = true;
	DurationIconEffect.bApplyOnHit = true;
	DurationIconEffect.bApplyOnMiss = true;
	DurationIconEffect.TargetConditions.AddItem(DurationEffectCondition);
	Template.AddTargetEffect(DurationIconEffect);
	Template.AddMultiTargetEffect(DurationIconEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	//Template.OverrideAbilities.AddItem('Holotarget'); // add the multi-targeting as a separate ability, so as not to render RapidTargeting useless

	return Template;
}


static function X2AbilityTemplate AddHDHolo()
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'HDHolo');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityHDHolo";
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


static function X2AbilityTemplate AddIndependentTracking()
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'IndependentTracking');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityIndependentTracking";
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


static function X2AbilityTemplate AddVitalPointTargeting()
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;
	local X2Condition_ValidWeaponType		WeaponCondition;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'VitalPointTargeting');
	Template.IconImage = "img:///UILibrary_LWSecondariesWOTC.LW_AbilityVitalPointTargeting";
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


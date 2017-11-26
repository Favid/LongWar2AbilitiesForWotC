class X2Ability_LW2WotC_SuppressionAbilitySet extends XMBAbility config (LW_SoldierSkills);

var config float DANGER_ZONE_BONUS_RADIUS;
var config int AREA_SUPPRESSION_AMMO_COST;
var config int AREA_SUPPRESSION_MAX_SHOTS;
var config int AREA_SUPPRESSION_SHOT_AMMO_COST;
var config float AREA_SUPPRESSION_RADIUS;
var config int SUPPRESSION_LW_SHOT_AIM_BONUS;
var config int AREA_SUPPRESSION_LW_SHOT_AIM_BONUS;
var config array<name> SUPPRESSION_LW_INVALID_WEAPON_CATEGORIES;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;


    Templates.AddItem(AddSuppressionAbility_LW());
    Templates.AddItem(SuppressionShot_LW()); //Additional Ability
    Templates.AddItem(AddAreaSuppressionAbility());
    Templates.AddItem(AreaSuppressionShot_LW()); //Additional Ability
    Templates.AddItem(AddLockdownAbility());
    Templates.AddItem(AddDangerZoneAbility());
    Templates.AddItem(LockdownBonuses()); //Additional Ability
    Templates.AddItem(PurePassive('Mayhem', "img:///UILibrary_LW_PerkPack.LW_AbilityMayhem", false, 'eAbilitySource_Perk'));
    Templates.AddItem(MayhemBonuses()); // AdditionalAbility;

    return Templates;
}

static function X2AbilityTemplate AddDangerZoneAbility()
{
    local X2AbilityTemplate                 Template;   

    Template = PurePassive('DangerZone', "img:///UILibrary_LW_PerkPack.LW_AbilityDangerZone", false, 'eAbilitySource_Perk');
    Template.bCrossClassEligible = false;
    return Template;
}


static function X2AbilityTemplate AddLockdownAbility()
{
    local X2AbilityTemplate                 Template;   

    Template = PurePassive('Lockdown', "img:///UILibrary_LW_PerkPack.LW_AbilityLockdown", false, 'eAbilitySource_Perk');
    Template.bCrossClassEligible = false;
    return Template;
}

static function X2AbilityTemplate AddSuppressionAbility_LW()
{
    local X2AbilityTemplate                 Template;   
    local X2AbilityCost_Ammo                AmmoCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
    local X2Effect_Suppression              SuppressionEffect;
    local X2Condition_UnitInventory         UnitInventoryCondition;
    local name                              WeaponCategory;
    local X2Condition_UnitEffects           SuppressedCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Suppression_LW');
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
    Template.bDisplayInUITooltip = false;

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
    Template.bCrossClassEligible = false;

    AmmoCost = new class'X2AbilityCost_Ammo';   
    AmmoCost.iAmmo = 2;
    Template.AbilityCosts.AddItem(AmmoCost);
    
    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
    ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
    Template.AbilityCosts.AddItem(ActionPointCost);
    
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    
    foreach default.SUPPRESSION_LW_INVALID_WEAPON_CATEGORIES(WeaponCategory)
    {
        UnitInventoryCondition = new class'X2Condition_UnitInventory';
        UnitInventoryCondition.RelevantSlot = eInvSlot_PrimaryWeapon;
        UnitInventoryCondition.ExcludeWeaponCategory = WeaponCategory;
        Template.AbilityShooterConditions.AddItem(UnitInventoryCondition);
    }

    Template.AddShooterEffectExclusions();
    
    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);

    ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
    ReserveActionPointsEffect.ReserveType = 'Suppression';
    Template.AddShooterEffect(ReserveActionPointsEffect);

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
    Template.AbilityTargetStyle = default.SimpleSingleTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    SuppressionEffect = new class'X2Effect_Suppression';
    SuppressionEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    SuppressionEffect.bRemoveWhenTargetDies = true;
    SuppressionEffect.bRemoveWhenSourceDamaged = true;
    SuppressionEffect.bBringRemoveVisualizationForward = true;
    SuppressionEffect.DuplicateResponse=eDupe_Allow;
    SuppressionEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionTargetEffectDesc, Template.IconImage);
    SuppressionEffect.SetSourceDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionSourceEffectDesc, Template.IconImage);
    Template.AddTargetEffect(SuppressionEffect);
    Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    
    Template.AdditionalAbilities.AddItem('SuppressionShot_LW');
    Template.AdditionalAbilities.AddItem('LockdownBonuses');
    Template.AdditionalAbilities.AddItem('MayhemBonuses');

    Template.bIsASuppressionEffect = true;
    //Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
    Template.ActivationSpeech='Suppressing';

    Template.AssociatedPassives.AddItem('HoloTargeting');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = Suppression_LWBuildVisualization;
    Template.BuildAppliedVisualizationSyncFn = class'X2Ability_GrenadierAbilitySet'.static.SuppressionBuildVisualizationSync;
    Template.CinescriptCameraType = "StandardSuppression";

    Template.Hostility = eHostility_Offensive;

    return Template;    
}


static function X2AbilityTemplate SuppressionShot_LW()
{
    local X2AbilityTemplate                 Template;   
    local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Condition_Visibility            TargetVisibilityCondition;
    local X2AbilityTrigger_Event            Trigger;
    local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
    local X2Effect_RemoveEffects            RemoveSuppression;
    local X2Effect                          ShotEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'SuppressionShot_LW');

    Template.bDontDisplayInAbilitySummary = true;
    ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
    ReserveActionPointCost.iNumPoints = 1;
    ReserveActionPointCost.AllowedTypes.AddItem('Suppression');
    Template.AbilityCosts.AddItem(ReserveActionPointCost);
    
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.BuiltInHitMod = default.SUPPRESSION_LW_SHOT_AIM_BONUS;
    StandardAim.bReactionFire = true;

    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    TargetEffectCondition.AddRequireEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsNotSuppressed');
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

    TargetVisibilityCondition = new class'X2Condition_Visibility';  
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.bAllowAmmoEffects = true;

    RemoveSuppression = new class'X2Effect_RemoveEffects';
    RemoveSuppression.EffectNamesToRemove.AddItem(class'X2Effect_Suppression'.default.EffectName);
    RemoveSuppression.bCheckSource = true;
    RemoveSuppression.SetupEffectOnShotContextResult(true, true);
    Template.AddShooterEffect(RemoveSuppression);
    
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    //Trigger on movement - interrupt the move
    Trigger = new class'X2AbilityTrigger_Event';
    Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
    Trigger.MethodName = 'InterruptGameState';
    Template.AbilityTriggers.AddItem(Trigger);
    
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    //don't want to exit cover, we are already in suppression/alert mode.
    Template.bSkipExitCoverWhenFiring = true;

    Template.bAllowFreeFireWeaponUpgrade = true;    
//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
    ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect();
    ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
    Template.AddTargetEffect(ShotEffect);
    //  Various Soldier ability specific effects - effects check for the ability before applying    
    ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
    ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
    Template.AddTargetEffect(ShotEffect);
    
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;    
}

static function Suppression_LWBuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference          InteractingUnitRef;
    local XGUnit                        UnitVisualizer;
    local XComUnitPawn                  UnitPawn;
    local XComWeapon                    WeaponPawn;

    local VisualizationActionMetadata        EmptyTrack;
    local VisualizationActionMetadata        BuildTrack;

    local XComGameState_Ability         Ability;
    local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = Context.InputContext.SourceObject;

    //Configure the visualization track for the shooter
    //****************************************************************************************
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    
    //check and see if there's any sort of animation for suppression
    UnitVisualizer = XGUnit(BuildTrack.VisualizeActor);
    if(UnitVisualizer != none)
    {
        UnitPawn = UnitVisualizer.GetPawn();
        if(UnitPawn != none)
        {
            WeaponPawn = XComWeapon(UnitPawn.Weapon);
            if(WeaponPawn != none)
            {
                if(!UnitPawn.GetAnimTreeController().CanPlayAnimation(GetSuppressAnimName(UnitPawn)))
                {
                    // no playable animation, so use the default firing animation
                    WeaponPawn.WeaponSuppressionFireAnimSequenceName = WeaponPawn.WeaponFireAnimSequenceName;
                }
            }
        }
    }

    class'X2Action_ExitCover'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
    class'X2Action_StartSuppression'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
    //****************************************************************************************
    //Configure the visualization track for the target
    InteractingUnitRef = Context.InputContext.PrimaryTarget;
    Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
    SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
    if (XComGameState_Unit(BuildTrack.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(BuildTrack.StateObject_NewState).ReserveActionPoints.Length == 0)
    {
        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
        SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
    }
}

// code based on XComIdleAnimationStateMachine.state'Fire'.GetSuppressAnimName
static function Name GetSuppressAnimName(XComUnitPawn UnitPawn)
{
    local XComWeapon Weapon;

    Weapon = XComWeapon(UnitPawn.Weapon);
    if( Weapon != None && UnitPawn.GetAnimTreeController().CanPlayAnimation(Weapon.WeaponSuppressionFireAnimSequenceName) )
    {
        return Weapon.WeaponSuppressionFireAnimSequenceName;
    }
    else if( UnitPawn.GetAnimTreeController().CanPlayAnimation(class'XComWeapon'.default.WeaponSuppressionFireAnimSequenceName) )
    {
        return class'XComWeapon'.default.WeaponSuppressionFireAnimSequenceName;
    }
    return '';
}

static function X2AbilityTemplate AddAreaSuppressionAbility()
{
    local X2AbilityTemplate                             Template;
    local X2AbilityCost_Ammo                            AmmoCost;
    local X2AbilityCost_ActionPoints                    ActionPointCost;
    local X2AbilityMultiTarget_Radius                   RadiusMultiTarget;
    local X2Effect_ReserveActionPoints                  ReserveActionPointsEffect;
    local X2Condition_UnitInventory                     InventoryCondition, InventoryCondition2;
    local X2Effect_LW2WotC_AreaSuppression                      SuppressionEffect;
    local X2AbilityTarget_Single                        PrimaryTarget;
    local AbilityGrantedBonusRadius                     DangerZoneBonus;
    local X2Condition_UnitProperty                      ShooterCondition;
    local X2Condition_UnitEffects                       SuppressedCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'AreaSuppression');
    Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AreaSuppression";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
    Template.Hostility = eHostility_Offensive;
    Template.bDisplayInUITooltip = false;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.bCrossClassEligible = false;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
    Template.ActivationSpeech='Suppressing';
    Template.bIsASuppressionEffect = true;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);   
    Template.AddShooterEffectExclusions();
    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);

    ShooterCondition=new class'X2Condition_UnitProperty';
    ShooterCondition.ExcludeConcealed = true;
    Template.AbilityShooterConditions.AddItem(ShooterCondition);

    Template.AssociatedPassives.AddItem('HoloTargeting');

    InventoryCondition = new class'X2Condition_UnitInventory';
    InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
    InventoryCondition.ExcludeWeaponCategory = 'shotgun';
    Template.AbilityShooterConditions.AddItem(InventoryCondition);

    InventoryCondition2 = new class'X2Condition_UnitInventory';
    InventoryCondition2.RelevantSlot=eInvSlot_PrimaryWeapon;
    InventoryCondition2.ExcludeWeaponCategory = 'sniper_rifle';
    Template.AbilityShooterConditions.AddItem(InventoryCondition2);

    AmmoCost = new class'X2AbilityCost_Ammo';   
    AmmoCost.iAmmo = default.AREA_SUPPRESSION_AMMO_COST;
    Template.AbilityCosts.AddItem(AmmoCost);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
    ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
    Template.AbilityCosts.AddItem(ActionPointCost);

    ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
    ReserveActionPointsEffect.ReserveType = 'Suppression';
    ReserveActionPointsEffect.NumPoints = default.AREA_SUPPRESSION_MAX_SHOTS;
    Template.AddShooterEffect(ReserveActionPointsEffect);

    Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
    Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

    PrimaryTarget = new class'X2AbilityTarget_Single';
    PrimaryTarget.OnlyIncludeTargetsInsideWeaponRange = false;
    PrimaryTarget.bAllowInteractiveObjects = false;
    PrimaryTarget.bAllowDestructibleObjects = false;
    PrimaryTarget.bIncludeSelf = false;
    PrimaryTarget.bShowAOE = true;
    Template.AbilityTargetSTyle = PrimaryTarget;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bAllowDeadMultiTargetUnits = false;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    RadiusMultiTarget.bUseWeaponRadius = false;
    RadiusMultiTarget.ftargetradius = default.AREA_SUPPRESSION_RADIUS;
    
    DangerZoneBonus.RequiredAbility = 'DangerZone';
    DangerZoneBonus.fBonusRadius = default.DANGER_ZONE_BONUS_RADIUS;
    RadiusMultiTarget.AbilityBonusRadii.AddItem (DangerZoneBonus);
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;
    
    Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

    SuppressionEffect = new class'X2Effect_LW2WotC_AreaSuppression';
    SuppressionEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    SuppressionEffect.bRemoveWhenTargetDies = true;
    SuppressionEffect.bRemoveWhenSourceDamaged = true;
    SuppressionEffect.bBringRemoveVisualizationForward = true;
    SuppressionEffect.DuplicateResponse=eDupe_Allow;
    SuppressionEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionTargetEffectDesc, Template.IconImage);
    SuppressionEffect.SetSourceDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionSourceEffectDesc, Template.IconImage);
    Template.AddTargetEffect(SuppressionEffect);
    Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    Template.AddMultiTargetEffect(SuppressionEffect);
    Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
    
    Template.AdditionalAbilities.AddItem('AreaSuppressionShot_LW');
    Template.AdditionalAbilities.AddItem('LockdownBonuses');
    Template.AdditionalAbilities.AddItem('MayhemBonuses');

    Template.TargetingMethod = class'X2TargetingMethod_AreaSuppression';

    Template.BuildVisualizationFn = AreaSuppressionBuildVisualization_LW;
    Template.BuildAppliedVisualizationSyncFn = AreaSuppressionBuildVisualizationSync;
    Template.CinescriptCameraType = "StandardSuppression";  
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

//Adds multitarget visualization
simulated function AreaSuppressionBuildVisualization_LW(XComGameState VisualizeGameState)
{
    local XComGameStateHistory History;
    local XComGameStateContext_Ability  Context;
    local StateObjectReference          InteractingUnitRef;
    local VisualizationActionMetadata      EmptyTrack;
    local VisualizationActionMetadata        BuildTrack;
    local XComGameState_Ability         Ability;
    local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

    History = `XCOMHISTORY;

    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = Context.InputContext.SourceObject;

    //Configure the visualization track for the shooter
    //****************************************************************************************
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    
    class'X2Action_ExitCover'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
    class'X2Action_StartSuppression'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
    //****************************************************************************************
    //Configure the visualization track for the primary target

    InteractingUnitRef = Context.InputContext.PrimaryTarget;
    Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
    SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
    if (XComGameState_Unit(BuildTrack.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(BuildTrack.StateObject_NewState).ReserveActionPoints.Length == 0)
    {
        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
        SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
    }

    //Configure for the rest of the targets in AOE Suppression
    if (Context.InputContext.MultiTargets.Length > 0)
    {
        foreach Context.InputContext.MultiTargets(InteractingUnitRef)
        {
            Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
            BuildTrack = EmptyTrack;
            BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
            BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
            BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
            SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
            SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
            if (XComGameState_Unit(BuildTrack.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(BuildTrack.StateObject_NewState).ReserveActionPoints.Length == 0)
            {
                SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
                SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
            }
        }
    }
}

simulated function AreaSuppressionBuildVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack)
{
    local X2Action_ExitCover ExitCover;

    if (EffectName == class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName)
    {
        ExitCover = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree( BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded ));
        ExitCover.bIsForSuppression = true;

        class'X2Action_StartSuppression'.static.AddToVisualizationTree( BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded );
    }
}


static function X2AbilityTemplate AreaSuppressionShot_LW()
{
    local X2AbilityTemplate                 Template;   
    local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
    local X2AbilityToHitCalc_StandardAim    StandardAim;
    local X2Condition_Visibility            TargetVisibilityCondition;
    local X2AbilityTrigger_Event            Trigger;
    local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
    local X2Effect_RemoveAreaSuppressionEffect  RemoveAreaSuppression;
    local X2Effect                          ShotEffect;
    local X2AbilityCost_Ammo                AmmoCost;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'AreaSuppressionShot_LW');

    Template.bDontDisplayInAbilitySummary = true;
    ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
    ReserveActionPointCost.iNumPoints = 1;
    ReserveActionPointCost.AllowedTypes.AddItem('Suppression');
    Template.AbilityCosts.AddItem(ReserveActionPointCost);
    
    AmmoCost = new class'X2AbilityCost_Ammo';   
    AmmoCost.iAmmo = default.AREA_SUPPRESSION_SHOT_AMMO_COST;
    Template.AbilityCosts.AddItem(AmmoCost);

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.BuiltInHitMod = default.AREA_SUPPRESSION_LW_SHOT_AIM_BONUS;
    StandardAim.bReactionFire = true;

    Template.AbilityToHitCalc = StandardAim;
    Template.AbilityToHitOwnerOnMissCalc = StandardAim;

    Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

    TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
    TargetEffectCondition.AddRequireEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsNotSuppressed');
    Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

    TargetVisibilityCondition = new class'X2Condition_Visibility';  
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.bAllowAmmoEffects = true;

    // this handles the logic for removing just from the target (if should continue), or removing from all targets if running out of ammo
    RemoveAreaSuppression = new class'X2Effect_RemoveAreaSuppressionEffect';
    RemoveAreaSuppression.EffectNamesToRemove.AddItem(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName);
    RemoveAreaSuppression.bCheckSource =  true;
    RemoveAreaSuppression.SetupEffectOnShotContextResult(true, true);
    Template.AddTargetEffect(RemoveAreaSuppression);

    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    //Trigger on movement - interrupt the move
    Trigger = new class'X2AbilityTrigger_Event';
    Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
    Trigger.MethodName = 'InterruptGameState';
    Template.AbilityTriggers.AddItem(Trigger);
    
    Template.AbilitySourceName = 'eAbilitySource_Standard';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
    Template.bDisplayInUITooltip = false;
    Template.bDisplayInUITacticalText = false;

    //don't want to exit cover, we are already in suppression/alert mode.
    Template.bSkipExitCoverWhenFiring = true;

    Template.bAllowFreeFireWeaponUpgrade = true;    
//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
    ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect();
    ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
    Template.AddTargetEffect(ShotEffect);
    //  Various Soldier ability specific effects - effects check for the ability before applying    
    ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
    ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
    Template.AddTargetEffect(ShotEffect);
    
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;    
}


static function X2AbilityTemplate LockdownBonuses()
{
    local X2Effect_LockdownDamage           DamageEffect;
    local X2AbilityTemplate                 Template;   

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LockdownBonuses');
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.bDisplayInUITooltip = false;
    Template.bIsASuppressionEffect = true;
    //  Effect code checks whether unit has Lockdown before providing aim and damage bonuses
    DamageEffect = new class'X2Effect_LockdownDamage';
    DamageEffect.BuildPersistentEffect(1,true,false,false,eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(DamageEffect);
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;
}

static function X2AbilityTemplate MayhemBonuses()
{
    local X2Effect_Mayhem                   DamageEffect;
    local X2AbilityTemplate                 Template;   

    `CREATE_X2ABILITY_TEMPLATE(Template, 'MayhemBonuses');
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.bDisplayInUITooltip = false;
    Template.bIsASuppressionEffect = true;
    //  Effect code checks whether unit has Mayhem before providing aim and damage bonuses
    DamageEffect = new class'X2Effect_Mayhem';
    DamageEffect.BuildPersistentEffect(1,true,false,false,eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(DamageEffect);
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;
}
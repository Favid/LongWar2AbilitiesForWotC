class X2Ability_LW2WotC_FullOverrideAbilitySet extends X2Ability dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

// static function array<X2DataTemplate> CreateTemplates()
// {
//     local array<X2DataTemplate> Templates;

//     Templates.AddItem(AddFullOverride());
//     Templates.AddItem(FinalizeFullOverride());
//     Templates.AddItem(CancelFullOverride());
//     Templates.AddItem(AddHackRewardControlRobot_Mission());

//     return Templates;
// }

// static function X2AbilityTemplate AddFullOverride()
// {
//     local X2AbilityTemplate             Template;
//     local X2AbilityCharges              Charges;
//     local X2AbilityCost_Charges         ChargeCost;
//     local X2Condition_UnitEffects       NotHaywiredCondition;

//     Template = class'X2Ability_SpecialistAbilitySet'.static.ConstructIntrusionProtocol('FullOverride', , true);

//     Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

//     Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFullOverride";

//     Charges = new class'X2AbilityCharges';
//     Charges.InitialCharges = 1;
//     Template.AbilityCharges = Charges;

//     ChargeCost = new class'X2AbilityCost_Charges';
//     ChargeCost.NumCharges = 1;
//     ChargeCost.bOnlyOnHit = true;
//     Template.AbilityCosts.AddItem(ChargeCost);

//     NotHaywiredCondition = new class 'X2Condition_UnitEffects';
//     NotHaywiredCondition.AddExcludeEffect ('Haywired', 'AA_NoTargets');
//     Template.AbilityTargetConditions.AddItem(NotHaywiredCondition);

//     Template.CancelAbilityName = 'CancelFullOverride';
//     Template.AdditionalAbilities.AddItem('CancelFullOverride');
//     Template.FinalizeAbilityName = 'FinalizeFullOverride';
//     Template.AdditionalAbilities.AddItem('FinalizeFullOverride');

//     Template.AbilityTargetStyle = default.SimpleSingleTarget;

//     Template.ActivationSpeech = 'HaywireProtocol';

//     return Template;
// }

// static function X2AbilityTemplate CancelFullOverride()
// {
//     local X2AbilityTemplate             Template;

//     Template = class'X2Ability_SpecialistAbilitySet'.static.CancelIntrusion('CancelFullOverride');

//     Template.BuildNewGameStateFn = CancelFullOverride_BuildGameState;

//     return Template;
// }

// // Full override only consumes the charge on a successful hack. The charge is attached to the FullOverride ability
// // and is charged when the player first selects the ability, similar to the cooldown applied on Haywire protocol.
// // As for haywire, if the player cancels the hack we need to refund the charge. Full override also refunds the charge
// // if the hack is attempted but fails.
// static function RefundFullOverrideCharge(XComGameStateContext_Ability AbilityContext, XComGameState NewGameState)
// {
//     local XComGameState_Ability AbilityState;
//     local XComGameStateHistory History;

//     History = `XCOMHISTORY;

//     // locate the Ability gamestate for HaywireProtocol associated with this unit, and remove the turn timer
//     foreach History.IterateByClassType(class'XComGameState_Ability', AbilityState)
//     {
//         if( AbilityState.OwnerStateObject.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID &&
//            AbilityState.GetMyTemplateName() == 'FullOverride' )
//         {
//             AbilityState = XComGameState_Ability(NewGameState.CreateStateObject(class'XComGameState_Ability', AbilityState.ObjectID));
//             NewGameState.AddStateObject(AbilityState);
//             ++AbilityState.iCharges;
//             return;
//         }
//     }
// }

// // Player has aborted a full override: Refund the chage.
// function XComGameState CancelFullOverride_BuildGameState(XComGameStateContext Context)
// {
//     local XComGameStateContext_Ability AbilityContext;
//     local XComGameState NewGameState;

//     AbilityContext = XComGameStateContext_Ability(Context);
//     NewGameState = TypicalAbility_BuildGameState(Context);
//     RefundFullOverrideCharge(AbilityContext, NewGameState);
//     return NewGameState;
// }

// // Player has attempted a full override: Perform the normal hack finalization, but in addition
// // we need to check if the hack has failed. If so, refund the charge.
// simulated function XComGameState FinalizeFullOverrideAbility_BuildGameState(XComGameStateContext Context)
// {
//     local XComGameStateContext_Ability AbilityContext;
//     local XComGameState_BaseObject TargetState;
//     local XComGameState_Unit TargetUnit;
//     local XComGameState NewGameState;

//     // First perform the standard hack finalization.
//     NewGameState = class'X2Ability_DefaultAbilitySet'.static.FinalizeHackAbility_BuildGameState_Internal(Context);
//     AbilityContext = XComGameStateContext_Ability(Context);

//     // Check if we have succesfully hacked the target. If not, refund the charge.
//     TargetState = NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID);
//     TargetUnit = XComGameState_Unit(TargetState);
//     if (TargetUnit != none && !TargetUnit.bHasBeenHacked)
//     {
//         RefundFullOverrideCharge(AbilityContext, NewGameState);
//     }

//     return NewGameState;
// }

// static function X2AbilityTemplate FinalizeFullOverride()
// {
//     local X2AbilityTemplate                 Template;
//     local X2AbilityCost_ActionPoints        ActionPointCost;
//     local X2AbilityTarget_Single            SingleTarget;
//     local X2Effect_Persistent               HaywiredEffect;

//     `CREATE_X2ABILITY_TEMPLATE(Template, 'FinalizeFullOverride');
//     Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_intrusionprotocol";
//     Template.bDisplayInUITooltip = false;
//     Template.bLimitTargetIcons = true;
//     Template.bStationaryWeapon = true; // we move the gremlin during the action, don't move it before we're ready
//     Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
//     Template.AbilitySourceName = 'eAbilitySource_Perk';
//     Template.Hostility = eHostility_Neutral;

//     // successfully completing the hack requires and costs an action point
//     ActionPointCost = new class'X2AbilityCost_ActionPoints';
//     ActionPointCost.iNumPoints = 1;
//     ActionPointCost.bConsumeAllPoints = true;
//     Template.AbilityCosts.AddItem(ActionPointCost);

//     Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_Hacking';
//     Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

//     Template.AddShooterEffectExclusions();
//     Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

//     Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

//     SingleTarget = new class'X2AbilityTarget_Single';
//     SingleTarget.bAllowInteractiveObjects = true;
//     Template.AbilityTargetStyle = SingleTarget;

//     HaywiredEffect = new class'X2Effect_Persistent';
//     HaywiredEffect.EffectName = 'Haywired';
//     HaywiredEffect.BuildPersistentEffect(1, true, false);
//     HaywiredEffect.bDisplayInUI = false;
//     HaywiredEffect.bApplyOnMiss = true;
//     Template.AddTargetEffect(HaywiredEffect);

//     Template.CinescriptCameraType = "Specialist_IntrusionProtocol";

//     Template.BuildNewGameStateFn = FinalizeFullOverrideAbility_BuildGameState;
//     Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.FinalizeHackAbility_BuildVisualization;
//     Template.PostActivationEvents.AddItem('ItemRecalled');

//     //Template.OverrideAbilities.AddItem( 'FinalizeHack' );
//     Template.bOverrideWeapon = true;
//     Template.bSkipFireAction = true;
//     return Template;
// }

// static function X2AbilityTemplate AddHackRewardControlRobot_Mission()
// {
//     local X2AbilityTemplate                 Template;
//     local X2AbilityTrigger_EventListener    Listener;
//     local X2Effect_MindControl              ControlEffect;
//     local bool                              bInfiniteDuration;
//     local X2Effect_RemoveEffects            RemoveEffects;

//     `CREATE_X2ABILITY_TEMPLATE(Template, 'HackRewardControlRobot_Mission');

//     Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
//     Template.Hostility = eHostility_Neutral;

//     Template.AbilityToHitCalc = default.DeadEye;

//     Listener = new class'X2AbilityTrigger_EventListener';
//     Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
//     Listener.ListenerData.EventFn = class'XComGameState_Ability'.static.HackTriggerTargetListener;
//     Listener.ListenerData.EventID = class'X2HackRewardTemplateManager'.default.HackAbilityEventName;
//     Listener.ListenerData.Filter = eFilter_None;
//     Template.AbilityTriggers.AddItem(Listener);

//     Template.AbilityTargetStyle = default.SimpleSingleTarget;

//     bInfiniteDuration = true;
//     ControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(99, true, bInfiniteDuration);
//     Template.AddTargetEffect(ControlEffect);

//     // Remove any pre-existing disorient.
//     Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
//     Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());

//     RemoveEffects = new class'X2Effect_RemoveEffects';
//     RemoveEffects.EffectNamesToRemove.AddItem('HackRewardBuffEnemy0');
//     RemoveEffects.EffectNamesToRemove.AddItem('HackRewardBuffEnemy1');
//     Template.AddTargetEffect(RemoveEffects);

//     Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//     Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//     Template.bSkipFireAction = true;
//     Template.bShowActivation = true;

//     return Template;
// }

// Used for adding a Full Override'd Mec to the outpost. Not relevant for vanilla, so comment this out for future reference
// static function X2AbilityTemplate AddHackRewardControlRobot_Permanent()
// {
//     local X2AbilityTemplate                 Template;
//     local X2AbilityTrigger_EventListener    Listener;
//     local X2Effect_MindControl              ControlEffect;
//     local bool                              bInfiniteDuration;
//     local X2Effect_TransferMecToOutpost     Effect;
//     local X2Effect_PersistentStatChange     Buff;
//     local X2Effect_RemoveEffects            RemoveEffects;

//     `CREATE_X2ABILITY_TEMPLATE(Template, 'HackRewardControlRobot_Permanent');

//     Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
//     Template.Hostility = eHostility_Neutral;

//     Template.AbilityToHitCalc = default.DeadEye;

//     Listener = new class'X2AbilityTrigger_EventListener';
//     Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
//     Listener.ListenerData.EventFn = class'XComGameState_Ability'.static.HackTriggerTargetListener;
//     Listener.ListenerData.EventID = class'X2HackRewardTemplateManager'.default.HackAbilityEventName;
//     Listener.ListenerData.Filter = eFilter_None;
//     Template.AbilityTriggers.AddItem(Listener);

//     Template.AbilityTargetStyle = default.SimpleSingleTarget;

//     bInfiniteDuration = true;
//     ControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(99, true, bInfiniteDuration);
//     ControlEffect.bRemoveWhenSourceDies = false; // added for ID 1733 -- mind control effect is no longer lost when source unit dies or evacs
//     ControlEffect.EffectRemovedVisualizationFn = none; // No visualization of this effect being removed (which happens when the unit evacs or dies)
//     Template.AddTargetEffect(ControlEffect);

//     // Save MEC effect
//     Effect = new class'X2Effect_TransferMecToOutpost';
//     Effect.BuildPersistentEffect(1, true, false, true, eGameRule_PlayerTurnBegin); // for ID 1733, changed parameter 3 to falso, so effect is no longer lost when source unit dies or evacs
//     Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), "img:///UILibrary_PerkIcons.UIPerk_hack_reward", true,,Template.AbilitySourceName);
//     Effect.bRemoveWhenTargetDies = true;
//     Effect.bUseSourcePlayerState = true;
//     Template.AddTargetEffect(Effect);

//     Buff = new class'X2Effect_PersistentStatChange';
//     Buff.BuildPersistentEffect (1, true, true);
//     Buff.SetDisplayInfo(1, class'X2Ability_HackRewards'.default.ControlRobotStatName, class'X2Ability_HackRewards'.default.ControlRobotStatDesc, "img:///UILibrary_PerkIcons.UIPerk_hack_reward", true);
//     Buff.AddPersistentStatChange(eStat_Offense, float(class'X2Ability_HackRewards'.default.CONTROL_ROBOT_AIM_BONUS));
//     Buff.AddPersistentStatChange(eStat_CritChance, float(class'X2Ability_HackRewards'.default.CONTROL_ROBOT_CRIT_BONUS));
//     Buff.AddPersistentStatChange(eStat_Mobility, float(class'X2Ability_HackRewards'.default.CONTROL_ROBOT_MOBILITY_BONUS));
//     Template.AddTargetEFfect(Buff);

//     RemoveEffects = new class'X2Effect_RemoveEffects';
//     RemoveEffects.EffectNamesToRemove.AddItem('HackRewardBuffEnemy0');
//     RemoveEffects.EffectNamesToRemove.AddItem('HackRewardBuffEnemy1');
//     Template.AddTargetEffect(RemoveEffects);

//     // Remove any pre-existing disorient.
//     Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
//     Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());

//     Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//     Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//     Template.bSkipFireAction = true;
//     Template.bShowActivation = true;

//     return Template;
// }
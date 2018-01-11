//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_OfficerAbilitySet
//  AUTHOR:  Amineri / John Lumpkin (Long War Studios)
//  PURPOSE: Defines officer ability templates
//--------------------------------------------------------------------------------------- 
class X2Ability_OfficerAbilitySet extends X2Ability config (LW_OfficerPack);

var config int GETSOME_ACTIONPOINTCOST;
var config int GETSOME_CRIT_BONUS;
var config int GETSOME_CHARGES;
var config int GETSOME_DURATION;
var config int FALLBACK_ACTIONPOINTCOST;
var config int FALLBACK_COOLDOWN;
var config int OSCARMIKE_ACTIONPOINTCOST;
var config int OSCARMIKE_CHARGES;
var config int OSCARMIKE_DURATION;
var config int OSCARMIKE_MOBILITY_BONUS;
var config int COLLECTOR_BONUS_INTEL_LOW;
var config int COLLECTOR_BONUS_INTEL_RANDBONUS;
var config int COLLECTOR_BONUS_CHANCE;

var localized string strCollector_WorldMessage;
var localized string FocussedFriendlyName;
var localized string FocussedFriendlyDesc;

var config float BaseCommandRange;
var config float CommandRangePerRank;
var config array<float> COMMANDRANGE_DIFFICULTY_MULTIPLER;

var const name OfficerSourceName; // change this once UI work is done 

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//rev 3 abilities
	Templates.AddItem(AddGetSomeAbility());
	Templates.AddItem(AddCollectorAbility());
	Templates.AddItem(AddFocusFireAbility());
	Templates.AddItem(AddFallBackAbility());
	Templates.AddItem(AddScavengerAbility());
	Templates.AddItem(AddOscarMikeAbility());

	//Templates.AddItem(CollectorPassive());
	Templates.AddItem(ScavengerPassive());

	return Templates;
}

// ******* Helper function ******* //

static function float GetCommandRangeSq(XComGameState_Unit Unit) 
{
	local float range;
	local XComGameState_Unit_LWOfficer OfficerState;

	range = default.BaseCommandRange;
	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
	if (OfficerState != none)
	{
		range += float(OfficerState.GetOfficerRank()) * default.CommandRangePerRank;
	} else {
		`Redscreen("LW Officer Pack: Computing Command Range unit with no Officer Component");
	}
	range *= default.COMMANDRANGE_DIFFICULTY_MULTIPLER[`CAMPAIGNDIFFICULTYSETTING];

	//`log("LW Officer Pack: CommandRange=" $ range);
	return range*range;
	//return 49.0;
}


//LT1: GetSome, use a action to give everybody in range a crit bonus
//Needs Aura AOE
static function X2AbilityTemplate AddGetSomeAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;		
	local X2Effect_PersistentStatChange		StatEffect;			
	local X2AbilityTargetStyle				TargetStyle; 
	local X2Condition_UnitProperty			MultiTargetProperty;
	//local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;						

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GetSome');

	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityWhereItHurts";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipFireAction = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.GETSOME_ACTIONPOINTCOST;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = default.GETSOME_CHARGES;
    Template.AbilityCharges = Charges;
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);
	
	Template.AbilityToHitCalc = default.Deadeye;

	TargetStyle = new class 'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	MultiTargetProperty = new class'X2Condition_UnitProperty';
	MultiTargetProperty.ExcludeAlive = false;
    MultiTargetProperty.ExcludeDead = true;
    MultiTargetProperty.ExcludeHostileToSource = true;
    MultiTargetProperty.ExcludeFriendlyToSource = false;
    MultiTargetProperty.RequireSquadmates = true;
    MultiTargetProperty.ExcludePanicked = true;
	MultiTargetProperty.ExcludeRobotic = true;
	MultiTargetProperty.ExcludeStunned = true;
	// Template.AbilityMultiTargetConditions.AddItem(MultiTargetProperty); -- has no effect in overridden class'X2AbilityMultiTarget_LWOfficerCommandRange'

	//add command range
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_LWOfficerCommandRange';


	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.BuildPersistentEffect(default.GETSOME_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	StatEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); // adjust?
	StatEffect.DuplicateResponse = eDupe_Refresh;
	StatEffect.AddPersistentStatChange (eStat_CritChance, float (default.GETSOME_CRIT_BONUS));
	StatEffect.TargetConditions.AddItem(MultiTargetProperty); // prevent exclusion on effect apply instead of in targeting
	Template.AddMultiTargetEffect(StatEffect);
	
	Template.AbilityConfirmSound = "Unreal2DSounds_NewWeaponUnlocked";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = GetSome_BuildVisualization;

	return Template;
}

//LT 2 Collector has an X% chance ot add y bonus intel for each kill
static function X2AbilityTemplate AddCollectorAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Collector				CollectorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Collector');
	
	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityCollector";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	CollectorEffect = new class'X2Effect_Collector';
	CollectorEffect.BuildPersistentEffect(1, true, true);
	CollectorEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(CollectorEffect);

	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);  
	//Template.AdditionalAbilities.AddItem('CollectorPassive');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;  // deliberately no visualization
	return Template;
}

// ***** OLD VERSION THAT USED EVENT CALLBACKS BELOW *****
//static function X2AbilityTemplate AddCollectorAbility()
//{
	//local X2AbilityTemplate                 Template;
	//local X2AbilityTrigger_EventListener	Listener;
	//local X2Condition_UnitProperty			ShooterPropertyConditions;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'Collector');
	//Template.IconImage = "img://UILibrary_LW_OfficerPack.LWOfficers_AbilityCollector";
	//Template.AbilitySourceName = default.OfficerSourceName;
	//Template.Hostility = eHostility_Neutral;
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
//
	//Template.AbilityToHitCalc = default.Deadeye;
	//Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//ShooterPropertyConditions = new class 'X2Condition_UnitProperty';
	//ShooterPropertyConditions.ExcludeDead = true;
	//ShooterPropertyConditions.ExcludeImpaired = true;
	//ShooterPropertyConditions.ExcludePanicked = true;
	//ShooterPropertyConditions.ExcludeInStasis = true;
	//ShooterPropertyConditions.ExcludeStunned = true;
	//Template.AbilityShooterConditions.AddItem(ShooterPropertyConditions);
//
	//Template.AbilityTargetStyle = new class 'X2AbilityTarget_Self';
	//Template.AdditionalAbilities.AddItem('CollectorPassive');
//
	//Listener = new class'X2AbilityTrigger_EventListener';
    //Listener.ListenerData.Filter = eFilter_None;
    //Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
	//Listener.ListenerData.EventID = 'UnitDied';
    //Listener.ListenerData.EventFn = CollectionCheck;
	//Template.AbilityTriggers.AddItem(Listener);
//
	//Template.bSkipFireAction = true;
//
	////No gamestate or visualization triggered here, as that is all handled by the ability trigger
	//Template.BuildNewGameStateFn = Empty_BuildGameState;
//
	//return Template;
//}

function XComGameState Empty_BuildGameState( XComGameStateContext Context )
{
	return none;
}

static function X2AbilityTemplate CollectorPassive()
{
 return PurePassive('CollectorPassive', "img://UILibrary_LW_OfficerPack.LWOfficers_AbilityCollector", , class'X2Ability_OfficerAbilitySet'.default.OfficerSourceName);
}

//***** MOVED TO XComGameState_Effect_Collector ***** KEEPING FOR BACKWARDS COMPATIBILITY ONLY
static function EventListenerReturn CollectionCheck(Object EventData, Object EventSource, XComGameState GameState, name EventID)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local XComGameState_Ability				AbilityState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local int								RandRoll, IntelGain;
	local XComGameState_Unit				SourceUnit, DeadUnit;
	//local XComGameState						NewGameState;
	//local XComGameStateContext_ChangeContainer ChangeContainer;

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(GameState.GetContext());
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	`log("Collection: AbilityState=" $ AbilityState.GetMyTemplateName());
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	`LOG ("COLLECTION:" @ string(SourceUnit.GetMyTemplateName()));
	If (SourceUnit == none) 
	{
		`Redscreen("CollectionCheck: No source");
		return ELR_NoInterrupt;
	}
	DeadUnit = XComGameState_Unit(EventData);
	`LOG ("COLLECTION:" @ string(DeadUnit.GetMyTemplateName()));
	If (DeadUnit == none)
	{
		`Redscreen("CollectionCheck: No killed unit");
		return ELR_NoInterrupt;
	}
	IntelGain = 0;
	if (DeadUnit.IsEnemyUnit(SourceUnit)) 
	{
		if (SourceUnit.GetTeam() == eTeam_XCom)
		{
			if ((!DeadUnit.IsMindControlled()) && (DeadUnit.GetMyTemplateName() != 'PsiZombie') && (DeadUnit.GetMyTemplateName() != 'PsiZombieHuman'))
			{
				RandRoll = `SYNC_RAND_STATIC(100);
				if (RandRoll < default.COLLECTOR_BONUS_CHANCE)
				{
					IntelGain = default.COLLECTOR_BONUS_INTEL_LOW + `SYNC_RAND_STATIC(default.COLLECTOR_BONUS_INTEL_RANDBONUS);
					If (IntelGain > 0)
					{
						//option 1 -- attach to existing state, use PostBuildVisualization
						XCOMHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
						XCOMHQ.AddResource(GameState, 'Intel', IntelGain);
						GameState.GetContext().PostBuildVisualizationFn.AddItem(Collector_BuildVisualization);

						//option 2 -- build new state, use PostBuildVisualization
						//XCOMHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
						//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Collector ability gain");
						//XCOMHQ.AddResource(NewGameState, 'Intel', IntelGain);
						//StateChangeContainer.InputContext.SourceObject = kUnit.GetReference();
						//NewGameState.GetContext().PostBuildVisualizationFn.AddItem(Collector_BuildVisualization);
						//`TACTICALRULES.SubmitGameState(NewGameState);

						//option 3 -- build new state, add attach BuildVisualization to change container
						//XCOMHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
						//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Collector ability gain");
						//XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = Collector_BuildVisualization;
						//XCOMHQ.AddResource(NewGameState, 'Intel', IntelGain);
						//`TACTICALRULES.SubmitGameState(NewGameState);
					}
				}
			}
		}

	}
	return ELR_NoInterrupt;
}


//***** MOVED TO XComGameState_Effect_Collector ***** KEEPING FOR BACKWARDS COMPATIBILITY ONLY
//static 
function Collector_BuildVisualization(XComGameState VisualizeGameState) // , out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		Context;
    //local VisualizationTrack				EmptyTrack, BuildTrack; // deprecated in WOTC
	local VisualizationActionMetadata		ActionMetadata;
	local XComGameState_Unit				UnitState;
    local X2Action_PlayWorldMessage			MessageAction;

	//local XComPresentationLayer				Presentation;
    //local XGParamTag						kTag;
    //local StateObjectReference				InteractingUnitRef;
	//local X2Action_PlaySoundAndFlyOver		SoundAndFlyoverTarget;
	//local XComGameState_Ability				Ability;
	//local XComGameState_Effect				EffectState;


    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	//Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    //InteractingUnitRef = context.InputContext.SourceObject;
   
	//`LOG ("COLLECTION: Building Collector Track");
	//BuildTrack = EmptyTrack;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	//`LOG ("COLLECTION: VisSoureUnit=" @ UnitState.GetFullName());
	ActionMetadata.StateObject_NewState = UnitState; // Previously BuildTrack.StateObject_NewState
	ActionMetadata.StateObject_OldState = UnitState; // Previously BuildTrack.StateObject_OldState
	ActionMetadata.VisualizeActor = UnitState.GetVisualizer(); // Previously BuildTrack.TrackActor
	//MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTrack(BuildTrack, VisualizeGameState.GetContext()));
	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	MessageAction.AddWorldMessage(default.strCollector_WorldMessage);
	//OutVisualizationTracks.AddItem(BuildTrack);
}

//CAPT 2 Focus Fire
//FocusFire makes each subsequent attack against designated enemy gain +x to-hit -- also grants +1 armor piercing to all attacks
static function X2AbilityTemplate AddFocusFireAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Effect_FocusFire				FocusFireEffect;
	local X2Condition_UnitEffects UnitEffectsCondition;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'FocusFire');
	Template.IconImage = "img://UILibrary_LW_OfficerPack.LWOfficers_AbilityTakeItDown";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	//Template.bDisplayInUITacticalText = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipFireAction = true;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = class'X2Effect_FocusFire'.default.FOCUSFIRE_ACTIONPOINTCOST;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = class'X2Effect_FocusFire'.default.FOCUSFIRE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible=true;
	TargetVisibilityCondition.bAllowSquadsight=false;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Target cannot already be focussed on
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_FocusFire'.default.EffectName, 'AA_UnitIsFocussed');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	// Needs effect implementation
	FocusFireEffect = new class'X2Effect_FocusFire';
	//FocusFireEffect.EffectName = default.MarkedName;
	FocusFireEffect.DuplicateResponse = eDupe_Ignore;
	FocusFireEffect.BuildPersistentEffect(class'X2Effect_FocusFire'.default.FOCUSFIRE_DURATION, false, true,,eGameRule_PlayerTurnEnd);
	//FocusFireEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	FocusFireEffect.SetDisplayInfo(ePerkBuff_Penalty, default.FocussedFriendlyName, default.FocussedFriendlyDesc, Template.IconImage, true,, Template.AbilitySourceName);
	FocusFireEffect.VisualizationFn = class'X2StatusEffects'.static.MarkedVisualization;
	FocusFireEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.MarkedVisualizationTicked;
	FocusFireEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.MarkedVisualizationRemoved;
	FocusFireEffect.bRemoveWhenTargetDies = true;

	Template.AddTargetEffect(FocusFireEffect);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = true;
    UnitPropertyCondition.ExcludeUnrevealedAI = true;
	UnitPropertyCondition.ExcludeConcealed = true;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.ExcludeAlive = false;   
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.RequireSquadmates = false;
    UnitPropertyCondition.ExcludePanicked = false;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeStunned = false;
	UnitPropertyCondition.ExcludeNoCover = false;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;

    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityConfirmSound = "Unreal2DSounds_TargetLock";
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = FocusFire_BuildVisualization;

	return Template;
}
 
//MAJ 1 Fall Back
static function X2AbilityTemplate AddFallBackAbility()
{	
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Effect_FallBack				FallBackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FallBack');
	Template.IconImage = "img://UILibrary_LW_OfficerPack.LWOfficers_AbilityFallBack";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipFireAction = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.FALLBACK_ACTIONPOINTCOST;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FALLBACK_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.Deadeye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible=true;
	TargetVisibilityCondition.bAllowSquadsight=false;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeUnrevealedAI = true;
	UnitPropertyCondition.ExcludeConcealed = false;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.ExcludeAlive = false;   
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludePanicked = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeStunned = true;
	UnitPropertyCondition.ExcludeNoCover = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	FallBackEffect = new class'X2Effect_FallBack';
	Template.AddTargetEffect(FallBackEffect);

	Template.AbilityConfirmSound = "Unreal2DSounds_GeneMod_SecondHeart";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = FallBack_BuildVisualization;  
	return Template;
}

//plays wave when ability fires
function FallBack_BuildVisualization(XComGameState VisualizeGameState) // , out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    //local VisualizationTrack				EmptyTrack, BuildTrack; // deprecated in WOTC
	local VisualizationActionMetadata		ActionMetadata;
    local X2Action_PlayAnimation			PlayAnimationAction;
	
    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = context.InputContext.SourceObject;
    //BuildTrack = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1); // Previously BuildTrack.StateObject_OldState
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID); // Previously BuildTrack.StateObject_NewState
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID); // Previously BuildTrack.TrackActor
 	
	//PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(BuildTrack, context));
	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_SignalEncourage';
	PlayAnimationAction.bFinishAnimationWait = true;

	//OutVisualizationTracks.AddItem(BuildTrack);
}

//MAJ 2 Scavenger adds +X supplies per mission
static function X2AbilityTemplate AddScavengerAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Scavenger				ScavengerEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Scavenger');
	
	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityScavenger";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	ScavengerEffect = new class'X2Effect_Scavenger';
	ScavengerEffect.BuildPersistentEffect(1, true, true);
	ScavengerEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(ScavengerEffect);

	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);  

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;  // deliberately no visualization
	return Template;
}

static function X2AbilityTemplate ScavengerPassive()
{
 return PurePassive('ScavengerPassive', "img://UILibrary_LW_OfficerPack.LWOfficers_AbilityScavenger", , class'X2Ability_OfficerAbilitySet'.default.OfficerSourceName);
}


//COL 2 Oscar Mike

static function X2AbilityTemplate AddOscarMikeAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2Condition_UnitProperty			MultiTargetProperty;
	//local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityCost_Charges				ChargeCost;
	local X2Effect_PersistentStatChange		StatEffect;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'OscarMike');
	Template.IconImage = "img://UILibrary_LW_OfficerPack.LWOfficers_AbilityOscarMike";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipFireAction = true;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.OSCARMIKE_ACTIONPOINTCOST;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = default.OSCARMIKE_CHARGES;
    Template.AbilityCharges = Charges;
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.Deadeye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = new class 'X2AbilityTarget_Self';

	MultiTargetProperty = new class'X2Condition_UnitProperty';
	MultiTargetProperty.ExcludeAlive = false;
    MultiTargetProperty.ExcludeDead = true;
    MultiTargetProperty.ExcludeHostileToSource = true;
    MultiTargetProperty.ExcludeFriendlyToSource = false;
    MultiTargetProperty.RequireSquadmates = true;
    MultiTargetProperty.ExcludePanicked = true;
	MultiTargetProperty.ExcludeRobotic = true;
	MultiTargetProperty.ExcludeStunned = true;
	MultiTargetProperty.TreatMindControlledSquadmateAsHostile = true;
	//Template.AbilityMultiTargetConditions.AddItem(MultiTargetProperty); // no function in overridden class'X2AbilityMultiTarget_LWOfficerCommandRange'

	//add command range
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_LWOfficerCommandRange';


	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.BuildPersistentEffect(default.OSCARMIKE_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	StatEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	StatEffect.DuplicateResponse = eDupe_Refresh;
	StatEffect.AddPersistentStatChange (eStat_Mobility, float (default.OSCARMIKE_MOBILITY_BONUS));
	StatEffect.TargetConditions.AddItem(MultiTargetProperty); // prevent exclusion on effect apply instead of in targeting
	Template.AddMultiTargetEffect(StatEffect);

	Template.AbilityConfirmSound = "Unreal2DSounds_CommLink";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = OscarMike_BuildVisualization;
	return Template;
}



function GetSome_BuildVisualization(XComGameState VisualizeGameState) // , out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    //local VisualizationTrack				EmptyTrack, BuildTrack, TargetTrack; // deprecated in WOTC
	local VisualizationActionMetadata		ActionMetadata, TargetMetadata;
    local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover, SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    //BuildTrack = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1); // Previously BuildTrack.StateObject_OldState
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID); // Previously BuildTrack.StateObject_NewState
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID); // Previously BuildTrack.TrackActor
    
    //SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, context));
    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);
	
	//PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(BuildTrack, context));
	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'LL_SignalGoAheadFwd';
	PlayAnimationAction.bFinishAnimationWait = true;

	//OutVisualizationTracks.AddItem(BuildTrack);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'GetSome')
		{
			//TargetTrack = EmptyTrack;
			UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			if ((UnitState != none) && (EffectState.StatChanges.Length > 0))
			{
				TargetMetadata.StateObject_NewState = UnitState; // Previously TargetTrack.StateObject_NewState
				TargetMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1); // Previously TargetTrack.StateObject_OldState
				TargetMetadata.VisualizeActor = UnitState.GetVisualizer(); // Previously TargetTrack.TrackActor
				//SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(TargetTrack, context));
				SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetMetadata, context, false, TargetMetadata.LastActionAdded));
				SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
				//OutVisualizationTracks.AddItem(TargetTrack);
			}
		}
	}
}

function OscarMike_BuildVisualization(XComGameState VisualizeGameState) // , out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    //local VisualizationTrack				EmptyTrack, BuildTrack, TargetTrack; // deprecated in WOTC
	local VisualizationActionMetadata		ActionMetadata, TargetMetadata;
    local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover, SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    //BuildTrack = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1); // Previously BuildTrack.StateObject_OldState
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID); // Previously BuildTrack.StateObject_NewState
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID); // Previously BuildTrack.TrackActor
    
    //SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, context));
    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);
	
	//class'X2Action_ExitCover'.static.AddToVisualizationTrack(BuildTrack, context);
	class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded);

	//PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(BuildTrack, context));
	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_SignalYellA';
	PlayAnimationAction.bFinishAnimationWait = true;
	
	//class'X2Action_EnterCover'.static.AddToVisualizationTrack(BuildTrack, context);
	class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded);

	//OutVisualizationTracks.AddItem(BuildTrack);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'OscarMike')
		{
			//TargetTrack = EmptyTrack;
			UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			if ((UnitState != none) && (EffectState.StatChanges.Length > 0))
			{
				TargetMetadata.StateObject_NewState = UnitState; // Previously TargetTrack.StateObject_NewState
				TargetMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1); // Previously TargetTrack.StateObject_OldState
				TargetMetadata.VisualizeActor = UnitState.GetVisualizer(); // Previously TargetTrack.TrackActor
				//SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(TargetTrack, context));
				SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetMetadata, context, false, TargetMetadata.LastActionAdded));
				SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
				//OutVisualizationTracks.AddItem(TargetTrack);
			}
		}
	}
}

function FocusFire_BuildVisualization(XComGameState VisualizeGameState) // , out array<VisualizationTrack> OutVisualizationTracks)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    //local VisualizationTrack				EmptyTrack, BuildTrack, TargetTrack; // deprecated in WOTC
	local VisualizationActionMetadata		ActionMetadata, TargetMetadata;
    local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover, SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	//local X2VisualizerInterface				TargetVisualizerInterface;
	//local int								I;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    //BuildTrack = EmptyTrack;
    ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1); // Previously BuildTrack.StateObject_OldState
    ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID); // Previously BuildTrack.StateObject_NewState
    ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID); // Previously BuildTrack.TrackActor
    
    //SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(BuildTrack, context));
    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);
	
	//PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTrack(BuildTrack, context));
	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, context, false, ActionMetadata.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_SignalPointA';
	PlayAnimationAction.bFinishAnimationWait = true;

	//OutVisualizationTracks.AddItem(BuildTrack);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'FocusFire')
		{
			//TargetTrack = EmptyTrack;
			UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			if (UnitState != none) 
			{
				TargetMetadata.StateObject_NewState = UnitState; // Previously TargetTrack.StateObject_NewState
				TargetMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1); // Previously TargetTrack.StateObject_OldState
				TargetMetadata.VisualizeActor = UnitState.GetVisualizer(); // Previously TargetTrack.TrackActor
				//SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTrack(TargetTrack, context));
				SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetMetadata, context, false, TargetMetadata.LastActionAdded));
				SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
				//OutVisualizationTracks.AddItem(TargetTrack);
			}
		}
	}
}


DefaultProperties
{
	OfficerSourceName = "eAbilitySource_Perk"
}	
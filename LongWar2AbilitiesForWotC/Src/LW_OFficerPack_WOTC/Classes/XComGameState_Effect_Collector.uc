//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Collector.uc
//  AUTHOR:  Amineri (Long War Studios)
//  PURPOSE: This is a component extension for Effect GameStates, containing 
//				additional data used for Collector.
//---------------------------------------------------------------------------------------
class XComGameState_Effect_Collector extends XComGameState_BaseObject config(LW_OfficerPack);

function XComGameState_Effect_Collector InitComponent()
{
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

function EventListenerReturn CollectionCheck(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData) // Added CallbackData
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local XComGameState_Ability				AbilityState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local int								RandRoll, IntelGain;
	local XComGameState_Unit				SourceUnit, DeadUnit, CollectionUnit;
	local XComGameState_Effect EffectState;
	//local XComGameState						NewGameState;
	//local XComGameStateContext_ChangeContainer ChangeContainer;

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(GameState.GetContext());
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	`log("Collection: AbilityState=" $ AbilityState.GetMyTemplateName());
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	`LOG ("COLLECTION:" @ string(SourceUnit.GetMyTemplateName()));

	EffectState = GetOwningEffect();
	if (EffectState == none)
	{
		`RedScreen("ScavengerCheck: no parent effect");
		return ELR_NoInterrupt;
	}

	CollectionUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (CollectionUnit == none)
		CollectionUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (CollectionUnit == none) 
	{
		`RedScreen("CollectorCheck: no collector officer unit");
		return ELR_NoInterrupt;
	}

	if(!CollectionUnit.IsAbleToAct()) { return ELR_NoInterrupt; }
	if(CollectionUnit.bRemovedFromPlay) { return ELR_NoInterrupt; }
	if(CollectionUnit.IsMindControlled()) { return ELR_NoInterrupt; }

	//if (CollectionUnit.IsDead() 
		//|| CollectionUnit.IsUnconscious()
		//|| CollectionUnit.bRemovedFromPlay()) 
		//{ return ELR_NoInterrupt; }

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
				if (RandRoll < class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_CHANCE)
				{
					IntelGain = class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_INTEL_LOW + `SYNC_RAND_STATIC(class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_INTEL_RANDBONUS);
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
	MessageAction.AddWorldMessage(class'X2Ability_OfficerAbilitySet'.default.strCollector_WorldMessage);
	//OutVisualizationTracks.AddItem(BuildTrack);
}

Class X2Effect_LW2WotC_LightningReflexes extends X2Effect_Persistent config (LW_SoldierSkills);

var config int LR_LW_FIRST_SHOT_PENALTY;
var config int LR_LW_PENALTY_REDUCTION_PER_SHOT;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Effect_LW2WotC_IncomingReactionFire         LightningReflexesEffectState;
    local X2EventManager                                    EventMgr;
    local Object                                            ListenerObj;
    local XComGameState_Unit                                UnitState;

    EventMgr = `XEVENTMGR;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    
    if (GetLightningReflexesEffectState(NewEffectState) == none)
    {
        LightningReflexesEffectState = XComGameState_Effect_LW2WotC_IncomingReactionFire(NewGameState.CreateStateObject(class'XComGameState_Effect_LW2WotC_IncomingReactionFire'));
        LightningReflexesEffectState.InitComponent();
        LightningReflexesEffectState.InitFlyoverComponent();
        NewEffectState.AddComponentObject(LightningReflexesEffectState);
        NewGameState.AddStateObject(LightningReflexesEffectState);
    }
    ListenerObj = LightningReflexesEffectState;
    if (ListenerObj == none)
    {
        `Redscreen("LightningReflexes: Failed to find LightningReflexes Component when registering listener");
        return;
    }

    EventMgr.RegisterForEvent(ListenerObj, 'PlayerTurnBegun', LightningReflexesEffectState.ResetUses, ELD_OnStateSubmitted);
    EventMgr.RegisterForEvent(ListenerObj, 'UnitMoveFinished', LightningReflexesEffectState.ResetFlyover, ELD_OnStateSubmitted,, UnitState);
    EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', LightningReflexesEffectState.IncomingReactionFireCheck, ELD_OnStateSubmitted);
    EventMgr.RegisterForEvent(ListenerObj, 'LightningReflexesLWTriggered2', LightningReflexesEffectState.IncrementUses, ELD_OnStateSubmitted,, UnitState);
    EventMgr.RegisterForEvent(ListenerObj, 'LightningReflexesLWTriggered', LightningReflexesEffectState.TriggerLRFlyover, ELD_OnStateSubmitted,, UnitState);
	EventMgr.RegisterForEvent(ListenerObj, 'TacticalGameEnd', LightningReflexesEffectState.OnTacticalGameEnd, ELD_OnStateSubmitted);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_BaseObject EffectComponent;
    local Object EffectComponentObj;
    
    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

    EffectComponent = GetLightningReflexesEffectState(RemovedEffectState);
    if (EffectComponent == none)
        return;

    EffectComponentObj = EffectComponent;
    `XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

    NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_LW2WotC_IncomingReactionFire GetLightningReflexesEffectState(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Effect_LW2WotC_IncomingReactionFire(Effect.FindComponentObject(class'XComGameState_Effect_LW2WotC_IncomingReactionFire'));
    return none;
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

    if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
        return;

    if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none)
    {
        if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire)
        {
            ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = -(default.LR_LW_FIRST_SHOT_PENALTY-(clamp((GetLightningReflexesEffectState(EffectState).uses) * default.LR_LW_PENALTY_REDUCTION_PER_SHOT,0,default.LR_LW_FIRST_SHOT_PENALTY)));
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}

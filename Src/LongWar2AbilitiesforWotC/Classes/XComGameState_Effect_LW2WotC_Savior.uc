//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_LW2WotC_Savior.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is an effect component extension listening for medikit heals to grant extra health to the healed unit
//---------------------------------------------------------------------------------------

class XComGameState_Effect_LW2WotC_Savior extends XComGameState_BaseObject;

function XComGameState_Effect_LW2WotC_Savior InitComponent()
{
    return self;
}

function XComGameState_Effect GetOwningEffect()
{
    return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

//This is triggered by a Medikit heal
simulated function EventListenerReturn OnMedikitHeal(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit SourceUnit, TargetUnit;
    local XpEventData XpEvent;
    local XComGameStateHistory History;
    local XComGameState_Effect EffectState;

    History = `XCOMHISTORY;
    XpEvent = XpEventData(EventData);
    if(XpEvent == none)
    {
        return ELR_NoInterrupt;
    }
    EffectState = GetOwningEffect();
    if (EffectState == none || EffectState.bReadOnly)  // this indicates that this is a stale effect from a previous battle
        return ELR_NoInterrupt;

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(XpEvent.XpEarner.ObjectID));
    if(SourceUnit == none || SourceUnit != XComGameState_Unit(History.GetGameStateForObjectID(GetOwningEffect().ApplyEffectParameters.TargetStateObjectRef.ObjectID)))
        return ELR_NoInterrupt;

    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(XpEvent.EventTarget.ObjectID));
    if(TargetUnit == none)
        return ELR_NoInterrupt;

    TargetUnit.ModifyCurrentStat(eStat_HP, class'X2Effect_LW2WotC_Savior'.default.SAVIOR_BONUS_HEAL_AMMOUNT);

    //visualization function    
    GameState.GetContext().PostBuildVisualizationFn.AddItem(Savior_BuildVisualization);

    return ELR_NoInterrupt;
}

function Savior_BuildVisualization(XComGameState VisualizeGameState)
{
    local XComGameStateHistory              History;
    local XComGameStateContext_Ability      Context;
    local VisualizationActionMetadata                EmptyTrack, BuildTrack;
    local XComGameState_Unit                UnitState;
    local X2Action_PlayWorldMessage         MessageAction;
    local XGParamTag                        kTag;
    local string                            WorldMessage;

    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
   
    BuildTrack = EmptyTrack;
    UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
    BuildTrack.StateObject_NewState = UnitState;
    BuildTrack.StateObject_OldState = UnitState;
    BuildTrack.VisualizeActor = UnitState.GetVisualizer();
    MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));

    kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
    if (kTag != none)
    {
        kTag.IntValue0 = class'X2Effect_LW2WotC_Savior'.default.SAVIOR_BONUS_HEAL_AMMOUNT;
        WorldMessage = `XEXPAND.ExpandString(class'X2Effect_LW2WotC_Savior'.default.strSavior_WorldMessage);
    } else {
        WorldMessage = "Placeholder Savior bonus (no XGParamTag)";
    }
    MessageAction.AddWorldMessage(WorldMessage);

}
class X2Effect_LW2WotC_RemoveReserveActionPoints extends X2Effect;

protected simulated function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit TargetUnit;
    
    TargetUnit = XComGameState_Unit(kNewTargetState);
    TargetUnit.ReserveActionPoints.Length = 0;
}
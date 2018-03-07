///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Trojan
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for TrojanVirus ability -- hacked target has special effects at end of hack
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_LW2WotC_TrojanVirus extends X2Effect_Persistent config(LW_SoldierSkills);

var config int TROJANVIRUSROLLS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'UnitGroupTurnBegun', PostEffectTickCheck, ELD_OnStateSubmitted, 25,,true, EffectObj);
}

//This is triggered at the start of each turn, after OnTickEffects (so after Hack stun/Mind Control effects are lost)
//The purpose is to check and see if those effects have been removed, in which case the Trojan Virus effects activate, then the effect is removed
static function EventListenerReturn PostEffectTickCheck(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameStateHistory History;
    local XComGameStateContext_TickEffect TickContext;
    local XComGameState NewGameState;
    local XComGameState_Unit OldTargetState, NewTargetState, SourceState;
    local XComGameState_Effect OwningEffect;
    local float AttackerHackStat, DefenderHackDefense, Damage;
    local int idx;

    //`LOG("PerkPack(Trojan): PostEffectTickCheck: Enter");

    History = `XCOMHISTORY;

    OwningEffect = XComGameState_Effect(CallbackData);
    if(OwningEffect == none)
        return ELR_NoInterrupt;

    OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(OwningEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    SourceState = XComGameState_Unit(History.GetGameStateForObjectID(OwningEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    // don't do anything if unit is still mind controlled or stunned
    if(OldTargetState.IsMindControlled() || OldTargetState.IsStunned())
    {
        //`LOG("PerkPack(Trojan): PostEffectTickCheck: Unit is still CC'd. Skipping.");
        return ELR_NoInterrupt;
    }

    //`LOG("PerkPack(Trojan): Virus activating.");

    //NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Apply Trojan Virus Effects");
    TickContext = class'XComGameStateContext_TickEffect'.static.CreateTickContext(OwningEffect);
    NewGameState = History.CreateNewGameState(true, TickContext);
    NewTargetState = XComGameState_Unit(NewGameState.CreateStateObject(OldTargetState.Class, OldTargetState.ObjectID));
    NewGameState.AddStateObject(NewTargetState);

    // effect has worn off, Trojan Virus now kicks in
    // Compute damage
    Damage = 0;
    AttackerHackStat = SourceState.GetCurrentStat(eStat_Hacking);
    DefenderHackDefense = OldTargetState.GetCurrentStat(eStat_HackDefense);
    for(idx = 0; idx < default.TROJANVIRUSROLLS; idx++)
    {
        if(Rand(100) < 50 + AttackerHackStat - DefenderHackDefense)
            Damage += 1.0;
    }
    NewTargetState.TakeEffectDamage(OwningEffect.GetX2Effect(), Damage, 0, 0, OwningEffect.ApplyEffectParameters,  NewGameState, false, false, true);

    //remove actions
    if(NewTargetState.IsAlive())
    {
        NewTargetState.ActionPoints.Length = 0;
        NewTargetState.ReserveActionPoints.Length = 0;
        NewTargetState.SkippedActionPoints.Length = 0;
    }

    //check that it wasn't removed already because of the unit being killed from damage
    if(!OwningEffect.bRemoved)
        OwningEffect.RemoveEffect(NewGameState, NewGameState);
    if( NewGameState.GetNumGameStateObjects() > 0 )
        `TACTICALRULES.SubmitGameState(NewGameState);
    else
        History.CleanupPendingGameState(NewGameState);

    return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="TrojanVirus";
    bRemoveWhenSourceDies=true;
}
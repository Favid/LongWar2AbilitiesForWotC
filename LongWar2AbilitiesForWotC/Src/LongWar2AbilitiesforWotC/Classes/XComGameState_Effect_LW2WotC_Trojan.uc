//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Trojan.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is an effect component extension listening for successful hacks to apply the Trojan Effect to the hacked unit
//---------------------------------------------------------------------------------------

class XComGameState_Effect_LW2WotC_Trojan extends XComGameState_BaseObject config(LW_SoldierSkills);

var config int TROJANVIRUSROLLS;

function XComGameState_Effect_LW2WotC_Trojan InitComponent()
{
    return self;
}

function XComGameState_Effect GetOwningEffect()
{
    return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

//This is triggered at the start of each turn, after OnTickEffects (so after Hack stun/Mind Control effects are lost)
//The purpose is to check and see if those effects have been removed, in which case the Trojan Virus effects activate, then the effect is removed
simulated function EventListenerReturn PostEffectTickCheck(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory History;
    local XComGameStateContext_TickEffect TickContext;
    local XComGameState NewGameState;
    local XComGameState_Unit OldTargetState, NewTargetState, SourceState;
    local XComGameState_Effect OwningEffect;
    local float AttackerHackStat, DefenderHackDefense, Damage;
    local int idx;

    `LOG("PerkPack(Trojan): PostEffectTickCheck: Enter");

    History = `XCOMHISTORY;
    OwningEffect = GetOwningEffect();
    OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(OwningEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    SourceState = XComGameState_Unit(History.GetGameStateForObjectID(OwningEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    // don't do anything if unit is still mind controlled or stunned
    if(OldTargetState.IsMindControlled() || OldTargetState.IsStunned())
    {
        `LOG("PerkPack(Trojan): PostEffectTickCheck: Unit is still CC'd. Skipping.");
        return ELR_NoInterrupt;
    }

    `LOG("PerkPack(Trojan): Virus activating.");

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
    for(idx = 0; idx < TROJANVIRUSROLLS; idx++)
    {
        if(`SYNC_RAND(100) < 50 + AttackerHackStat - DefenderHackDefense)
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

//This is triggered by a successful hack (on InteractiveObject or Unit)
//Because it can trigger for hacking doors/chests, we have to check that it applied to a unit
simulated function EventListenerReturn OnSuccessfulHack(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit SourceUnit, TargetUnit;
    local XpEventData XpEvent;
    local XComGameStateHistory History;

    `LOG("PerkPack(Trojan): Event XpSuccessfulHack Triggered");
    History = `XCOMHISTORY;
    XpEvent = XpEventData(EventData);
    if(XpEvent == none)
    {
        `REDSCREEN("Trojan : XpSuccessfulHack Event with invalid event data.");
        return ELR_NoInterrupt;
    }
    
    `LOG("PerkPack(Trojan): Retrieving Source Unit");
    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(XpEvent.XpEarner.ObjectID));
    if(SourceUnit == none || SourceUnit != XComGameState_Unit(History.GetGameStateForObjectID(GetOwningEffect().ApplyEffectParameters.TargetStateObjectRef.ObjectID)))
        return ELR_NoInterrupt;

    `LOG("PerkPack(TrojanVirus): Retrieving Target Unit");
    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(XpEvent.EventTarget.ObjectID));
    if(TargetUnit == none)
        return ELR_NoInterrupt;

    // Don't apply trojan to fully-overridden robots. The MC effect is permanent anyway, so we don't need to apply this.
    // Applying it means the flyover will appear on EVAC, which we don't want.
    if (TargetUnit.AffectedByEffectNames.Find('TransferMecToOutpost') != -1)
    {
        `LOG("Skipping trojan on full override target");
        return ELR_NoInterrupt;
    }

    `LOG("PerkPack(Trojan): Activating TrojanVirus on Target Unit.");
    ActivateAbility('LW2WotC_TrojanVirus', SourceUnit.GetReference(), TargetUnit.GetReference());
    return ELR_NoInterrupt;
}

//This is used to activate the secondary TrojanVirus ability, which applies the TrojanVirus effect to the target of a successful hack
function ActivateAbility(name AbilityName, StateObjectReference SourceRef, StateObjectReference TargetRef)
{
    local GameRulesCache_Unit UnitCache;
    local int i, j;
    local X2TacticalGameRuleset TacticalRules;
    local StateObjectReference AbilityRef;
    local XComGameState_Unit SourceState; //, TargetState;
    local XComGameStateHistory History;
    History = `XCOMHISTORY;
    SourceState = XComGameState_Unit(History.GetGameStateForObjectID(SourceRef.ObjectID));
    AbilityRef = SourceState.FindAbility(AbilityName);

    TacticalRules = `TACTICALRULES;
    if( AbilityRef.ObjectID > 0 &&  TacticalRules.GetGameRulesCache_Unit(SourceRef, UnitCache) )
    {
        `LOG("PerkPack(TrojanVirus): Valid ability, retrieved UnitCache.");
        for( i = 0; i < UnitCache.AvailableActions.Length; ++i )
        {
            if( UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == AbilityRef.ObjectID )
            {
                `LOG("PerkPack(TrojanVirus): Found matching Ability ObjectID=" $ AbilityRef.ObjectID);
                for( j = 0; j < UnitCache.AvailableActions[i].AvailableTargets.Length; ++j )
                {
                    if( UnitCache.AvailableActions[i].AvailableTargets[j].PrimaryTarget == TargetRef )
                    {
                        `LOG("PerkPack(TrojanVirus): Found Target ObjectID=" $ TargetRef.ObjectID);
                        if( UnitCache.AvailableActions[i].AvailableCode == 'AA_Success' )
                        {
                            `LOG("PerkPack(TrojanVirus): AvailableCode AA_Success");
                            class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], j);
                        }
                        else
                        {
                            `LOG("PerkPack(TrojanVirus): AvailableCode = " $ UnitCache.AvailableActions[i].AvailableCode);
                        }
                        break;
                    }
                }
                break;
            }
        }
    }
}

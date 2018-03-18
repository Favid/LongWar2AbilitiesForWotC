///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_EmergencyLifeSupport.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements EmergencyLifeSupport, auto-succeeds at first bleedout roll
//--------------------------------------------------------------------------------------- 
class X2Effect_LW2WotC_EmergencyLifeSupport extends X2Effect_Persistent config(LW_SoldierSkills);

var protectedwrite name ELSDeathUsed;

var config int EMERGENCY_LIFE_SUPPORT_BONUS_BLEEDINGOUT_TURNS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;
    local XComGameState_Unit EffectTargetUnit;

    //`LOG("EmergencyLifeSupport: Registering for events.");

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    EffectTargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'UnitBleedingOut', OnUnitBleedingOut, ELD_OnStateSubmitted, , EffectTargetUnit);
}

static function EventListenerReturn OnUnitBleedingOut(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit UnitState;
    local XComGameState_Effect BleedOutEffect;

    //`LOG("EmergencyLifeSupport: OnUnitBleedingOut.");

    UnitState = XComGameState_Unit(EventData);
    
    BleedOutEffect = UnitState.GetUnitAffectedByEffectState(class'X2StatusEffects'.default.BleedingOutName);
    BleedOutEffect = XComGameState_Effect(GameState.GetGameStateForObjectID(BleedOutEffect.ObjectID));
    if( BleedOutEffect != none )
    {
        //`LOG("EmergencyLifeSupport: Increasing bleedout turns.");
        BleedOutEffect.iTurnsRemaining += default.EMERGENCY_LIFE_SUPPORT_BONUS_BLEEDINGOUT_TURNS;
    }

    return ELR_NoInterrupt;
}
function bool PreDeathCheck(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
    local UnitValue ELSValue;

    //`LOG("EmergencyLifeSupport: Starting PreDeath Check.");

    if (UnitState.GetUnitValue(default.ELSDeathUsed, ELSValue))
    {
        if (ELSValue.fValue > 0)
        {
            //`LOG("EmergencyLifeSupport: Already used, failing.");
            return false;
        }
    }
    //`LOG("EmergencyLifeSupport: Triggered, setting unit value.");
    UnitState.SetUnitFloatValue(default.ELSDeathUsed, 1, eCleanup_BeginTactical);
    if (ApplyBleedingOut(UnitState, NewGameState ))
    {
        //`LOG("EmergencyLifeSupport: Successfully applied bleeding-out.");
        UnitState.LowestHP = 1; // makes wound times correct if ELS gets used
        return true;
    }
    //`LOG("EmergencyLifeSupport : Unit" @ UnitState.GetFullName() @ "should have bled out but ApplyBleedingOut failed. Killing it instead.");

    return false;
}

function bool ApplyBleedingOut(XComGameState_Unit UnitState, XComGameState NewGameState)
{
    local EffectAppliedData ApplyData;
    local X2Effect BleedOutEffect;

    if (NewGameState != none)
    {
        BleedOutEffect = GetBleedOutEffect();
        ApplyData.PlayerStateObjectRef = UnitState.ControllingPlayer;
        ApplyData.SourceStateObjectRef = UnitState.GetReference();
        ApplyData.TargetStateObjectRef = UnitState.GetReference();
        ApplyData.EffectRef.LookupType = TELT_BleedOutEffect;
        if (BleedOutEffect.ApplyEffect(ApplyData, UnitState, NewGameState) == 'AA_Success')
        {
            //`LOG("Emergency Life Support : Triggered ApplyBleedingOut.");
            return true;
        }
    }
    return false;
}

DefaultProperties
{
    EffectName = "EmergencyLifeSupport"
    ELSDeathUsed = "EmergencyLifeSupportDeathUsed"
}

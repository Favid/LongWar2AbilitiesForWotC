///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Savior
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for Savior ability -- this is a triggering effect that occurs when a medikit heal is applied
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_LW2WotC_Savior extends X2Effect_Persistent config(LW_SoldierSkills);

var localized string strSavior_WorldMessage;
var config int SAVIOR_BONUS_HEAL_AMMOUNT;

//add a component to XComGameState_Effect to listen for medikit heal being applied
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Effect_LW2WotC_Savior SaviorEffectState;
    local X2EventManager EventMgr;
    local Object ListenerObj;

    EventMgr = `XEVENTMGR;

    if (GetEffectComponent(NewEffectState) == none)
    {
        //create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
        SaviorEffectState = XComGameState_Effect_LW2WotC_Savior(NewGameState.CreateStateObject(class'XComGameState_Effect_LW2WotC_Savior'));
        SaviorEffectState.InitComponent();
        NewEffectState.AddComponentObject(SaviorEffectState);
        NewGameState.AddStateObject(SaviorEffectState);
    }

    //add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
    ListenerObj = SaviorEffectState;
    if (ListenerObj == none)
    {
        return;
    }
    EventMgr.RegisterForEvent(ListenerObj, 'XpHealDamage', SaviorEffectState.OnMedikitHeal, ELD_OnStateSubmitted,,,true);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_BaseObject EffectComponent;
    local Object EffectComponentObj;
    
    super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

    EffectComponent = GetEffectComponent(RemovedEffectState);
    if (EffectComponent == none)
        return;

    EffectComponentObj = EffectComponent;
    `XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

    NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_LW2WotC_Savior GetEffectComponent(XComGameState_Effect Effect)
{
    if (Effect != none) 
        return XComGameState_Effect_LW2WotC_Savior(Effect.FindComponentObject(class'XComGameState_Effect_LW2WotC_Savior'));
    return none;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="LW2WotC_Savior";
    bRemoveWhenSourceDies=true;
}
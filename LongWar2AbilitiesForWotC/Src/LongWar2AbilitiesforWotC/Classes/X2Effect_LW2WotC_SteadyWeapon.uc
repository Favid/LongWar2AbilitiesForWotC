class X2Effect_LW2WotC_SteadyWeapon extends X2Effect_Persistent;

var int Aim_Bonus;
var int Crit_Bonus;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', SteadyWeaponWoundListener, ELD_OnStateSubmitted, 75, UnitState,, EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'ImpairingEffect', SteadyWeaponWoundListener, ELD_OnStateSubmitted, 75, UnitState,, EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', SteadyWeaponActionListener, ELD_OnStateSubmitted, 75, UnitState,, EffectObj);
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

    if(!bMelee && AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        ShotInfo.ModType = eHit_Success;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = Aim_Bonus;
        ShotModifiers.AddItem(ShotInfo);

        ShotInfo.ModType = eHit_Crit;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = Crit_Bonus;
        ShotModifiers.AddItem(ShotInfo);
    }
}

static function EventListenerReturn SteadyWeaponWoundListener(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameStateContext_EffectRemoved RemoveContext;
    local XComGameState NewGameState;
	local XComGameState_Effect EffectState;

    //`LOG("SteadyWeapon SteadyWeaponWoundListener triggered...");

    EffectState = XComGameState_Effect(CallbackData);
    if (EffectState != none && !EffectState.bRemoved)
    {
        RemoveContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
        NewGameState = `XCOMHISTORY.CreateNewGameState(true, RemoveContext);
        EffectState.RemoveEffect(NewGameState, NewGameState);
        `TACTICALRULES.SubmitGameState(NewGameState);
        //`LOG("SteadyWeapon removing...");
    }
    return ELR_NoInterrupt;
}

static function EventListenerReturn SteadyWeaponActionListener(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameState_Ability AbilityState;
    local XComGameStateContext_EffectRemoved RemoveContext;
    local XComGameState NewGameState;
    local X2AbilityCost Cost;
    local bool CostlyAction;
	local XComGameState_Effect EffectState;

    //`LOG("SteadyWeapon SteadyWeaponActionListener triggered...");

    AbilityState = XComGameState_Ability(EventData);
    if (AbilityState != none)
    {
        //`LOG("SteadyWeapon AbilityState valid...");
        foreach AbilityState.GetMyTemplate().AbilityCosts(Cost)
        {
            CostlyAction = false;
            if (Cost.IsA('X2AbilityCost_ActionPoints') && !X2AbilityCost_ActionPoints(Cost).bFreeCost)
                CostlyAction = true;
            if (Cost.IsA('X2AbilityCost_ReserveActionPoints') && !X2AbilityCost_ReserveActionPoints(Cost).bFreeCost)
                CostlyAction = true;
            if (Cost.IsA('X2AbilityCost_HeavyWeaponActionPoints') && !X2AbilityCost_HeavyWeaponActionPoints(Cost).bFreeCost)
                CostlyAction = true;
            if (Cost.IsA('X2AbilityCost_QuickdrawActionPoints') && !X2AbilityCost_QuickdrawActionPoints(Cost).bFreeCost)
                CostlyAction = true;
            if (AbilityState.GetMyTemplateName() == 'LW2WotC_CloseCombatSpecialistAttack')
                CostlyAction = true;
            if (AbilityState.GetMyTemplateName() == 'BladestormAttack')
                CostlyAction = true;
            if (AbilityState.GetMyTemplateName() == 'LightningHands')
                CostlyAction = true;
            if(CostlyAction) 
            {
                if (AbilityState.GetMyTemplateName() == 'LW2WotC_SteadyWeapon' || AbilityState.GetMyTemplateName() == 'Stock_LW_Bsc_Ability' ||  AbilityState.GetMyTemplateName() == 'Stock_LW_Adv_Ability' ||  AbilityState.GetMyTemplateName() == 'Stock_LW_Sup_Ability')
                    return ELR_NoInterrupt;

                //`LOG("SteadyWeapon action is costly...");
                EffectState = XComGameState_Effect(CallbackData);
                if (EffectState != none && !EffectState.bRemoved)
                {
                    RemoveContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
                    NewGameState = `XCOMHISTORY.CreateNewGameState(true, RemoveContext);
                    EffectState.RemoveEffect(NewGameState, NewGameState);
                    `TACTICALRULES.SubmitGameState(NewGameState);
                    //`LOG("SteadyWeapon removing...");
                }
            }
        }
    }
    return ELR_NoInterrupt;
}

defaultproperties
{
    EffectName="SteadyWeapon"
}

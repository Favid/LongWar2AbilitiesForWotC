//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LW2WotC_Failsafe.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Failsafe Effect
//---------------------------------------------------------------------------------------
class X2Effect_LW2WotC_Failsafe extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'FailsafeTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
	EventMgr.RegisterForEvent(EffectObj, 'PreAcquiredHackReward', PreAcquiredHackReward, ELD_Immediate, 75,,, EffectObj);
}

// this is triggered just before acquiring a hack reward, giving a chance to skip adding the negative one
static function EventListenerReturn PreAcquiredHackReward(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideHackRewardTuple;
	local XComGameState_Unit		Hacker;
	local XComGameState_BaseObject	HackTarget;
	local X2HackRewardTemplate		HackTemplate;
	local XComGameState_Ability					AbilityState;
	local StateObjectReference		AbilityRef;

	OverrideHackRewardTuple = XComLWTuple(EventData);
	if(OverrideHackRewardTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	HackTemplate = X2HackRewardTemplate(EventSource);
	if(HackTemplate == none)
		return ELR_NoInterrupt;


	if(OverrideHackRewardTuple.Id != 'OverrideHackRewards')
		return ELR_NoInterrupt;

	Hacker = XComGameState_Unit(OverrideHackRewardTuple.Data[1].o);
	HackTarget = XComGameState_BaseObject(OverrideHackRewardTuple.Data[2].o); // not necessarily a unit, could be a Hackable environmental object

	if(Hacker == none || HackTarget == none)
		return ELR_NoInterrupt;

	if(Hacker == none || !Hacker.HasSoldierAbility('LW2WotC_Failsafe'))
		return ELR_NoInterrupt;

	if(HackTemplate.bBadThing)
	{
		if(Rand(100) < class'X2Ability_LW2WotC_PassiveAbilitySet'.default.FAILSAFE_PCT_CHANCE)
		{
			OverrideHackRewardTuple.Data[0].b = true;
            AbilityRef = Hacker.FindAbility('LW2WotC_Failsafe');
			if(AbilityRef.ObjectID > 0)
			{
				AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityRef.ObjectID));
				`XEVENTMGR.TriggerEvent('FailsafeTriggered', AbilityState, Hacker, NewGameState);
			}
		}
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="Failsafe";
}
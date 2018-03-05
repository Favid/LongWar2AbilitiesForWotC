class X2Effect_LW2WotC_RapidReaction extends X2Effect_Persistent config (LW_SoldierSkills);

var config int RAPID_REACTION_USES_PER_TURN;
var config array<name> RAPID_REACTION_ABILITYNAMES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'LW2WotC_RapidReaction_Triggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local X2EventManager						EventMgr;
	local XComGameState_Ability					AbilityState;       //  used for looking up our source ability (LW2WotC_RapidReaction), not the incoming one that was activated
	local XComGameState_Unit					TargetUnit;
	local name                                  ValueName;
    local UnitValue                             RapidReactionCounterValue;
    
    // To make sure Rapid Reaction only activates a set number of times
    SourceUnit.GetUnitValue('LW2WotC_RapidReaction_Counter', RapidReactionCounterValue);
    if(RapidReactionCounterValue.fValue >= default.RAPID_REACTION_USES_PER_TURN)
    {
        return false;
    }

	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return false;

    if (!AbilityContext.IsResultContextHit())
	    return false;

	if (SourceUnit.ReserveActionPoints.Length != PreCostReservePoints.Length && default.RAPID_REACTION_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
	{
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));		
		if (AbilityState != none)
		{
            // To make sure we don't shoot the same target twice - pending implementation
			TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
			ValueName = name("OverwatchShot" $ TargetUnit.ObjectID);
			SourceUnit.SetUnitFloatValue (ValueName, 1.0, eCleanup_BeginTurn);

            // Reset reserve action points
			SourceUnit.ReserveActionPoints = PreCostReservePoints;

            // Update the Rapid Reaction activation counter
			SourceUnit.SetUnitFloatValue ('LW2WotC_RapidReaction_Counter', RapidReactionCounterValue.fValue + 1, eCleanup_BeginTurn);

            // Trigger the flyover
            EventMgr = `XEVENTMGR;
			EventMgr.TriggerEvent('LW2WotC_RapidReaction_Triggered', AbilityState, SourceUnit, NewGameState);
            
            NewGameState.AddStateObject(SourceUnit);
		}
	}
	return false;
}

Class X2Effect_LW2WotC_LightningReflexes extends X2Effect_Persistent config (LW_SoldierSkills);

var config int LR_LW_FIRST_SHOT_PENALTY;
var config int LR_LW_PENALTY_REDUCTION_PER_SHOT;
var config array<name> LR_REACTION_FIRE_ABILITYNAMES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
    local XComGameState_Unit UnitState;

    //`LOG("LightningReflexes: RegisterForEvents: Entered");
    
	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', IncomingReactionFireCheck, ELD_OnStateSubmitted,,,, EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'LightningReflexesLWTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);

    //`LOG("LightningReflexes: RegisterForEvents: Exit");
}

static function EventListenerReturn IncomingReactionFireCheck(Object EventData, Object EventSource, XComGameState NewGameState, name InEventID, Object CallbackData)
{
    local XComGameState_Unit            AttackingUnit, DefendingUnit;
    local XComGameState_Ability         ActivatedAbilityState;
    local XComGameStateContext_Ability  AbilityContext;
    local UnitValue                     LightningReflexesCounterValue;
    local XComGameState_Effect          EffectState;
    local XComGameState_Ability         LightningReflexesAbilityState;

    //`LOG("LightningReflexes: IncomingReactionFireCheck: Entered");

	// Get the Expected SourceUnit
	EffectState = XComGameState_Effect(CallbackData);
    LightningReflexesAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

    AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());  
    DefendingUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
    if (DefendingUnit != none)
    {
        if (DefendingUnit.HasSoldierAbility('LW2WotC_LightningReflexes') && !DefendingUnit.IsImpaired(false) && !DefendingUnit.IsBurning() && !DefendingUnit.IsPanicked())
        {
            AttackingUnit = class'X2TacticalGameRulesetDataStructures'.static.GetAttackingUnitState(NewGameState);
            if(AttackingUnit != none && AttackingUnit.IsEnemyUnit(DefendingUnit))
            {
                ActivatedAbilityState = XComGameState_Ability(EventData);
                if (ActivatedAbilityState != none)
                {       
                    if (default.LR_REACTION_FIRE_ABILITYNAMES.Find(ActivatedAbilityState.GetMyTemplateName()) != -1)
                    {                           
                        // Update the Lightning Reflexes counter
                        DefendingUnit.GetUnitValue('LW2WotC_LightningReflexes_Counter', LightningReflexesCounterValue);
			            DefendingUnit.SetUnitFloatValue ('LW2WotC_LightningReflexes_Counter', LightningReflexesCounterValue.fValue + 1, eCleanup_BeginTurn);

                        //`LOG("LightningReflexes: IncomingReactionFireCheck: LightningReflexesCounterValue increased to: " $ string(LightningReflexesCounterValue.fValue + 1));

                        // Send event to trigger the flyover, but only for the first shot
                        if(LightningReflexesCounterValue.fValue == 0)
                        {
                            `XEVENTMGR.TriggerEvent('LightningReflexesLWTriggered', LightningReflexesAbilityState, DefendingUnit, NewGameState);
                        }
                    }
                }
            }
        }   
    }
    return ELR_NoInterrupt;
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo      ShotInfo;
    local UnitValue             LightningReflexesCounterValue;

    if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
        return;

    if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none)
    {
        if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire)
        {
            Target.GetUnitValue('LW2WotC_LightningReflexes_Counter', LightningReflexesCounterValue);
            
            //`LOG("LightningReflexes: GetToHitAsTargetModifiers: LightningReflexesCounterValue: " $ string(LightningReflexesCounterValue.fValue));

            ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = -(default.LR_LW_FIRST_SHOT_PENALTY-(clamp((LightningReflexesCounterValue.fValue) * default.LR_LW_PENALTY_REDUCTION_PER_SHOT,0,default.LR_LW_FIRST_SHOT_PENALTY)));
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="LW2WotC_LightningReflexes";
}
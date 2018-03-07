//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_LW2WotC_HyperReactivePupils
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up HRP perk effect
//--------------------------------------------------------------------------------------- 

class X2Effect_LW2WotC_HyperReactivePupils extends X2Effect_Persistent config (LW_SoldierSkills);

var config int HYPERREACTIVE_PUPILS_AIM_BONUS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', HyperReactivePupilsListener, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn HyperReactivePupilsListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit UnitState;
	local XComGameState_Item SourceWeapon;

    //`LOG("HyperReactivePupils: Triggered");

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	`assert(AbilityContext != none);
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	AbilityState = XComGameState_Ability(EventData);
	`assert(AbilityState != none);
	UnitState = XComGameState_Unit(EventSource);
	`assert(UnitState != none);
	
    //`LOG("HyperReactivePupils: Past asserts");

	if (AbilityState.IsAbilityInputTriggered())
	{
        //`LOG("HyperReactivePupils: Triggered ability");
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && SourceWeapon != none && SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
		{
            //`LOG("HyperReactivePupils: Valid ability");
            
            if (AbilityContext.IsResultContextMiss())
            {
                //`LOG("HyperReactivePupils: Miss");
			    UnitState.SetUnitFloatValue('HyperReactivePupilsMiss', 1, eCleanup_BeginTactical);
            }
            else
            {
                //`LOG("HyperReactivePupils: Hit");
			    UnitState.SetUnitFloatValue('HyperReactivePupilsMiss', 0, eCleanup_BeginTactical);
            }
		}
	}
	return ELR_NoInterrupt;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item						SourceWeapon;
    local ShotModifierInfo							ShotInfo;
	local UnitValue                                 MissValue;

	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return;
	if (AbilityState == none)
		return;

    SourceWeapon = AbilityState.GetSourceWeapon();    
	if (SourceWeapon == Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon))
	{
		if ((SourceWeapon != none) && (Target != none))
		{
		    Attacker.GetUnitValue('HyperReactivePupilsMiss', MissValue);
            
			if (MissValue.fValue > 0)
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = default.HYPERREACTIVE_PUPILS_AIM_BONUS;
				ShotModifiers.AddItem(ShotInfo);
			}
        }
    }    
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="LW2WotC_HyperReactivePupils"
}


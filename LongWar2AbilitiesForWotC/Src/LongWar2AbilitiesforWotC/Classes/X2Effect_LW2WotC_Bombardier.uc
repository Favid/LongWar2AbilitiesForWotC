//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LW2WotC_Bombardier.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Increases throw and launch range of grenades
//---------------------------------------------------------------------------------------
class X2Effect_LW2WotC_Bombardier extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'OnGetItemRange', OnGetItemRange, ELD_Immediate);
}

static function EventListenerReturn OnGetItemRange(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Item		Item;
	//local int						Range;  // in tiles -- either bonus or override
	local XComGameState_Ability		Ability;
	//local bool						bOverride; // if true, replace the range, if false, just add to it
	local XComGameState_Item		SourceWeapon;
	local X2WeaponTemplate			WeaponTemplate;
    local XComGameState_Unit        UnitState;

	//`LOG("Bombardier : Triggered.");

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnGetItemRange event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("Bombardier : Parsed XComLWTuple.");

	if(OverrideTuple.Id != 'GetItemRange')
		return ELR_NoInterrupt;
	//`LOG("Bombardier : Tuple id valid.");

	Item = XComGameState_Item(EventSource);
	if(Item == none)
		return ELR_NoInterrupt;
	//`LOG("Bombardier : EventSource valid.");

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Item.OwnerStateObject.ObjectID));
	if(UnitState == none)
		return ELR_NoInterrupt;
	//`LOG("Bombardier : UnitState valid.");

    if(!UnitState.HasSoldierAbility('LW2WotC_Bombardier'))
		return ELR_NoInterrupt;
	//`LOG("Bombardier : Unit has ability.");

	//bOverride = OverrideTuple.Data[0].b;  // override? (true) or add? (false)
	//Range = OverrideTuple.Data[1].i;  // override/bonus range
	Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability

	if(Ability == none)
		return ELR_NoInterrupt;
	//`LOG("Bombardier : Ability valid.");

	//get the source weapon and weapon template
	SourceWeapon = Ability.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return ELR_NoInterrupt;
	//`LOG("Bombardier : Weapon valid.");

	// make sure the weapon is either a grenade or a grenade launcher
	if(X2GrenadeTemplate(WeaponTemplate) != none || X2GrenadeLauncherTemplate(WeaponTemplate) != none || WeaponTemplate.DataName == 'Battlescanner')
	{
	    //`LOG("Bombardier : Adding range: " $ string(class'X2Ability_LW2WotC_PassiveAbilitySet'.default.BOMBARDIER_BONUS_RANGE_TILES));
		OverrideTuple.Data[1].i += class'X2Ability_LW2WotC_PassiveAbilitySet'.default.BOMBARDIER_BONUS_RANGE_TILES;
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="Bombardier";
}
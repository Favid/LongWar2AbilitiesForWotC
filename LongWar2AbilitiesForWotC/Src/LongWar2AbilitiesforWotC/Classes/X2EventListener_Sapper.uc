class X2EventListener_Sapper extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListenerTemplateModifyEnvironmentDamage());

	return Templates;
}

static function CHEventListenerTemplate CreateListenerTemplateModifyEnvironmentDamage()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'ModifyEnvironmentDamage');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = false;

	Template.AddCHEvent('ModifyEnvironmentDamage', OnModifyEnvironmentDamageSapper, ELD_Immediate);
	//`LOG("Register Event OnModifyEnvironmentDamageSapper");

	return Template;
}

// EventData is XComLWTuple with expected format:
//      Id    : 'ModifyEnvironmentDamage'
//      [0].b : override? (true) or add? (false)
//      [1].i : override/bonus environment damage
//      [2].o : XComGameState_Ability being used
static function EventListenerReturn OnModifyEnvironmentDamageSapper(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple				ModifyEnvironmentDamageTuple;
	local XComGameState_Item		Item;
	local XComGameState_Unit		Unit;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Item        SourceAmmo;
    local X2GrenadeTemplate         SourceGrenade;
    
    // handle unexpected EventData type
	ModifyEnvironmentDamageTuple = XComLWTuple(EventData);
	if(ModifyEnvironmentDamageTuple == none)
	{
		`REDSCREEN("OnModifyEnvironmentDamageSapper event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
    
    // handle incorrect tuple id
	if(ModifyEnvironmentDamageTuple.Id != 'ModifyEnvironmentDamage')
    {
		return ELR_NoInterrupt;
    }
    
    // handle no source ability
	AbilityState = XComGameState_Ability(ModifyEnvironmentDamageTuple.Data[2].o);
	if(AbilityState == none)
    {
		return ELR_NoInterrupt;
    }
    
    // make sure source unit has Sapper
    Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	if(!Unit.HasSoldierAbility('LW2WotC_Sapper'))
    {
		return ELR_NoInterrupt;
    }

    // this gets the grenade from the grenade launcher
	SourceAmmo = AbilityState.GetSourceAmmo();

    // handles case where grenade is thrown
    if(SourceAmmo == none)
    {
        SourceAmmo = AbilityState.GetSourceWeapon();

        if(SourceAmmo == none)
        {
		    return ELR_NoInterrupt;
        }
    }

    // make sure this is caused by a grenade
    SourceGrenade = X2GrenadeTemplate(SourceAmmo.GetMyTemplate());
    if(SourceGrenade == none)
    {
		return ELR_NoInterrupt;
    }

    // the grenade must do some environment damage already
    if(SourceGrenade.iEnvironmentDamage <= 0)
    {
		return ELR_NoInterrupt;
    }

    // now we add our environment damage bonus
    ModifyEnvironmentDamageTuple.Data[0].b = false;
    ModifyEnvironmentDamageTuple.Data[1].i += class'X2Ability_LW2WotC_PassiveAbilitySet'.default.SAPPER_BONUS_ENVIRONMENT_DAMAGE;
    
    return ELR_NoInterrupt;
}
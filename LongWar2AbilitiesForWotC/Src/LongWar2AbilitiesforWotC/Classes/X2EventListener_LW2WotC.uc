class X2EventListener_LW2WotC extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
    
	Templates.AddItem(CreateListenerTemplateModifyEnvironmentDamage());
	Templates.AddItem(CreateListenerTemplateOnKilledByExplosion());
	Templates.AddItem(CreateListenerTemplateOnSerialKill());
	Templates.AddItem(CreateListenerTemplateOnGetPCSImage());
	Templates.AddItem(CreateListenerTemplateOnCleanupTacticalMission());

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

static function CHEventListenerTemplate CreateListenerTemplateOnKilledByExplosion()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'KilledByExplosion');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = false;

	Template.AddCHEvent('KilledByExplosion', OnKilledByExplosion, ELD_Immediate);
	//`LOG("Register Event OnKilledByExplosion");

	return Template;
}

static function CHEventListenerTemplate CreateListenerTemplateOnSerialKill()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'SerialKiller');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = false;

	Template.AddCHEvent('SerialKiller', OnSerialKill, ELD_OnStateSubmitted);
	//`LOG("=== Register Event OnSerialKill");

	return Template;
}

static function CHEventListenerTemplate CreateListenerTemplateOnGetPCSImage()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'OnGetPCSImage');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('OnGetPCSImage', OnGetPCSImage, ELD_Immediate);
	//`LOG("=== Register Event OnGetPCSImage");

	return Template;
}

static function CHEventListenerTemplate CreateListenerTemplateOnCleanupTacticalMission()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'OnCleanupTacticalMission');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = false;

	Template.AddCHEvent('CleanupTacticalMission', OnCleanupTacticalMission, ELD_OnStateSubmitted);
	//`LOG("=== Register Event CleanupTacticalMission");

	return Template;
}

// EventData is XComLWTuple with expected format:
//      Id        : 'ModifyEnvironmentDamage'
//      Data[0].b : override? (true) or add? (false)
//      Data[1].i : override/bonus environment damage
//      Data[2].o : XComGameState_Ability being used
static function EventListenerReturn OnModifyEnvironmentDamageSapper(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple				ModifyEnvironmentDamageTuple;
	local XComGameState_Unit		Unit;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Item        SourceAmmo;
    local X2GrenadeTemplate         SourceGrenade;

    //`LOG("Sapper: Triggered");
    
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

    //`LOG("Sapper: Applying bonus env damage: " $ class'X2Ability_LW2WotC_PassiveAbilitySet'.default.SAPPER_BONUS_ENVIRONMENT_DAMAGE);

    // now we add our environment damage bonus
    ModifyEnvironmentDamageTuple.Data[0].b = false;
    ModifyEnvironmentDamageTuple.Data[1].i += class'X2Ability_LW2WotC_PassiveAbilitySet'.default.SAPPER_BONUS_ENVIRONMENT_DAMAGE;
    
    return ELR_NoInterrupt;
}

// EventData is XComLWTuple with expected format:
//      Id        : 'OverrideKilledByExplosion'
//      Data[0].b : whether or not the target was killed by an explosion
//      Data[1].i : ObjectId of the killer
static function EventListenerReturn OnKilledByExplosion(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComLWTuple				OverrideTuple;
	local XComGameState_Unit		Killer, Target;

    //`LOG("Needle Grenades: Triggered");

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnKilledByExplosion event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	Target = XComGameState_Unit(EventSource);
	if(Target == none)
		return ELR_NoInterrupt;

	if(OverrideTuple.Id != 'OverrideKilledByExplosion')
		return ELR_NoInterrupt;

	Killer = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(OverrideTuple.Data[1].i));

	if (OverrideTuple.Data[0].b && Killer.HasSoldierAbility('LW2WotC_NeedleGrenades', true))
	{
		OverrideTuple.Data[0].b = false;
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnSerialKill(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit ShooterState;
    local UnitValue UnitVal;

	//`LOG("=== OnSerialKill Triggered");

	ShooterState = XComGameState_Unit (EventSource);
	If (ShooterState == none)
	{   
        //`LOG("=== No Shooter");
		return ELR_NoInterrupt;
	}
	ShooterState.GetUnitValue ('SerialKills', UnitVal);
	ShooterState.SetUnitFloatValue ('SerialKills', UnitVal.fValue + 1.0, eCleanup_BeginTurn);

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnGetPCSImage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple			OverridePCSImageTuple;
	local XComGameState_Item	ItemState;

	OverridePCSImageTuple = XComLWTuple(EventData);
	if(OverridePCSImageTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	if(OverridePCSImageTuple.Id != 'GetPCSImageTuple')
		return ELR_NoInterrupt;

    ItemState = XComGameState_Item(OverridePCSImageTuple.Data[0].o);
	if(ItemState == none)
		return ELR_NoInterrupt;

	switch (ItemState.GetMyTemplateName())
	{
		case 'DepthPerceptionPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_depthperception"; break;
		case 'HyperReactivePupilsPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_hyperreactivepupils"; break;
		case 'CombatAwarenessPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_threatassessment"; break;
		case 'DamageControlPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_damagecontrol"; break;
		case 'ImpactFieldsPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_impactfield"; break;
		case 'BodyShieldPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_bodyshield"; break;
		case 'EmergencyLifeSupportPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_emergencylifesupport"; break;
		case 'IronSkinPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_ironskin"; break;
		case 'SmartMacrophagesPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_smartmacrophages"; break;
		case 'CombatRushPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_combatrush"; break;
		case 'CommonPCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_dodge"; break;
		case 'RarePCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_dodge"; break;
		case 'EpicPCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_dodge"; break;
		case 'CommonPCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_hacking"; break;
		case 'RarePCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_hacking"; break;
		case 'EpicPCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_PerkPack.implants_hacking"; break;

		default:  break;
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnCleanupTacticalMission(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_BattleData BattleData;
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local StateObjectReference EffectRef;

    History = `XCOMHISTORY;
    BattleData = XComGameState_BattleData(EventData);
    BattleData = XComGameState_BattleData(GameState.GetGameStateForObjectID(BattleData.ObjectID));

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if(Unit.IsAlive() && !Unit.bCaptured)
		{
			foreach Unit.AffectedByEffects(EffectRef)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				if (EffectState.GetX2Effect().EffectName == class'X2Effect_LW2WotC_FieldSurgeon'.default.EffectName)
				{
					X2Effect_LW2WotC_FieldSurgeon(EffectState.GetX2Effect()).ApplyFieldSurgeon(EffectState, Unit, GameState);
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

//---------------------------------------------------------------------------------------
//  FILE:    VanillaTemplateMods
//  PURPOSE: Modifies base game ability templates to match LW2 functionality
//--------------------------------------------------------------------------------------- 

class VanillaTemplateMods extends X2StrategyElement config (LW_SoldierSkills);

var config bool NO_MELEE_ATTACKS_WHEN_ON_FIRE;
var config bool NO_STANDARD_ATTACKS_WHEN_ON_FIRE;
var config array<name> STANDARD_ATTACKS;
var config int HAIL_OF_BULLETS_AMMO_COST;
var config int DEMOLITION_AMMO_COST;
var config int SERIAL_CRIT_MALUS_PER_KILL;
var config int SERIAL_AIM_MALUS_PER_KILL;
var config bool SERIAL_DAMAGE_FALLOFF;
var config int INSANITY_MIND_CONTROL_DURATION;
var config bool INSANITY_ENDS_TURN;
var config int CONCEAL_ACTION_POINTS;
var config bool CONCEAL_ENDS_TURN;
var config int RUPTURE_CRIT_BONUS;
var config int AID_PROTOCOL_COOLDOWN;
var config int SATURATION_FIRE_AMMO_COST;
var config int FUSE_COOLDOWN;
var config int COVERING_FIRE_OFFENSE_MALUS;
var config int REVIVAL_PROTOCOL_CHARGES_CV;
var config int REVIVAL_PROTOCOL_CHARGES_MG;
var config int REVIVAL_PROTOCOL_CHARGES_BM;

var localized string LocCoveringFire;
var localized string LocCoveringFireMalus;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateModifyAbilitiesGeneralTemplate());

    return Templates;
}

static function X2LWTemplateModTemplate CreateModifyAbilitiesGeneralTemplate()
{
   local X2LWTemplateModTemplate Template;
   
   `CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ModifyAbilitiesGeneral');
   Template.AbilityTemplateModFn = ModifyAbilitiesGeneral;

   return Template;
}

function ModifyAbilitiesGeneral(X2AbilityTemplate Template, int Difficulty)
{
	local int								                    k;
	local X2AbilityCost_Ammo				                    AmmoCost;
	local X2Condition_UnitInventory			                    NoShotgunsCondition, NoSnipersCondition, NoVektorCondition;
    local X2Effect_LW2WotC_SerialKillStatReductions             SerialKillStatReductions;
    local X2AbilityCost_ActionPoints                            ActionPointCost;
    local X2AbilityToHitCalc_StandardAim                        StandardAim;
    local X2AbilityCooldown                                     Cooldown;
    local X2AbilityCharges_LW2WotC_GremlinTierBased             RPCharges;
    local X2Effect_LW2WotC_MaybeApplyDirectionalWorldDamage     WorldDamage;
    local X2Effect_Persistent                                   Effect;
    local X2Condition_UnitEffects                               SuppressedCondition, UnitEffectsCondition, BurningUnitEffects;
    local X2Effect_LW2WotC_Guardian                             GuardianEffect;
    local X2Effect_Persistent                                   HaywiredEffect;
    local X2Condition_UnitEffects                               NotHaywiredCondition;
    local X2Effect_PersistentStatChange                         CoveringFireMalusEffect;
    local X2Condition_AbilityProperty                           CoveringFireAbilityCondition;
    local X2Effect_LW2WotC_CancelLongRangePenalty               CancelLongRangePenaltyEffect;
    local X2Effect_LW2WotC_DeathFromAbove                       DeathEffect;

    // Hail of Bullets - Unusable with shotguns, snipers, and vektor rifles and make its ammo cost configurable
    if (Template.DataName == 'HailofBullets')
	{
		NoShotgunsCondition = new class'X2Condition_UnitInventory';
		NoShotgunsCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
		NoShotgunsCondition.ExcludeWeaponCategory = 'shotgun';
		Template.AbilityShooterConditions.AddItem(NoShotgunsCondition);
	
		NoSnipersCondition = new class'X2Condition_UnitInventory';
		NoSnipersCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
		NoSnipersCondition.ExcludeWeaponCategory = 'sniper_rifle';
		Template.AbilityShooterConditions.AddItem(NoSnipersCondition);

		NoVektorCondition = new class'X2Condition_UnitInventory';
		NoVektorCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
		NoVektorCondition.ExcludeWeaponCategory = 'vektor_rifle';
		Template.AbilityShooterConditions.AddItem(NoVektorCondition);

		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[k]);
			if (AmmoCost != none)
			{
				X2AbilityCost_Ammo(Template.AbilityCosts[k]).iAmmo = default.HAIL_OF_BULLETS_AMMO_COST;
			}
		}

        `LOG("LongWar2AbilitiesForWotc: Modifying Hail of Bullets");
	}

    // Demolition - Make ammo cost configurable
	if (Template.DataName == 'Demolition')
	{
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[k]);
			if (AmmoCost != none)
			{
				X2AbilityCost_Ammo(Template.AbilityCosts[k]).iAmmo = default.DEMOLITION_AMMO_COST;
			}
		}

        `LOG("LongWar2AbilitiesForWotc: Modifying Demolition");
	}

    // Serial - Reduce the user's aim, crit chance, and damage after every kill based on config values
	if (Template.DataName == 'InTheZone')
	{
		SerialKillStatReductions = new class 'X2Effect_LW2WotC_SerialKillStatReductions';
		SerialKillStatReductions.BuildPersistentEffect(1, false, true, false, 8);
		SerialKillStatReductions.CritReductionPerKill = default.SERIAL_CRIT_MALUS_PER_KILL;
		SerialKillStatReductions.AimReductionPerKill = default.SERIAL_AIM_MALUS_PER_KILL;
		SerialKillStatReductions.Damage_Falloff = default.SERIAL_DAMAGE_FALLOFF;
		SerialKillStatReductions.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
		Template.AbilityTargetEffects.AddItem(SerialKillStatReductions);
        
        `LOG("LongWar2AbilitiesForWotc: Modifying Serial");
	}

    // Modify Death from Above so that it is compatible with Double Tap, cancels the long-range sniper penalty, and can only activate once per turn
	if (Template.DataName == 'DeathFromAbove')
	{
		Template.AbilityTargetEffects.Length = 0;
		CancelLongRangePenaltyEffect = New class'X2Effect_LW2WotC_CancelLongRangePenalty';
		CancelLongRangePenaltyEffect.BuildPersistentEffect (1, true, false);
		CancelLongRangePenaltyEffect.SetDisplayInfo (0, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);
		Template.AddTargetEffect(CancelLongRangePenaltyEffect);

		DeathEffect = new class'X2Effect_LW2WotC_DeathFromAbove';
		DeathEffect.BuildPersistentEffect(1, true, false, false);
		DeathEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
		Template.AddTargetEffect(DeathEffect);

        `LOG("LongWar2AbilitiesForWotc: Modifying Death From Above");
	}

    // Insanity - Expose mind control duration and whether its use ends the user's turn to config values
    if (Template.DataName == 'Insanity')
	{
		for (k = 0; k < Template.AbilityTargetEffects.length; k++)
		{
			if (Template.AbilityTargetEffects[k].IsA ('X2Effect_MindControl'))
			{
				X2Effect_MindControl(Template.AbilityTargetEffects[k]).iNumTurns = default.INSANITY_MIND_CONTROL_DURATION;
			}
		}
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[k]);
			if (ActionPointCost != none)
			{
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).bConsumeAllPoints = default.INSANITY_ENDS_TURN;
			}
		}

        `LOG("LongWar2AbilitiesForWotc: Modifying Insanity");
	}
    
    // Conceal - Add a configurable action point cost
	if (Template.DataName == 'Stealth' && default.CONCEAL_ACTION_POINTS > 0)
	{
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[k]);
			if (ActionPointCost != none)
			{
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).iNumPoints = default.CONCEAL_ACTION_POINTS;
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).bConsumeAllPoints = default.CONCEAL_ENDS_TURN;
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).bFreeCost = false;
			}
		}

        `LOG("LongWar2AbilitiesForWotc: Modifying Stealth");
	}
    
    // Rupture - Replace guarenteed crits with a configurable crit bonus
	if (Template.DataName == 'BulletShred')
	{
		StandardAim = new class'X2AbilityToHitCalc_StandardAim';
		StandardAim.bHitsAreCrits = false;
		StandardAim.BuiltInCritMod = default.RUPTURE_CRIT_BONUS;
		Template.AbilityToHitCalc = StandardAim;
		Template.AbilityToHitOwnerOnMissCalc = StandardAim;

        `LOG("LongWar2AbilitiesForWotc: Modifying Rupture");
	}

	// Aid Protocol - Make cooldown configurable and removes Threat Assessment cooldown increase
	if (Template.DataName == 'AidProtocol')
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.AID_PROTOCOL_COOLDOWN;
		Template.AbilityCooldown = Cooldown;

        `LOG("LongWar2AbilitiesForWotc: Modifying Aid Protocol");
	}
    
    // Revival Protocol - Make it grant more charges based on equipped gremlin tech level
	if (Template.DataName == 'RevivalProtocol')
	{
	    RPCharges = new class 'X2AbilityCharges_LW2WotC_GremlinTierBased';
	    RPCharges.CV_Charges = default.REVIVAL_PROTOCOL_CHARGES_CV;
	    RPCharges.MG_Charges = default.REVIVAL_PROTOCOL_CHARGES_MG;
	    RPCharges.BM_Charges = default.REVIVAL_PROTOCOL_CHARGES_BM;
	    Template.AbilityCharges = RPCharges;

        `LOG("LongWar2AbilitiesForWotc: Modifying Revival Protocol");
	}

    // Saturation Fire - Make ammo cost configurable and fix vanilla bug where the chance to destroy cover is ignored GOOD
    if (Template.DataName == 'SaturationFire')
	{
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[k]);
			if (AmmoCost != none)
			{
				X2AbilityCost_Ammo(Template.AbilityCosts[k]).iAmmo = default.SATURATION_FIRE_AMMO_COST;
			}
		}
		Template.AbilityMultiTargetEffects.length = 0;
		Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
		WorldDamage = new class'X2Effect_LW2WotC_MaybeApplyDirectionalWorldDamage';
		WorldDamage.bUseWeaponDamageType = true;
		WorldDamage.bUseWeaponEnvironmentalDamage = false;
		WorldDamage.EnvironmentalDamageAmount = 30;
		WorldDamage.bApplyOnHit = true;
		WorldDamage.bApplyOnMiss = true;
		WorldDamage.bApplyToWorldOnHit = true;
		WorldDamage.bApplyToWorldOnMiss = true;
		WorldDamage.bHitAdjacentDestructibles = true;
		WorldDamage.PlusNumZTiles = 1;
		WorldDamage.bHitTargetTile = true;
		WorldDamage.ApplyChance = class'X2Ability_GrenadierAbilitySet'.default.SATURATION_DESTRUCTION_CHANCE;
		Template.AddMultiTargetEffect(WorldDamage);

        `LOG("LongWar2AbilitiesForWotc: Modifying Saturation Fire");
	}

    // Full Override - Gives names to failed enemy hack buffs with unnamed effects so they can later be referenced
	switch (Template.DataName)
	{
		case 'HackRewardBuffEnemy':
			for (k = 0; k < Template.AbilityTargetEffects.length; k++)
			{
				Effect = X2Effect_Persistent (Template.AbilityTargetEffects[k]);
				if (Effect != none)
				{
					if (k == 0)
					{
						X2Effect_Persistent(Template.AbilityTargetEffects[k]).EffectName = 'HackRewardBuffEnemy0';
					}
					if (k == 1)
					{
						X2Effect_Persistent(Template.AbilityTargetEffects[k]).EffectName = 'HackRewardBuffEnemy1';
					}
				}
			}
			break;
		default:
			break;
	}

    // Area Suppression - Restrict overwatch abilities from being used while suppressed by Area Suppression
    switch (Template.DataName)
	{
		case 'Overwatch':
		case 'PistolOverwatch':
		case 'SniperRifleOverwatch':
		case 'LongWatch':
		case 'Killzone':		
			SuppressedCondition = new class'X2Condition_UnitEffects';
			SuppressedCondition.AddExcludeEffect(class'X2Effect_LW2WotC_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
			Template.AbilityShooterConditions.AddItem(SuppressedCondition);
			break;
        default:
            break;

        `LOG("LongWar2AbilitiesForWotc: Modifying Area Suppression");
	}

    // Domination - Don't let Domination be used on stunned targets
    if (Template.DataName == 'Domination')
	{
		UnitEffectsCondition = new class'X2Condition_UnitEffects';
		UnitEffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
		Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

        `LOG("LongWar2AbilitiesForWotc: Modifying Domination");
	}

    // Fuse - Add a configurable cooldown 
    if (Template.DataName == 'Fuse' && default.FUSE_COOLDOWN > 0)
	{
		Cooldown = new class 'X2AbilityCooldown';
		Cooldown.iNumTurns = default.FUSE_COOLDOWN;
		Template.AbilityCooldown = Cooldown;

        `LOG("LongWar2AbilitiesForWotc: Modifying Fuse");
	}
    
    // Guardian - Sets to one shot per target per turn
	if (Template.DataName == 'Sentinel')
	{
		Template.AbilityTargetEffects.length = 0;
	    GuardianEffect = new class'X2Effect_LW2WotC_Guardian';
	    GuardianEffect.BuildPersistentEffect(1, true, false);
	    GuardianEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	    GuardianEffect.ProcChance = class'X2Ability_SpecialistAbilitySet'.default.GUARDIAN_PROC;
	    Template.AddTargetEffect(GuardianEffect);
        
        `LOG("LongWar2AbilitiesForWotc: Modifying Guardian");
	}
    
	// Soul Steal - Adds Shield if user's Health is full
	if (Template.DataName == 'SoulSteal')
	{
		Template.AdditionalAbilities.AddItem('SoulStealTriggered2');
        
        `LOG("LongWar2AbilitiesForWotc: Modifying Soul Steal");
	}

    // Haywire Protocol - Changes so that individual enemies can only be hacked once per mission
    if (Template.DataName == 'FinalizeHaywire')
	{
		HaywiredEffect = new class'X2Effect_Persistent';
		HaywiredEffect.EffectName = 'Haywired';
		HaywiredEffect.BuildPersistentEffect(1, true, false);
		HaywiredEffect.bDisplayInUI = false;
		HaywiredEffect.bApplyOnMiss = true;
		Template.AddTargetEffect(HaywiredEffect);
        
        `LOG("LongWar2AbilitiesForWotc: Modifying Finalize Haywire");
	}
	if (Template.DataName == 'HaywireProtocol') 
	{
		NotHaywiredCondition = new class 'X2Condition_UnitEffects';
		NotHaywiredCondition.AddExcludeEffect ('Haywired', 'AA_NoTargets'); 
		Template.AbilityTargetConditions.AddItem(NotHaywiredCondition);
        
        `LOG("LongWar2AbilitiesForWotc: Modifying Haywire Protocol");
	}

    // Covering Fire - This makes overwatch shots apply malus if the user has Covering Fire
    switch (Template.DataName)
	{
		case 'OverwatchShot':
		case 'LongWatchShot':
		case 'GunslingerShot':
		case 'KillZoneShot':
		case 'PistolOverwatchShot':
		case 'LW2WotC_SuppressionShot':
		case 'SuppressionShot':
		case 'LW2WotC_AreaSuppressionShot':
		case 'LW2WotC_CloseCombatSpecialistAttack':

            CoveringFireMalusEffect = new class'X2Effect_PersistentStatChange';
            CoveringFireMalusEffect.AddPersistentStatChange(eStat_Offense, -default.COVERING_FIRE_OFFENSE_MALUS);
            CoveringFireMalusEffect.BuildPersistentEffect(2, false, false, false, eGameRule_PlayerTurnBegin);
            CoveringFireMalusEffect.SetDisplayInfo(ePerkBuff_Penalty, default.LocCoveringFire, default.LocCoveringFireMalus, "img:///UILibrary_PerkIcons.UIPerk_coverfire", true);
            CoveringFireMalusEffect.bRemoveWhenTargetDies = false;
            CoveringFireMalusEffect.bUseSourcePlayerState = true;
            CoveringFireMalusEffect.bApplyOnMiss = true;
            CoveringFireMalusEffect.DuplicateResponse=eDupe_Allow;

            CoveringFireAbilityCondition = new class'X2Condition_AbilityProperty';
            CoveringFireAbilityCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');

            CoveringFireMalusEffect.TargetConditions.AddItem(CoveringFireAbilityCondition);
			CoveringFireMalusEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

			Template.AddTargetEffect(CoveringFireMalusEffect);
            break;
        default:
            break;
        
        `LOG("LongWar2AbilitiesForWotc: Modifying Covering Fire");
	}

    // Prevents standard attacks from being used while burning, based on configuration
    if (default.NO_STANDARD_ATTACKS_WHEN_ON_FIRE && default.STANDARD_ATTACKS.Find(Template.DataName) != INDEX_NONE)
	{
		BurningUnitEffects = new class'X2Condition_UnitEffects';
		BurningUnitEffects.AddExcludeEffect(class'X2StatusEffects'.default.BurningName, 'AA_UnitIsBurning');
		Template.AbilityShooterConditions.AddItem(BurningUnitEffects);
	}

    // Prevents melee attacks from being used while burning, based on configuration
	if (default.NO_MELEE_ATTACKS_WHEN_ON_FIRE)
	{
		if (Template.IsMelee())
		{
			BurningUnitEffects = new class'X2Condition_UnitEffects';
			BurningUnitEffects.AddExcludeEffect(class'X2StatusEffects'.default.BurningName, 'AA_UnitIsBurning');
			Template.AbilityShooterConditions.AddItem(BurningUnitEffects);
		}
	}

}
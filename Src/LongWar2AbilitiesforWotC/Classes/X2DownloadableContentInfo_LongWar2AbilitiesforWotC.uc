//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_LongWar2AbilitiesforWotC.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LongWar2AbilitiesforWotC extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);
	switch(Type)
	{
		case 'CENTERMASS_DAMAGE':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.CENTERMASS_DAMAGE);
			return true;
		case 'LETHAL_DAMAGE':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.LETHAL_DAMAGE);
			return true;
		case 'HNR_USES_PER_TURN':
			OutString = getNumRefundsString(class'X2Effect_LW2WotC_HitandRun'.default.HNR_USES_PER_TURN);
			return true;
		case 'CCS_RANGE':
			OutString = getStringBasedOnValue(class'X2AbilityTarget_LW2WotC_Single_CCS'.default.CCS_RANGE, "tile", "tiles");
			return true;
		case 'CCS_AMMO_PER_SHOT':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.CCS_AMMO_PER_SHOT);
			return true;
		case 'DGG_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_DamnGoodGround'.default.DGG_AIM_BONUS);
			return true;
		case 'DGG_DEF_BONUS':
			OutString = string(class'X2Effect_LW2WotC_DamnGoodGround'.default.DGG_DEF_BONUS);
			return true;
		case 'EXECUTIONER_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_Executioner'.default.EXECUTIONER_AIM_BONUS);
			return true;
		case 'EXECUTIONER_CRIT_BONUS':
			OutString = string(class'X2Effect_LW2WotC_Executioner'.default.EXECUTIONER_CRIT_BONUS);
			return true;
		case 'RESILIENCE_CRITDEF_BONUS':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.RESILIENCE_CRITDEF_BONUS);
			return true;
		case 'TACTICAL_SENSE_DEF_BONUS_PER_ENEMY':
			OutString = string(class'X2Effect_LW2WotC_TacticalSense'.default.TACTICAL_SENSE_DEF_BONUS_PER_ENEMY);
			return true;
		case 'TACTICAL_SENSE_MAX_DEF_BONUS':
			OutString = string(class'X2Effect_LW2WotC_TacticalSense'.default.TACTICAL_SENSE_MAX_DEF_BONUS);
			return true;
		case 'TS_SQUADSIGHT_ENEMIES_APPLY':
			OutString = getSquadsightString(class'X2Effect_LW2WotC_TacticalSense'.default.TS_SQUADSIGHT_ENEMIES_APPLY);
			return true;
		case 'AGGRESSION_CRIT_BONUS_PER_ENEMY':
			OutString = string(class'X2Effect_LW2WotC_Aggression'.default.AGGRESSION_CRIT_BONUS_PER_ENEMY);
			return true;
		case 'AGGRESSION_MAX_CRIT_BONUS':
			OutString = string(class'X2Effect_LW2WotC_Aggression'.default.AGGRESSION_MAX_CRIT_BONUS);
			return true;
		case 'AGG_SQUADSIGHT_ENEMIES_APPLY':
			OutString = getSquadsightString(class'X2Effect_LW2WotC_Aggression'.default.AGG_SQUADSIGHT_ENEMIES_APPLY);
			return true;
		case 'BEO_BONUS_CRIT_DAMAGE_PER_ENEMY':
			OutString = string(clamp(class'X2Effect_LW2WotC_BringEmOn'.default.BEO_BONUS_CRIT_DAMAGE_PER_ENEMY * 2, 0, class'X2Effect_LW2WotC_BringEmOn'.default.BEO_MAX_BONUS_CRIT_DAMAGE));
			return true;
		case 'BEO_MAX_BONUS_CRIT_DAMAGE':
			OutString = string(class'X2Effect_LW2WotC_BringEmOn'.default.BEO_MAX_BONUS_CRIT_DAMAGE);
			return true;
		case 'BEO_SQUADSIGHT_ENEMIES_APPLY':
			OutString = getSquadsightString(class'X2Effect_LW2WotC_BringEmOn'.default.BEO_SQUADSIGHT_ENEMIES_APPLY);
			return true;
		case 'HT_DODGE_BONUS_PER_ENEMY':
			OutString = string(class'X2Effect_LW2WotC_HardTarget'.default.HT_DODGE_BONUS_PER_ENEMY);
			return true;
		case 'HT_MAX_DODGE_BONUS':
			OutString = string(class'X2Effect_LW2WotC_HardTarget'.default.HT_MAX_DODGE_BONUS);
			return true;
		case 'HT_SQUADSIGHT_ENEMIES_APPLY':
			OutString = getSquadsightString(class'X2Effect_LW2WotC_HardTarget'.default.HT_SQUADSIGHT_ENEMIES_APPLY);
			return true;
		case 'INFIGHTER_DODGE_BONUS':
			OutString = string(class'X2Effect_LW2WotC_Infighter'.default.INFIGHTER_DODGE_BONUS);
			return true;
		case 'INFIGHTER_MAX_TILES':
			OutString = getStringBasedOnValue(class'X2Effect_LW2WotC_Infighter'.default.INFIGHTER_MAX_TILES, "tile", "tiles");
			return true;
		case 'DP_AIM_BONUS':
			OutString = string(class'X2Effect_LW2WotC_DepthPerception'.default.DP_AIM_BONUS);
			return true;
		case 'DP_ANTIDODGE_BONUS':
			OutString = string(class'X2Effect_LW2WotC_DepthPerception'.default.DP_ANTIDODGE_BONUS);
			return true;
		default: 
			return false;
	}
}

private static function string getStringBasedOnValue(int value, string single, string plural)
{
	if(value > 1)
	{
		return string(value) @ plural;
	}

	return string(value) @ single;
}

private static function string getEndTurnString(bool value)
{
	if(value)
	{
		return "Ends the user's turn when used.";
	}

	return "Does not end the user's turn when used as a first action.";
}

private static function string getNumRefundsString(int maxRefunds)
{
	if(maxRefunds == 0)
	{
		return "Can activate an unlimited number of times per turn.";
	}
	else if(maxRefunds == 1)
	{
		return "Can activate 1 time per turn.";
	}
	
	return "Can activate" @ string(maxRefunds) @ "times per turn.";
}

private static function string getOneMinusFloatValueString(float modifier)
{
	local float result;
	local string returnString;

	result = 1 - modifier;
	returnString = string(int(result * 100)) $ "%";

	return returnString;
}

private static function string getInversedValueString(int value)
{
	return string(-1 * value);
}

private static function string getSquadsightString(bool squadsightValid)
{
    if(squadsightValid)
    {
        return "Units visible at squadsight ranges do confer bonus.";
    }
    else
    {
        return "Units visible at squadsight ranges do not confer bonus.";
    }
}
//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_GrazingFire
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up Grazing Fire -- enemy must make saving throw versus dodge to avoid
// being grazed on a miss
//--------------------------------------------------------------------------------------- 

class X2Effect_LW2WotC_GrazingFire extends X2Effect_Persistent;

var int SuccessChance;

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
    local int RandRoll, HitChance;

    if (AbilityState.GetSourceWeapon() == Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon))
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultMiss(CurrentResult))
        {
            RandRoll = `SYNC_RAND(100);
            HitChance = SuccessChance - TargetUnit.GetCurrentStat(eStat_Dodge);
            if (Randroll <= HitChance)
            {
                NewHitResult = eHit_Graze;
                return true;
            }
        }
    }
    return false;
}
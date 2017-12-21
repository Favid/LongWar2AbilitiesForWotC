class X2AbilityCost_LW2WotC_ReducedActionCostByAbility extends X2AbilityCost_ActionPoints;

var array<name> AbilitiesThatReduceCost;

simulated function int GetPointCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
    local int PointCheck;
    local name AbilityName;

    PointCheck = super.GetPointCost(AbilityState, AbilityOwner);

    if(PointCheck > 1)
    {
        foreach AbilitiesThatReduceCost(AbilityName)
        {
            if(AbilityOwner.HasSoldierAbility(AbilityName))
            {
                return (PointCheck - 1);
            }
        }
    }

    return PointCheck;
}
class X2Effect_LW2WotC_SnapShotAimModifier extends X2Effect_Persistent config (LW_SoldierSkills);

var config array<int> AimModifier;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local int Tiles;
    local XComGameState_Item SourceWeapon;
    local ShotModifierInfo ShotInfo;

    if (AbilityState.GetMyTemplateName() == 'LW2WotC_SnapShot')
    {
        SourceWeapon = AbilityState.GetSourceWeapon();    
        if(SourceWeapon != none && SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        {
            Tiles = Attacker.TileDistanceBetween(Target);       
            if(AimModifier.Length > 0)
            {
                if(Tiles < AimModifier.Length)
                {
                    ShotInfo.Value = AimModifier[Tiles];
                }            
                else //Use last value
                {
                    ShotInfo.Value = AimModifier[AimModifier.Length - 1];
                }
                ShotInfo.ModType = eHit_Success;
                ShotInfo.Reason = FriendlyName;
                ShotModifiers.AddItem(ShotInfo);
            }
        }    
    }
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="LW2WotC_SnapShotAimModifier"
}
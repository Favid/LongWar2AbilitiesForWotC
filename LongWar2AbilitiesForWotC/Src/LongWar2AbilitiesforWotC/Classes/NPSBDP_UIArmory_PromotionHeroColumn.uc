class NPSBDP_UIArmory_PromotionHeroColumn extends UIArmory_PromotionHeroColumn;

var int Offset;

function OnAbilityInfoClicked(UIButton Button)
{
    local X2AbilityTemplate AbilityTemplate;
    local X2AbilityTemplateManager AbilityTemplateManager;
    local UIButton InfoButton;
    local NPSBDP_UIArmory_PromotionHero PromotionScreen;
    local int idx;

    PromotionScreen = NPSBDP_UIArmory_PromotionHero(Screen);

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach InfoButtons(InfoButton, idx)
    {
        if (InfoButton == Button)
        {
            AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityNames[Offset + idx]);
            break;
        }
    }
    
    if (AbilityTemplate != none)
        `HQPRES.UIAbilityPopup(AbilityTemplate, PromotionScreen.UnitReference);

    if( InfoButton != none )
        InfoButton.Hide();
}
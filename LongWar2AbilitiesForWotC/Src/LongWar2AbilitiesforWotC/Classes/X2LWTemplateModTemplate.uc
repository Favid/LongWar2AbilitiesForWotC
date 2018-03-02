//---------------------------------------------------------------------------------------
//  FILE:    X2LWTemplateModTemplate.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: "Meta" templates to allow modification to existing templates on game launch.
//---------------------------------------------------------------------------------------

class X2LWTemplateModTemplate extends X2StrategyElementTemplate;

var Delegate<AbilityTemplateMod> AbilityTemplateModFn;

delegate AbilityTemplateMod(X2AbilityTemplate Template, int Difficulty);
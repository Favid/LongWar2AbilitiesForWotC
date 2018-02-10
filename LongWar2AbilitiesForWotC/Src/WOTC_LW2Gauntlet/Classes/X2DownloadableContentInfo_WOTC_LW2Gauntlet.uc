class X2DownloadableContentInfo_WOTC_LW2Gauntlet extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager				ItemTemplateMgr;
	
	`REDSCREEN("LW2 Gauntlet");
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
    if(ItemTemplateMgr.FindItemTemplate('LWGauntlet_CV') == none)
    {
        `REDSCREEN("LWGauntlet_CV not found");
    }
    if(ItemTemplateMgr.FindItemTemplate('LWGauntlet_MG') == none)
    {
        `REDSCREEN("LWGauntlet_MG not found");
    }
    if(ItemTemplateMgr.FindItemTemplate('LWGauntlet_BM') == none)
    {
        `REDSCREEN("LWGauntlet_BM not found");
    }
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;
	local UITacticalHUD TacticalHUD;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local int NumTiles;

	Type = name(InString);
	switch(Type)
	{
		case 'ROCKETSCATTER':
			TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
			if (TacticalHUD != none)
				UnitRef = XComTacticalController(TacticalHUD.PC).GetActiveUnitStateRef();
			if (UnitRef.ObjectID > 0)
				UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

			if (TacticalHUD != none && TacticalHUD.GetTargetingMethod() != none && UnitState != none)
			{
				NumTiles = class'X2Ability_LW_TechnicalAbilitySet'.static.GetNumAimRolls(UnitState);
				Outstring = class'X2Ability_LW_TechnicalAbilitySet'.default.strMaxScatter $ string(NumTiles);
			}
			else
			{
				Outstring = "";
			}
			return true;
		default: 
			return false;
	}
}
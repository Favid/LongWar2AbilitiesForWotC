
class X2DownloadableContentInfo_WOTC_LW2SecondaryWeapons extends X2DownloadableContentInfo config(LW2SecondariesWOTC);

// Setup socket replacement structures to add the sockets that the new secondaries attach to
struct SocketReplacementInfo
{
	var name TorsoName;
	var string SocketMeshString;
	var bool Female;
};

var config array<SocketReplacementInfo> SocketReplacements;


// Variables to control updating base game class abilities to have proper weapon restrictions
var config bool bEditAbilityTemplatesForBaseClasses;

var config array<name> EDIT_ABILITIES_PISTOL;
var config array<name> VALID_WEAPON_CATEGORIES_FOR_PISTOL_SKILLS;

var config array<name> EDIT_ABILITIES_GREMLIN;
var config array<name> VALID_WEAPON_CATEGORIES_FOR_GREMLIN_SKILLS;

var config array<name> EDIT_ABILITIES_MELEE;
var config array<name> VALID_WEAPON_CATEGORIES_FOR_MELEE_SKILLS;

var config array<name> EDIT_ABILITIES_LAUNCHER;
var config array<name> VALID_WEAPON_CATEGORIES_FOR_LAUNCHER_SKILLS;


// Events to manage loading mod templates into an existing save
// Backup methods to handle loading after the first time because I can't get it to work consistently
static event OnLoadedSavedGame()
{
	`Log("LW2 Secondaries for WotC:  Manage templates on first-time loading of existing save");
	ManageTemplates();
}
// --
static event OnLoadedSavedGameToStrategy()
{
	ManageTemplates();
}
// --
static event OnExitPostMissionSequence()
{
	ManageTemplates();
}
// --
static function ManageTemplates()
{
	local XComGameState						NewGameState;
	local XComGameStateHistory				History;
	local XComGameState_HeadquartersXCom	XComHQ;
	local X2ItemTemplateManager				ItemTemplateMgr;
	local array<X2ItemTemplate>				CheckItemTemplates, AddItemTemplates;
	local XComGameState_Item				NewItemState;
	local int i;

	History = `XCOMHISTORY;
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	// Check to see if the base items are in the HQ Inventory - if any are not, add them
	CheckItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('Arcthrower_CV'));
	CheckItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('CombatKnife_CV'));
	//CheckItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('LWGauntlet_CV'));
	CheckItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('Holotargeter_CV'));
	CheckItemTemplates.AddItem(ItemTemplateMgr.FindItemTemplate('SawedOffShotgun_CV'));

	for (i = 0; i < CheckItemTemplates.Length; ++i)
	{
		if(CheckItemTemplates[i] != none)
		{
			`Log("LW2 Secondaries: Checking inventory for " @ CheckItemTemplates[i].GetItemFriendlyName());
			if (!XComHQ.HasItem(CheckItemTemplates[i]))
			{
				AddItemTemplates.AddItem(CheckItemTemplates[i]);
	}	}	}

	// If any items need to be added, create a new gamestate and add them
	if (AddItemTemplates.length > 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LW2 Secondaries: Updating HQ Storage");
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);

		for (i = 0; i < AddItemTemplates.Length; ++i)
		{
			if(AddItemTemplates[i] != none)
			{
				`Log("LW2 Secondaries: " @ AddItemTemplates[i].GetItemFriendlyName() @ " not found, adding to inventory");
				NewItemState = AddItemTemplates[i].CreateInstanceFromTemplate(NewGameState);
				NewGameState.AddStateObject(NewItemState);
				XComHQ.AddItemToHQInventory(NewItemState);
		}	}
			
		History.AddGameStateToHistory(NewGameState);
	}
}


static event OnPostTemplatesCreated()
{
	UpdateAbilityTemplates();
	ChainAbilityTag();
}


// Update base game Secondary Weapon ability templates to add a weapon restriction
static function UpdateAbilityTemplates()
{
	local X2AbilityTemplateManager				AbilityManager;
	local array<X2AbilityTemplate>				TemplateAllDifficulties;
	local X2AbilityTemplate						Template;
	local name									TemplateName;
	local X2Condition_ValidWeaponType			WeaponCondition;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// Add weapon restrictions for Pistol Abilities
	if (default.bEditAbilityTemplatesForBaseClasses)
	{
		foreach default.EDIT_ABILITIES_PISTOL(TemplateName)
		{
			AbilityManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
			foreach TemplateAllDifficulties(Template)
			{
				WeaponCondition = new class'X2Condition_ValidWeaponType';
				WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_PISTOL_SKILLS;
				Template.AbilityShooterConditions.AddItem(WeaponCondition);
				`Log("WOTC LW2 Secondary Weapons - Template Edits: Added pistol weapon restrictions to" @ TemplateName);
			}
		}

		// Add weapon restrictions for Gremlin Abilities
		foreach default.EDIT_ABILITIES_GREMLIN(TemplateName)
		{
			AbilityManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
			foreach TemplateAllDifficulties(Template)
			{
				WeaponCondition = new class'X2Condition_ValidWeaponType';
				WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_GREMLIN_SKILLS;
				Template.AbilityShooterConditions.AddItem(WeaponCondition);
				`Log("WOTC LW2 Secondary Weapons - Template Edits: Added gremlin weapon restrictions to" @ TemplateName);
			}
		}

		// Add weapon restrictions for Melee Abilities
		foreach default.EDIT_ABILITIES_MELEE(TemplateName)
		{
			AbilityManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
			foreach TemplateAllDifficulties(Template)
			{
				WeaponCondition = new class'X2Condition_ValidWeaponType';
				WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_MELEE_SKILLS;
				Template.AbilityShooterConditions.AddItem(WeaponCondition);
				`Log("WOTC LW2 Secondary Weapons - Template Edits: Added melee weapon restrictions to" @ TemplateName);
			}
		}

		// Add weapon restrictions for Grenade Launcher Abilities
		foreach default.EDIT_ABILITIES_LAUNCHER(TemplateName)
		{
			AbilityManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
			foreach TemplateAllDifficulties(Template)
			{
				WeaponCondition = new class'X2Condition_ValidWeaponType';
				WeaponCondition.AllowedWeaponCategories = default.VALID_WEAPON_CATEGORIES_FOR_LAUNCHER_SKILLS;
				Template.AbilityShooterConditions.AddItem(WeaponCondition);
				`Log("WOTC LW2 Secondary Weapons - Template Edits: Added grenade launcher weapon restrictions to" @ TemplateName);
}	}	}	}


// Handle Expanding Ability Tags in Localization text
static function ChainAbilityTag()
{
	local XComEngine						Engine;
	local X2AbilityTag_LW2SecondariesWOTC	NewAbilityTag;
	local X2AbilityTag						OldAbilityTag;
	local int idx;

	Engine = `XENGINE;

	OldAbilityTag = Engine.AbilityTag;
	
	NewAbilityTag = new class'X2AbilityTag_LW2SecondariesWOTC';
	NewAbilityTag.WrappedTag = OldAbilityTag;

	idx = Engine.LocalizeContext.LocalizeTags.Find(Engine.AbilityTag);
	Engine.AbilityTag = NewAbilityTag;
	Engine.LocalizeContext.LocalizeTags[idx] = NewAbilityTag;
}


// Append sockets to the human skeletal meshes for the new secondary weapons
// (this needs appropriate calls from XComHumanPawn.uc and/or XComUnitPawn.uc added by the X2CommunityHighlander to work)
static function string DLCAppendSockets(XComUnitPawn Pawn)
{
	local SocketReplacementInfo SocketReplacement;
	local name TorsoName;
	local bool bIsFemale;
	local string DefaultString, ReturnString;
	local XComHumanPawn HumanPawn;

	HumanPawn = XComHumanPawn(Pawn);
	if (HumanPawn == none) { return ""; }

	TorsoName = HumanPawn.m_kAppearance.nmTorso;
	bIsFemale = HumanPawn.m_kAppearance.iGender == eGender_Female;

	foreach default.SocketReplacements(SocketReplacement)
	{
		if (TorsoName != 'None' && TorsoName == SocketReplacement.TorsoName && bIsFemale == SocketReplacement.Female)
		{
			ReturnString = SocketReplacement.SocketMeshString;
			break;
		}
		else
		{
			if (SocketReplacement.TorsoName == 'Default' && SocketReplacement.Female == bIsFemale)
			{
				DefaultString = SocketReplacement.SocketMeshString;
			}
		}
	}
	if (ReturnString == "")
	{
		// did not find, so use default
		ReturnString = DefaultString;
	}
	return ReturnString;
}
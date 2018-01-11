//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_AWCPack_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes Officer mod settings on campaign start or when loading campaign without mod previously active
//--------------------------------------------------------------------------------------- 

class X2DownloadableContentInfo_AWCPack_LW extends X2DownloadableContentInfo;	

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	`Log("LW AWCPack : Starting OnLoadedSavedGame");
	UpdateAWCFacility();
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	`Log("X2DLCInfo_AWCPack_LW: Starting OnPostTemplatesCreated");
	UpdateAWCFacilityTemplates();
}

// ******** HANDLE UPDATING FACILITY TEMPLATES ************* //
// This handles updating the AWC facility templates (for all difficulties), for the cases in which the OTS hasn't already been built
static function UpdateAWCFacilityTemplates()
{
	//local X2FacilityTemplate FacilityTemplate;
	//local array<X2FacilityTemplate> FacilityTemplates;

	//FindFacilityTemplateAllDifficulties('RecoveryCenter', FacilityTemplates);
	//foreach FacilityTemplates(FacilityTemplate)
	//{
		//if(FacilityTemplate.StaffSlots.Length == 2)
		//{
			//FacilityTemplate.StaffSlots.AddItem('AWCTrainingSlot_LW');
			//FacilityTemplate.StaffSlots.AddItem('AWCTrainingSlot_LW');
			//FacilityTemplate.StaffSlotsLocked = 1;
//
			//FacilityTemplate.Upgrades.AddItem('AWCTrainingUpgrade_SecondSlot_LW');
		//}
	//}
	//`LOG("LW AWCPack: Updated AdvancedWarfare Facility");

	local X2FacilityTemplate FacilityTemplate;
	local array<X2FacilityTemplate> FacilityTemplates;
	local StaffSlotDefinition StaffSlot;

	StaffSlot.StaffSlotTemplateName = 'AWCTrainingSlot_LW';
	StaffSlot.LinkedStaffSlotTemplateName = '';
	StaffSlot.bStartsLocked = true;

	// ***  OFFICER TRAINING SCHOOL *** //
	FindFacilityTemplateAllDifficulties('RecoveryCenter', FacilityTemplates);
	foreach FacilityTemplates(FacilityTemplate)
	{
		//FacilityTemplate.StaffSlots.AddItem('OTSOfficerSlot'); // changed to StaffSlotDefinition
		FacilityTemplate.StaffSlotDefs.AddItem(StaffSlot);
		FacilityTemplate.StaffSlotsLocked = 1;
		`log("LW OfficerPack: Added OTSOfficerSlot to facility template OfficerTrainingSchool");

		FacilityTemplate.Upgrades.AddItem('AWCTrainingUpgrade_SecondSlot_LW');
		`log("LW OfficerPack: Added OTS Facility upgrade to facility template OfficerTrainingSchool");
	}
	`LOG("LW OfficerPack : Update OTS Templates");
}

//retrieves all difficulty variants of a given facility template -- future proofing in case difficulty variants get added
static function FindFacilityTemplateAllDifficulties(name DataName, out array<X2FacilityTemplate> FacilityTemplates, optional X2StrategyElementTemplateManager StrategyTemplateMgr)
{
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
	local X2FacilityTemplate FacilityTemplate;

	if(StrategyTemplateMgr == none)
		StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	StrategyTemplateMgr.FindDataTemplateAllDifficulties(DataName, DataTemplates);
	FacilityTemplates.Length = 0;
	foreach DataTemplates(DataTemplate)
	{
		FacilityTemplate = X2FacilityTemplate(DataTemplate);
		if( FacilityTemplate != none )
		{
			FacilityTemplates.AddItem(FacilityTemplate);
		}
	}
}


// ******** HANDLE UPDATING AWC FACILITY ************* //
// This handles updating the AWC facility, in case facility is already built or is being built
// Upgrades are dynamically pulled from templates even for already-completed facilities, so don't have to be updated
static function UpdateAWCFacility()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local name TemplateName;
	local XComGameState_FacilityXCom FacilityState, OTSState;

	//`Log("LW OfficerPack : Searching for existing OTS Facility");
	TemplateName = 'GuerillaTacticsSchool';
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_FacilityXCom', FacilityState)
	{
		if( FacilityState.GetMyTemplateName() == TemplateName )
		{
			OTSState = FacilityState; 
			break;
		}
	}

	if(OTSState == none) 
	{
		//`log("LW OfficerPack: No existing OTS facility, update aborted");
		return;
	}

	//`Log("LW OfficerPack: Found existing OTS, Attempting to update StaffSlots");
	if(OTSState.StaffSlots.Length == 1)
	{
		//`log("LW OfficerPack: OTS had only single staff slot, attempting to update facility"); 
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating OTS Facility for LW_OfficerPack");
		CreateStaffSlots(OTSState, NewGameState);
		NewGameState.AddStateObject(OTSState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}


//---------------------------------------------------------------------------------------
static function CreateStaffSlots(XComGameState_FacilityXCom FacilityState, XComGameState NewGameState)
{
local X2FacilityTemplate FacilityTemplate;
	local X2StaffSlotTemplate StaffSlotTemplate;
	local XComGameState_StaffSlot StaffSlotState;
	local int i, LockThreshold;
	
	FacilityTemplate = FacilityState.GetMyTemplate();

	//LockThreshold = FacilityTemplate.StaffSlots.Length - FacilityTemplate.StaffSlotsLocked; // Template's StaffSlots became StaffSlotDefs
	LockThreshold = FacilityTemplate.StaffSlotDefs.Length - FacilityTemplate.StaffSlotsLocked;
	
	//for (i = FacilityState.StaffSlots.Length ; i < FacilityTemplate.StaffSlots.Length; i++) // Template's StaffSlots became StaffSlotDefs
	for (i = FacilityState.StaffSlots.Length ; i < FacilityTemplate.StaffSlotDefs.Length; i++)
	{
		//StaffSlotTemplate = X2StaffSlotTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(FacilityTemplate.StaffSlots[i]));
		StaffSlotTemplate = X2StaffSlotTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(FacilityTemplate.StaffSlotDefs[i].StaffSlotTemplateName));

		if (StaffSlotTemplate != none)
		{
			StaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewGameState);
			StaffSlotState.Facility = FacilityState.GetReference(); //make sure the staff slot knows what facility it is in
			if (i >= LockThreshold)
			{
				StaffSlotState.LockSlot();
			}
			
			NewGameState.AddStateObject(StaffSlotState);

			FacilityState.StaffSlots.AddItem(StaffSlotState.GetReference());
		}
	}
}

// Use SLG hook to add AWC abilities from AWC component
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local array<AbilitySetupData> arrData;
	local array<AbilitySetupData> arrAdditional;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local XComGameState_Unit_AWC_LW AWCState;
	local int i;
	local name AbilityName;
	local AbilitySetupData Data, EmptyData;
	local array<SoldierClassAbilityType> EarnedAWCAbilities;
	local array<ClassAgnosticAbility> TrainedAWCAbilities;
	local array<XComGameState_Item> CurrentInventory;
	local XComGameState_Item InventoryItem;

	return; // DEPRECATED

	if (UnitState == none) {return;}

	AWCState = class'LWAWCUtilities'.static.GetAWCComponent(UnitState);
	if (AWCState == none) { return; }

	CurrentInventory = UnitState.GetAllInventoryItems(StartState);

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	//retrieve the AWC abilities from the AWC state
	TrainedAWCAbilities = AWCState.GetAllTrainedAWCAbilities();
	for(i = 0; i < TrainedAWCAbilities.Length; ++i)
	{
		EarnedAWCAbilities.AddItem(TrainedAWCAbilities[i].AbilityType);
	}

	//add the AWC abilities
	for (i = 0; i < EarnedAWCAbilities.Length; ++i)
	{
		AbilityName = EarnedAWCAbilities[i].AbilityName;
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
		if (AbilityTemplate != none && !AbilityTemplate.bUniqueSource || arrData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE)
		{
			Data = EmptyData;
			Data.TemplateName = AbilityName;
			Data.Template = AbilityTemplate;
			if (EarnedAWCAbilities[i].ApplyToWeaponSlot != eInvSlot_Unknown)
			{
				foreach CurrentInventory(InventoryItem)
				{
					if (InventoryItem.bMergedOut)
						continue;
					if (InventoryItem.InventorySlot == EarnedAWCAbilities[i].ApplyToWeaponSlot)
					{
						Data.SourceWeaponRef = InventoryItem.GetReference();

						if (EarnedAWCAbilities[i].ApplyToWeaponSlot != eInvSlot_Utility)
						{
							//  stop searching as this is the only valid item
							break;
						}
						else
						{
							//  add this item if valid and keep looking for other utility items
							if (InventoryItem.GetWeaponCategory() == EarnedAWCAbilities[i].UtilityCat)							
							{
								arrData.AddItem(Data);
							}
						}
					}
				}
				//  send an error if it wasn't a utility item (primary/secondary weapons should always exist)
				if (Data.SourceWeaponRef.ObjectID == 0 && EarnedAWCAbilities[i].ApplyToWeaponSlot != eInvSlot_Utility)
				{
					`RedScreen("Soldier ability" @ AbilityName @ "wants to attach to slot" @ EarnedAWCAbilities[i].ApplyToWeaponSlot @ "but no weapon was found there.");
				}
			}
			//  add data if it wasn't on a utility item
			if (EarnedAWCAbilities[i].ApplyToWeaponSlot != eInvSlot_Utility)
			{
				if (AbilityTemplate.bUseLaunchedGrenadeEffects)     //  could potentially add another flag but for now this is all we need it for -jbouscher
				{
					//  populate a version of the ability for every grenade in the inventory
					foreach CurrentInventory(InventoryItem)
					{
						if (InventoryItem.bMergedOut) 
							continue;

						if (X2GrenadeTemplate(InventoryItem.GetMyTemplate()) != none)
						{ 
							Data.SourceAmmoRef = InventoryItem.GetReference();
							arrData.AddItem(Data);
						}
					}
				}
				else
				{
					arrData.AddItem(Data);
				}
			}
		}
	}

	//  Add any additional abilities
	for (i = 0; i < arrData.Length; ++i)
	{
		foreach arrData[i].Template.AdditionalAbilities(AbilityName)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
			if (AbilityTemplate != none && !AbilityTemplate.bUniqueSource || arrData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE)
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				Data.SourceWeaponRef = arrData[i].SourceWeaponRef;
				arrAdditional.AddItem(Data);
			}			
		}
	}
	// Move all the basic abilities into the return list
	for (i = 0; i < arrData.Length; ++i)
	{
		if( SetupData.Find('TemplateName', arrData[i].TemplateName) == INDEX_NONE )
		{
			SetupData.AddItem(arrData[i]);
		}
	}


	//  Move all of the additional abilities into the return list
	for (i = 0; i < arrAdditional.Length; ++i)
	{
		if( SetupData.Find('TemplateName', arrAdditional[i].TemplateName) == INDEX_NONE )
		{
			SetupData.AddItem(arrAdditional[i]);
		}
	}
}

static function ModifyEarnedSoldierAbilities(out array<SoldierClassAbilityType> EarnedAbilities, XComGameState_Unit UnitState)
{
	local XComGameState_Unit_AWC_LW AWCState;
	local ClassAgnosticAbility Ability;
	
	if(UnitState == none)
	{
		`REDSCREEN("ModifyEarnedSoldierAbilities called with none UnitState");
		return;
	}

	AWCState = class'LWAWCUtilities'.static.GetAWCComponent(UnitState);
	if (AWCState != none)
	{
		//Modify the EarnedAbilities with the AWC abilities from the AWCState
		foreach AWCState.OffenseAbilities(Ability)
		{
			if(Ability.bUnlocked)
				EarnedAbilities.AddItem(Ability.AbilityType);
		}

		foreach AWCState.DefenseAbilities(Ability)
		{
			if(Ability.bUnlocked)
				EarnedAbilities.AddItem(Ability.AbilityType);
		}

		foreach AWCState.PistolAbilities(Ability)
		{
			if(Ability.bUnlocked)
				EarnedAbilities.AddItem(Ability.AbilityType);
		}
	}
}

//=========================================================================================
//================== BEGIN EXEC LONG WAR CONSOLE EXEC =====================================
//=========================================================================================


// this forces all non-rookie soldiers to re-roll their AWC trainable abilities
exec function LWForceAWCRerolls()
{
	local XComGameState NewGameState;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit, UpdatedUnit;
	local XComGameState_Unit_AWC_LW AWCState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Force AWC Rerolls");

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		if(Unit.GetRank() > 0) // can't do this for rookies, since they have no class tree for AWC restrictions
		{
			AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);
			if(AWCState == none)
			{
				//create and link it
				UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
				NewGameState.AddStateObject(UpdatedUnit);
				AWCState = XComGameState_Unit_AWC_LW(NewGameState.CreateStateObject(class'XComGameState_Unit_AWC_LW'));
				NewGameState.AddStateObject(AWCState);
				UpdatedUnit.AddComponentObject(AWCState);

				AWCState.ChooseSoldierAWCOptions(UpdatedUnit, true);
			}
			else
			{
				AWCState = XComGameState_Unit_AWC_LW(NewGameState.CreateStateObject(class'XComGameState_Unit_AWC_LW', AWCState.ObjectID));
				NewGameState.AddStateObject(AWCState);
				AWCState.ChooseSoldierAWCOptions(Unit, true);
			}
		}
	}
	
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

// this gives the next available AWC offense ability to the named soldier
exec function LWGiveAWCOffenseAbility(string SoldierFirstName, string SoldierLastName)
{
	LWGiveAWCAbility(AWCTT_Offense, SoldierFirstName, SoldierLastName);
}

// this gives the next available AWC defense ability to the named soldier
exec function LWGiveAWCDefenseAbility(string SoldierFirstName, string SoldierLastName)
{
	LWGiveAWCAbility(AWCTT_Defense, SoldierFirstName, SoldierLastName);
}

// this gives the next available AWC pistol ability to the named soldier
exec function LWGiveAWCPistolAbility(string SoldierFirstName, string SoldierLastName)
{
	LWGiveAWCAbility(AWCTT_Pistol, SoldierFirstName, SoldierLastName);
}

// this gives the next available AWC specified ability type to the named soldier
function LWGiveAWCAbility(AWCTrainingType Type, string SoldierFirstName, string SoldierLastName)
{
	local XComGameState NewGameState;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_AWC_LW AWCState;
	local ClassAgnosticAbility AWCAbility;
	local int Count;

	Soldiers = `XCOMHQ.GetSoldiers();
	foreach Soldiers(Unit)
	{
		`LOG("Checking Soldier: " $ Unit.GetFirstName() @ Unit.GetLastName());
		if(Unit.GetFirstName() ~= SoldierFirstName && Unit.GetLastName() ~= SoldierLastName)
		{
			AWCState = class'LWAWCUtilities'.static.GetAWCComponent(Unit);
			if(AWCState != none)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Force AWC Rerolls");
				AWCState = XComGameState_Unit_AWC_LW(NewGameState.CreateStateObject(class'XComGameState_Unit_AWC_LW', AWCState.ObjectID));
				NewGameState.AddStateObject(AWCState);
				switch (Type)
				{
					case AWCTT_Offense:
						foreach AWCState.OffenseAbilities(AWCAbility, Count)
						{
							if(!AWCAbility.bUnlocked)
							{
								AWCState.TrainAbility(Count, Type);
								break;
							}
						}
						break;
					case AWCTT_Pistol:
						foreach AWCState.PistolAbilities(AWCAbility, Count)
						{
							if(!AWCAbility.bUnlocked)
							{
								AWCState.TrainAbility(Count, Type);
								break;
							}
						}
						break;
					case AWCTT_Defense:
						foreach AWCState.DefenseAbilities(AWCAbility, Count)
						{
							if(!AWCAbility.bUnlocked)
							{
								AWCState.TrainAbility(Count, Type);
								break;
							}
						}
						break;
					default:
						break;
				}
				`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
				return;
			}
		}
	}
}

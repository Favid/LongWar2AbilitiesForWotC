
class X2Condition_ValidWeaponType extends X2Condition;

// Variables to pass into the condition check:
var array<name>		ExcludedWeaponCategories;
var array<name>		AllowedWeaponCategories;


event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameStateHistory	History;
	local XComGameState_Unit	SourceUnit;
	local XComGameState_Item	InventoryItem;
	local EInventorySlot		InventorySlot;
	local X2WeaponTemplate		WeaponTemplate;
	local name					WeaponCategory;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	InventoryItem = XComGameState_Item(History.GetGameStateForObjectID(kAbility.SourceWeapon.ObjectID));
	InventorySlot = InventoryItem.InventorySlot;

	InventoryItem = SourceUnit.GetItemInSlot(InventorySlot);
	if (InventoryItem == none)
		return 'AA_WeaponIncompatible';

	WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
	if (WeaponTemplate == none)
		return 'AA_WeaponIncompatible';
	
	WeaponCategory = WeaponTemplate.WeaponCat;
	if (ExcludedWeaponCategories.Length > 0 && ExcludedWeaponCategories.find(WeaponCategory) != INDEX_NONE)
		return 'AA_WeaponIncompatible';
	
	if (AllowedWeaponCategories.Length > 0 && AllowedWeaponCategories.find(WeaponCategory) == INDEX_NONE)
		return 'AA_WeaponIncompatible';
	
	return 'AA_Success';
}


function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	local XComGameState_Item			InventoryItem;
	local array<XComGameState_Item>		CurrentInventory;
	local X2WeaponTemplate				WeaponTemplate;
	local name							WeaponCategory;


	// Check SourceUnit's inventory to make sure ONE of their equipped items matches the required weapon type.
	// If not, the ability will not even be added to the unit for the tactical battle. This does not verify
	// that the item of the correct weapon category is equipped as the correct item slot - that will be handled
	// in CallAbilityMeetsCondition. This should be an edge case and wont be handled as cleanly - the ability
	// will still show up on the SourceUnit's toolbar, they just wont be able to use it. Any excluded weapon
	// categories are NOT checked here, because (again, edge case) an excluded weapon type in a different
	// inventory slot should not prevent the ability from being used with a proper item type in the ability's
	// assigned inventory slot. Skip if no AllowedWeaponCategories are defined.
	if (AllowedWeaponCategories.Length <= 0)
		return true;

	CurrentInventory = SourceUnit.GetAllInventoryItems(, true);
	foreach CurrentInventory(InventoryItem)
	{
		WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
		WeaponCategory = WeaponTemplate.WeaponCat;
	
		if (AllowedWeaponCategories.find(WeaponCategory) != INDEX_NONE)
			return true;
	}
	
	// No valid weapon category was found - do not add ability to SourceUnit for this tactical battle.
	return false;
}
//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIFacilityStaffContainer_AWC_LW.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Staff container override for LW AWC Training Staff Slot. 
//----------------------------------------------------------------------------

class UIFacilityStaffContainer_AWC_LW extends UIFacilityStaffContainer;

simulated function UIStaffContainer InitStaffContainer(optional name InitName, optional string NewTitle = DefaultStaffTitle)
{
	return super.InitStaffContainer(InitName, NewTitle);
}

simulated function Refresh(StateObjectReference LocationRef, delegate<UIStaffSlot.OnStaffUpdated> onStaffUpdatedDelegate)
{
	local int i;
	local XComGameState_FacilityXCom Facility;

	Facility = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(LocationRef.ObjectID));

	// Show or create slots for the currently requested facility
	for (i = 0; i < Facility.StaffSlots.Length; i++)
	{
		// If the staff slot is locked and no upgrades are available, do not initialize or show the staff slot
		if (Facility.GetStaffSlot(i).IsLocked() && !Facility.CanUpgrade())
			continue;

		if (i < StaffSlots.Length)
			StaffSlots[i].UpdateData();
		else
		{
			switch (Movie.Stack.GetCurrentClass())
			{
			case class'UIFacility_TrainingCenter':
				if (Facility.GetStaffSlot(i).IsSoldierSlot())
				{
					if (i == 1)
					{
						`LOG("LW OfficerPack: ADDING ITEM UIFacility_AdvancedWarfareCenterSlot ");
						StaffSlots.AddItem(Spawn(class'UIFacility_AdvancedWarfareCenterSlot', self).InitStaffSlot(self, LocationRef, i, onStaffUpdatedDelegate));
					}
					else
					{
					`LOG("LW OfficerPack: ADDING ITEM UIFacility_AWCTrainingSlot_LW ");
						StaffSlots.AddItem(Spawn(class'UIFacility_AWCTrainingSlot_LW', self).InitStaffSlot(self, LocationRef, i, onStaffUpdatedDelegate));
					}
				}
				else
				{
					StaffSlots.AddItem(Spawn(class'UIFacility_StaffSlot', self).InitStaffSlot(self, LocationRef, i, onStaffUpdatedDelegate));
				}
				break;
			default:
				StaffSlots.AddItem(Spawn(class'UIFacility_StaffSlot', self).InitStaffSlot(self, LocationRef, i, onStaffUpdatedDelegate));
				break;
			}
		}
	}

	//Hide the box for facilities without any staffers, like the Armory, or for any facilities which have them permanently hidden. 
	if (Facility.StaffSlots.Length > 0 && !Facility.GetMyTemplate().bHideStaffSlots)
		Show();
	else
		Hide();
}

defaultproperties
{
}

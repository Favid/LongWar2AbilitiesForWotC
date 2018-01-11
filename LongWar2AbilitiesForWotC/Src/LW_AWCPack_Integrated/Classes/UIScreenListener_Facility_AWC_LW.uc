//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Academy_AWC_LW
//  AUTHOR:  Amineri
//
//  PURPOSE: Implements hooks to setup AWC Training Staff Slot 
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Facility_AWC_LW extends UIScreenListener;

var UIFacility_AWCTrainingSlot_LW Slot;
var localized string strAWCTrainButton;
var UIPersonnel PersonnelSelection;
var XComGameState_StaffSlot StaffSlot;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local int i, QueuedDropDown;
	local UIFacility_TrainingCenter ParentScreen;

	//default is no dropdown
	QueuedDropDown = -1;

	ParentScreen = UIFacility_TrainingCenter(Screen);

	//check for queued dropdown, and cache it if find one
	for(i = 0; i < ParentScreen.m_kStaffSlotContainer.StaffSlots.Length; i++)
	{
		if(ParentScreen.m_kStaffSlotContainer.StaffSlots[i].m_QueuedDropDown)
		{
			QueuedDropDown = i;
			break;
		}
	}

	ParentScreen.RealizeNavHelp();

	//Get rid of existing staff slots
	for(i = ParentScreen.m_kStaffSlotContainer.StaffSlots.Length-1; i >= 0; i--)
	{
		ParentScreen.m_kStaffSlotContainer.StaffSlots[i].Remove();
		ParentScreen.m_kStaffSlotContainer.StaffSlots[i].Destroy();
	}

	//Get rid of the existing staff slot container
	ParentScreen.m_kStaffSlotContainer.Hide();
	ParentScreen.m_kStaffSlotContainer.Destroy();

	//Create the new staff slot container that correctly handles the second soldier AWC training slot
	ParentScreen.m_kStaffSlotContainer = ParentScreen.Spawn(class'UIFacilityStaffContainer_AWC_LW', ParentScreen);
	ParentScreen.m_kStaffSlotContainer.InitStaffContainer();
	ParentScreen.m_kStaffSlotContainer.SetMessage("");
	ParentScreen.RealizeStaffSlots();

	//re-queue the dropdown if there was one
	if(QueuedDropDown >= 0)
	{
		ParentScreen.ClickStaffSlot(QueuedDropDown);
	}
}

// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen)
{
	UIFacility_TrainingCenter(Screen).m_kStaffSlotContainer.Show();
}
// This event is triggered after a screen loses focus
event OnLoseFocus(UIScreen Screen)
{
	UIFacility_TrainingCenter(Screen).m_kStaffSlotContainer.Hide();
}

simulated function OnSoldierSelected(StateObjectReference _UnitRef)
{
	local UIArmory_AWCExpandedPromotion_LW PromotionScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	PromotionScreen = UIArmory_AWCExpandedPromotion_LW(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_AWCExpandedPromotion_LW', HQPres), HQPres.Get3DMovie()));
	PromotionScreen.InitPromotion(_UnitRef, false);
	PromotionScreen.CreateSoldierPawn();
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIFacility_TrainingCenter;
}
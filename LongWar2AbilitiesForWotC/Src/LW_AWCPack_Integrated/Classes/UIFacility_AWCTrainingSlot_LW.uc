//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_AWCTrainingSlot_LW.uc
//  AUTHOR:  Amineri
//           
//  PURPOSE: Reworked UIFacility_StaffSlot for AWC training functionality
//---------------------------------------------------------------------------------------

class UIFacility_AWCTrainingSlot_LW extends UIFacility_StaffSlot
	dependson(UIPersonnel);

var localized string m_strTrainAWCDialogTitle;
var localized string m_strTrainAWCDialogText;
var localized string m_strStopTrainAWCDialogTitle;
var localized string m_strStopTrainAWCDialogText;
var localized string m_strNoSoldiersTooltip;
var localized string m_strSoldiersAvailableTooltip;
var localized string m_strNeedsUpgradeTooltip;

simulated function UIStaffSlot InitStaffSlot(UIStaffContainer OwningContainer, StateObjectReference LocationRef, int SlotIndex, delegate<OnStaffUpdated> onStaffUpdatedDel)
{
	local int TooltipID;

	super.InitStaffSlot(OwningContainer, LocationRef, SlotIndex, onStaffUpdatedDel);

	TooltipID = Movie.Pres.m_kTooltipMgr.AddNewTooltipTextBox(m_strNoSoldiersTooltip, 0, 0, string(MCPath), , , , true);
	Movie.Pres.m_kTooltipMgr.TextTooltip.SetMouseDelegates(TooltipID, RefreshTooltip);

	return self;
}
//-----------------------------------------------------------------------------
simulated function OnClickStaffSlot(UIPanel kControl, int cmd)
{
	local XComGameState_StaffSlot StaffSlot;
	local XComGameState_Unit UnitState;
	//local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectTrainAWC_LW TrainProject;
	local string StopTrainingText;

	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP_DELAYED:
		if (StaffSlot.IsLocked())
		{
			ShowUpgradeFacility();
		}
		else if (StaffSlot.IsSlotEmpty())
		{
			OnAWCTrainSelected();
		}
		else // Ask the user to confirm that they want to empty the slot and stop training
		{
			//XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
			UnitState = StaffSlot.GetAssignedStaff();
			TrainProject = class'X2StrategyElement_AWC_TrainingStaffSlot_LW'.static.GetAWCTrainingProject(UnitState.GetReference(), StaffSlot);

			StopTrainingText = m_strStopTrainAWCDialogText;
			StopTrainingText = Repl(StopTrainingText, "%UNITNAME", UnitState.GetName(eNameType_RankFull));
			StopTrainingText = Repl(StopTrainingText, "%CLASSNAME", TrainProject.GetTrainingAbilityFriendlyName());

			ConfirmEmptyProjectSlotPopup(m_strStopTrainAWCDialogTitle, StopTrainingText);
		}
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_RELEASE_OUTSIDE:
		if(!StaffSlot.IsLocked())
		{
			StaffContainer.HideDropDown(self);
		}
		break;
	}
}


simulated function QueueDropDownDisplay()
{
	OnClickStaffSlot(none, class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP);
}

simulated function OnAWCTrainSelected()
{
	local TDialogueBoxData DialogData;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_CampaignSettings Settings;
	local name FlagName;
	local XComGameState NewGameState;

	FlagName = 'LWAWCPack_WarningPlayed';

	if(IsDisabled)
		return;

	XComHQ = `XCOMHQ;
	Settings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	if (!Settings.bSuppressFirstTimeNarrative && XComHQ.SeenClassMovies.Find(FlagName) == INDEX_NONE)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState ("Update AWC Training Warning Flag");
		XComHQ = XComGameState_HeadquartersXCom (NewGameState.CreateStateObject (class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject (XComHQ);
		XComHQ.SeenClassMovies.AddItem(FlagName);
		`GAMERULES.SubmitGameState (NewGameState);
		DialogData.fnCallbackEx = TrainAWCDialogCallback;

		DialogData.eType = eDialog_Alert;
		DialogData.strTitle = m_strTrainAWCDialogTitle;
		DialogData.strText = m_strTrainAWCDialogText;
		DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
		DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

		Movie.Pres.UIRaiseDialog(DialogData);
	}
	else
	{
		TrainAWCDialogCallback('eUIAction_Accept', none);
	}
}

simulated function TrainAWCDialogCallback(Name eAction, UICallbackData xUserData)
{
	local UIPersonnel_AWC_LW kPersonnelList;
	local XComHQPresentationLayer HQPres;
	local XComGameState_StaffSlot StaffSlotState;
	
	if (eAction == 'eUIAction_Accept')
	{
		HQPres = `HQPRES;
		StaffSlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

		//Don't allow clicking of Personnel List is active or if staffslot is filled
		if(HQPres.ScreenStack.IsNotInStack(class'UIPersonnel') && !StaffSlotState.IsSlotFilled())
		{
			kPersonnelList = Spawn( class'UIPersonnel_AWC_LW', HQPres);
			kPersonnelList.m_eListType = eUIPersonnel_Soldiers;
			kPersonnelList.onSelectedDelegate = OnSoldierSelected;
			kPersonnelList.m_bRemoveWhenUnitSelected = true;
			kPersonnelList.SlotRef = StaffSlotRef;
			HQPres.ScreenStack.Push( kPersonnelList );
		}
	}
}

simulated function OnSoldierSelected(StateObjectReference _UnitRef)
{
	local XComGameState_Unit Unit, UpdatedUnit;
	local XComGameState_Unit_AWC_LW AWCState;
	local XComGameState NewGameState;
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(_UnitRef.ObjectID));

	if (class'LWAWCUtilities'.static.GetAWCComponent(Unit) == none)
	{
		//Create the AWC Component and fill out the randomized ability progression
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("AWC States cleanup");
		UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
		NewGameState.AddStateObject(UpdatedUnit);
		AWCState = XComGameState_Unit_AWC_LW(NewGameState.CreateStateObject(class'XComGameState_Unit_AWC_LW'));
		NewGameState.AddStateObject(AWCState);

		UpdatedUnit.AddComponentObject(AWCState);
		AWCState.ChooseSoldierAWCOptions(UpdatedUnit);

		`GAMERULES.SubmitGameState(NewGameState);
	}

	//invoke the selection UI
	class'LWAWCUtilities'.static.UIChooseAWCAbility(Unit.GetReference(), StaffSlotRef);
}

simulated function UpdateData()
{
	local XComGameState_StaffSlot StaffSlot;
	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	super.UpdateData();
	SetDisabled(!IsUnitAvailableForThisSlot() && !StaffSlot.IsLocked());
}

simulated function bool IsUnitAvailableForThisSlot()
{
	local int i;
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;
	local XComGameState_StaffSlot SlotState;
	local StaffUnitInfo UnitInfo;
	local XComGameState_HeadquartersXCom HQState;

	History = `XCOMHISTORY;
	SlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	if (SlotState.IsSlotFilled())
	{
		return true;
	}

	HQState = class'UIUtilities_Strategy'.static.GetXComHQ();
	for (i = 0; i < HQState.Crew.Length; i++)
	{
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(HQState.Crew[i].ObjectID));
		UnitInfo.UnitRef = Unit.GetReference();

		if (SlotState.ValidUnitForSlot(UnitInfo))
		{
			return true;
		}
	}
	return false;
}

simulated function RefreshTooltip(UITooltip Tooltip)
{
	local XComGameState_StaffSlot StaffSlot;
	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	if (StaffSlot.IsLocked())
		UITextTooltip(Tooltip).SetText(m_strNeedsUpgradeTooltip);
	else if (IsUnitAvailableForThisSlot())
		UITextTooltip(Tooltip).SetText(m_strSoldiersAvailableTooltip);
	else
		UITextTooltip(Tooltip).SetText(m_strNoSoldiersTooltip);
}
//==============================================================================

defaultproperties
{
	width = 370;
	height = 65;
}

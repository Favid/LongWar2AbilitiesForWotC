//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_PersonnelSquadSelect_LWOfficerPack
//  AUTHOR:  Amineri
//
//  PURPOSE: Dynamically replaces UIPersonnel_SquadSelect (only when Toolbox or some other mod that replaces it isn't present)
//--------------------------------------------------------------------------------------- 

class UIScreenListener_PersonnelSquadSelect_LWOfficerPack extends UIScreenListener;

//var UISquadSelect ParentScreen;

var localized string strAutoFillLabel;
var localized string strAutoFillTooltip;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local XComHQPresentationLayer HQPres;
	local array<X2DownloadableContentInfo> DLCInfos;
	local int i;
	local XComOnlineEventMgr EventManager;
	local UIPersonnel_SquadSelect OldPersonnelList;
	local UIPersonnel_SquadSelect_LWOfficerPack NewPersonnelList;

	// we only need to replace when not running Toolbox, since it includes TriggerEvents which OfficerPack uses for officer-related info/restrictions
	EventManager = `ONLINEEVENTMGR;
	DLCInfos = EventManager.GetDLCInfos(false);
	for(i = 0; i < DLCInfos.Length; ++i)
	{
		if(DLCInfos[i].DLCIdentifier == "LW_Toolbox")
		{
			return;
		}
	}

	OldPersonnelList = UIPersonnel_SquadSelect(Screen);
	if (OldPersonnelList == none)
		return;

	HQPres = `HQPRES;
	if(HQPres.ScreenStack.IsNotInStack(class'UIPersonnel_SquadSelect_LWOfficerPack'))
	{
		NewPersonnelList = HQPres.Spawn( class'UIPersonnel_SquadSelect_LWOfficerPack', HQPres );
		NewPersonnelList.onSelectedDelegate = OldPersonnelList.onSelectedDelegate;
		NewPersonnelList.GameState = OldPersonnelList.GameState;
		NewPersonnelList.HQState = OldPersonnelList.HQState;

		HQPres.ScreenStack.Push(NewPersonnelList);
		HQPres.ScreenStack.Pop(OldPersonnelList);
	}

}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIPersonnel_SquadSelect;
}
//---------------------------------------------------------------------------------------
//  FILE:    UIPersonnel_SquadSelect_LWOfficerPack.uc
//  AUTHOR:  Amineri (Long War Studios)
//  PURPOSE: Provides custom behavior for personnel selection screen when
//           selecting soldiers to take on a mission.
//			 Extends functionality to prevent more than one officer from being selected.
//--------------------------------------------------------------------------------------- 
class UIPersonnel_ListItem_SquadSelect_LWOfficerPack extends UIPersonnel_SoldierListItem;

var localized string strOfficerAlreadySelectedStatus;

var UIICon OfficerIcon;

//override in order to retrieve custom status string for 2nd+ officers
simulated function UpdateData()
{
	local XComGameState_Unit Unit;
	local string UnitLoc, status, statusTimeLabel, statusTimeValue, classIcon, rankIcon, flagIcon, mentalStatus;	
	local int iRank, iTimeNum;
	local X2SoldierClassTemplate SoldierClass;
	local XComGameState_ResistanceFaction FactionState;
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;
	local XComGameState_Unit Bondmate;
	local int BondLevel;
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	iRank = Unit.GetRank();

	SoldierClass = Unit.GetSoldierClassTemplate();
	FactionState = Unit.GetResistanceFaction();

	//this is the new code here
	GetPersonnelStatusWithOfficer(Unit, status, statusTimeLabel, statusTimeValue);
	mentalStatus = "";

	if(Unit.IsActive())
	{
		Unit.GetMentalStateStringsSeparate(mentalStatus, statusTimeLabel, iTimeNum);
		statusTimeLabel = class'UIUtilities_Text'.static.GetColoredText(statusTimeLabel, Unit.GetMentalStateUIState());

		if(iTimeNum == 0)
		{
			statusTimeValue = "";
		}
		else
		{
			statusTimeValue = class'UIUtilities_Text'.static.GetColoredText(string(iTimeNum), Unit.GetMentalStateUIState());
		}
	}


	if( statusTimeValue == "" )
		statusTimeValue = "---";

	flagIcon = Unit.GetCountryTemplate().FlagImage;
	rankIcon = class'UIUtilities_Image'.static.GetRankIcon(iRank, SoldierClass.DataName);
	classIcon = SoldierClass.IconImage;

	// if personnel is not staffed, don't show location
	if( class'UIUtilities_Strategy'.static.DisplayLocation(Unit) )
		UnitLoc = class'UIUtilities_Strategy'.static.GetPersonnelLocation(Unit);
	else
		UnitLoc = "";

	if( BondIcon == none )
	{
		BondIcon = Spawn(class'UIBondIcon', self);
		if( `ISCONTROLLERACTIVE ) 
			BondIcon.bIsNavigable = false; 
	}
	
	if( Unit.HasSoldierBond(BondmateRef, BondData) )
	{
		Bondmate = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BondmateRef.ObjectID));
		BondLevel = BondData.BondLevel;
		if( !BondIcon.bIsInited )
		{
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondData.Bondmate);
		}
		BondIcon.Show();
		SetTooltipText(Repl(BondmateTooltip, "%SOLDIERNAME", Caps(Bondmate.GetName(eNameType_RankFull))));
		Movie.Pres.m_kTooltipMgr.TextTooltip.SetUsePartialPath(CachedTooltipID, true);
	}
	else if( Unit.ShowBondAvailableIcon(BondmateRef, BondData) )
	{
		BondLevel = BondData.BondLevel;
		if( !BondIcon.bIsInited )
		{
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondmateRef);
		}
		BondIcon.Show();
		BondIcon.AnimateCohesion(true);
		SetTooltipText(class'XComHQPresentationLayer'.default.m_strBannerBondAvailable);
		Movie.Pres.m_kTooltipMgr.TextTooltip.SetUsePartialPath(CachedTooltipID, true);
	}
	else
	{
		if( !BondIcon.bIsInited )
		{
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondData.Bondmate);
		}
		BondIcon.Hide();
		BondLevel = -1; 
	}

	AS_UpdateDataSoldier(Caps(Unit.GetName(eNameType_Full)),
					Caps(Unit.GetName(eNameType_Nick)),
					Caps(`GET_RANK_ABBRV(Unit.GetRank(), SoldierClass.DataName)),
					rankIcon,
					Caps(SoldierClass != None ? SoldierClass.DisplayName : ""),
					classIcon,
					status,
					statusTimeValue $"\n" $ Class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Class'UIUtilities_Text'.static.GetSizedText( statusTimeLabel, 12)),
					UnitLoc,
					flagIcon,
					false, 
					(Unit.ShowPromoteIcon()),
					false,
					mentalStatus,
					BondLevel ); // BondLevel added. Does BondLevel need to be scoped to something? superclass implies not
					
	AS_SetFactionIcon(FactionState.GetFactionIcon());
	AddGenericOfficerIcon(Unit);
}

//helper to add generic officer icon
simulated function AddGenericOfficerIcon(XComGameState_Unit Unit)
{

	if (class'LWOfficerUtilities'.static.IsOfficer(Unit))
	{
		if (OfficerIcon == none) 
		{
			OfficerIcon = Spawn(class'UIIcon', self).InitIcon('abilityIcon1MC', class'LWOfficerUtilities'.static.GetGenericIcon(), false, true, 18);
		} else {
			OfficerIcon.Show();
		}
		OfficerIcon.OriginTopLeft();
		OfficerIcon.SetPosition(101, 24);
	} else {
		if (OfficerIcon != none)
		{
			OfficerIcon.Hide();
		}
	}
}

//intercepts the base game call to GetPersonnelStatusSeparate to insert custom status if unit is officer and squad already has one
static function GetPersonnelStatusWithOfficer(XComGameState_Unit Unit, out string Status, out string TimeLabel, out string TimeValue, optional int MyFontSize = -1)
{
	local bool bUnitInSquad, bAllowWoundedSoldiers;
	local GeneratedMissionData MissionData;
	local XComGameState_HeadquartersXCom HQState;

	HQState = `XCOMHQ;

	bUnitInSquad = HQState.IsUnitInSquad(Unit.GetReference());

	MissionData = HQState.GetGeneratedMissionData(HQState.MissionRef.ObjectID);
	bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;

	if (!bUnitInSquad && class'LWOfficerUtilities'.static.IsOfficer(Unit) && class'LWOfficerUtilities'.static.HasOfficerInSquad() && !bAllowWoundedSoldiers)
	{
		Status = class'UIUtilities_Text'.static.GetColoredText(default.strOfficerAlreadySelectedStatus, eUIState_Bad, MyFontSize);
		TimeLabel = class'UIUtilities_Text'.static.GetColoredText(TimeLabel, eUIState_Bad, MyFontSize);
		TimeValue = "";
		return;
	}
	class'UIUtilities_Strategy'.static.GetPersonnelStatusSeparate(Unit, Status, TimeLabel, TimeValue, MyFontSize);
}
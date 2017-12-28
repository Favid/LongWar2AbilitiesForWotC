# X2LongWarOfTheChosen
X2LongWarOfTheChosen is a team dedicated to porting Pavonis Interactive's
original LW work.

## Perk Pack
The perk pack is a port of the abilities and classes from Long War 2, originally designed and implemented by PI.
# What version are we at?  
The release version of LongWar2AbilitiesForWotC/WeaponsPack is 0.0.6  
The working version of LongWar2AbilitiesForWotC/WeaponsPack is 0.0.7

# The Job List
* Complete issues

# Setting up the development environment
ModBuddy is the mod development tool used for xcom 2 mods. Follow the tutorial
provided here https://www.reddit.com/r/xcom2mods/wiki/firsttime . There are a
number of other fantastic resources available here
https://www.reddit.com/r/xcom2mods/wiki/index

To start working on the codebase:   
    + Fork and clone this repository.  
    + Run `git remote add upstream https://github.com/X2LongWarOfTheChosen/LongWar2AbilitiesForWotC.git`.   
    + Verify that everything is set up properly by typing `git remote -v` which should produce output the same as the following but with your GitHub username in place:  
```
  origin   https://github.com/YourUsername/LongWar2AbilitiesForWotC.git (fetch)
  origin   https://github.com/YourUsername/LongWar2AbilitiesForWotC.git (push)
  upstream https://github.com/X2LongWarOfTheChosen/LongWar2AbilitiesForWotC.git (fetch)
  upstream https://github.com/X2LongWarOfTheChosen/LongWar2AbilitiesForWotC.git (push)
```

# Contributing
Due to the large number of people working on this project, it is important to
ensure consistent coding standards. If you don't want your changes to get stuck
in PR hell, please do all of the following

## When contributing, please
### Use the development branch
The development branch will be the primary branch that work is done from. If you are completing an issue, commit to either development, or a new branch off of development.

### Master branch is reservered for releases
Do not commit to the Master branch. Ever. It is reservered for Steam Workshop releases only. When a release is to be performed, merge the work that is to be included in the release to Master, and then continue future work off of the development branch.

### One change at a time
If you start working on unrelated tickets, there should be a unique PR for each
of them. In order to do this it's recommended that you create a unique branch
off the head of dev for each ticket you work on. When that is done submit a PR to
the X2LongWarOfTheChosen repo, comparing your branch to the master branch.

### Follow coding style
* use the code style that is generally used in the XCOM 2 codebase:
  * Use spaces, not tabs
  * Use new lines for braces
  * Use appropriate spacing, watch out whitespace changes on unrelated lines
  * Use braces even for one-line if/else bodies

The following code should illustrate all of this:
```
    static function CompleteStrategyFromTacticalTransfer()
    {
        local XComOnlineEventMgr EventManager;
        local array<X2DownloadableContentInfo> DLCInfos;
        local int i;

        UpdateSkyranger();
        CleanupProxyVips();
        ProcessMissionResults();
        SquadTacticalToStrategyTransfer();

        EventManager = `ONLINEEVENTMGR;
        DLCInfos = EventManager.GetDLCInfos(false);
        for (i = 0; i < DLCInfos.Length; ++i)
        {
            DLCInfos[i].OnPostMission();
        }
    }
```

# Troubleshooting
For any troubleshooting direct your questions to any of the senior devs on the
discord.

thanks to the X2CommunityHighlander for the readme inspiration
// note: versions prior to v1.10.2020.11.4 require Hot Coffee Mod to work
state("Superliminal", "2019")
{
    // the current level number (1 for induction, 9 for retrospect, 255 for main menu and loading screens)
    byte levelID : 0xb00b1e5;

    // true during loading screens
    bool isLoading : 0xb00b1e6;

    // true whenever any alarm clock is clicked, set back to false when entering a level
    bool alarmStopped : "fmodstudio.dll", 0x2b3cf0, 0x28, 0x18, 0x170, 0xe8, 0x28, 0x80, 0x18;
}

// duplicate state matching the Steam process name
state("SuperliminalSteam", "2019")
{
    byte levelID : 0xb00b1e5;
    bool isLoading : 0xb00b1e6;
    bool alarmStopped : "fmodstudio.dll", 0x2b3cf0, 0x28, 0x18, 0x170, 0xe8, 0x28, 0x80, 0x18;
}

// starting from v1.10.2020.11.4, the game has a speedrun timer, so we can read it directly
state("Superliminal", "2020")
{
    // the number of seconds elapsed after entering induction
    double timer : "UnityPlayer.dll", 0x168ee90, 0x8, 0xa0, 0x188, 0x118;

    // true whenever any alarm clock is clicked, set back to false when entering a level
    bool alarmStopped : "fmodstudio.dll", 0x2b3cf0, 0x28, 0x18, 0x170, 0x100, 0x28, 0x80, 0x18;

    // the camera position
    uint xPos : "UnityPlayer.dll", 0x168ec88, 0x78, 0x78, 0x60, 0x30, 0x8, 0x840, 0xd8;
    uint yPos : "UnityPlayer.dll", 0x168ec88, 0x78, 0x78, 0x60, 0x30, 0x8, 0x840, 0xdc;
    uint zPos : "UnityPlayer.dll", 0x168ec88, 0x78, 0x78, 0x60, 0x30, 0x8, 0x840, 0xe0;
}

// duplicate state matching the Steam process name
state("SuperliminalSteam", "2020")
{
    double timer : "UnityPlayer.dll", 0x168ee90, 0x8, 0xa0, 0x188, 0x118;
    bool alarmStopped : "fmodstudio.dll", 0x2b3cf0, 0x28, 0x18, 0x170, 0x100, 0x28, 0x80, 0x18;
    uint xPos : "UnityPlayer.dll", 0x168ec88, 0x78, 0x78, 0x60, 0x30, 0x8, 0x840, 0xd8;
    uint yPos : "UnityPlayer.dll", 0x168ec88, 0x78, 0x78, 0x60, 0x30, 0x8, 0x840, 0xdc;
    uint zPos : "UnityPlayer.dll", 0x168ec88, 0x78, 0x78, 0x60, 0x30, 0x8, 0x840, 0xe0;
}

// updated for version 1.10.2020.12.10
state("Superliminal", "2021")
{
    // the number of seconds elapsed after entering induction
    double timer : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0x128;

    // the pointer to the name of the checkpoint
    // Note: the pointer might be null in main menu / loading screen
    //       hence we use a pointer instead.
    long checkpointNamePtr : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0xb0;

    // true whenever any alarm clock is clicked, set back to false when entering a level
    bool alarmStopped : "fmodstudio.dll", 0x2b3cf0, 0x28, 0x18, 0x170, 0x100, 0x28, 0x80, 0x18;

    // the active scene filename
    string255 scene : "UnityPlayer.dll", 0x180b4f8, 0x48, 0x10, 0x0;
}

// duplicate state matching the Steam process name
state("SuperliminalSteam", "2021")
{
    double timer : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0x128;
    long checkpointNamePtr : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0xb0;
    bool alarmStopped : "fmodstudio.dll", 0x2b3cf0, 0x28, 0x18, 0x170, 0x100, 0x28, 0x80, 0x18;
    string255 scene : "UnityPlayer.dll", 0x180b4f8, 0x48, 0x10, 0x0;
}

startup
{
    settings.Add("il", false, "Individual Level");
    settings.SetToolTip("il", "Only works with game version 2021");

    settings.Add("split_on_cp", false, "Split on checkpoints (use with subsplits for CPs)");
    settings.SetToolTip("split_on_cp", "Only works with game version 2021");
}

init
{
    // check size of UnityPlayer.dll to determine version
    if (modules[4].ModuleMemorySize == 25210880)
    {
        print("Using Hot Coffee Mod");
        version = "2019";
    }
    else if (modules[4].ModuleMemorySize == 25563136)
    {
        print("Using in-game speedrun timer");
        version = "2020";
    }
    else // 26861568 or 589824
    {
        print("Using scene filename and in-game speedrun timer");
        version = "2021";

        // true when the active scene is a level
        // this is required because the 'scene' pointer seems to
        // be invalid for a few frames when entering a new scene
        vars.inLevel = false;

        // the name of the checkpoint, 
        //   corresponding to current.checkpointNamePtr
        //                    and old.checkpointNamePtr
        vars.cp_name = "";
        vars.old_cp_name = "";

        if(settings["split_on_cp"]) {
            vars.split_on_cp = true;
            print("Splitting on checkpoints");
        }
    }

    if (vars.il = settings["il"])
        print("Timing individual level");
}

update
{
    if (version == "2019")
    {
        current.levelID = memory.ReadValue<byte>(new IntPtr(0xb00b1e5));
        current.isLoading = memory.ReadValue<bool>(new IntPtr(0xb00b1e6));
    }
    else if (version == "2021")
    {
        const string LevelPrefix = "Assets/_Levels/_LiveFolder/ACT";
        if (!vars.inLevel && current.scene != null && current.scene.StartsWith(LevelPrefix))
            vars.inLevel = true;
        
        vars.split_on_cp = settings["split_on_cp"];

        vars.old_cp_name = vars.cp_name;
        if(current.checkpointNamePtr != 0 && current.checkpointNamePtr != old.checkpointNamePtr) {
            vars.cp_name = memory.ReadString((IntPtr)(current.checkpointNamePtr + 0x14), 256);
        }
    }

    if (settings["il"])
    {
        // use regular timing method for Induction and for older game versions
        const string Induction = "Assets/_Levels/_LiveFolder/ACT01/TestChamber/TestChamber_Live.unity";
        vars.il = version == "2021" && current.scene != Induction;
    }
}

gameTime
{
    if (version != "2019" && !vars.il)
        return TimeSpan.FromSeconds(current.timer);

    return null;
}

isLoading
{
    bool loading = false;

    if (vars.il)
        loading = false;

    else if (version == "2019")
        loading = current.isLoading;

    else
        loading = old.timer == current.timer;

    return loading;
}

start
{
    bool startedInduction = false;

    if (vars.il)
    {
        const string LevelPrefix = "Assets/_Levels/_LiveFolder/ACT";
        bool inLevel = current.scene != null && current.scene.StartsWith(LevelPrefix);
        startedInduction = inLevel && current.scene != old.scene;
    }

    else if (version == "2019")
        startedInduction = current.levelID == 1 && current.levelID != old.levelID;

    else
        startedInduction = current.timer > 0 && old.timer != current.timer;

    return startedInduction;
}

reset
{
    bool inMainMenu = false;
    bool enteredInduction = false;

    if (version == "2019")
        enteredInduction = current.levelID == 1 && current.levelID != old.levelID;

    else
    {
        enteredInduction = old.timer != current.timer && (current.timer < old.timer || old.timer == 0);

        if (version == "2020")
        {
            // pos = [0.04, 1, -10] in main menu
            inMainMenu =
                current.xPos == old.xPos && current.xPos == 0x3d23d70a
                && current.yPos == old.yPos && current.yPos == 0x3f800000
                && current.zPos == old.zPos && current.zPos == 0xc1200000;
        }
        else
        {
            const string Menu = "Assets/_Levels/_LiveFolder/Misc/StartScreen_Live.unity";
            inMainMenu = current.scene != old.scene && current.scene == Menu;
        }
    }

    return inMainMenu || enteredInduction;
}

split
{
    bool enteredNextLevel = false;
    bool finalAlarmClicked = false;
    bool checkpointUpdated = false;

    if (version == "2019")
    {
        enteredNextLevel = !current.isLoading
            && current.levelID != old.levelID
            && current.levelID != 255;

        finalAlarmClicked = !current.isLoading
            && current.levelID == 9 && current.alarmStopped;
    }

    else if (version == "2020")
    {
        // pos = [0, 0, 0] during loading screens
        enteredNextLevel =
               current.xPos != old.xPos && current.xPos == 0
            && current.yPos != old.yPos && current.yPos == 0
            && current.zPos != old.zPos && current.zPos == 0;
        finalAlarmClicked = timer.CurrentSplitIndex == 8 && current.alarmStopped;
    }

    else if (version == "2021")
    {
        if (current.scene != null)
        {
            const string LoadingScenesPrefix = "Assets/_Levels/_LiveFolder/Misc/LoadingScenes/";
            if (vars.inLevel && current.scene.StartsWith(LoadingScenesPrefix))
            {
                vars.inLevel = false;
                enteredNextLevel = true;
            }

            const string Retrospect = "Assets/_Levels/_LiveFolder/ACT03/EndingMontage/EndingMontage_Live.unity";
            finalAlarmClicked = current.scene == Retrospect && current.alarmStopped;

            if (vars.split_on_cp
                && vars.inLevel 
                && current.checkpointNamePtr != 0 
                && !vars.cp_name.Equals(vars.old_cp_name)
                && !vars.cp_name.Equals("")) {
                checkpointUpdated = true;
            }
        }
    }

    return enteredNextLevel || finalAlarmClicked || checkpointUpdated;
}

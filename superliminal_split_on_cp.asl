state("Superliminal", "2021")
{
    // the number of seconds elapsed after entering induction
    double timer : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0x128;
    string255 cpname : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0xb0, 0x14;
    long cpname_ptr : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0xb0;

    // true whenever any alarm clock is clicked, set back to false when entering a level
    bool alarmStopped : "fmodstudio.dll", 0x2b3cf0, 0x28, 0x18, 0x170, 0x100, 0x28, 0x80, 0x18;

    // the active scene filename
    string255 scene : "UnityPlayer.dll", 0x180b4f8, 0x48, 0x10, 0x0;
}

state("SuperliminalSteam", "2021")
{
    double timer : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0x128;
    string255 cpname : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0xb0, 0x14;
    long cpname_ptr : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0xb0;
    bool alarmStopped : "fmodstudio.dll", 0x2b3cf0, 0x28, 0x18, 0x170, 0x100, 0x28, 0x80, 0x18;
    string255 scene : "UnityPlayer.dll", 0x180b4f8, 0x48, 0x10, 0x0;
}

startup
{
    settings.Add("il", false, "Individual Level");
    settings.SetToolTip("il", "Only works with game version 2021");
}

init
{
    version = "2021";

    // true when the active scene is a level
    // this is required because the 'scene' pointer seems to
    // be invalid for a few frames when entering a new scene
    vars.inLevel = false;

    vars.old_cp_name = "";
    vars.cp_name = "";

    vars.fd = new StreamWriter("C:\\Users\\etaoi\\Desktop\\1.txt", append: true);

    if (vars.il = settings["il"])
        print("Timing individual level");
}

exit {
    vars.fd.Close();
}

update
{
    vars.old_cp_name = vars.cp_name;
    if(current.cpname_ptr != 0 && current.cpname_ptr != old.cpname_ptr) {
        vars.cp_name = memory.ReadString((IntPtr)(current.cpname_ptr + 0x14), 256);
        vars.fd.WriteLine(vars.cp_name);
    }

    const string LevelPrefix = "Assets/_Levels/_LiveFolder/ACT";
    if (!vars.inLevel && current.scene != null && current.scene.StartsWith(LevelPrefix))
        vars.inLevel = true;

    if (settings["il"])
    {
        // use regular timing method for Induction and for older game versions
        const string Induction = "Assets/_Levels/_LiveFolder/ACT01/TestChamber/TestChamber_Live.unity";
        vars.il = version == "2021" && current.scene != Induction;
    }
}

gameTime
{
    return TimeSpan.FromSeconds(current.timer);
}

isLoading
{
    bool loading = false;

    if (vars.il)
        loading = false;

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

    else
        startedInduction = current.timer > 0 && old.timer != current.timer;

    return startedInduction;
}

reset
{
    bool inMainMenu = false;
    bool enteredInduction = false;

    enteredInduction = old.timer != current.timer && (current.timer < old.timer || old.timer == 0);

    const string Menu = "Assets/_Levels/_LiveFolder/Misc/StartScreen_Live.unity";
    inMainMenu = current.scene != old.scene && current.scene == Menu;

    return inMainMenu || enteredInduction;
}

split
{
    bool enteredNextLevel = false;
    bool finalAlarmClicked = false;
    bool checkpointUpdated = false;

    if (current.scene != null)
    {
        const string LoadingScenesPrefix = "Assets/_Levels/_LiveFolder/Misc/LoadingScenes/";
        if (vars.inLevel && current.scene.StartsWith(LoadingScenesPrefix))
        {
            vars.inLevel = false;
            enteredNextLevel = true;
        }

        if (vars.inLevel 
            && current.cpname_ptr != 0 
            && !vars.cp_name.Equals(vars.old_cp_name)
            && !vars.cp_name.Equals("")) {
            checkpointUpdated = true;
        }

        const string Retrospect = "Assets/_Levels/_LiveFolder/ACT03/EndingMontage/EndingMontage_Live.unity";
        finalAlarmClicked = current.scene == Retrospect && current.alarmStopped;
    }

    return enteredNextLevel || finalAlarmClicked || checkpointUpdated;
}
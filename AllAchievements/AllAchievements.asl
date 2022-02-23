state("SuperliminalSteam", "2022")
{
  double timer : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x128;
  uint achv_count : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x80, 0x10, 0x30;
  string255 scene : "UnityPlayer.dll", 0x183cf10, 0x48, 0x10, 0x0;
}

state("Superliminal", "2022")
{
  double timer : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x128;
  uint achv_count : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x80, 0x10, 0x30;
  string255 scene : "UnityPlayer.dll", 0x183cf10, 0x48, 0x10, 0x0;
}

startup
{
  settings.Add("achv21", false, "Split on getting 21st achievement");
  settings.SetToolTip("achv21", "");
  settings.Add("achv22", false, "Split on getting 22nd achievement");
  settings.SetToolTip("achv22", "");
  settings.Add("achv23", false, "Split on getting 23rd achievement");
  settings.SetToolTip("achv23", "");
}

init
{
  version = "2022";
}

start
{
  const string Menu = "Assets/_Levels/_LiveFolder/Misc/StartScreen_Live.unity";
  return !current.scene.StartsWith(Menu);
}

update
{
}

isLoading
{
  const string LoadingScenesPrefix = "Assets/_Levels/_LiveFolder/Misc/LoadingScenes/";
  return current.scene.StartsWith(LoadingScenesPrefix);
}

split
{
  if (old.achv_count != current.achv_count) {
    return 
      (settings["achv21"] && current.achv_count == 21) ||
      (settings["achv22"] && current.achv_count == 22) ||
      (settings["achv23"] && current.achv_count == 23);
  }
  return false;
}

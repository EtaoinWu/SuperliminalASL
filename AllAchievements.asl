// duplicate state matching the Steam process name
state("SuperliminalSteam", "2021")
{
  double timer : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0x128;
  uint achv_count : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0x80, 0x10, 0x30;
  string255 scene : "UnityPlayer.dll", 0x180b4f8, 0x48, 0x10, 0x0;
}

startup
{
}

init
{
  print("Using scene filename and in-game speedrun timer");
  version = "2021x";
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
    return current.achv_count >= 21 || current.achv_count == 1;
  }
  return false;
  // return current.achv_count > old.achv_count;
}

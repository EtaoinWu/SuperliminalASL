// duplicate state matching the Steam process name
state("SuperliminalSteam", "2021")
{
  double timer : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0x128;
  uint achv_count : "UnityPlayer.dll", 0x17c8588, 0x8, 0xb0, 0x28, 0x80, 0x10, 0x30;
  string255 scene : "UnityPlayer.dll", 0x180b4f8, 0x48, 0x10, 0x0;

  float vague120 : "UnityPlayer.dll", 0x017C8358, 0xA8, 0xD8, 0x110, 0x30, 0xA8, 0x28, 0x40;
  float vague15 : "UnityPlayer.dll", 0x017C8358, 0xA8, 0xD8, 0x110, 0x30, 0xA8, 0x28, 0x44;
  float vague30 : "UnityPlayer.dll", 0x017C8358, 0xA8, 0xD8, 0x110, 0x30, 0xA8, 0x28, 0x48;
  uint vague_state : "UnityPlayer.dll", 0x017C8358, 0xA8, 0xD8, 0x110, 0x30, 0xA8, 0x28, 0x4c;
}

startup
{
}

init
{
  print("Using scene filename and in-game speedrun timer");
  version = "2021x";
  vars.vague_ok = false;
}

start
{
  const string Menu = "Assets/_Levels/_LiveFolder/Misc/StartScreen_Live.unity";
  return !current.scene.StartsWith(Menu);
}

update
{
  vars.vague_ok = 
    Math.Abs(current.vague120 - 120.0) < 1.0e-9 &&
    Math.Abs(current.vague15 - 15.0) < 1.0e-9 &&
    Math.Abs(current.vague30 - 30.0) < 1.0e-9 &&
    (current.vague_state == 1 || current.vague_state == 2 || current.vague_state == 3);
}

isLoading
{
  const string LoadingScenesPrefix = "Assets/_Levels/_LiveFolder/Misc/LoadingScenes/";
  return current.scene.StartsWith(LoadingScenesPrefix);
}

split
{
  if (vars.vague_ok) {
    if (old.vague_state != current.vague_state 
      && current.vague_state >= 2) {
      return true;
    }
  }

  if (old.achv_count != current.achv_count) {
    return current.achv_count >= 21;
  }
  return false;
  // return current.achv_count > old.achv_count;
}

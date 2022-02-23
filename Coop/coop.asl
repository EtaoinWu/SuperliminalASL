state("SuperliminalSteam", "coop")
{
  // <some global object>.getComponent<MultiplayerMode>().LevelInfo
  ulong levelInfo : "UnityPlayer.dll", 0x17f9d28, 0x8, 0x1A0, 0x28, 0x50;
  // <some global object>.getComponent<MultiplayerMode>().LevelInfo.gameObject.getComponent<MultiplayerEndOfLevelLogic>.EndOfLevelState
  uint EOLState : "UnityPlayer.dll", 0x17f9d28, 0x8, 0x1A0, 0x28, 0x50, 0x10, 0x30, 0x30, 0x58, 0x28, 0x3c;
  // <some global object>.getComponent<GameManager>().player
  ulong player : "UnityPlayer.dll", 0x17f9d28, 0x8, 0x60, 0x28, 0x28;

  bool alarmStopped : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x141;
  string255 scene : "UnityPlayer.dll", 0x183cf10, 0x48, 0x10, 0x0;
}

startup
{
  version = "coop";
}

init
{
  vars.MPPlayer = (IntPtr)0;
  vars.MPHud = (IntPtr)0;
  vars.playedDing = false;
  
  vars.inLevel = false;
  vars.printed = 50;
}

update
{
  vars.printed -= 1;
  vars.printing = false;
  if (vars.printed == 0) {
    vars.printing = true;
    vars.printed = 300;
  }

  vars.old_MPPlayer = vars.MPPlayer;
  vars.old_MPHud = vars.MPHud;
  vars.old_playedDing = vars.playedDing;

  vars.Player = (IntPtr)current.player;
  vars.MPLevelInfo = (IntPtr)current.levelInfo;
  IntPtr PlayerInternal = new DeepPointer(vars.Player + 0x10).Deref<IntPtr>(game);
  int nComponent = new DeepPointer(PlayerInternal + 0x40).Deref<int>(game);
  vars.MPPlayer = (IntPtr)0;

  for (int i = 0; i < nComponent; i++) {
    IntPtr likelyMPPlayer =
      new DeepPointer(PlayerInternal + 0x30, 0x8 + i * 0x10, 0x28)
      .Deref<IntPtr>(game);
    bool levelInfoMatch = new DeepPointer(likelyMPPlayer + 0xd8)
      .Deref<IntPtr>(game) == vars.MPLevelInfo;
    bool myPlayerMatch = new DeepPointer(likelyMPPlayer + 0x80)
      .Deref<IntPtr>(game) == vars.Player;
    if (levelInfoMatch && myPlayerMatch) {
      vars.MPPlayer = likelyMPPlayer;
    }
  }

  vars.MPHud = new DeepPointer(vars.MPPlayer + 0x90, 0x10, 0x30, 0x18, 0x28)
    .Deref<IntPtr>(game);
  vars.playedDing = new DeepPointer(vars.MPHud + 0x139).Deref<bool>(game);
}

isLoading
{
  // Players haven't loaded yet
  if (vars.playedDing == false) {
    return true;
  }
  // Level has ended
  if (current.EOLState == 3 || current.EOLState == 4) {
    return true;
  }
  return false;
}

start
{
  const string LevelPrefix = "Assets/_Levels/_LiveFolder/ACT";
  vars.inLevel = current.scene != null && current.scene.StartsWith(LevelPrefix);
  if (vars.inLevel && vars.playedDing) {
    vars.last_scene = current.scene;
    return true;
  }
  return false;
}

reset
{
  const string Lobby = "Assets/_Levels/_LiveFolder/Multiplayer/MPLobby.unity";
  const string Menu = "Assets/_Levels/_LiveFolder/Misc/StartScreen_Live.unity";
  if (current.scene == Lobby || current.scene == Menu) {
    vars.inLevel = false;
    return true;
  }
  return false;
}

split
{
  // If we're in a level, and we've just finished a level,
  const string LevelPrefix = "Assets/_Levels/_LiveFolder/ACT";
  if (current.scene != null 
    && current.scene.StartsWith(LevelPrefix) 
    && current.scene != vars.last_scene) {
    vars.last_scene = current.scene;
    return true;
  }
  // Final alarm clicked
  const string Retrospect = "Assets/_Levels/_LiveFolder/ACT03/EndingMontage/EndingMontage_Live.unity";
  if (current.scene == Retrospect && current.alarmStopped) {
    return true;
  }
  return false;
}

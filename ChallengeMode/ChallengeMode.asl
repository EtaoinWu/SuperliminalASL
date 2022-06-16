state("SuperliminalSteam", "2022")
{
  double timer : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x130;
  string255 scene : "UnityPlayer.dll", 0x183cf10, 0x48, 0x10, 0x0;
  int mini_challenge_chapter_count : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x90, 0x10, 0x40;
}

// Let's just assume that these will work...
state("Superliminal", "2022")
{
  double timer : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x130;
  string255 scene : "UnityPlayer.dll", 0x183cf10, 0x48, 0x10, 0x0;
  int mini_challenge_chapter_count : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x90, 0x10, 0x40;
}

state("SuperliminalGOG", "2022")
{
  double timer : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x130;
  string255 scene : "UnityPlayer.dll", 0x183cf10, 0x48, 0x10, 0x0;
  int mini_challenge_chapter_count : "UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x90, 0x10, 0x40;
}

startup
{
  vars.challenge_count = 0;
  vars.challenge_count_1 = 0;

  settings.Add("split_on_challenge", false, "Split on finishing a mini challenge");
  settings.SetToolTip("split_on_challenge", "");

  settings.Add("il", false, "Individual Level");
  settings.SetToolTip("il", "For IL practices only");
}

init
{
  version = "2022";

  vars.inLevel = false;

}

start
{
  if (settings["il"])
  {
    const string LevelPrefix = "Assets/_Levels/_LiveFolder/ACT";
    bool inLevel = current.scene != null && current.scene.StartsWith(LevelPrefix);
    return inLevel && current.scene != old.scene;
  }

  return current.timer > 0 && old.timer != current.timer;
}

update
{
  if (current.scene == null) {
    current.scene = old.scene;
  }
  const string LevelPrefix = "Assets/_Levels/_LiveFolder/ACT";
  if (!vars.inLevel && current.scene != null && current.scene.StartsWith(LevelPrefix))
    vars.inLevel = true;

  vars.old_challenge_count = vars.challenge_count;
  vars.old_challenge_count_1 = vars.challenge_count_1;
  vars.challenge_count = 0;
  vars.challenge_count_1 = 0;
  for (int i = 0; i < current.mini_challenge_chapter_count; i++) {
    vars.challenge_count_1 = new DeepPointer("UnityPlayer.dll", 0x17f9d28, 0x8, 0xb0, 0x28, 0x90, 0x10, 0x18, 0x30 + i * 0x18, 0x30).Deref<int>(game);
    vars.challenge_count += vars.challenge_count_1;
  }
}

gameTime
{
  if (settings["il"]) {
    return null;
  }
  return TimeSpan.FromSeconds(current.timer);
}

isLoading
{
  if (settings["il"]) {
    return false;
  }
  // const string LoadingScenesPrefix = "Assets/_Levels/_LiveFolder/Misc/LoadingScenes/";
  // return current.scene.StartsWith(LoadingScenesPrefix);
  return old.timer == current.timer;
}

reset
{
  bool inMainMenu = false;
  bool enteredInduction = false;

  enteredInduction = old.timer != current.timer && (current.timer < old.timer || old.timer == 0);

  const string Menu = "Assets/_Levels/_LiveFolder/Misc/StartScreen_Live.unity";
  if (current.scene != old.scene && current.scene == Menu) {
    if (settings["il"]) {
      const string Whitespace = "Assets/_Levels/_LiveFolder/ACT03/Unlit/Astral_Live.unity";
      if (old.scene == Whitespace) {
        inMainMenu = vars.challenge_count_1 != 3;
      } else {
        inMainMenu = true;
      }
    } else {
      inMainMenu = vars.challenge_count != 32;
    }
  }

  return inMainMenu || enteredInduction;
}

split
{
  bool enteredNextLevel = false;
  bool finishedGame = false;
  bool collectedMiniChallenge = false;

  const string LoadingScenesPrefix = "Assets/_Levels/_LiveFolder/Misc/LoadingScenes/";
  if (vars.inLevel && current.scene.StartsWith(LoadingScenesPrefix))
  {
    vars.inLevel = false;
    enteredNextLevel = true;
  }
  
  if(vars.inLevel)
    collectedMiniChallenge = vars.challenge_count != vars.old_challenge_count;

  const string Menu = "Assets/_Levels/_LiveFolder/Misc/StartScreen_Live.unity";
  finishedGame = current.scene != old.scene && current.scene == Menu;

  return enteredNextLevel 
    || finishedGame 
    || (settings["split_on_challenge"] && collectedMiniChallenge);
}

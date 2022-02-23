

# Superliminal Supplementary Auto-splitters and Splits File

Still in development. Use at your own risk. Read this file carefully before using.

This repo contains resources for 

- Checkpoint Autosplitter (see below),
- [All Achievements](AllAchievements),
- [Challenge Mode](ChallengeMode),
- [Co-op](Coop) speedruns

and other resources.
## Development Status

Work-in-progess: support for 2022.2.

For older versions (in-game version 1.10.2021.x), please visit [v2021mp](https://github.com/EtaoinWu/SuperliminalASL/tree/v2021mp).

## Checkpoint Autosplitter

The checkpoint autosplitter is currently maintained on [Loris's repo](https://github.com/loriswit/asl).

### Usage

* The script is intended for PC **Glitchless** runners. Make sure you installed the correct version (2021 and beyond) of the game.
* Download and select `Superliminal - subsplits.lss` as your splits file. In the settings for auto-splitter, enable "Split on checkpoints".
* For load removal in version 2020 and above, you need to set your comparison to **Game Time** instead of Real Time, which LiveSplit would read the in-game timer from memory.
* Fire up your game and have fun.
* If you need IL split files with checkpoint subsplits, you can use `IL/[level name].lss`.

### Compatibility

Limited testing was done. No guarantee on any platform other than PC Steam latest. (Contact me if you want support on your favorite platform.)

### Skipping CPs

If you skip a checkpoint trigger, the script would not work properly.

* In *Induction*, the checkpoint `TC_TwoButtonRoom_EM` can be skipped if you jump down the door instead of walk down; the trigger is roughly here:
  
  ![Position of the checkpoint `TC_TwoButtonRoom_EM`](position_TC_TwoButtonRoom_EM.png)

  If you have the habit to jump down the door, you can delete this checkpoint from the splits file.

* If you perform the blind walking strategy in the room where you need to jump above boxes in *Blackout* (rather than getting the red light from another room), you'll need to delete the subsplit `_ExitSignLightWithBoxes` from the splits file.

* In *Labyrinth*, after the elevator maze, there is another elevator which will teleport you to a parking lot with street lamps and moon. The checkpoint `_ParkingLot` is placed on the far end of that elevator, roughly here on the screenshot:

  ![Position of the checkpoint `_ParkingLot`](position_ParkingLot.png)

  The scene transition trigger is different from the checkpoint trigger; that is, you got the scene transition as long as you enter the elevator, while you got the checkpoint only if you hit the far end of the elevator (also, after the elevator disappeared, you can still hit the checkpoint at the middle of the parking lot area). Due to its inconsistency, this checkpoint has been removed from the split file, and **splitting on this CP is disabled** in the auto-splitter by default.

* In *Whitespace*, after you drop down from the black place with rain, there is a checkpoint here called `_WalkThroughShadow`:![position_WalkThroughShadow](position_WalkThroughShadow.png)

  Due to its inconsistency, this checkpoint has been removed from the split file, and **splitting on this CP is disabled** in the auto-splitter by default.

No other CP skips are found in my glitchless testing runs.

### About Subsplits' Names

I use in-game CP names as subsplit names. They are fetched from game memory. They are usually about the place where the checkpoint trigger is placed, rather than the actual level between the checkpoints. Rename them as you like!
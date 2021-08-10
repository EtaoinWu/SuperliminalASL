# Superliminal Checkpoint Autosplitter

Still in development. Use at your own risk. Read this file carefully before using.

## Usage

* The script is intended for PC **Glitchless** runners. Make sure you installed the correct version (2021) of the game.
* Download and select `Superliminal - subsplits.lss` as your splits file. In the settings for auto-splitter, enable "Split on checkpoints".
* Fire up your game and have fun.

## Compatibility

Only tested on LiveSplit 1.8.16 with Superliminal Steam version 1.10.2021.5.10.  The script might not work on earlier versions.

It should also work in challenge mode; I've only tested the first few rooms though. If you run challenge mode, you need to manually remove the last split for Retrospect.

## Skipping CPs

If you skip a checkpoint trigger, the script would not work properly.

* If you perform the blind walking strategy in the room where you need to jump above boxes in Blackout (rather than getting the red light from another room), you need to delete the subsplit `_ExitSignLightWithBoxes`.

* In Labyrinth, after the elevator maze, there is another elevator which will teleport you to a parking lot with street lamps and moon. The checkpoint `_ParkingLot` is placed on the far end of that elevator, roughly here on the screenshot:

  ![Position of the checkpoint `_ParkingLot`](position_ParkingLot.png)

  The scene transition trigger is different from the checkpoint trigger; that is, you got the scene transition as long as you enter the elevator, while you got the checkpoint only if you hit the far end of the elevator. Depending on your habit, you may or may not skip this checkpoint. You might need to manually split (or undo split) if you accidentally miss (or hit, respectively) this trigger.

No other CP skips are found in my glitchless testing runs.

## About Subsplits' Names

I use in-game CP names as subsplit names. They are fetched from game memory. They are usually about the place where the checkpoint trigger is placed, rather than the actual level between the checkpoints. Rename them as you like!
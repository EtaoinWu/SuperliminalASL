# Superliminal Checkpoint Autosplitter

Still in development. Use at your own risk. Read this file carefully before using.

## Usage

* The script is intended for PC Glitchless runners. Make sure you installed the correct version of the game.
* Download the repo as a zip file. 
* Select `Superliminal - subsplits.lss` as your splits file. 
* Then, in "Edit Splits" - "Auto start/split/reset and load removal available", choose "Activate", and in "Settings", change the script path to the downloaded `superliminal_split_on_cp.asl` file.
* Enable Start, Split and Reset; keep Individual Level off for now.
* Fire up your game and have fun.

## Compatibility

Only tested on LiveSplit 1.8.16 with Superliminal Steam version 1.10.2021.5.10.  The script might not work on earlier versions.

## Skipping CPs

If you skip a checkpoint trigger, the script would not work properly.

* If you perform the blind walking strategy in the room where you need to jump above boxes in Blackout (rather than getting the red light from another room), you need to delete the subsplit `_ExitSignLightWithBoxes`.

No other CP skips are done in my glitchless testing runs.

## About Subsplits' Names

I use in-game CP names as subsplit names. They are fetched from game memory. They are usually about the place where the checkpoint trigger is placed, rather than the actual level between the checkpoints. Rename them as you like!
Assign AutoStart Fix v1.1.0.1

Please note that this will likely break in future version of the console. and to use at your own risk.

This plugin applies a [workaround](https://forum.malighting.com/thread/3712-playbacks/?postID=8769) to AutoStart always running the next cue even when the executor is already active.

Usage:
* `Plugin "Assign AutoStart Fix" "2"` - Assigns the MacOS to Sequence 2
* `Plugin "Assign AutoStart Fix" "1,10-11"` - Assigns the MacOS to Sequence 1, 10 and 11
* Calling the plugin without a argument will popup a Dialog asking for the Sequences.



Issues:
* ***NOTE: This will OVERWRITE any CMD's in the Selected Sequences CueZero and OffCue!***
* Does not currently check if the Sequence exists, probably no need since when the issue gets fixed this plugin will be deprecated.

Releases:
* 1.0.0.1 - Initial release
* 1.0.0.2 - Added Oops, better checks for non valid inputs
* 1.0.0.3 - Making functions local
* 1.1.0.1 - Spelling Corrections

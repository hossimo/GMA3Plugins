Assign AutoStart Fix v1.0.0.3

Please note that this will likly break in future version of the console. and to use at your own risk.

This plugin applys a [workaround](https://forum.malighting.com/thread/3712-playbacks/?postID=8769) to AutoStart always running the next cue even when the executor is already active.

Usage:
* Call Plugin "Assign AutoStart Fix" "2" - Assigns the Macos to Sequence 2
* Call Plugin "Assign AutoStart Fix" "1,10-11" - Assigns the Macos to Sequence 1, 10 and 11
* Calling the plugin without a argument will popup a Dialog asking for the Sequences.



Issues:
* ***NOTE: This will OVERWRITE any CMD's in the Selected Sequences CueZero and OffCue!***
* Does not currently check if the Sequence exists, probably no need since when the issue gets fixed this plugin will be depricated.

Releases:
* 1.0.0.1 - Inital release
* 1.0.0.2 - Added Oops, better checks for non valid inputs
* 1.0.0.3 - Makeing functions local

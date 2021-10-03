# Fade Master
*v1.1.0.2*

## Note:
As of console version 1.6.1.3 the built-in `FaderMaster` command with `Fade` keyword is working. for example to Fade Executor 201 on Page 1 to 100% at 5 seconds you cen type:

`FaderMaster Page 1.201 at 100 Fadde 5`


![Fade Master Example](../../../../../Images/FadeMaster.gif)

Allows you to automate a Executor or Sequence Fader movement over time.

In grandMA 2 you could do `ExecButton 1.1 At 100 Fade 3`

With this plugin you can do:
`Plugin "Fade Master" "Page,1.201,100,3"` Which fade executor 1.201 from its current value to 100% over 3 seconds.

You also can do the following:
`Plugin "Fade Master" "Sequence,4,100,3"` Which Sequence 4 from its current value to 100% over 3 seconds. The executor does not even need to be assigned to an executor or an executor with a master.

Added in v1.1.0.2:
* `Plugin "Fade Master"` (without arguments) and a dialog with options will be displayed
* No longer need `Page` or `Sequence` arguments, if you enter a number with a `.` it will be a page and without a sequence.


Additionally, if you have a long running fade that you need to abort you can delete the User Variable and the fade will stop.

### Note:

* The plugin does it's best to make sure a user does not run the same executor twice, However there are edge cases like assigning Sequence 2 to Page 1.201 and dunning both Page and Sequence modes on the same executor will do undefined things.
* If the Fade Master plugin is already running it will not start again until the previous move is complete (thus its corresponding UserVar is deleted.)
* Fades are limited to 1 Hour, only for a sensible limit.
* Fades are currently always calculated in seconds.
* Spacing between arguments is optional but arguments must be delimited by comma ","
* At the Moment the Plugin only works for `FaderMaster`, but technically it could be modified to allow other types of masters (XFade, Temp, ...)

### Usage:

*Fade Executor 1.201 to full*

`Plugin "Fade Maser" "Page , 1.201 , 100 , 5"`

*Fade Sequence 4 to full*

`Plugin "Fade Maser" "Sequence , 4 , 100 , 5"`

*Stop Executor 1.201 While running*

`DelUserVar "FMP1.201"`

*Stop Sequence 4 While running*

`DelUserVar "FMS4"`

### Releases:
- 1.1.0.1 - Initial Release
- 1.1.0.2 - Added no argument dialog, and some additional sanity checking.
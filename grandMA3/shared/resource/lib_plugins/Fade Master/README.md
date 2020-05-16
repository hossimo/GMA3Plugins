# Fade Master
*v1.1.0.1*
Please note that this will likly break in future version of the console. and to use at your own risk.

![Fade Master Example](../../../../../Images/FadeMaster.gif)

Allows you to automate a Executor or Sequence Fader movement over time.

In grandMA 2 you could do `ExecButton 1.1 At 100 Fade 3`

With this plugin you can do:
'Plugin "Fade Master" "Page,1.201,100,3"' Which fade executor 1.201 from its current value to 100% over 3 seconds.

You also can do the following:
'Plugin "Fade Master" "Sequence,4,100,3"' Which Sequence 4 from its current value to 100% over 3 seconds. The executor does not even need to be assigned to an executor or an executor with a master.


Additionally, if you have a long running fade that you need to abort you can delete the User Vraiable and the fade will stop.

### Note:

* The plugin does it's best to make sure a user does not run the same executor twice, However there are edge cases like assigining Sequence 2 to Page 1.201 and dunning both Page and Sequence modes on the same executor will do undefined things.
* If the Fade Master plugin is already running it will not start again until the previous move is complete (thus its corasponding UserVar is deleted.)
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
- 1.1.0.1 - Inital Release

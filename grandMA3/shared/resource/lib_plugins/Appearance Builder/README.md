## Appearance Builder 2.0
Tested with MA 2.0.2.0

This updated version of the appearance builder adds images and a better UI

Changes from v1.x
- Removed the Commandline Entry (could add back if it's useful).
- Updated UI to the ScreenOverlay APIs.
- Added the ability to append generated System Colors (Macro, Sequence, Fade, Delay...).
- Added the ability to add Images to the generated Appearances.
- Window Stays open between generations for easy creation of multiple color setups.
- A new Undo step is created every type you press apply
- UI will complain in if any value is not valid (e.g. Saturation of 1.1 or count and start is greater then 10,000)
- Choosing a Count of 0 and System colors will only make the system colors
- The fill Saturation controls the color of the image, to make the image show up as designed make the Fill Saturation 0


Create 12 Appearances starting at index 1
![AppearanceBuilder Example](https://github.com/hossimo/GMA3Plugins/blob/master/Images/ApearanceBuilder2-simple1.png)

Create another 12 starting at 14 and fill and outline brightness set to 50%
![AppearanceBuilder Example](https://github.com/hossimo/GMA3Plugins/blob/master/Images/AppearanceBuilder2-simple2.png)

Create 13 appearances starting at 1 and append the system colors as well as overwriting pervious
![AppearanceBuilder Example](https://github.com/hossimo/GMA3Plugins/blob/master/Images/AppearanceBuilder2-system.png)


Create 25 Appearances with Image 2 overwriting previous, note the color of the fill chooses the color of the Image, so a Saturation of 0 makes the fill white thus making the image appear as designed, increating the Saturation of the fill with an image acts as a tint.
![AppearanceBuilder Example](https://github.com/hossimo/GMA3Plugins/blob/master/Images/AppearanceBuilder2-images.png)



![Appearance Builder 2_combined.xml](https://github.com/hossimo/GMA3Plugins/blob/master/grandMA3/shared/resource/lib_plugins/Appearance%20Builder%202%20combined.xml) - This is noth the xml and lua code in a single file
![Appearance Builder 2.lua](https://github.com/hossimo/GMA3Plugins/blob/master/grandMA3/shared/resource/lib_plugins/Appearance%20Builder%202.lua) - If you want to view the code here on github
![Appearance Builder 2.xml](https://github.com/hossimo/GMA3Plugins/blob/master/grandMA3/shared/resource/lib_plugins/Appearance%20Builder%202.xml) - used with the lua file if you like it that way.




## AppearanceBuilder v1.6

Please note that this will likely break in future version of the console. and to use at your own risk.

This plugin creates the specified number of Appearance colors by spinning the Hue wheel evenly. it tries to give the colors names based on a small list of editable RGB values and names in the plugin.

Usage:
`Plugin Appearance Builder "COUNT [,AppearanceStartIndex [,FillSaturation [,FillBrightness [,OutlineSaturation [,OutlineBrightness]]]]]"`

Example:
`Plugin "Appearance Builder" "10, 103, 1, 0.4, 1, 1"`

Creates 10 Appearances starting at 103 with the fill being darker then the outline.

`Plugin "Appearance Builder" "10, 42"`

Creates 10 at 42 with the below defaults

`Plugin "Appearance Builder" "10"`

Creates 10 at default index with the below defaults

If no properties are called with with the plugin a series of text boxes will ask questions for each value.

![AppearanceBuilder Example](https://github.com/hossimo/GMA3Plugins/blob/master/Images/AppearanceBuilderExample.png)

![Example with System Colors](https://github.com/hossimo/GMA3Plugins/assets/1986602/14408603-6d62-41ea-9847-5fee3b1454b4)

Properties:
COUNT                between  1 and 360
AppearanceStartIndex between 0 - 10000 defaults to 101
FillSaturation       between 0.0 and 1.0 defaults to 1.0
FillBrightness       between 0.0 and 1.0 defaults to 1.0
FillSaturation       between 0.0 and 1.0 defaults to <FillSaturation>
FillBrightness       between 0.0 and 1.0 defaults to <FillBrightness>

Things todo:
- The name is currently taken from the outline color, and has a small list of colors.
- Better Macro overwriting, currently deletes and creates, if not overwriting adds additional lines with the INSERT command
- Efficacies and Consistently issues

Releases:
- 1.0.0.1 - Initial Release
- 1.0.0.2 - Added Text input when no arguments
- 1.0.0.3 - Changed Text input confirmation to Confirm() from PopupInput()
- 1.0.0.4 - Added Undo/Oops
- 1.0.0.5 - Cleanup and making functions local
- 1.1.0.1 - Uses MessageBox() and better Appearance Overwriting.
- 1.1.0.2 - Message Box fields use the correct types. Fixed a bug where canceling at continue proceeded anyway.
- 1.1.0.3 - Fixed Undo
- 1.1.0.4 - When overwriting, clear out any overwritten images
- 1.5.2.1-1 - Fixed for 1.5.2.1, removed macro creation, re-ordered command line arguments, corrected default values MessageBox() status now return true/false not 0/1,
- 1.6.0 - Added System Colors, fixed overwrite result from the message box being a bool and not a int any longer.

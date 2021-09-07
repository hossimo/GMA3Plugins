AppearanceBuilder v1.5.2.1-1

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

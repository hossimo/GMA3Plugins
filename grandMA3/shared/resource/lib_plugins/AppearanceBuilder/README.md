AppearanceBuilder v1.1.0.1

Please note that this will likly break in future version of the console. and to use at your own risk.

This plugin creates the specified number of Appearance colors by spinning the Hue wheel eavenly. it trys to give the colors names based on a small list of editable RGB values and names in the plugin.

Usage:
`Call Plugin AppearanceBuilder "COUNT, [FillSaturation], [FillBrightness], [OutlineSaturation], [OutlineBrightness], [AppearanceStartIndex], [MacroStartIndex]"'`

Example:
`Call Plugin "AppearanceBuilder" "10, 1, 0.4, 1, 1, 103, 121"`

Creates 10 Appearances starting at 103 and Macros starting at 121 with the fill being darker then the outline.
If no properties are called with with the plugin a series of text boxes will ask questions for each value.

![AppearanceBuilder Example](https://github.com/hossimo/GMA3Plugins/blob/master/Images/AppearanceBuilderExample.png)
 
Properties:
COUNT           between  1 and 360 defalts to 15
FillSaturation  between 0.0 and 1.0 defaults to 1.0
FillBrightness  between 0.0 and 1.0 defaults to 1.0
FillSaturation  between 0.0 and 1.0 defaults to <FillSaturation>
FillBrightness  between 0.0 and 1.0 defaults to <FillBrightness>
AppearanceStartIndex between 0 - 10000 defaults to 101
AppearanceStartIndex between 0 - 10000 defaults to AppearanceStartIndex

Things todo:
- The name is curretly taken from the outline color, and has a small list of colors.
- Better Macro overwriting, currently deletes and creates, if not overwriting adds additional lines with the INSERT command
- Eficancies and Consistantly issues

Releases:
- 1.0.0.1 - Inital Release
- 1.0.0.2 - Added Text input when no arguments
- 1.0.0.3 - Changed Text input confirmation to Confirm() from PopupInput()
- 1.0.0.4 - Added Undo/Oops
- 1.0.0.5 - Cleanup and making functions local
- 1.1.0.1 - Uses MessageBox() and better Apperance Overwriting.
- 1.1.0.2 - Message Box fields use the correct types. Fixed a bug where canceling at continue proceded anyway.
- 1.1.0.3 - Fixed Undo
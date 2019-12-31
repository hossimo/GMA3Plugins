AppearanceBuilder v1.0.0.1
Please note that this will likly break in future version of the console. and to use at your own risk.

This plugin creates the specified number of Appearance colors by spinning the Hue wheel eavenly. it trys to give the colors names based on a small list of editable RGB values and names in the plugin.

Usage:
Call Plugin AppearanceBuilder "COUNT, [FillSaturation], [FillBrightness], [OutlineSaturation], [OutlineBrightness], [AppearnceStartIndex], [MacroStartIndex]"'

Example:
Call Plugin "AppearnceBuilder" "10, 1, 0.4, 1, 1, 103, 121"

Creates 10 Appearances starting at 103 and Macros starting at 121 with the fill being darker then the outline.
 
Properties:
COUNT           between  1 and 360 defalts to 15
FillSaturation  between 0.0 and 1.0 defaults to 1.0
FillBrightness  between 0.0 and 1.0 defaults to 1.0
FillSaturation  between 0.0 and 1.0 defaults to <FillSaturation>
FillBrightness  between 0.0 and 1.0 defaults to <FillBrightness>
AppearnceStartIndex between 0 - 10000 defaults to 101
AppearnceStartIndex between 0 - 10000 defaults to AppearnceStartIndex

Things todo:
- Figure out how to ask a question for the user to input a value
- The name is curretly taken from the outline color, and has a small list of colors.
- Better Appearance overwriteing, currently deletes and creates causing the refrances to be deleted.
- Better Macro overwriting, currently deletes and creates, if not overwriting adds additional lines with the INSERT command
- Better property managment, key value pairs would be much nicer
- Eficancies and Consistantly issues
- Include Overwrite as a property

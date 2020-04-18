# Global Functions
###### As of Version 1.0.0.3

Here is a listing of my my findings, there are many more commented out, edit and make a PR if you would like to help out.

Note that none of this is offical, and there are likly mistakes that need to be fixed.

## Table Of Contents
*Not it any useful order*

* [Cmd](#Cmd)
* [CreateUndo](#CreateUndo)
* [CloseUndo](#CloseUndo)
* [GlobalVars](#GlobalVars)
* [PluginVars](#PluginVars)
* [AddonVars](#AddonVars)
* [UserVars](#UserVars)
* [GetVar](#GetVar)
* [SetVar](#SetVar)
* [DelVar](#DelVar)
* [Confirm](#Confirm)
* [MessageBox](#MessageBox)
* [PopupInput](#PopupInput)
* [TextInput](#TextInput)
* [DeskLocked](#DeskLocked)
* [Echo](#Echo)
* [ErrEcho](#ErrEcho)
* [Printf](#Printf)
* [ErrPrintf](#ErrPrintf)
* [Root](#Root)
* [ShowData](#ShowData)

*[Selection](#Selection)
*[SelectionCount](#SelectionCount)
*[SelectionFirst](#SelectionFirst)
*[SelectionNext](#SelectionNext)

Referances

* [vkPlugin](#vkPlugin)

<!----- CMD ----->
<a name="Cmd"></a>

## Cmd(string:command, [object:undo]) : string
### Breif:
Enters a command on the command line with an optional undo object.

### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:command  | A command line string |
 object:undo | An Undo session Object | ✔

### Returns:
string: "Ok"
string: "Syntax Error"
string: "Ilegal Command"
...

### Examples:
```lua
Cmd("Fixture 1 thru 36")
```

```lua
local undo = CreateUndo()
Cmd("Store Cue 1", undo)
CloseUndo(undo)
```
<!----- CreateUndo ----->
<a name="CreateUndo"></a>

## CreateUndo(string:description) : object
### Breif:
Creates an undo object

### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:description  | undo Description |
 
### Returns:
Object: Undo

### Examples:
```lua
local undo = CreateUndo("Undo Store Cue 1")
Cmd("Store Cue 1", undo)
local result = CloseUndo(undo)
```

<!----- CloseUndo ----->
<a name="CloseUndo"></a>

## CloseUndo(object:undo) : boolean
### Breif:
Closes an undo object

### Paramiters:
 Name | Description | Optional
-- | -- | --
 object:undo  | An undo object created with `CreateUndo` |
 
### Returns:
boolean: true if closed
boolean: false if in use
...

### Examples:
```lua
local undo = CreateUndo()
Cmd("Store Cue 1", undo)
CloseUndo(undo)
```

<!-- | GlobalVars()| | userdata:variables | -->
<a name="GlobalVars"></a>

## GlobalVars(): object
### Paramiters:
None

### Returns:
object: Global Variable Object

### Examples:
```lua
local v = GlobalVars()
local result = DelVar(v, "Counter") -- Deletes the COUNTER Global Variable
```
<!-- | PluginVars()| <sup>(1)</sup>|<sup>(1)</sup>| -->
<a name="PluginVars"></a>

## PluginVars() : object
### Paramiters:
None
### Returns:
object: Plugin Variable Object
...

### Examples:
```lua
-- HAVE NOT TRIED THIS YET
local v = PluginVars()
local result = DelVar(v, "Counter") -- Deletes the COUNTER Plugin Variable
```

<!-- | AddonVars() | (string: addon Name)| userdata: addon variables| -->
<a name="AddonVars"></a>

## AddonVars()
### Paramiters:
None
### Returns:
object: AddonVars Object

### Examples:
```lua
-- HAVE NOT TRIED THIS YET
local v = AddonVars()
local result = DelVar(v, "Counter") -- Deletes the COUNTER AddonVar
```


<!-- | UserVars()| | userdata:variables | -->
<a name="UserVars"></a>

## UserVars()
### Paramiters:
None
### Returns:
object: UserVars Object

### Examples:
```lua
-- HAVE NOT TRIED THIS YET
local v = UserVars()
local result = DelVar(v, "Counter") -- Deletes the COUNTER UserVar
```

<!-- | GetVar() | userdata:variables, string "varName" | var:value | -->
<a name="GetVar"></a>

## GetVar(object:variables, string:varName) : var
### Paramiters:
 Name | Description | Optional
-- | -- | --
 object:varible  | A referance to Variables Object. e.g. GlobalVars(), PluginVars(), AddonVars(), UserVars() |
 string:name | Variable name to retrive |

### Returns:
var: value (number, string, ...)
nil: if no value

### Examples:
```lua
local userVar = UserVars()
local setSuccess = SetVar(userVar, "COUNTER", 42)
local result = GetVar(userVar, "COUNTER") -- result = 42
local delSuccess = DelVar(userVar, "COUNTER") 
```

<!-- SetVar(userdata:variables, string "varName", value) : bool -->
<a name="SetVar"></a>

## SetVar(object: variables, string:varName, var:value) : bool
### Paramiters:
 Name | Description | Optional
-- | -- | --
 object:variables  | A referance to Variables Object. e.g. GlobalVars(), PluginVars(), AddonVars(), UserVars() |
 string:varName | Variable name to set |
 var:value | The resulting value (number, string, ...) |

### Returns:
string: "Ok"
string: "Syntax Error"
string: "Ilegal Command"
...

### Examples:
```lua
local userVar = UserVars()
local setSuccess = SetVar(userVar, "COUNTER", 42)
local result = GetVar(userVar, "COUNTER") -- result = 42
local delSuccess = DelVar(userVar, "COUNTER") 
```

<!--  DelVar -->
<a name="DelVar"></a>

## DelVar(object:variables, string "varName") : bool
### Paramiters:
 Name | Description | Optional
-- | -- | --
 object:Variables  |  A referance to Variables Object. e.g. GlobalVars(), PluginVars(), AddonVars(), UserVars()   |
 string: Variable Name | The name of the variable |

### Returns:
bool: success

### Examples:
```lua
local userVar = UserVars()
local setSuccess = SetVar(userVar, "COUNTER", 42)
local result = GetVar(userVar, "COUNTER") -- result = 42
local delSuccess = DelVar(userVar, "COUNTER") 
```
<!--  DelVar -->

<!----- Confirm ----->
<a name="Confirm"></a>

## Confirm([string:Header [, string:Body]) : boolean
### Breif:
Displays the user a OK/Cancel question with header and multiline body text

### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:Header | Header text | ✔
 object:Body | Multiline body text | ✔

### Returns:
boolean: OK
false: Cancel

### Examples:
```lua
local result = Confirm("Do you want to exit?", "Are you sure?")
```
<!----- Confirm ----->

<!-- MessageBox -->
<a name="MessageBox"></a>

## MessageBox(table:options) : table
### Brief:
 Displays a Message box with many options, a number of features are still to be determined.
### Paramiters:
 Name | Description | Optional
-- | -- | --
 table:options  | table of options detailed below |

#### Options
Name | Description | Optional
-- | -- | --
title : string|The title for the dialog.|
backColor : int\|string|The dialog chrome color. This color can be a number or string based on the current color theme and can be found at `Menu > Desk Lights Color Theme > Edit` For example "Global.Selected" or 1.7 is equal to FFD700FF in RGBA |✔
timeout : number|Number of MS the dialog will show for|✔
timeoutResultCancel : bool| TBD |✔
timeoutResultID : int| The result value is the dialog times out|✔
icon : int\|string|A Texture to display in the top left corner of the dialog. can be a texture name or it's index number. a listing a availible textures and indexes can be found by listing the GraphicsToor/TextureCollect/Textures path in the console or in onPC by navagating to the `C:\ProgramData\MALightingTechnology\gma3_1.1.3\shared\resource\textures` folder for a list of names. |✔
titleTextColor : int\|string| See `backColor` |✔
messageTextColor : int\|string| See `backColor` |✔
message : String|multiline dialog message|
display : int\|handle|TBD, set to nil?|✔
commands : table| Table of buttons across the bottom of the dialog, detailed in the Command table below|✔
inputs : table|Table of Text imputs below the dialog message, detailed in the Inputs table below|✔
states : table|Table of check buttons below the inputs, detailed in the States table below|✔
#### Commands
Name | Description | Optional
-- | -- | --
value : int| Value of result if command is chosen |
name : string| Display of the command button |
#### Inputs
Name | Description | Optional
-- | -- | --
name : string|Name of the Input|
value : string|Default of the input|
blackFilter : string|A string that represents characters to block during input e.g. "$()\*" |
whiteFilter : string|A string that represents characters to allow during input e.g. "0123456789-"|
vkPlugin : string|A named ID reference to special virtual keyboards 'TextInputNumOnly' for a listing see [vkPlugin](#vkPlugin)|
maxTextLength : string|The maximum lenth of the entered string, the default value can ignore this number.|
#### States
Name | Description | Optional
-- | -- | --
name : string| Name of the Checkbox|
state : bool| Default value of the state?|
group : int| TBD |✔
### Returns:
table: {int:success, int:result, table:inputs, table:states}

### Examples:
![Example Image](https://github.com/hossimo/GMA3Plugins/blob/master/Images/MessageBox.png)
```lua
    local options = {
        title="This is a title",                        --string
        backColor="Global.Focus",                       --string: Color based on current theme.
        timeout=10000,                                  --number:in Miliseconds
        timeoutResultCancel=false,                      --bool
        timeoutResultID=-1,                             --number
        icon="time",                                    --int|string
        titleTextColor="Global.AlertText",              --int|string
        messageTextColor=nil,                           --int|string
        message="This is a long\nMultiline\nMessage",   --string
        display= nil,                                   --int? | handle?
        commands={
            {value=0, name="NO"},                       --int, string
            {value=1, name="MAYBE"},
            {value=2, name="YES"}
        },
        inputs={
            {name="INPUT 1", value="123", blackFilter="", whiteFilter="0123456789", vkPlugin="TextInputNumOnly", maxTextLength = 3},
            {name="INPUT 2", value="789ABC", blackFilter="$-=", whiteFilter="", vkPlugin="", maxTextLength = 6},
        },
        states={
            {name="State 1", state = true, group = 1},
            {name="State 2", state = false, group = 1},
            {name="State 3", state = true, group = 2},
            {name="State 4", state = false, group = 2},
            {name="State 5", state = true, group = 3},
            {name="State 6", state = false, group = 3}
        }
    }
    local r = MessageBox(options)

    -- r[success]              -- 
    -- r[result]               -- either the selected Command or timeoutResultID if the timer ran out.
    -- r[<input name>]         -- the value of the input
    -- r[inputs][<input name>] -- same as the above
    -- r[<state name>]         -- the value of the states
    -- r[states][<state name>] -- same as the above
```
<!-- MessageBox -->


<!-- PopupInput -->
<a name="PopupInput"></a>

## PopupInput(string:title, object: display_handle, table:values...[,string:selectedValue[,integer:x,integer:y]]}) : int
### Breif:
Displays a Radio or Option list the user can select an item from and returns what item the user selected.

This seems to allow several types for options including strings, numbers and maybe, LUA or other display handles. more information is needed.

### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:title  | Title of the dialog box | ✔ (string or nil)
 object:displayhandel | the main display_value | 
 table: value | Can be a table value of strings for each option or a table of tables in the format of {"int" \| "str" \| "lua" \| "handle", name , type dependant}. This second methoud needs more details |
 string: selectedvalue | String of selected value | ✔
 integer: x | *Not sure what this does* | ✔
 integer: y | *Not sure what this does* | if x?

### Returns:
nil: if user cancels

int: zero based selected value

*error documentation says it returns a string:value*

...

### Examples:
Option 1: 
```lua
local function Main(display_handle,argument) -- we need this display_handle
    -- ...
    local title = "Select your type of pizza"
    local options = {"Pineapple", "Pepperoni", "Mushroom"}
    local r = PopupInput(title, display_handle, options, "Pepperoni") -- defaults to "Pepperoni", user selected "Pineapple"
    Echo("result: " .. r .. " is type: " .. type(r)) -- result: 0 is type number
    -- ...
end
```
Option 2: Needs more details
```lua
local r = PopupInput("TITLE", display_handle, {{"str", "String", nil}, {"int","Number", 123}}, "123", 1, 1)
-- displays:
-- String
-- Number <-selected
E(type(r) .. " = " .. r) -- returns the zero based numer of the selected item.
```
<!-- PopupInput -->

<!-- TextInput -->
<a name="TextInput"></a>

## TextInput([string | number:Title], [string | number:Default]) : string
### Breif:
Displays a text input field for the user to enter a valie, takes optional title and default values

### Paramiters:
 Name | Description | Optional
-- | -- | --
 string \| number :Title  | The title for the input window | ✔
 string \| number :Defailt | The default text | ✔

### Returns:
nil: if cancled

string: value entered

### Examples:
```lua
local result = TextInput("Enter a Prime Number", 41) -- displays menu with title and the value of 41 entered
Echo(type(result) .. " " .. result) -- returns a string of the result
```
<!-- TextInput -->

<!-- DeskLocked -->
<a name="DeskLocked"></a>

## DeskLocked() : bool
### Paramiters:
 Name | Description | Optional
-- | -- | --

### Returns:
bool: true = Desk is locked
bool: false = Desk is not locked
...

### Examples:
```lua
    local locked = DeskLocked()
    if(locked) then
        Echo("Desk is locked")
    else
        Echo("Desk is unlocked")
    end
```
<!-- DeskLocked -->


<!-- Echo -->
<a name="Echo"></a>

## Echo(string:format ...)
### Breif:
Outputs a yellow colored string to the consoles System Monitor
### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:format  | lua formatted string see https://www.lua.org/pil/20.html for further details|

### Returns:
nil

### Examples:
```lua
    Echo("Testing, Testing " .. 100 + 20 + 3 .. "!")
    Echo("Testing, Testing %d!", 100 + 20 + 3)
    local test = "Testing"
    Echo("%s, %s %d!", test, test, 100 + 20 + 3) -- Testing, Testing 123 (decimal)
    Echo("%s, %s %f!", test, test, 100 + 20 + 3 + 0.0) -- Testing, Testing 123.000000! (float)
    Echo("%s, %s %x!", test, test, 2748) -- Testing, Testing abc (hex)
```
<!-- Echo -->

<!-- ErrEcho -->
<a name="ErrEcho"></a>

## ErrEcho(string:format ...)
### Breif:
Outputs a red colored string to the consoles System Monitor
### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:format  | lua formatted string see https://www.lua.org/pil/20.html for further details|

### Returns:
nil

### Examples:
```lua
    ErrEcho("Testing, Testing " .. 100 + 20 + 3 .. "!")
    ErrEcho("Testing, Testing %d!", 100 + 20 + 3)
    local test = "Testing"
    ErrEcho("%s, %s %d!", test, test, 100 + 20 + 3) -- Testing, Testing 123 (decimal)
    ErrEcho("%s, %s %f!", test, test, 100 + 20 + 3 + 0.0) -- Testing, Testing 123.000000! (float)
    ErrEcho("%s, %s %x!", test, test, 2748) -- Testing, Testing abc (hex)
```
<!-- ErrEcho -->

<!-- Printf -->
<a name="Printf"></a>

## Printf(string:format ...)
### Breif:
Outputs a white(1) colored string to the consoles Command Line History AND System Monitor
(1) This may be a bug.
### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:format  | lua formatted string see https://www.lua.org/pil/20.html for further details|

### Returns:
nil

### Examples:
```lua
    Printf("Testing, Testing " .. 100 + 20 + 3 .. "!")
    Printf("Testing, Testing %d!", 100 + 20 + 3)
    local test = "Testing"
    Printf("%s, %s %d!", test, test, 100 + 20 + 3) -- Testing, Testing 123 (decimal)
    Printf("%s, %s %f!", test, test, 100 + 20 + 3 + 0.0) -- Testing, Testing 123.000000! (float)
    Printf("%s, %s %x!", test, test, 2748) -- Testing, Testing abc (hex)
```
<!-- Printf -->

<!-- ErrPrintf -->
<a name="ErrPrintf"></a>

## ErrPrintf(string:format ...)
### Breif:
Outputs a white(1) colored string to the consoles Command Line History AND System Monitor
(1) This may be a bug.
### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:format  | lua formatted string see https://www.lua.org/pil/20.html for further details|

### Returns:
nil

### Examples:
```lua
    ErrPrintf("Testing, Testing " .. 100 + 20 + 3 .. "!")
    ErrPrintf("Testing, Testing %d!", 100 + 20 + 3)
    local test = "Testing"
    ErrPrintf("%s, %s %d!", test, test, 100 + 20 + 3) -- Testing, Testing 123 (decimal)
    ErrPrintf("%s, %s %f!", test, test, 100 + 20 + 3 + 0.0) -- Testing, Testing 123.000000! (float)
    ErrPrintf("%s, %s %x!", test, test, 2748) -- Testing, Testing abc (hex)
```
<!-- ErrPrintf -->


<!-- Root -->
<a name="Root"></a>

## Root() : object
### Brief:
Returns the Root Object. This object can be used to traverse the hierarchy from the root
### Paramiters:
 Name | Description | Optional
-- | -- | --

### Returns:
object: Root
...

### Examples:
```lua
local sequences = Root().ShowData.DataPools.Default.Sequences[1]
Echo("Sequence 1's name is : %s", sequences.name) -- User 1 is called: Default
```
<!-- Root -->

<!-- ShowData -->
<a name="ShowData"></a>

## ShowData() : object
### Brief:
Returns the ShowData Object. This object can be used to traverse the hierarchy from the root of ShowData()
### Paramiters:
 Name | Description | Optional
-- | -- | --

### Returns:
object: ShowData
...

### Examples:
```lua
local profileName = ShowData().UserProfiles[1].name;
Echo("User 1 is called: %s", profileName) -- User 1 is called: Default

local wheelMode = ShowData().UserProfiles:Find("Default").wheelmode
Echo("The Default users wheelmode is %s", wheelMode) --The Default users wheelmode additive
```
<!-- ShowData -->

<!-- Selection -->
<a name="Selection"></a>

## Selection() : UserData
### Brief:
⚠__Need more information__⚠

Returns a Dataobject not no idea of its format.

### Paramiters:
 Name | Description | Optional
-- | -- | --
 
### Returns:
?

### Examples:
```lua
local x = Selection().name
Echo("Name: %s", x) -- Name: Selection
```
<!-- Selection -->

<!-- SelectionCount -->
<a name="SelectionCount"></a>

## SelectionCount() : int
### Brief:
Returns a count of the number of fixtures selected

### Paramiters:
 Name | Description | Optional
-- | -- | --
 
### Returns:
int : Count of fixtures selected.

### Examples:
Patched Fixtures:
FID | Gird | Description
-- | -- | --
101 | 0/0/0 | Dimmer 1
102 | 1/0/0 | Dimmer 2
103 | 0/1/0 | Dimmer 3
104 | 1/1/0 | Dimmer 4

Fixture 1 thru 4

```lua
local count = SelectionCount()
Echo("Selected Count: %d", count) -- Selected Count: 3
```
<!-- SelectionCount -->

<!-- SelectionFirst -->
<a name="SelectionFirst"></a>

## SelectionFirst() : int, int, int, int
### Brief:
Returns the first selected fxtures SubfixtureIndex, X, Y and, Z grid positions. The Fixtures subfixture ID is a representation of the fixture within the patch and does not directly reflect the fixtures FID or CID, for example. A fixture with no FID or CID still does have a valid SubfixtureIndex.

### Paramiters:
 Name | Description | Optional
-- | -- | --
 
### Returns:
int, int, int, int : SubfixtureIndex, GridX, GridY, GridZ

### Examples:
Patched Fixtures:
FID | Gird | Description
-- | -- | --
101 | 0/0/0 | Dimmer 1
102 | 1/0/0 | Dimmer 2
103 | 0/1/0 | Dimmer 3
104 | 1/1/0 | Dimmer 4

Fixture 1 thru 4

```lua
local index, x, y, z = SelectionFirst()
Echo("index: %d %d/%d/%d", index, x, y, z) -- index: 1 0/0/0
```
<!-- SelectionFirst -->

<!-- SelectionNext -->
<a name="SelectionNext"></a>

## SelectionNext() : int, int, int, int
### Brief:
Returns the first selected fxtures SubfixtureIndex, X, Y and, Z grid positions. The Fixtures subfixture ID is a representation of the fixture within the patch and does not directly reflect the fixtures FID or CID, for example. A fixture with no FID or CID still does have a valid SubfixtureIndex.

### Paramiters:
 Name | Description | Optional
-- | -- | --
int:current| an int that represents the current selected SubfixtureIndex| 
 
### Returns:
int, int, int, int : SubfixtureIndex, GridX, GridY, GridZ

### Examples:
Patched Fixtures:
FID | Gird | Description
-- | -- | --
101 | 0/0/0 | Dimmer 1
102 | 1/0/0 | Dimmer 2
103 | 0/1/0 | Dimmer 3
104 | 1/1/0 | Dimmer 4

Fixture 1 thru 4

```lua
local index, x, y, z = SelectionFirst()
Echo("index: %d %d/%d/%d", index, x, y, z) -- index: 1 0/0/0
index, x, y, z = SelectionNext(index)
Echo("index: %d %d/%d/%d", index, x, y, z) -- index: 2 1/0/0
```
<!-- SelectionNext -->



<!-- vkPlugin -->
<a name="vkPlugin"></a>

## Text Input Plugins
### Brief:
This is an inital list of text inputs:

Name | Image
-- | --
CueNumberInput | ![](https://github.com/hossimo/GMA3Plugins/blob/master/Images/CueNumberInput.png)
IP4Prefix | ![](https://github.com/hossimo/GMA3Plugins/blob/master/Images/IP4Prefix.png)
NumericInput | ![](https://github.com/hossimo/GMA3Plugins/blob/master/Images/NumericInput.png)
RelCueNumberInput | ![](https://github.com/hossimo/GMA3Plugins/blob/master/Images/RelCueNumberInput.png)
TextInput | ![](https://github.com/hossimo/GMA3Plugins/blob/master/Images/TextInput.png)
TextInputNumOnly | ![](https://github.com/hossimo/GMA3Plugins/blob/master/Images/TextInputNumOnly.png)
TextInputNumOnlyRange | ![](https://github.com/hossimo/GMA3Plugins/blob/master/Images/TextInputNumOnlyRange.png)
TextInputTimeOnly | ![](https://github.com/hossimo/GMA3Plugins/blob/master/Images/TextInputTimeOnly.png)
<!-- vkPlugin -->




<!-- TEMPLATE -->
<!--
<a name="TEMPLATE"></a>

## TEMPLATE(string:x, [object:undo]) : bool
### Brief:
### Paramiters:
 Name | Description | Optional
-- | -- | --
 string:x  | a thing |
 object:x | an optional thing | ✔

### Returns:
string: "Ok"
string: "Syntax Error"
string: "Ilegal Command"
...

### Examples:
```lua
Code("Example")
```
-->
<!-- TEMPLATE -->

<!--
This table may contain objects that do not exist in the console. some are filled out based on findings.

| Function | Arguments| Returns|
| -------------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------- |
| AddIPAddress() | <sup>(1)</sup>|<sup>(1)</sup>|
| BuildDetails() | ()| Contains a table of build details|
| CheckDMXCollision()| (userdata: dmxMode, string: dmx Address[, integer:count[, integer:breakIndex]]) | boolean: true = no collision ,false = collision |
| CheckFIDCollision()| integer:FID[, integer:count] | boolean: true = no collision, false collision|
| CloseAllOverlays()| ()| nil|
| CmdIndirect()| (string: command[, userdata: undo[, userdata: target]]) | nil|
| CmdIndirectWait() | <sup>(1)</sup>|<sup>(1)</sup>|
| CmdObj() | <sup>(1)</sup>|<sup>(1)</sup>|
| CurrentExecPage() | ()| userdata: ObectMeta|
| CurrentProfile()| ()| userdata: ObectMeta |
| CurrentUser()| ()| userdata: ObectMeta|
| DataPool()| <sup>(1)</sup>|<sup>(1)</sup>|
| DefaultDisplayPositions()| ()|<sup>(1)</sup>|
| DeleteIPAddress() | <sup>(1)</sup>|<sup>(1)</sup>|
| Enums()| <sup>(1)</sup>|<sup>(1)</sup>|
| Export() | <sup>(1)</sup>|<sup>(1)</sup>|
| ExportCSV() | <sup>(1)</sup>|<sup>(1)</sup>|
| ExportJson()| <sup>(1)</sup>|<sup>(1)</sup>|
| FileExists()| <sup>(1)</sup>|<sup>(1)</sup>|
| FindBestDMXPatchAddr()| <sup>(1)</sup>|<sup>(1)</sup>|
| FindBestFocus()| <sup>(1)</sup>|<sup>(1)</sup>|
| FindNextFocus()| <sup>(1)</sup>|<sup>(1)</sup>|
| FixtureType()| <sup>(1)</sup>|<sup>(1)</sup>|
| FromAddr()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetAttributeByUIChannel()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetAttributeCount()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetAttributeIndex()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetButton() | <sup>(1)</sup>|<sup>(1)</sup>|
| GetChannelFunctionIndex()| int:ui channel index, int:attribute index |int: channel function index|
| GetDisplayByIndex()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetDisplayCollect()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetExecutor()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetFocus()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetFocusDisplay() | <sup>(1)</sup>|<sup>(1)</sup>|
| GetPath()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetPathOverrideFor() | <sup>(1)</sup>|<sup>(1)</sup>|
| GetPathSeparator()| | string: system path seperator "\\" or "/"|
| GetPathType()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetProgPhaser()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetProgPhaserValue() | <sup>(1)</sup>|<sup>(1)</sup>|
| GetPropertyColumnId()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetRTChannel() | <sup>(1)</sup>|<sup>(1)</sup>|
| GetRTChannelCount()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetSelectedAttribute()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetSubfixture()| int: subfixture index|userdata: ref to subfixture object or nil|
| GetSubfixtureCount() | <sup>(1)</sup>|<sup>(1)</sup>|
| GetTokenName() | <sup>(1)</sup>|<sup>(1)</sup>|
| GetTokenNameByIndex()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetTopModal()| <sup>(1)</sup>|<sup>(1)</sup>|
| GetUIChannel() | <sup>(1)</sup>|<sup>(1)</sup>|
| GetUIChannelCount()| |number: ???|
| GetUIChannelIndex()|int:subfixture index, int: attribute index|int ui channel index|
| GetUIChannels()|int: subfixture index|table: UI Channel indices or nil|
| GetUIObjectAtPosition() | <sup>(1)</sup>|<sup>(1)</sup>|
| HWEncoder() | <sup>(1)</sup>|<sup>(1)</sup>|
| HWKey()| <sup>(1)</sup>|<sup>(1)</sup>|
| HandleToInt()| <sup>(1)</sup>|<sup>(1)</sup>|
| HandleToStr()| <sup>(1)</sup>|<sup>(1)</sup>|
| HookObjectChange()| <sup>(1)</sup>|<sup>(1)</sup>|
| HostOS() | <sup>(1)</sup>|<sup>(1)</sup>|
| HostSubType()| <sup>(1)</sup>|<sup>(1)</sup>|
| HostType()| <sup>(1)</sup>|<sup>(1)</sup>|
| Import() | <sup>(1)</sup>|<sup>(1)</sup>|
| IncProgress()| <sup>(1)</sup>|<sup>(1)</sup>|
| IntToHandle()| <sup>(1)</sup>|<sup>(1)</sup>|
| IsObjectValid()| <sup>(1)</sup>|<sup>(1)</sup>|
| Keyboard()| <sup>(1)</sup>|<sup>(1)</sup>|
| KeyboardObj()| <sup>(1)</sup>|<sup>(1)</sup>|
| LoadExecConfig()| <sup>(1)</sup>|<sup>(1)</sup>|
| Mouse()| <sup>(1)</sup>|<sup>(1)</sup>|
| MouseObj()| <sup>(1)</sup>|<sup>(1)</sup>|
| MultiLanguage()| <sup>(1)</sup>|<sup>(1)</sup>|
| Obj() | <sup>(1)</sup>|<sup>(1)</sup>|
| OverallDeviceCertificate() | <sup>(1)</sup>|<sup>(1)</sup>|
| Patch()| |userdata: ???|
| Programmer()||userdata: ???|
| ProgrammerPart()| <sup>(1)</sup>|<sup>(1)</sup>|
| Pult()| <sup>(1)</sup>|<sup>(1)</sup>|
| RefreshLibrary()| <sup>(1)</sup>|<sup>(1)</sup>|
| ReleaseType()| <sup>(1)</sup>|<sup>(1)</sup>|
| Root()| <sup>(1)</sup>|<sup>(1)</sup>|
| SaveExecConfig()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionComponentX()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionComponentY()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionComponentZ()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionNotifyBegin()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionNotifyEnd() | <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionNotifyObject() | <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionToArray()| <sup>(1)</sup>|<sup>(1)</sup>|
| SerialNumber() | <sup>(1)</sup>|<sup>(1)</sup>|
| SetBlockInput()| <sup>(1)</sup>|<sup>(1)</sup>|
| SetLED() | userdata: usbdevice, table:led_values| |
| SetProgPhaser()| <sup>(1)</sup>|<sup>(1)</sup>|
| SetProgPhaserValue() | <sup>(1)</sup>|<sup>(1)</sup>|
| SetProgress()| <sup>(1)</sup>|<sup>(1)</sup>|
| SetProgressRange()| <sup>(1)</sup>|<sup>(1)</sup>|
| SetProgressText() | <sup>(1)</sup>|<sup>(1)</sup>|
| StartProgress()| <sup>(1)</sup>|<sup>(1)</sup>|
| StopProgress() | <sup>(1)</sup>|<sup>(1)</sup>|
| StrToHandle()| <sup>(1)</sup>|<sup>(1)</sup>|
| SyncFS() | <sup>(1)</sup>|<sup>(1)</sup>|
| Time()| <sup>(1)</sup>|<sup>(1)</sup>|
| Timer()| <sup>(1)</sup>|<sup>(1)</sup>|
| ToAddr() | <sup>(1)</sup>|<sup>(1)</sup>|
| Touch()| <sup>(1)</sup>|<sup>(1)</sup>|
| TouchObj()| <sup>(1)</sup>|<sup>(1)</sup>|
| Unhook() | <sup>(1)</sup>|<sup>(1)</sup>|
| Version()| <sup>(1)</sup>|<sup>(1)</sup>|
| WaitModal() | <sup>(1)</sup>|<sup>(1)</sup>|
| WaitObjectDelete()| <sup>(1)</sup>|<sup>(1)</sup>|
| _G | Globals Table | N/A|
| _VERSION | Contains LUA version| string:"Lua 5.3"|
| __CallbacksRegistry()| <sup>(1)</sup>|<sup>(1)</sup>|
| assert() | <sup>(1)</sup>|<sup>(1)</sup>|
| collectgarbage()| <sup>(1)</sup>|<sup>(1)</sup>|
| coroutine() | <sup>(1)</sup>|<sup>(1)</sup>|
| debug()| <sup>(1)</sup>|<sup>(1)</sup>|
| dofile() | <sup>(1)</sup>|<sup>(1)</sup>|
| error()| <sup>(1)</sup>|<sup>(1)</sup>|
| getColorName() | <sup>(1)</sup>|<sup>(1)</sup>|
| getmetatable() | <sup>(1)</sup>|<sup>(1)</sup>|
| io()| <sup>(1)</sup>|<sup>(1)</sup>|
| ipairs() | <sup>(1)</sup>|<sup>(1)</sup>|
| load()| <sup>(1)</sup>|<sup>(1)</sup>|
| loadfile()| <sup>(1)</sup>|<sup>(1)</sup>|
| math()| <sup>(1)</sup>|<sup>(1)</sup>|
| next()| <sup>(1)</sup>|<sup>(1)</sup>|
| os()| <sup>(1)</sup>|<sup>(1)</sup>|
| package()| <sup>(1)</sup>|<sup>(1)</sup>|
| pairs()| <sup>(1)</sup>|<sup>(1)</sup>|
| pcall()| <sup>(1)</sup>|<sup>(1)</sup>|
| print()| <sup>(1)</sup>|<sup>(1)</sup>|
| rawequal()| <sup>(1)</sup>|<sup>(1)</sup>|
| rawget() | <sup>(1)</sup>|<sup>(1)</sup>|
| rawlen() | <sup>(1)</sup>|<sup>(1)</sup>|
| rawset() | <sup>(1)</sup>|<sup>(1)</sup>|
| require()| <sup>(1)</sup>|<sup>(1)</sup>|
| select() | <sup>(1)</sup>|<sup>(1)</sup>|
| setmetatable() | <sup>(1)</sup>|<sup>(1)</sup>|
| split()| <sup>(1)</sup>|<sup>(1)</sup>|
| table()| <sup>(1)</sup>|<sup>(1)</sup>|
| tonumber()| <sup>(1)</sup>|<sup>(1)</sup>|
| tostring()| <sup>(1)</sup>|<sup>(1)</sup>|
| type()| <sup>(1)</sup>|<sup>(1)</sup>|
| utf8()| <sup>(1)</sup>|<sup>(1)</sup>|
| x()| <sup>(1)</sup>|<sup>(1)</sup>|
| xpcall() | <sup>(1)</sup>|<sup>(1)</sup>|


### Notes
<sup>(1)</sup> Haven't tested yet
<sup>(2)</sup> May be other options

-->

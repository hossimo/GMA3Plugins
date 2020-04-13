# Global Functions
###### As of Version 1.0.0.3

Here is a listing of my my findings, there are many more commented out, edit and make a PR if you would like to help out.

Note that none of this is offical, and there are likly mistakes that need to be fixed.

## Table Of Contents
*Not it any useful order*

* [Cmd](#Cmd)
* [CreateUndo](#CreateUndo)
* [CloseUndo](#CloseUndo)
* [Confirm](#Confirm)
* [GlobalVars](#GlobalVars)
* [PluginVars](#PluginVars)
* [AddonVars](#AddonVars)
* [UserVars](#UserVars)
* [GetVar](#GetVar)
* [SetVar](#SetVar)
* [DelVar](#DelVar)
* [PopupInput](#PopupInput)
* [TextInput](#TextInput)

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
...

### Examples:
```lua
local result = TextInput("Enter a Prime Number", 41) -- displays menu with title and the value of 41 entered
Echo(type(result) .. " " .. result) -- returns a string of the result
```
<!-- TextInput -->



<!-- TEMPLATE -->
<!--
<a name="TEMPLATE"></a>

## TEMPLATE(string:x, [object:undo]) : bool
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
| CreateUndo()| (string: description)| userdata: undo |
| CurrentExecPage() | ()| userdata: ObectMeta|
| CurrentProfile()| ()| userdata: ObectMeta |
| CurrentUser()| ()| userdata: ObectMeta|
| DataPool()| <sup>(1)</sup>|<sup>(1)</sup>|
| DefaultDisplayPositions()| ()|<sup>(1)</sup>|
| DeleteIPAddress() | <sup>(1)</sup>|<sup>(1)</sup>|
| DeskLocked()| <sup>(1)</sup>|<sup>(1)</sup>|
| Echo()| <sup>(1)</sup>|<sup>(1)</sup>|
| Enums()| <sup>(1)</sup>|<sup>(1)</sup>|
| ErrEcho()| <sup>(1)</sup>|<sup>(1)</sup>|
| ErrPrintf() | <sup>(1)</sup>|<sup>(1)</sup>|
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
| MessageBox()| <sup>(1)</sup>|<sup>(1)</sup>|
| Mouse()| <sup>(1)</sup>|<sup>(1)</sup>|
| MouseObj()| <sup>(1)</sup>|<sup>(1)</sup>|
| MultiLanguage()| <sup>(1)</sup>|<sup>(1)</sup>|
| Obj() | <sup>(1)</sup>|<sup>(1)</sup>|
| OverallDeviceCertificate() | <sup>(1)</sup>|<sup>(1)</sup>|
| Patch()| |userdata: ???|
| PopupInput()| <sup>(1)</sup>|<sup>(1)</sup>|
| Printf() | <sup>(1)</sup>|<sup>(1)</sup>|
| Programmer()||userdata: ???|
| ProgrammerPart()| <sup>(1)</sup>|<sup>(1)</sup>|
| Pult()| <sup>(1)</sup>|<sup>(1)</sup>|
| RefreshLibrary()| <sup>(1)</sup>|<sup>(1)</sup>|
| ReleaseType()| <sup>(1)</sup>|<sup>(1)</sup>|
| Root()| <sup>(1)</sup>|<sup>(1)</sup>|
| SaveExecConfig()| <sup>(1)</sup>|<sup>(1)</sup>|
| Selection() | <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionComponentX()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionComponentY()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionComponentZ()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionCount()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionFirst()| <sup>(1)</sup>|<sup>(1)</sup>|
| SelectionNext()| <sup>(1)</sup>|<sup>(1)</sup>|
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
| ShowData()| <sup>(1)</sup>|<sup>(1)</sup>|
| StartProgress()| <sup>(1)</sup>|<sup>(1)</sup>|
| StopProgress() | <sup>(1)</sup>|<sup>(1)</sup>|
| StrToHandle()| <sup>(1)</sup>|<sup>(1)</sup>|
| SyncFS() | <sup>(1)</sup>|<sup>(1)</sup>|
| TextInput() | <sup>(1)</sup>|<sup>(1)</sup>|
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
| clamp()| <sup>(1)</sup>|<sup>(1)</sup>|
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
| string() | <sup>(1)</sup>|<sup>(1)</sup>|
| table()| <sup>(1)</sup>|<sup>(1)</sup>|
| toRGB()| <sup>(1)</sup>|<sup>(1)</sup>|
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

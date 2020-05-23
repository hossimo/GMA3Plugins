# Rem Dim
*v1.1.0.1*

![Rem Dim Example](../../../../../Images/RemDim.gif)

Based on your selection, sets the dimmer of _other_ fixtures to 0.

Using the plugin without arguments will restrict the operation to fixtures of the selected ID Type. The "All" argument will execute Rem Dim on ALL patched fixtures however Global Fixtures will be ignored.

Makes sensible selections so should work with any number of fixtures.

### Note:

SubFixtures with Dimmer channels will be affected by the root fixtures dimmer channel.

### Usage:

*Only RemDim Fixtures*
```
Fixture 1 Thru 10 At Full
Fixture 5 + 7
Plugin "Rem Dim"
```
Result:
Fixtures 1 thru 4 + 6 + 8 thru 10 at 0

*Only RemDim Houselights*
```
Houselights 1 Thru 10 At Full
Houselights 3 + 4
Plugin "Rem Dim"
```

Result:
Houselights 1 thru 2 + 5 thru 10 at 0

*RemDim Fixtures and Houselights*
```
Fixtures 1 Thru 10 + Houselights 1 Thru 10 At Full
Fixture 1 + Houselights 1
Plugin "Rem Dim"
```

Result:
Fixture 2 Thru 10 + Houselights 2 Thru 10 At 0

*Only Fixture selected but Rem Dim all patched fixtures*
```
Fixture 1 thru 10  + Channel 1 thru 10 At Full
Fixture 1
Plugin "Rem Dim" "All"
```
Result:
Fixtures 2 Thru 10 + Channel 2 Thru 10 At 0

### Releases:
- 1.1.0.1 - Initial Release

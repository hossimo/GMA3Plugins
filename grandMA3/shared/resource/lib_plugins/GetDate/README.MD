# GetDate
*v1.5.2.3.1*

Please note that this will likely break in future version of the console. and to use at your own risk.

When called returns the current UTC time into the DATE User Variable.

The Plugin/Function uses Lua's `os.date(format)` to retrieve and format the date and time.

### Parameters:
format - if nil will use the format YYYY-MM-DD or use https://www.lua.org/pil/22.1.html
code | description
--   |  -- 
%a	 | abbreviated weekday name (e.g., Wed)
%A	 | full weekday name (e.g., Wednesday)
%b	 | abbreviated month name (e.g., Sep)
%B	 | full month name (e.g., September)
%c	 | date and time (e.g., 09/16/98 23:48:10)
%d	 | day of the month (16) [01-31]
%H	 | hour, using a 24-hour clock (23) [00-23]
%I	 | hour, using a 12-hour clock (11) [01-12]
%M	 | minute (48) [00-59]
%m	 | month (09) [01-12]
%p	 | either "am" or "pm" (pm)
%S	 | second (10) [00-61]
%w	 | weekday (3) [0-6 = Sunday-Saturday]
%x	 | date (e.g., 09/16/98)
%X	 | time (e.g., 23:48:10)
%Y	 | full year (1998)
%y	 | two-digit year (98) [00-99]
%%	 | the character `%´

### Note:
* At the moment the format argument is not validated.

### Usage:
* Can be called as a Plugin:

    `Call Plugin "GetDate"` or `Call Plugin "GetDate" "%Y-%m-$d %H:%M:%S"`
    ![Example Image](https://github.com/hossimo/GMA3Plugins/blob/master/Images/GetDateUsedAsPlugin.png)

* Or as a function directly on the Command Line:

    `Lua 'GetDate()'` or `Lua 'GetDate("%Y-%m-$d %H:%M:%S")'`
    ![Example Image](https://github.com/hossimo/GMA3Plugins/blob/master/Images/GetDateUsedFromScript.png)

* Or as a function call within your own Plugins:

```lua
    local function main
        Printf("The Current Date is " .. GetDate())
    end
    return main
```

### Releases:
- 1.5.2.3.1 - Initial Release

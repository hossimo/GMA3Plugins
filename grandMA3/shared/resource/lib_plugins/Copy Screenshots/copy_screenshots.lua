--[[
Copy Screenshots v1.0.0.3
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage:
* Call Plugin "Copy Screenshots"
* Will any screen shots (with the name *display*.png) to all connected USB sticks
  in the folder grandMA3\shared\resource\lib_images

Issues:
* The console currently enumerates all disk connected to the console including 
  pervious versions (?) This may cause some skipped files even with the USB key
  dot not include the selected file
* The copied files are not checked for consistancy, this could be done but did
  not seem nessassary
* If a file exists on a key with the exact name the fill will be skipped and noted
  in the System Monitor
* if the key does not have the grandMA3 folder structure the copy will fail and all
  files will be skipped. Store a show to the stick first.

Releases:
1.0.0.1 - Inital release
1.0.0.2 - Fixed a path parsing bug causing the plugin to not work on the console.
1.0.0.3 - Makeing functions local


MIT License

Copyright (c) 2020 Down Right Technical Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]


local pluginName    = select(1,...);
local componentName = select(2,...); 
local signalTable   = select(3,...);
local my_handle     = select(4,...);

-- ****************************************************************
-- speed up global functions, by creating local cache 
-- this can be very important for high speed plugins
-- caring about performance is imperative for plugins with execute function
-- ****************************************************************

local F=string.format;
local E=Echo;

-- Local Functions
local split, copyFileToUSB

-- ****************************************************************
-- plugin main entry point 
-- ****************************************************************

local function Main(display_handle,argument)
    local sep = package.config:sub(1,1)
    local lib_images = GetPathOverrideFor("lib_images", "") .. sep -- MaLightingTechnology\gma3_1.0.0\shared\resource\lib_images\
    local destination_path = ""
    local files = {}
    E("lib_images Path: " .. (lib_images or "<NONE>"))

    local pfile
    if (sep == "\\") then
        pfile = io.popen('dir /B "'.. lib_images ..'"*display*.png')
            for filename in pfile:lines() do
                files[filename] = lib_images..filename
            end
        else
        pfile = io.popen('ls "'.. lib_images .. '"*display*.png')
            for filename in pfile:lines() do
                local file = split(filename,"/")

                files[file[#file]] = filename -- file listing includes full path, just use the first last part
            end
        end

    -- files to copy

    -- get someone else to do it.
    local result = copyFileToUSB(files, true)
end

-- ****************************************************************
-- plugin exit cleanup entry point 
-- ****************************************************************

local function Cleanup()
end

-- ****************************************************************
-- plugin execute entry point 
-- ****************************************************************

local function Execute(Type,...)
	local func=signalTable[Type];
	if(func) then
		func(signalTable,...);
	else
		local debug_text=string.format("Execute %s not supported",Type);
		E(debug_text);
	end
end

function signalTable:Key(Status,Source,Profile,Token)
	local debug_text=F("Execute Key (%s) %s UserProfile %d : %s",Status,Source,Profile,Token);
	E(debug_text);
end

function signalTable:Fader(Status,Source,Profile,Token,Value)
	local debug_text=F("Execute Fader (%s) %s UserProfile %d : %s %f",Status,Source,Profile,Token,Value);
	E(debug_text);
end

-- ****************************************************************
-- Local Functions
-- ****************************************************************

-- split
function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function copyFileToUSB(sourceFiles, overwrite)
    local sep = package.config:sub(1,1) -- windows or linux paths
    local usbFound = false
    local copyCount = 0
    local skipCount = 0

    for k, v in pairs(sourceFiles) do
        --Echo("srcFileHandle: %s", v)
        local srcFileHandle = assert(io.open(v, "r"))
        local fileContent = srcFileHandle:read("*all")

        for i, d in ipairs(Root().Temp.DriveCollect) do
            -- i == 1 --> Local
            -- i >= 2 --> not local
            -- not confidant how this works yet but it seems the first and last index are the desk itself.
            -- Only skipping the first as MA does, this will cause a number of skips when the file already on the desk.
            if i ~= 1 then
                local path = d.path
                local exportFilePath = GetPathOverrideFor("lib_images", path) .. sep
                local file = io.open(exportFilePath .. k, "r")
                if overwrite and  file ~= nil then 
                    E("Skipping Existing: %s", exportFilePath)
                    skipCount = skipCount + 1
                    io.close(file)
                    goto continue
                end


                local file, err = io.open(exportFilePath .. k, "w+")
                if file then
                    assert(file:write(fileContent))
                    io.close(file)
                    copyCount = copyCount + 1
                    E("Wrote: %s -> %s", k, exportFilePath .. k)
                    -- files are kind of large, lets sync once at the end.
                    --SyncFS();
                    usbFound = true
                else
                    E("Error opening file %s : %s", k, tostring(err))
                end
            end
            ::continue::
        end
    end
    if copyCount == 0 and skipCount == 0 then
        Printf("Copy Screenshots: Nothing to copy.")
    elseif copyCount > 0 then
        SyncFS()
        Printf("Copy Screenshots: Copied %d, Skipped %d Details in System Monitor", copyCount, skipCount)
    elseif copyCount == 0 and skipCount == 1 then
        Printf("Copy Screenshots: Nothing to copy, all %d file(s) skipped", skipCount)
    else
        Printf("Copy Screenshots: Nothing to copy, %d file skipped", skipCount)
    end
end


-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************

return Main,Cleanup,Execute

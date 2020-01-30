--[[
Assign AutoStart Fix v1.0.0.1

Please note that this will likly break in future version of the console. and to use at your own risk.

This plugin applys a [workaround](https://forum.malighting.com/thread/3712-playbacks/?postID=8769) to AutoStart always running the next cue even when the executor is already active.

Usage:
* Call Plugin "Assign AutoStart Fix" "2" - Assigns the Macos to Sequence 2
* Call Plugin "Assign AutoStart Fix" "1,10-11" - Assigns the Macos to Sequence 1, 10 and 11
* Calling the plugin without a argument will popup a Dialog asking for the Sequences.


Issues:
***NOTE: This will OVERWRITE any CMD's in the Selected Sequences CueZero and OffCue!***
* Does not currently check if the Sequence exists, probably no need since when the issue gets fixed this plugin will be depricated.

Releases:
* 1.0.0.1 - Inital release


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


-- ****************************************************************
-- plugin main entry point 
-- ****************************************************************

local function Main(display_handle,argument)
	local input = ""

	if argument ~= null then
		-- got an inline argument
		input = argument
	else
		-- no argument prompt in the UI
		input = TextInput("Enter Sequance Number or range (e.g. 1,2-4)")
	end
	
	local sequances = calculateRange(input)
	if sequances == nil then
		Echo("No Valid Ranges")
		return
	end

	-- use our returned sequences to insert the CueZero and CueEnd Macros

	for k, v in pairs(sequances) do
		Echo("%d", v)
	-- make sure object exists!
	-- assign the macros
	local cmdString = string.format('Set Seq %d "CmdEnable" "Yes"', v)
	Cmd(cmdString)
	cmdString = string.format('Set Seq %d Cue 0 "Cmd" "Set Seq %d AutoStart No"', v, v)
	Cmd(cmdString)
	cmdString = string.format('Set Seq %d Cue "OffCue" "Cmd" "Set Seq %d AutoStart Yes"', v, v)
	Cmd(cmdString)
	end
end

-- calculateRange
function calculateRange(input)
	-- first split on ","
	local seqSplit = split(input, ",")
	local returnList = {}

	if #seqSplit == 0 then
		Printf("No Sequences Found, Exiting")
		return null
	elseif #seqSplit > 0 then
		for k, v in pairs(seqSplit) do
			if string.find(v, "-") ~= nil then
				-- found a range
				local inputRange = split(v, "-")
				local inputStart = math.floor(tonumber(inputRange[1]))
				local inputEnd = math.floor(tonumber(inputRange[2]))

				if inputStart < inputEnd then
					--input the range into the table
					for i = inputStart, inputEnd do
						table.insert (returnList, i)
					end
				else
					--range is invalid, skip it.
				end
				
			else
				-- just a value
				local item = math.floor(tonumber(v))
				if item ~= null then
					table.insert (returnList, item)
				end
			end
		end
	end
	if #returnList == 0 then
		return null
	else 
		return returnList		
	end
end

-- split
-- why is there no split in lua?
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
-- return the entry points of this plugin : 
-- ****************************************************************

return Main,Cleanup,Execute

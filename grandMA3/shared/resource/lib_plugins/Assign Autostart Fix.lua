--[[
Assign AutoStart Fix v1.1.0.1
See README.md for more information

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

	if argument ~= nil then
		-- got an inline argument
		input = argument
	else
		-- no argument prompt in the UI
		input = TextInput("Enter Sequence Number or range (e.g. 1,2-4)")
	end
	
	local sequences, stringSequences = Drt.calculateRange(input)
	if sequences == nil then
		Echo("No Valid Ranges")
		return
	end

	-- create an undo session.
	local undo = CreateUndo("Adding Macros AutoStart Macros to Sequences " .. stringSequences)
	
	-- use our returned sequences to insert the CueZero and CueEnd Macros
	for k, v in pairs(sequences) do
		-- make sure object exists!
		-- assign the macros
		local cmdString = string.format('Set Seq %d "CmdEnable" "Yes"', v)
		Cmd(cmdString, undo)
		cmdString = string.format('Set Seq %d Cue 0 "Cmd" "Set Seq %d AutoStart No"', v, v)
		Cmd(cmdString, undo)
		cmdString = string.format('Set Seq %d Cue "OffCue" "Cmd" "Set Seq %d AutoStart Yes"', v, v)
		Cmd(cmdString, undo)
	end
	CloseUndo(undo)
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
end

-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************
return Main,Cleanup,Execute

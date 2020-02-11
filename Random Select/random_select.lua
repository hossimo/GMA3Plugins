--[[
Random Select v1.0.0.2
Please note that this will likly break in future version of the console. and to use at your own risk.

Usage:
* Select some fixtures
* Call Plugin "Random Select"
* Your selection is now in a random order, if you don't like the order call the selection again.

Releases:
1.0.0.1 - Inital release
1.0.0.2 - Makeing functions local


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

-- local functions forward decloration
local SelectionToArray

-- ****************************************************************
-- plugin main entry point 
-- ****************************************************************

local function Main(display_handle,argument)
	local selection = SelectionToArray(true)
	
	if (#selection) == 0 then
		Echo("No Selection")
		return
	end

	Cmd("Clear")
	local selcetionString = ""
	for k in pairs(selection) do
		selcetionString = selcetionString .. GetSubfixture(selection[k]).FID

		if #selection ~= k then
			selcetionString = selcetionString .. " + "
		end
	end
	Cmd("Fixture " .. selcetionString)
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
--Thanks MA, this is really helpful. I added a random option.
function SelectionToArray(random)
	random = random or false

	local selectedFixtures = {};
	local sfIdx = SelectionFirst (true);

	while (sfIdx ~= nil)
	do
		if random == true then
			local key = tostring(math.random())
			selectedFixtures[key] = sfIdx;
		else
			selectedFixtures[#selectedFixtures + 1] = sfIdx;
		end
		sfIdx = SelectionNext(sfIdx, true);
	end

	-- if we are in random mode we would like to short the keys to the result is random.
	if random == true then
		math.randomseed(os.time())
		math.random() -- chuck the fist one away just in case.

		local keys = {}
		
		-- grab our random keys
		for k in pairs(selectedFixtures) do
			table.insert(keys, k)
		end
		
		-- sort them
		table.sort(keys)

		-- make a new selection table with our sorted randomness
		local sortedSelection = {}

		for i, k in ipairs(keys) do
			table.insert(sortedSelection, selectedFixtures[k])
		end
		return sortedSelection -- return our random selection
	end
	return selectedFixtures -- return our default selection
end


-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************

return Main,Cleanup,Execute

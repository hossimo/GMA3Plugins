--[[
Random Select v1.1.0.1
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
	local selection = Drt.SelectionToArray(true)
	
	if (#selection) == 0 then
		Echo("No Selection")
		return
	end

	Cmd("Clear")
	local selcetionString = ""
	for k in pairs(selection) do
		selcetionString = selcetionString .. Drt.calculateSFID(selection[k])

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
end

-- ****************************************************************
-- return the entry points of this plugin : 
-- ****************************************************************
return Main,Cleanup,Execute

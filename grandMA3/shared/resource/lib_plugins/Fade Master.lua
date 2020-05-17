--[[
MIT License

Copyright (c) 2019 Down Right Technical Inc.

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


-- ****************************************************************
-- speed up global functions, by creating local cache 
-- this can be very important for high speed plugins
-- caring about performance is imperative for plugins with execute function
-- ****************************************************************

local F=string.format;
local E=Echo;

local pluginName = select(1,...);
local componentName = select(2,...);
local signalTable = select(3,...);
local my_handle = select(4,...);

-- local functions
--local

-- ****************************************************************
-- plugin main entry point
-- ****************************************************************
local function Main (display_handle, argument)
    local arguments = Drt.split(argument, ",")
    local tick = 1/30       -- updates / second
    local MAXTIME = 3600.0  -- the max number of seconds
    local MAXPOOL = 9999    -- the max number of pool items
    local op = ""           -- the object we are operating on
    local destPage          -- the page asked for
    local destExec          -- the executor on the page
    local destSeq           -- the sequence
    local faderEnd          -- the end value for the fader
    local faderTime = 0     -- the time to run
    local execObject = nil
    local v = UserVars()
    local gVarName = ""

    -- Grab inputs based on the number of arguments
    -- we will validate them later.
    if argument == nil then
        -- ask through dialog
        local messageBoxInputs = {
            "Page.Exec # or\nSequence #",
            "Level (%)",
            "Time (S)"
        }

        local messageBoxOptions = {
            title="Fade Master Options",
            message="",
            commands = {
                {value=0, name="Cancel"},
                {value=1, name="OK"}
            },
            inputs = {
                {name=messageBoxInputs[1], vkPlugin="TextInputNumOnlyRange"},
                {name=messageBoxInputs[2], vkPlugin="TextInputNumOnlyRange"},
                {name=messageBoxInputs[3], vkPlugin="TextInputNumOnlyRange"}
            }
        }
        local result = MessageBox(messageBoxOptions)
        if result.result == 0 then
            return
        end

        local x = Drt.split(result.inputs[messageBoxInputs[1]], ".")
        if #x == 1 then
            op = "Sequence"
            destSeq = tonumber(x[1])
        elseif #x == 2 then
            op = "Page"
            destPage = tonumber(x[1])
            destExec = tonumber(x[2])
        else
            ErrPrintf("Incorrect Sequence/Page Identifier")
            return
        end

        faderEnd = result.inputs[messageBoxInputs[2]]
        faderTime = result.inputs[messageBoxInputs[3]]

    elseif #arguments == 3 then
        -- [1]page/seq [2]level [3]time
        faderEnd = tonumber(arguments[2])
        faderTime = tonumber(arguments[3])

        local x = Drt.split(arguments[1], ".")
        if #x == 1 then
            op = "Sequence"
            destSeq = tonumber(x[1])
        elseif #x == 2 then
            op = "Page"
            destPage = tonumber(x[1])
            destExec = tonumber(x[2])
        else
            ErrPrintf("Incorrect Sequence/Page Identifier")
            return
        end
    elseif #arguments == 4 then
        -- [1]"Page"/"Seq" [2]page/seqID [3]level [4]time
        faderEnd = tonumber(arguments[3])
        faderTime = tonumber(arguments[4])

        if string.lower(arguments[1]):sub(1, 3) == "seq" then       -- Operate on a Sequence
            op = "Sequence"
            destSeq = tonumber(arguments[2])
        elseif string.lower(arguments[1]):sub(1, 3) == "pag" then   -- Operate on a Page
            op = "Page"
            local x = Drt.split(arguments[2], ".")
            if #x == 2 then
                destPage = tonumber(x[1])
                destExec = tonumber(x[2])
            else
                ErrPrintf("Incorrect Page Identifier; Page.Ecexutor")
                return
            end
        end
    else
        ErrPrintf("Incorrect number of arguments")
        ErrPrintf("Plugin \"Fade Master\" \"<Page|Sequence>, <Page#.Executor# | Sequence#>, <Level>, <Seconds> \"")
        return
    end


    -- check our inputs
    if tonumber(faderEnd) == nil then
        ErrPrintf("Incorrect level, Enter a value between 0.0 and 100.0")
        return
    else
        faderEnd = Drt.clamp(tonumber(faderEnd), 0.0, 100.0)
    end
    if tonumber(faderEnd) == nil then
        ErrPrintf("Incorrect time, Enter Seconds between 0.0 and " .. MAXTIME)
        return
    else
        faderTime = Drt.clamp(tonumber(faderTime), 0.0, MAXTIME)
    end

    if op == "Sequence" then
        if destSeq == nil then
            Printf("Invalid Page Number, Enter a number between 1 and " .. MAXPOOL)
        else
            destSeq = Drt.clamp(destSeq, 1, MAXPOOL)
        end
    elseif op == "Page" then
        if destPage == nil then
            Printf("Invalid Sequence Number, Enter a number between 1 and " .. MAXPOOL)
        else
            destPage = Drt.clamp(destPage, 1, MAXPOOL)
        end
        if destExec == nil then
            Printf("Invalid Executor Number, Enter a Page.Executor, e.g: 1.201")
        end
    end

    -- setup exec and UserVars
    if op == "Sequence" then
        gVarName = "FM".."S"..destSeq
        execObject = DataPool().sequences:Children()[destSeq]
    elseif op == "Page" then
        gVarName = "FM".. "P"..destPage.."."..destExec
        local executors = DataPool().Pages:Children()[destPage]:Children()
        for key, value in pairs(executors) do
            if value.No == destExec then
                Echo("Found " .. value.Name)
                execObject = value
            end
        end
    end

    if GetVar(v, gVarName) ~= nil then
        Printf("Exitting, Fade Master already running on " .. gVarName)
        return
    end

    if execObject == nil then
        if op == "Sequence" then
            ErrPrintf("Sequence %d not found, Exitting", destSeq)
        elseif op == "Page" then
            ErrPrintf("Executor %d not found on page %d, Exitting", destExec, destPage)
        end
        return
    else
        -- store the current faders position
        local faderOptions = {}
        faderOptions.value = faderEnd
        faderOptions.token = "FaderMaster"
        faderOptions.faderDisabled = false;

        local faderStart = execObject:GetFader(faderOptions)
        local distance = faderStart - faderEnd

        -- Start momement session
        SetVar(v, gVarName, true)

        if faderTime > 0  and math.abs(distance) > 0 then
            if op == "Sequence" then
                Printf("Running Fade Master on Sequence %d for %d Seconds. To abort - DelUserVar \"%s\"", destSeq, faderTime, gVarName)
            elseif op == "Page" then
                Printf("Running Fade Master on Page %d.%d for %d Seconds. To abort - DelUserVar \"%s\"", destPage, destExec, faderTime, gVarName)
            end
            local interval = (distance * tick)/faderTime
            repeat
                local faderCurrent = execObject:GetFader(faderOptions)
                faderOptions.value = faderCurrent - interval
                execObject:SetFader(faderOptions)
                coroutine.yield(tick)
                if GetVar(v, gVarName) == nil then
                    Printf("Exitting ".. gVarName .. " due to Variable Deletion")
                    return
                end
            until math.abs(faderOptions.value - faderEnd) <= math.abs(interval)
            end

            faderOptions.value = faderEnd
            execObject:SetFader(faderOptions)

        -- End momement session
        DelVar(v, gVarName)

        Printf("Fade Master ".. gVarName .." Done")
    end
end
return Main
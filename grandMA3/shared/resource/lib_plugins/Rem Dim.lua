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

local pluginName = select(1,...);
local componentName = select(2,...);
local signalTable = select(3,...);
local my_handle = select(4,...);

-- local functions
local compressSelection, findFreeGroup

-- ****************************************************************
-- plugin main entry point
-- ****************************************************************
local function Main (display_handle, argument)
    local MODE = string.lower("all")
    argument = string.lower(argument or "")

    if argument == MODE then
        Printf("Rem Dim All Fixtures")
    else
        Printf("Rem Dim Selected Types")
    end

    local selectionTypeID = {}          -- table of [Types][IDs]
    local dimTypeID = {}                -- list of ID's to Dim.
    local undo = CreateUndo("Rem Dim")  -- undo session

        -- store our current selection to a free group
        local group = findFreeGroup()
        if group == nil then
            Printf("Error Finding free group. Exitting.")
            return
        end
        Cmd(("Store Group " .. group), undo)

    -- first we need a list of IDtypes to work with.
    local sel = SelectionFirst()
    if sel == nil then
        Printf("Exitting, nothing selected.")
        return
    end
    while sel do
        if GetSubfixture(sel).IDType ~= "Global" then
            local subfixtureID = GetSubfixture(sel).IDType
            local selOffset = GetSubfixture(sel)
            if GetSubfixture(sel):GetClass() == "SubFixture" then
                -- If selected fixture is a "SubFixture", traverse up until it's not.
                -- _Should_ be safe.
                repeat
                    selOffset = selOffset:Parent()
                until selOffset:GetClass() ~= "SubFixture"
                subfixtureID = selOffset.IDType
            end
            -- create empty tables for selected and to dim fixtures
            if selectionTypeID[subfixtureID] == nil then
                selectionTypeID[subfixtureID] = {}
                dimTypeID[subfixtureID] = {}
            end

            -- store the selected FID or CID
            if GetSubfixture(sel).FID ~= nil then
                selectionTypeID[subfixtureID][sel] = true
            elseif GetSubfixture(sel).CID ~= nil then
                selectionTypeID[subfixtureID][sel] = true
            end
        end
        sel = SelectionNext(sel)
    end

    -- invert the selectionTypeID based on argument.
    -- always skip the universal fixture (start on id 1)
    for i = 1, GetSubfixtureCount() - 1, 1 do
        local currentSelection = selectionTypeID[GetSubfixture(i).IDType]
        if GetSubfixture(i).IDType ~= "Global" then
            if argument == "" then
                -- Only the same Types IDs as selected
                if currentSelection ~= nil and currentSelection[i] ~= true then
                    dimTypeID[GetSubfixture(i).IDType][i] = true
                end
            elseif argument == MODE then
                if GetSubfixture(i).IDType ~= nil then
                    if dimTypeID[GetSubfixture(i).IDType] == nil then
                        dimTypeID[GetSubfixture(i).IDType] = {}
                    end
                    if currentSelection == nil or currentSelection[i] ~= true then
                        dimTypeID[GetSubfixture(i).IDType][i] = true
                    end
                end
            end
        end
    end

    -- build the commandline
    local cmdLine = ""
    for key, value in pairs(dimTypeID) do
        local compressString = compressSelection(value, key)
        if compressString ~= nil then
            cmdLine = cmdLine .. key .. " " .. compressString .. " + "
        end
    end

    if #cmdLine == 0 then
        Printf("Nothing to do.")
    else
        cmdLine = cmdLine:sub(1, -4) .. " At 0"
        Cmd("Clear", undo)
        Cmd(cmdLine, undo)
    end

    -- restore your pervious selection
    Cmd("Clear", undo)
    Cmd(("SelFix Group " .. group), undo)
    Cmd(("Delete Group " .. group), undo)

    CloseUndo(undo)
end


-- ****************************************************************
-- Cleanup (placeholder)
-- ****************************************************************
local function Cleanup()
end

-- ****************************************************************
-- Execute (placeholder)
-- ****************************************************************
local function Execute(Type, ...)
end

-- ****************************************************************
-- Local Functions
-- ****************************************************************
function compressSelection(input, Type)

    local r = ""
    local divider = ""
    local previous = nil
    local orderedKeys = {}
    for key, value in pairs(input) do
        table.insert(orderedKeys, key)
    end
    table.sort(orderedKeys)


    local startRun = -1
    local endRun = -1
    for key, value in pairs(orderedKeys) do
        local id
        if Type == "Fixture" then
            id = tonumber(GetSubfixture(value).FID)
        else
            id = tonumber(GetSubfixture(value).CID)
        end

        if previous == nil then -- first one.
            previous = id
        elseif startRun == -1 and (id - 1) == previous then --not started a thru and next in sequence
            startRun = previous
        elseif startRun == -1 and (id -1) ~= previous then  --not started a thru and not next in sequence
            r = r .. previous .. " + "
        elseif startRun ~= -1 and (id - 1) ~= previous then --started a thru and not next in sequence
            endRun = previous
        end

        if startRun ~= -1 and endRun ~= -1 then             -- if we are done a thru then append it.
            r = r .. startRun .. " Thru " .. endRun .. " + "
            startRun = -1
            endRun = -1
        end

        previous = id
    end

    if previous == nil then
        return nil
    end

    if startRun ~= -1 then
        r = r .. startRun .. " Thru " .. previous
    else
        r = r .. previous
    end
    return r
end

function findFreeGroup()
    local index = 0
    local group
    repeat
        index = index + 1
        group = DataPool().Groups[index]
    until group == nil or index == 10000
    if index == 10000 then
        index = nil
    end
    return index
end

return Main, Cleanup, Execute
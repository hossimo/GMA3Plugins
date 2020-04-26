--[[
AppearanceBuilder v1.1.0.3
See README.md for more information

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

-- Enter Names for colors, Add your own in the following format
-- {{r, g, b,"NAME"}}
-- r, g and b are between 0 and 255
local names = {
    {{0  ,  0,  0},"Black"},
    {{255,  0,  0},"Red"},
    {{0  ,255,  0},"Green"},
    {{0  ,  0,255},"Blue"},

    {{0  ,255,255},"Cyan"},
    {{255,255,  0},"Yellow"},
    {{255,  0,255},"Magenta"},

    {{255,127,  0},"Orange"},
    {{127,255,  0},"Lime"},
    {{  0,255,127},"Sea Foam"},
    {{  0,127,255},"Lt Blue"},
    {{127,  0,255},"Purple"},
    {{255,  0,127},"Hot Pink"},

    {{255,255,255},"White"}
}

-- local functions
local split, clamp, toRGB, getColorName

-- ****************************************************************
-- plugin main entry point 
-- ****************************************************************
local function Main (display_handle, argument)
    local arguments

    local count
    local fillS
    local fillB
    local outlineS
    local outlineB
    local appearanceStartIndex
    local macroStartIndex
    local inline = false
    local continueString
    local overwrite = false


    if argument == nil then
        Printf("Usage:")
        Printf('Call Plugin AppearanceBuilder "<COUNT 1 - 360>, [Fill Saturation 0 - 1], [Fill Brightness 0 - 1], [Outline Saturation 0 - 1], [Outline Brightness 0 - 1], [Appearance Start Index 1 - 10000], [Macro Start Index 1 - 10000]"');
        Printf('All options except for COUNT are optional, and will choose some defaults')

        -- Gather information using MessageBox()

        local messageBoxQuestions = {
            "Count",
            "Fill Saturation\n(0.0 - 1.0)",
            "Fill Brightness\n(0.0 - 1.0)",
            "Outline Saturation\n(0.0 - 1.0)",
            "Outline Brightness\n(0.0 - 1.0)",
            "Appearance Index\n(1 - 9999)",
            "Macro Index\n(1 - 9999)",
            "Overwrite"
        }
        local wfInt = "0123456789"
        local wfFloat = "0123456789."
        local messageBoxOptions = {
            title="AppearanceBuilder",
            backColor=nil,
            timeout=nil,
            timeoutResultCancel=false,
            timeoutResultID=nil,
            icon=nil,
            titleTextColor=nil,
            messageTextColor=nil,
            message="Please enter the following information",
            display= nil,
            commands={
                {value=1, name="Done"},
                {value=0, name="Cancel"}
            },
            inputs={
                -- black and white filters don't seem to work with non TextInput fields
                -- NumericInput does not have "."
                -- Therefore need to remove the the following from the result "/-+Thru %=*"
                {name=messageBoxQuestions[1], value="", maxTextLength = 4, vkPlugin = "TextInputNumOnly", whiteFilter = wfInt},
                {name=messageBoxQuestions[2], value="1.0", maxTextLength = 5, vkPlugin = "NumericInput", whiteFilter = wfFloat},
                {name=messageBoxQuestions[3], value="1.0", maxTextLength = 5, vkPlugin = "NumericInput", whiteFilter = wfFloat},
                {name=messageBoxQuestions[4], value="1.0", maxTextLength = 5, vkPlugin = "NumericInput", whiteFilter = wfFloat},
                {name=messageBoxQuestions[5], value="1.0", maxTextLength = 5, vkPlugin = "NumericInput", whiteFilter = wfFloat},
                {name=messageBoxQuestions[6], value="101", maxTextLength = 5, vkPlugin = "TextInputNumOnly", whiteFilter = wfInt},
                {name=messageBoxQuestions[7], value="101", maxTextLength = 5, vkPlugin = "TextInputNumOnly", whiteFilter = wfInt}
            },
            states={
                {name=messageBoxQuestions[8], state = true},
            }
        }
        local messageBoxResult = MessageBox(messageBoxOptions);
        --tableToString(messageBoxResult)
        overwrite = messageBoxResult["states"][messageBoxQuestions[8]];

        -- get inputs
        count = clamp(math.floor(tonumber(messageBoxResult["inputs"][messageBoxQuestions[1]]) or 0), 0, 360)
        if count == 0 or messageBoxResult["result"] == 0 then
            return
        end
        -- have to filter out the numbers because non text inputs dont respect the black/white Filters.
        local v = "[^0123456789.]"

        fillS = string.gsub(messageBoxResult["inputs"][messageBoxQuestions[2]], v, "") -- valid characters only
        fillS = clamp(tonumber(fillS) or 1.0, 0.0, 1.0)

        fillB = string.gsub(messageBoxResult["inputs"][messageBoxQuestions[3]], v, "")
        fillB = clamp(tonumber(fillB) or 1.0, 0.0, 1.0)

        outlineS = string.gsub(messageBoxResult["inputs"][messageBoxQuestions[4]], v, "")
        outlineS = clamp(tonumber(outlineS) or 1.0, 0.0, 1.0)

        outlineB = string.gsub(messageBoxResult["inputs"][messageBoxQuestions[5]], v, "")
        outlineB = clamp(tonumber(outlineB) or 1.0, 0.0, 1.0)

        appearanceStartIndex = clamp(tonumber(messageBoxResult["inputs"][messageBoxQuestions[6]]) or 101, 1 ,9999)
        macroStartIndex = clamp(tonumber(messageBoxResult["inputs"][messageBoxQuestions[7]]) or 101, 1 ,9999)
        local overwriteString
        if overwrite == 1 then
            overwriteString = "Yes"
        else
            overwriteString = "No"
        end

        continueString = string.format("Continue? Count: %d\nFill Saturation: %f\nFill Brightness: %f\nOutline Saturation: %f\nOutline Brightness: %f\nAppearance Start Index: %d\nMacro Start Index: %d\nOverwrite: %s", count, fillS, fillB, outlineS, outlineB, appearanceStartIndex, macroStartIndex, overwriteString)
    else
        -- sanatize our inputs
        arguments = split(argument, ",")
        --count (int)
        count = clamp(math.floor(tonumber(arguments[1]) or 15 ), 1, 360)

        -- fill saturation (float)
        fillS = clamp(tonumber(arguments[2]) or (1.0 + .0), 0.0, 1.0)

        -- fill brightness (float)
        fillB = clamp(tonumber(arguments[3]) + .0, 0.0, 1.0) or 1.0

        --outline saturation (float)
        outlineS = clamp(tonumber(arguments[4]) + .0, 0.0, 1.0) or fillS

        -- outline brightness (float)
        outlineB = clamp(tonumber(arguments[5]) + .0, 0.0, 1.0) or fillB

        -- appearanceStartIndex (int)
        appearanceStartIndex = clamp(math.floor(tonumber(arguments[6]) or 101),1,10000)

        -- appearanceStartIndex (int)
        macroStartIndex = clamp(math.floor(tonumber(arguments[7]) or appearanceStartIndex),1,10000)

        inline = true
    end



    if inline == false then
        local c = Confirm("Continue?", continueString)
        if c ~= true then
            Printf("Exiting Plugin")
            return
        end
    end

    local undo = CreateUndo("Appearance Builder")

    local fillIncrement = 1 / count
    local appearanceIndex = appearanceStartIndex
    local macroIndex = macroStartIndex

    -- loop thru count, hack to not include 1 in the loop
    for i = 0, 1-0.001, fillIncrement do
        local a = 1.0
        local rf, gf, bf, namef = toRGB(i, fillS, fillB)
        local ro, go, bo, nameo = toRGB(i, outlineS, outlineB)

        -- Overwrite Appearances
        local buildAppearances
        local currentAppearance = Root().ShowData.Appearances[appearanceIndex] --index number, nil if not exists
        if overwrite == 1 then
            buildAppearances = true
        elseif overwrite == 0  and currentAppearance == nil then
            buildAppearances = true
        else
            buildAppearances = false
        end

        if (buildAppearances == true) then
            -- build Appearances
            local command = ""
            if nameo == nil then
                command = string.format('Set Appearance %d Property "Color" "%f,%f,%f,%f" "BackR" "%d" "BackG" "%d" "BackB" "%d" "BackAlpha" "%d"',
                    appearanceIndex,
                    rf,
                    gf,
                    bf,
                    a,
                    math.floor(ro * 255),
                    math.floor(go * 255),
                    math.floor(bo * 255),
                    math.floor(a * 255))
            else
                command = string.format('Set Appearance %d Property "Color" "%f,%f,%f,%f" "BackR" "%d" "BackG" "%d" "BackB" "%d" "BackAlpha" "%d" "Name" "%s"',
                    appearanceIndex,
                    rf,
                    gf,
                    bf,
                    a,
                    math.floor(ro * 255),
                    math.floor(go * 255),
                    math.floor(bo * 255),
                    math.floor(a * 255),
                    nameo)
            end
            Cmd("Store Appearance " .. appearanceIndex, undo) --store it first to make sure we have something to set.
            Cmd(command, undo)
        end

        -- build macros
        -- Overwrite Macros
        --TODO: This should do an overwrite insted of a delete
        if overwrite == 1 then
            Cmd(string.format("Delete Macro %d /NC", macroIndex), undo)
        end

        Cmd("Store Macro " .. macroIndex, undo)
        Cmd("Assign Appearance " .. appearanceIndex .. " at Macro " .. macroIndex, undo)
        Cmd("CD Macro " .. macroIndex, undo)
        Cmd("Insert", undo) --TODO: HMM, how do I first delete all lines.
        Cmd(string.format('Set 1 Command "Assign Appearance %d at" ', appearanceIndex), undo)
        Cmd("Set 1 Execute no", undo)
        Cmd("CD Root", undo)
        local macroName = "Assign " .. (nameo or "Appearance")
        Cmd("Label Macro " .. macroIndex .. '"'.. macroName ..'"', undo)


        -- increment our indexes
        appearanceIndex = appearanceIndex + 1
        macroIndex = macroIndex + 1
    end
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

-- clamp
function clamp (input, min, max)
    local i = input
    if i < min then i = min end
    if i > max then i = max end
    return i
end

-- convert to RGB
function toRGB (h, s, v)
    -- stuff of magic https://stackoverflow.com/questions/17242144/javascript-convert-hsb-hsv-color-to-rgb-accurately
    if h == nil then h = 0 end
    if s == nil then s = 1.0 end
    if v == nil then v = 1.0 end

    local r = 0
    local g = 0
    local b = 0
    local name = nil
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1.0 - s)
    local q = v * (1.0 - f  * s)
    local t = v * (1.0 - (1.0 - f) * s)

    if (i % 6) == 0 then
        r = v
        g = t
        b = p
    elseif (i % 6) == 1 then
        r = q
        g = v
        b = p
    elseif (i % 6) == 2 then
        r = p
        g = v
        b = t
    elseif (i % 6) == 3 then
        r = p
        g = q
        b = v
    elseif (i % 6) == 4 then
        r = t
        g = p
        b = v
    elseif (i % 6) == 5 then
        r = v
        g = p
        b = q
    end

    -- need to round and clamp this!
    name = getColorName(r,g,b)
    return r, g, b, name
end

function getColorName (r, g, b, threshold)
    -- http://chir.ag/projects/ntc/ntc.js
    -- not fully implimented, needs to also check HSV values, but works for now.
    -- safty first
    r = r or 0
    g = g or 0
    b = b or 0
    threshold = threshold or 1500

    r = clamp(math.floor(r * 255), 0, 255)
    g = clamp(math.floor(g * 255), 0, 255)
    b = clamp(math.floor(b * 255), 0, 255)

    local bestScore = -1
    local bestIndex
    for k, v in pairs(names) do
        local cR = v[1][1];
        local cG = v[1][2];
        local cB = v[1][3];

        local score = ((r - cR)*(r - cR)) + ((g - cG)*(g - cG)) + ((b - cB)*(b - cB))
        
        if bestScore < 0 or bestScore > score then
            bestScore = score
            bestIndex = k
        end
    end
    --Echo("%s (%d)", names[bestIndex][2], bestScore)
    local result = nil
    if (bestScore < threshold) then
        result = names[bestIndex][2]
    end
    return result
end



return Main, Cleanup, Execute
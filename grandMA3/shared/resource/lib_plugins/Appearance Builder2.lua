local pluginName    = select(1,...);
local componentName = select(2,...); 
local signalTable   = select(3,...); 
local my_handle     = select(4,...);

local dialog

-- functions
local buildMenu, buildHeader, getColorName, toRGB, clamp, split, validateDialog

--global values
local builtInColors, colorNames


local validValues = {}
local isValid = false

local stateOverwrite = 0
local stateSystemColors = 1

local colorTransparent = Root().ColorTheme.ColorGroups.Global.Transparent


local function main()
    dialog = buildMenu(600, 600)
end

-- BUILD MENU
function buildMenu(width, height)
    local result = {}
    -- grab the focused display
    result.display = GetFocusDisplay()
    result.overlay = result.display.ScreenOverlay

    -- main dialog
    result.dialog = result.overlay:Append("BaseInput")
    result.dialog.Name = "Appearance Builder 2"
    result.dialog.Name = "Dialog Title"
    result.dialog.H = height
    result.dialog.W = width
    result.dialog.Rows = 2
    result.dialog.Columns = 1
    result.dialog[1][1].SizePolicy = "Fixed"
    result.dialog[1][1].Size = "60"
    result.dialog[1][2].SizePolicy = "Stretch"
    result.dialog.AutoClose = "No"
    result.dialog.CloseOnEscape = "Yes"

    --titlebar
    -- titlebar
    result.titleBar = result.dialog:Append("TitleBar")
    result.titleBar.Columns = 2
    result.titleBar.Rows = 1
    result.titleBar.Anchors = "0,0"
    result.titleBar[2][2].SizePolicy = "Fixed"
    result.titleBar[2][2].Size = "50"
    result.titleBar.Texture = "corner2"

    result.titleBarIcon = result.titleBar:Append("TitleButton")
    result.titleBarIcon.Text = "Appearance Builder"
    result.titleBarIcon.Texture = "corner1"
    result.titleBarIcon.Anchors = "0,0"
    result.titleBarIcon.Icon = "object_appear"

    result.titleBarCloseButton = result.titleBar:Append("CloseButton")
    result.titleBarCloseButton.Anchors = "1,0"
    result.titleBarCloseButton.Texture = "corner2"

    -- Create the dialog's main frame.
    result.dlgFrame = result.dialog:Append("DialogFrame")
    --dlgFrame.Padding ="5,5,5,0"
    result.dlgFrame.H = "100%"
    result.dlgFrame.W = "100%"
    result.dlgFrame.Columns = 1
    result.dlgFrame.Rows = 10

    -- Row 1
    result.Row1 = result.dlgFrame:Append("UILayoutGrid")
    result.Row1.Anchors = "0,0"
    result.Row1.Columns = 4
    result.Row1.Rows = 1
    result.Row1[2][1].SizePolicy = "Fixed"
    result.Row1[2][1].Size = "60"
    -- Brightness
    result.Row1[2][3].SizePolicy = "Fixed"
    result.Row1[2][3].Size = "60"

        -- label
        result.startLabel = result.Row1:Append("UIObject")
        result.startLabel.Anchors = "0,0"
        result.startLabel.Text = "Start"
        result.startLabel.Font = "Medium20"
        result.startLabel.HasHover = "No"
        result.startLabel.BackColor = colorTransparent
        result.startLabel.TextalignmentH = "Right"

        -- Start
        result.start = result.Row1:Append("LineEdit")
        result.start.Name="Start"
        result.start.Message="Start Index"
        result.start.Anchors = "1,0"
        result.start.Texture = "corner15"
        result.start.target = CurrentProfile()
        result.start.Focus = "InitialFocus"
        result.start.TextChanged="OnChange"
        result.start.PluginComponent = my_handle
        result.start.VKPluginName = "TextInputNumOnly"
        result.start.Filter = "1234567890"
        result.start.MaxTextLength = 5    

    -- label
    result.countLabel = result.Row1:Append("UIObject")
    result.countLabel.Anchors = "2,0"
    result.countLabel.Text = "Count"
    result.countLabel.Font = "Medium20"
    result.countLabel.HasHover = "No"
    result.countLabel.BackColor = colorTransparent
    result.countLabel.TextalignmentH = "Right"

    -- Count
    result.count = result.Row1:Append("LineEdit")
    result.count.Name="Count"
    result.count.Message="Number of Items"
    result.count.Anchors = "3,0"
    result.count.Texture = "corner15"
    result.count.target = CurrentProfile()
    result.count.Focus = "InitialFocus"
    result.count.TextChanged="OnChange"
    result.count.PluginComponent = my_handle
    result.count.VKPluginName = "TextInputNumOnly"
    result.count.Filter = "1234567890"
    result.count.MaxTextLength = 5
    ----------------------------------------------
    -- FILL
    ----------------------------------------------
    -- Header Fill
    buildHeader("Fill (0.0 - 1.0)", result.dlgFrame, "0,1")

    -- This is row 2 of the dlgFrame.
    result.Row3 = result.dlgFrame:Append("UILayoutGrid")
    result.Row3.Anchors = "0,2"
    result.Row3.Columns = 6
    result.Row3.Rows = 1
    result.Row3[2][1].SizePolicy = "Fixed"
    result.Row3[2][1].Size = "20"
    -- Brightness
    result.Row3[2][3].SizePolicy = "Fixed"
    result.Row3[2][3].Size = "20"
    -- Alpha
    result.Row3[2][5].SizePolicy = "Fixed"
    result.Row3[2][5].Size = "20"
    

    -- Saturation Label
    result.saturationLabel = result.Row3:Append("UIObject")
    result.saturationLabel.Anchors = "0,0"
    result.saturationLabel.Text = "S"
    result.saturationLabel.Font = "Medium20"
    result.saturationLabel.HasHover = "No"
    result.saturationLabel.BackColor = colorTransparent
    result.saturationLabel.TextalignmentH = "Right"

    -- Saturation
    result.fillSaturation = result.Row3:Append("LineEdit")
    result.fillSaturation.Name="FillSaturation"
    result.fillSaturation.Message="Saturation"
    result.fillSaturation.Anchors = "1,0"
    result.fillSaturation.Texture = "corner15"
    result.fillSaturation.target = CurrentProfile()
    result.fillSaturation.TextChanged="OnChange"
    result.fillSaturation.PluginComponent = my_handle
    result.fillSaturation.VKPluginName = "CueNumberInput"
    result.fillSaturation.Filter = "1234567890."
    result.fillSaturation.MaxTextLength = 5
    result.fillSaturation.Content = "1.0"

    -- Brightness Label
    result.brightnessLabel = result.Row3:Append("UIObject")
    result.brightnessLabel.Anchors = "2,0"
    result.brightnessLabel.Text = "B"
    result.brightnessLabel.Font = "Medium20"
    result.brightnessLabel.HasHover = "No"
    result.brightnessLabel.BackColor = colorTransparent
    result.brightnessLabel.TextalignmentH = "Right"

    -- Brightness
    result.fillBrightness = result.Row3:Append("LineEdit")
    result.fillBrightness.Name="FillBrightness"
    result.fillBrightness.Message="Brightness"
    result.fillBrightness.Anchors = "3,0"
    result.fillBrightness.Texture = "corner15"
    result.fillBrightness.target = CurrentProfile()
    result.fillBrightness.TextChanged="OnChange"
    result.fillBrightness.PluginComponent = my_handle
    result.fillBrightness.VKPluginName = "CueNumberInput"
    result.fillBrightness.Filter = "1234567890."
    result.fillBrightness.MaxTextLength = 5
    result.fillBrightness.Content = "1.0"


    -- Alpha Label
    result.alphaLabel = result.Row3:Append("UIObject")
    result.alphaLabel.Anchors = "4,0"
    result.alphaLabel.Text = "A"
    result.alphaLabel.Font = "Medium20"
    result.alphaLabel.HasHover = "No"
    result.alphaLabel.BackColor = colorTransparent
    result.alphaLabel.TextalignmentH = "Right"

    -- Alpha
    result.fillAlpha = result.Row3:Append("LineEdit")
    result.fillAlpha.Name="FillAlpha"
    result.fillAlpha.Message="Alpha"
    result.fillAlpha.Anchors = "5,0"
    result.fillAlpha.Texture = "corner15"
    result.fillAlpha.target = CurrentProfile()
    result.fillAlpha.TextChanged="OnChange"
    result.fillAlpha.PluginComponent = my_handle
    result.fillAlpha.VKPluginName = "CueNumberInput"
    result.fillAlpha.Filter = "1234567890."
    result.fillAlpha.MaxTextLength = 5
    result.fillAlpha.Content = "1.0"

    ----------------------------------------------
    -- OUTLINE
    ----------------------------------------------
    -- Header Outline
    buildHeader("Outline (0.0 - 1.0)", result.dlgFrame, "0,3")

    -- This is row 2 of the dlgFrame.
    result.Row5 = result.dlgFrame:Append("UILayoutGrid")
    result.Row5.Anchors = "0,4"
    result.Row5.Columns = 6
    result.Row5.Rows = 1
    -- Saturation
    result.Row5[2][1].SizePolicy = "Fixed"
    result.Row5[2][1].Size = "20"
    -- Brightness
    result.Row5[2][3].SizePolicy = "Fixed"
    result.Row5[2][3].Size = "20"
    -- Alpha
    result.Row5[2][5].SizePolicy = "Fixed"
    result.Row5[2][5].Size = "20"


    -- Saturation Label
    result.saturationLabel = result.Row5:Append("UIObject")
    result.saturationLabel.Anchors = "0,0"
    result.saturationLabel.Text = "S"
    result.saturationLabel.Font = "Medium20"
    result.saturationLabel.HasHover = "No"
    result.saturationLabel.BackColor = colorTransparent
    result.saturationLabel.TextalignmentH = "Right"
    
    -- Saturation
    result.outlineSaturation = result.Row5:Append("LineEdit")
    result.outlineSaturation.Name="OutlineSaturation"
    result.outlineSaturation.Message="Saturation"
    result.outlineSaturation.Anchors = "1,0"
    result.outlineSaturation.Texture = "corner15"
    result.outlineSaturation.target = CurrentProfile()
    result.outlineSaturation.TextChanged="OnChange"
    result.outlineSaturation.PluginComponent = my_handle
    result.outlineSaturation.MaxTextLength = 5
    result.outlineSaturation.Content = "1.0"
    


    
    -- Brightness Label
    result.brightnessLabel = result.Row5:Append("UIObject")
    result.brightnessLabel.Anchors = "2,0"
    result.brightnessLabel.Text = "B"
    result.brightnessLabel.Font = "Medium20"
    result.brightnessLabel.HasHover = "No"
    result.brightnessLabel.BackColor = colorTransparent
    result.brightnessLabel.TextalignmentH = "Right"

    -- Brightness
    result.outlineBrightness = result.Row5:Append("LineEdit")
    result.outlineBrightness.Name="OutlineBrightness"
    result.outlineBrightness.Message="Brightness"
    result.outlineBrightness.Anchors = "3,0"
    result.outlineBrightness.Texture = "corner15"
    result.outlineBrightness.target = CurrentProfile()
    result.outlineBrightness.TextChanged="OnChange"
    result.outlineBrightness.PluginComponent = my_handle
    result.outlineBrightness.MaxTextLength = 5
    result.outlineBrightness.Content = "1.0"


    
    -- Alpha Label
    result.alphaLabel = result.Row5:Append("UIObject")
    result.alphaLabel.Anchors = "4,0"
    result.alphaLabel.Text = "S"
    result.alphaLabel.Font = "Medium20"
    result.alphaLabel.HasHover = "No"
    result.alphaLabel.BackColor = colorTransparent
    result.alphaLabel.TextalignmentH = "Right"

    -- Alpha
    result.outlineAlpha = result.Row5:Append("LineEdit")
    result.outlineAlpha.Name="OutlineAlpha"
    result.outlineAlpha.Message="Alpha"
    result.outlineAlpha.Anchors = "5,0"
    result.outlineAlpha.Texture = "corner15"
    result.outlineAlpha.target = CurrentProfile()
    result.outlineAlpha.TextChanged="OnChange"
    result.outlineAlpha.PluginComponent = my_handle
    result.outlineAlpha.MaxTextLength = 5
    result.outlineAlpha.Content = "1.0"


    -- Image
    result.image = result.dlgFrame:Append("PropertyInput")
    result.image.Name = 'Image'
    result.image.Text = 'Image'
    result.image.Property = 'image'
    result.image.target = CurrentProfile()
    result.image.Anchors = "0,6"
    result.image.colorindicatorheight = 0
    result.image.Texture = "corner15"
    result.image.PluginComponent = my_handle

    -- Other Stuff

    result.systemRow = result.dlgFrame:Append("UILayoutGrid")
    result.systemRow.Anchors = "0,7"
    result.systemRow.Columns = 2
    result.systemRow.Rows = 1

    -- overwite
    result.overwrite = result.systemRow:Append("CheckBox")
    result.overwrite.Name="Overwrite"
    result.overwrite.Text="Overwrite"
    result.overwrite.Anchors = "0,0"
    result.overwrite.Texture = "corner5"
    result.overwrite.Clicked = "CheckBoxClicked"
    result.overwrite.TextalignmentH = "Left";
    result.overwrite.ColorIndicator = Root().ColorTheme.ColorGroups.Global.Selected
    result.overwrite.State = stateOverwrite
    result.overwrite.PluginComponent = my_handle


    --system colors
    result.systemColors = result.systemRow:Append("CheckBox")
    result.systemColors.Name="System Colors"
    result.systemColors.Text="System Colors"
    result.systemColors.Anchors = "1,0"
    result.systemColors.Texture = "corner10"
    result.systemColors.Clicked = "CheckBoxClicked"
    result.systemColors.TextalignmentH = "Left";
    result.systemColors.ColorIndicator = Root().ColorTheme.ColorGroups.Global.Selected
    result.systemColors.State = stateSystemColors
    result.systemColors.PluginComponent = my_handle

    -- Action Buttons

    result.actionButtons = result.dlgFrame:Append("UILayoutGrid")
    result.actionButtons.Anchors = "0,9"
    result.actionButtons.Columns = 2
    result.actionButtons.Rows = 1

    -- Apply
    result.apply = result.actionButtons:Append("Button");
    result.apply.Anchors = "0,0";
    result.apply.Textshadow = 1;
    result.apply.HasHover = "Yes";
    result.apply.Text = "Apply";
    result.apply.Font = "Medium20";
    result.apply.BackColor = Root().ColorTheme.ColorGroups.Button.BackgroundClear;
    result.apply.TextalignmentH = "Centre";
    result.apply.PluginComponent = my_handle
    result.apply.Clicked = "ApplyButtonClicked"
    result.apply.Enabled = "No"
    
    -- Cancel
    result.cancel = result.actionButtons:Append("Button");
    result.cancel.Anchors = "1,0";
    result.cancel.Textshadow = 1;
    result.cancel.HasHover = "Yes";
    result.cancel.Text = "Close";
    result.cancel.Font = "Medium20";
    result.cancel.TextalignmentH = "Centre";
    result.cancel.PluginComponent = my_handle
    result.cancel.Clicked = "CancelButtonClicked"

    return result
end

-- BUILD HEADER
function buildHeader(text, parent, ankor)
    local header = parent:Append("UIObject")
    header.Anchors = ankor
    header.Text = text
    header.Font = "Medium20"
    header.HasHover = "No"
    header.BackColor = colorTransparent
end

signalTable.OnChange = function (caller, ...)
    --
    -- Saturation, Brightness, Alpha
    --
    if string.find(caller.Name, "Saturation") or string.find(caller.Name, "Brightness") or string.find(caller.Name, "Alpha") then
        local value = tonumber(caller.Content) or 0
        if value > 1.0 then
            caller.TextColor = Root().ColorTheme.ColorGroups.Global.ErrorText
            validValues[caller.Name] = false
        else
            caller.TextColor = Root().ColorTheme.ColorGroups.Global.Text
            validValues[caller.Name] = true
        end
    end

    --validate object space
    validateDialog()
end

function validateDialog()
    -- check if the count is too high
    local currentCount = tonumber(dialog.count.Content) or 0
    local currentStart = tonumber(dialog.start.Content) or 0

    -- Count
    if currentCount > 100 then
        dialog.count.TextColor = Root().ColorTheme.ColorGroups.Global.ErrorText
        validValues["Count"] = false
    else
        dialog.count.TextColor = Root().ColorTheme.ColorGroups.Global.Text
        validValues["Count"] = true
    end

    --Start
    if currentStart > 10000 then
        dialog.start.TextColor = Root().ColorTheme.ColorGroups.Global.ErrorText
        validValues["Start"] = false
    else
        dialog.start.TextColor = Root().ColorTheme.ColorGroups.Global.Text
        validValues["Start"] = true
    end

    local systemCount = 0
    if dialog.systemColors.State == 1 then
        for k, v in pairs(builtInColors) do
            systemCount = systemCount + 1
        end
    end

    if currentCount + currentStart + systemCount > 10000 then
        dialog.count.TextColor = Root().ColorTheme.ColorGroups.Global.ErrorText
        dialog.start.TextColor = Root().ColorTheme.ColorGroups.Global.ErrorText
        validValues["Count"] = false
        validValues["Start"] = false
    end

    -- check if all values are valid
    isValid = true
    local validCount = 0
    for k, v in pairs(validValues) do
        validCount = validCount + 1
        if v == false or v == nil then
            isValid = false
            break
        end
    end

    if isValid and validCount == 8 then
        dialog.apply.BackColor = Root().ColorTheme.ColorGroups.Button.BackgroundPlease
        dialog.apply.Enabled = "Yes"
    else
        dialog.apply.BackColor = Root().ColorTheme.ColorGroups.Button.BackgroundClear
        dialog.apply.Enabled = "No"
    end
end

signalTable.CheckBoxClicked = function (caller, ...)
    if caller.Name == "Overwrite" then
        stateOverwrite = 1 - caller.State
        caller.State = stateOverwrite
    elseif caller.Name == "System Colors" then
        stateSystemColors = 1 - caller.State
        caller.State = stateSystemColors
    end
    validateDialog()
end

signalTable.ApplyButtonClicked = function (caller, ...)
    local undo = CreateUndo("Appearance Builder 2")
    local fillIncrement = 1/tonumber(dialog.count.Content)
    local appearanceIndex = tonumber(dialog.start.Content)
    for i = 0, 1-0.001, fillIncrement do
        local af = dialog.fillAlpha.Content
        local ao = dialog.outlineAlpha.Content
        local rf, gf, bf, namef = toRGB(i, tonumber(dialog.fillSaturation.Content), tonumber(dialog.fillBrightness.Content))
        local ro, go, bo, nameo = toRGB(i, tonumber(dialog.outlineSaturation.Content), tonumber(dialog.outlineBrightness.Content))
        local currentAppearance = Root().ShowData.Appearances[appearanceIndex]
        if currentAppearance == nil or dialog.overwrite.State == 1 then
            local command = string.format('Set Appearance %d Property "Color" "%f,%f,%f,%f" "BackR" "%d" "BackG" "%d" "BackB" "%d" "BackAlpha" "%d"',
                            appearanceIndex,
                            rf,
                            gf,
                            bf,
                            af,
                            math.floor(ro * 255),
                            math.floor(go * 255),
                            math.floor(bo * 255),
                            math.floor(ao * 255))

            if nameo then
                command = command .. ' Name "' .. nameo .. '"'
            end

            -- Store it
            Cmd("Store Appearance " .. appearanceIndex, undo)
            Cmd(command, undo)
            -- TODO: Image
            Cmd(string.format("Set Appearance %d Property Image ''", appearanceIndex), undo)
        end
        appearanceIndex = appearanceIndex + 1
    end

    -- Add System colors to the end
    if dialog.systemColors.State == 1 then
        for k, v in pairs(builtInColors) do
            local currentAppearance = Root().ShowData.Appearances[appearanceIndex]
            if currentAppearance == nil or dialog.overwrite.State == 1 then
                local command = string.format(
                    'Set Appearance %d Property "Color" "%f,%f,%f,%f" "BackR" "%d" "BackG" "%d" "BackB" "%d" "BackAlpha" "%d" "Name" "%s"',
                    appearanceIndex,
                    v[1]/255, --0 - 255
                    v[2]/255,
                    v[3]/255,
                    1.0,
                    v[1], -- 0 - 1
                    v[2],
                    v[3],
                    255,
                    k
                )
                Cmd("Store Appearance " .. appearanceIndex, undo)
                Cmd(command, undo)
                -- TODO: Image
                Cmd(string.format("Set Appearance %d Property Image ''", appearanceIndex), undo)
            end
            appearanceIndex = appearanceIndex + 1

        end
    end
    CloseUndo(undo)
end


signalTable.CancelButtonClicked = function (caller, ...)
    Obj.Delete(dialog.overlay, Obj.Index(dialog.dialog))
end

-- ****************************************************************
-- clamp(number, number, number) : number
-- ****************************************************************
function clamp(input, min, max)
    local ErrorString = "clamp(number:input, number:min, number:max) "
    assert(type(input) == "number", ErrorString .. "- input, must be a number")
    assert(type(min) == "number", ErrorString .. "- min, must be a number")
    assert(type(max) == "number", ErrorString .. "- max, must be a number")
    assert(min <= max, ErrorString .. "- min must be less or equal to max")
    local i = input
    if i < min then i = min end
    if i > max then i = max end
    return i
end

-- ****************************************************************
-- split(string, string) : table
-- ****************************************************************
function split(input, separator)
    local ErrorString = "split(string:input[, string:seperator]) "
    assert(type(input) == "string" or input == nil, ErrorString .. "- Input Must be a string")
    assert(type(separator) == "string" or separator == nil, ErrorString .. "- seperator must be a string or nil (nil == '%s')")
    if input == nil then
        return nil
    end


    if separator == nil then separator = "%s" end
    local t = {}
    for str in string.gmatch(input, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- ****************************************************************
-- toRGB(number, number, number) : (number, number, number, string)
-- ****************************************************************
function toRGB (h, s, v)
    local ErrorString = "toRGB([number:Hue] [, number:Saturation] [, number:Value]) "
    assert(type(h) == "number" or h == nil, ErrorString .. " - Hue must be a number or nil")
    assert(type(s) == "number" or s == nil, ErrorString .. " - Saturation must be a number or nil")
    assert(type(v) == "number" or v == nil, ErrorString .. " - Value must be a number or nil")

    --assert(h >= 0 or s <= 1, ErrorString .. " - Hue must be between 0 and 1") -- I don't remember if this is true
    assert(s >= 0 or s <= 1, ErrorString .. " - Saturation must be between 0 and 1")
    assert(v >= 0 or v <= 1, ErrorString .. " - Value must be between 0 and 1")

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

-- ****************************************************************
-- getColorName(number, number, number, number) : string
-- ****************************************************************
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
    for k, v in pairs(colorNames) do
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
        result = colorNames[bestIndex][2]
    end
    return result
end

-- ****************************************************************
-- colorNames
-- Enter Names for colors, Add your own in the following format
-- {{r, g, b,"NAME"}}
-- r, g and b are between 0 and 255
-- ****************************************************************

colorNames = {
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

-- ****************************************************************
-- builtInColors hard coded from the default color template v1.9.7.0
-- Values are entered in hex (0x00 - 0xFF) since that is how they are
-- entered in the console
-- ****************************************************************
builtInColors = {
    A_Fade =     {0x00, 0xCC, 0xFF},
    A_Delay =    {0xFF, 0x7C, 0x00},
    A_Absolute = {0x7E, 0x11, 0x11},
    A_Relative = {0x98, 0x3B, 0x5E},
    A_Phaser =   {0x74, 0x36, 0x80},
    A_Macro =    {0x80, 0x00, 0x00},
    A_Plugin =   {0x70, 0x00, 0x50},
    A_Group =    {0x00, 0x40, 0x80},
    A_World =    {0x00, 0x00, 0x80},
    A_Filters =  {0x00, 0x00, 0x90},
    A_Sequence = {0xA6, 0x7D, 0x00},
    A_Preset =   {0x00, 0x80, 0x80}
}

return main

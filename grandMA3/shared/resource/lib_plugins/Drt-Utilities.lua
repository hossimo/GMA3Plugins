--[[
Drt-Utilities v1.1.0.1

A collection of common tools

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

if Drt == nil then
    Drt = {}
end

-- ****************************************************************
-- Drt.split(string, string) : table
-- ****************************************************************
function Drt.split(input, seperator)
    local ErrorString = "Drt.split(string:input[, string:seperator]) "
    assert(type(input) == "string" or input == nil, ErrorString .. "- Input Must be a string")
    assert(type(seperator) == "string" or seperator == nil, ErrorString .. "- seperator must be a string or nil (nil == '%s')")
    if input == nil then
        return nil
    end


    if seperator == nil then seperator = "%s" end
    local t = {}
    for str in string.gmatch(input, "([^" .. seperator .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- ****************************************************************
-- Drt.clamp(number, number, number) : number
-- ****************************************************************
function Drt.clamp(input, min, max)
    local ErrorString = "Drt.clamp(number:input, number:min, number:max) "
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
-- Drt.toRGB(number, number, number) : (number, number, number, string)
-- ****************************************************************
function Drt.toRGB (h, s, v)
    local ErrorString = "Drt.toRGB([number:Hue] [, number:Saturation] [, number:Value]) "
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
    name = Drt.getColorName(r,g,b)
    return r, g, b, name
end

-- ****************************************************************
-- Drt.getColorName(number, number, number, number) : string
-- ****************************************************************
function Drt.getColorName (r, g, b, threshold)

    -- http://chir.ag/projects/ntc/ntc.js
    -- not fully implimented, needs to also check HSV values, but works for now.
    -- safty first
    r = r or 0
    g = g or 0
    b = b or 0
    threshold = threshold or 1500

    r = Drt.clamp(math.floor(r * 255), 0, 255)
    g = Drt.clamp(math.floor(g * 255), 0, 255)
    b = Drt.clamp(math.floor(b * 255), 0, 255)

    local bestScore = -1
    local bestIndex
    for k, v in pairs(Drt.colorNames) do
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
        result = Drt.colorNames[bestIndex][2]
    end
    return result
end

-- ****************************************************************
-- Drt.colorNames
-- Enter Names for colors, Add your own in the following format
-- {{r, g, b,"NAME"}}
-- r, g and b are between 0 and 255
-- ****************************************************************

Drt.colorNames = {
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
-- Drt.selectionToArray(boolean) : table
-- Thanks MA, this is really helpful. I added a random option.
-- ****************************************************************
function Drt.SelectionToArray(random)
	random = random or false
    assert(type(random) == "boolean")

	local selectedFixtures = {};
	local sfIdx = SelectionFirst ();
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
-- Drt.calculateSFID(number) : string
-- Sub Fixtures (not child fixtures), don't contain an FID. returns the aparent Sub fixture ID based on the root fixture
-- ****************************************************************
function Drt.calculateSFID(fixture)
    assert(type(fixture) == "number", "Drt.calculateSFID(int:fixture)")
	local result = GetSubfixture(fixture).FID
	if (result ~= nil) then
		return result
	end

	result = ""

	while (GetSubfixture(fixture):GetClass() == "SubFixture")
	do
		local parent = GetSubfixture(fixture):Parent();
		result = "." .. fixture - parent.SubfixtureIndex .. result
		fixture = parent.SubfixtureIndex
	end
	result = GetSubfixture(fixture).FID .. result
	return result
end

-- ****************************************************************
-- Drt.calculateRange(string) : table, string
-- ****************************************************************
function Drt.calculateRange(input)
    assert(type(input) == "string", "Drt.calculateRange(string) : table, string")
	-- first split on ","
	local seqSplit = Drt.split(input, ",")
	local returnList = {}
	local returnString = ""

	if #seqSplit == 0 then
		Printf("No Sequences Found, Exiting")
		return nil
	elseif #seqSplit > 0 then
		for k, v in pairs(seqSplit) do
			if string.find(v, "-") ~= nil then
				local inputRange = Drt.split(v, "-")

				-- if inputRange[1] == null or inputRange[2] == null then
				-- 	goto continue
				-- end

				if tonumber(inputRange[1]) == nil or tonumber(inputRange[2]) == nil then
					goto continue
				end

				-- found a range
				local inputStart = math.floor(tonumber(inputRange[1]))
				local inputEnd = math.floor(tonumber(inputRange[2]))

				if inputStart < inputEnd then
					--input the range into the table
					for i = inputStart, inputEnd do
						table.insert (returnList, i)
					end
					returnString = returnString .. v .. ","
				else
					--range is invalid, skip it.
				end
				
			else
				-- just a value
				if tonumber(v) == nil then
					goto continue
				end
				local item = math.floor(tonumber(v))
				if item ~= nil then
					table.insert (returnList, item)
					returnString = returnString .. v .. ","
				end
			end
			::continue::
		end
	end
	if #returnList == 0 then
		return nil
	else 
		returnString = returnString:sub(1, -2)
		return returnList, returnString	
	end
end

function Drt.table2String(input)
    if type(input) == "boolean" then
        if input == true then
            return "true"
        else
           return "false"
        end
    elseif type(input) == "table" then
        local result = ""
        for k, v in pairs(input) do
            k = Drt.table2String(k)
            v = Drt.table2String(v)
            result = result .. string.format("[%s] %s", k, v)
            Echo(string.format("[%s] %s", k, v))
        end
        return result
    else
        return tostring(input)
    end
end

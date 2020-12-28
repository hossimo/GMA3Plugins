local pluginName = select(1,...);
local componentName = select(2,...);
local signalTable = select(3,...);
local my_handle = select(4,...);

local split

-- main
local function Main (display_handle, argument)
    local h, m, s = 0, 0, 0;    -- set hour minute and second to 0
    local userVar = UserVars(); -- lets store the FID in the UserVars 
    local clear = false;        -- cunset the clear flag

    -- If CLOCK_FID is a number then use it, else set it to -1 and ask the user what channel.
    if tonumber(GetVar(userVar, "CLOCK_FID") or -1) == -1 then
        local tempid = tonumber(TextInput("ENTER CLOCK FIXTURE ID"))
        if tempid == nil then
            Echo("Imporer Fixture ID, Exitting");
            return;
        end
        fid = tempid
        SetVar(userVar, "CLOCK_FID", fid);
    end

    local result = split(TextInput("Enter Time in format 'h.m.s.<clear>'"),".");
    if #result == 1 then
        s = result[1];
    elseif #result == 2 then
        m = result[1];
        s = result[2];
    elseif #result == 3 then
        h = result[1];
        m = result[2];
        s = result[3];
    elseif #result == 4 then
        h = result[1];
        m = result[2];
        s = result[3];
        clear = true;

    else
        Echo("Incorrect number of arguments");
        return;
    end

    Cmd('Clear Selection; Fixture '..fid..'; Attribute "Control1" At Absolute Decimal8 6; Attribute "Hours" At Absolute Decimal8 '..h..'; Attribute "Minutes" At Absolute Decimal8 '..m..'; Attribute "Seconds" At Absolute Decimal8 '.. s)
    if clear then 
        coroutine.yield(2/30)
        Cmd('Off Attribute "Control1"; Off Attribute "Hours"; Off Attribute "Minutes"; Off Attribute "Seconds"');
    end
end

-- ****************************************************************
-- Drt.split(string, string) : table
-- ****************************************************************
function split(input, seperator)
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
return Main
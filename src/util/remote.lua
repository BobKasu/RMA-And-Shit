local UpdBoothRemote = game:GetService("ReplicatedStorage").Remotes.CommitBoothDraft

local remote = {}


--plydlll

local function table_copy(source, destination)
    table.clear(destination)

    for key, val in pairs(source) do
        destination[key] = val
    end
end

function remote.upd_booth(args)
    local BoothProperties = _G.RES_State.booth_properties

    if args then -- Because it could be nil, indicating that booth properties were already modified before calling
        table_copy(args, BoothProperties)
    end

    UpdBoothRemote:InvokeServer(BoothProperties)

    --[[
    
    Example args table:

    {
        booth = "Default Booth",
        image = "",
        pollYes = "",
        desc = txt,
        pollNo = "", -- jstfuissslsjlsdll
        accentColor = Color3.fromRGB(ar, ag, ab),
        primaryColor = Color3.fromRGB(br, bg, bb), -- Fixed bb typo and added missing comma
        blacklist = {}  
    }
    
    ]]--
end

function remote.upd_booth_prop(property, value)
    local BoothProperties = _G.RES_State.booth_properties

    BoothProperties[property] = value

    UpdBoothRemote:InvokeServer(BoothProperties)
end

function remote.upd_booth_props(property_and_vals)
    local BoothProperties = _G.RES_State.booth_properties

    for prop, val in pairs(property_and_vals) do
        BoothProperties[prop] = val
    end

    UpdBoothRemote:InvokeServer(BoothProperties)
end

return remote
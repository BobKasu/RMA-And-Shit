local function run()
    if _G.RES_Loaded == true then 
        return
    end
    _G.RES_Loaded = true
    _G.RES_Thread = coroutine.running()

    local GH_REPO_URL = "https://raw.githubusercontent.com/BobKasu/RMA-And-Shit/main/%s"

    _G.RES_web_import = function(file)
        return loadstring(
            game:HttpGetAsync((GH_REPO_URL):format(file)), file .. ".lua"
        )()
    end
    _G.RES_json_decode_file = function(file)
        local _json = game:HttpGetAsync((GH_REPO_URL):format(file))
        return game:GetService("HttpService"):JSONDecode(_json)
    end

    local remote_util = _G.RES_web_import("src/util/remote.lua")
    local text_util = _G.RES_web_import("src/util/text.lua")
    
    -- On shutdown, set to nil
    _G.RES_State = {
        ["started"] = false,
        ["current_running"] = "setup",
        ["owner_username"] = game.Players.LocalPlayer.Name, -- This is to allow owner transfership, set to the username of the player calling the script by default
        ["interact_blacklist"] = {},
        ["targets"] = {},
        ["booth_properties"] = {
            ["booth"] = "Default Booth",
            ["image"] = "",
            ["pollYes"] = "",
            ["desc"] = "[RES] Loading...",
            ["pollNo"] = "",
            ["accentColor"] = Color3.new(59 / 255, 59 / 255, 59 / 255),
            ["primaryColor"] = Color3.new(59 / 255, 59 / 255, 59 / 255), 
            ["blacklist"] = {}
        }
    }

    remote_util.upd_booth(nil)

    -- setup
    --------

    task.wait(1)

    -- ss

    _G.RES_State.current_running = "waiting_for_start"

    remote_util.upd_booth_props({
        ["primaryColor"] = Color3.new(237 / 255, 234 / 255, 22 / 255),
        ["accentColor"] = Color3.new(222 / 255, 219 / 255, 34 / 255)
    })

    task.wait(0.1)
    
    text_util.text_loop(
        {"Waiting for start", "Waiting for start_"},
        function() return _G.RES_State.started == false end,
        1
    )

end

local thread = task.spawn(run) -- nipmaudsljsdlll
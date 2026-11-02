local remote_util, text_util, state_util = nil, nil, nil
local GH_REPO_URL = "https://raw.githubusercontent.com/BobKasu/RMA-And-Shit/main/%s"

local function setup()
    _G.RES_Thread = coroutine.running()

    _G.RES_web_import = function(file)
        return loadstring(
            game:HttpGetAsync((GH_REPO_URL):format(file)), file
        )()
    end
    _G.RES_json_decode_file = function(file)
        local _json = game:HttpGetAsync((GH_REPO_URL):format(file))
        return game:GetService("HttpService"):JSONDecode(_json)
    end

    remote_util = _G.RES_web_import("src/util/remote.lua")
    text_util = _G.RES_web_import("src/util/text.lua")
    state_util = _G.RES_web_import("src/util/state.lua")

    _G.RES_Loaded = true -- set loaded to true after actual module setup, etc
    
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
            ["desc"] = "Loading...",
            ["pollNo"] = "",
            ["accentColor"] = Color3.new(59 / 255, 59 / 255, 59 / 255),
            ["primaryColor"] = Color3.new(59 / 255, 59 / 255, 59 / 255), 
            ["blacklist"] = {}
        }
    }
end

local function intro()
    remote_util.upd_booth(nil)

    -- more setup
    --------

    task.wait(3)

    remote_util.upd_booth_prop("desc", "...")

    _G.RES_State.current_running = "waiting_for_start"

    remote_util.upd_booth_props({
        ["primaryColor"] = Color3.new(237 / 255, 234 / 255, 22 / 255),
        ["accentColor"] = Color3.new(222 / 255, 219 / 255, 34 / 255),
        ["image"] = "11104447788"
    })

    task.wait(0.1)
    
    text_util.text_loop(
        {"1", "2", "3"},
        -- {"Waiting for start", "Waiting for start.", "Waiting for start..", "Waiting for start..."},
        5,
        -- function() return _G.RES_State.started == false end,
        2
    )

    state_util.shutdown()

    task.wait(2)

    -- This won't run cuz it shut down
    remote_util.upd_booth_prop("desc", "test")
end

local function run()
    if _G.RES_Loaded == true then 
        return
    end

    setup()
    intro()
end

local thread = task.spawn(run) 


-- [[

    TODO :
        
        -- make changes to src/bg/chat.lua (it is a core task that runs in the background at all times, hence the folder name 'bg'. it checks for general commands like 'stop' or 'shutdown', etc). 
        -- add chat utils, etc. this is for providing utils that lets SERVICES use n call them in their files and use them, like game services, menu etc. they are used for their own independent things or commands, not commands like stop or shutdown etc 
    
        POTENTIAL

        -- move the extra stuff aside from the actual setup like text loop, etc into a different func called 'intro' for example to be called in run, so run only has the setup stuff
        -- add a custom config feature where the script caller adds a custom global "custom config" table into the calling fetch script, where they can make their own custom configurations like color, images, settings, etc
        
--]]

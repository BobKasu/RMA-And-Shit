local chat = {}

local web_import = _G.RES_web_import
local state_util = web_import("src/util/state.lua")

-- nlineahmaudsljsdll

local commands = {}

local function commands.join(username)

end

local function command(username, text, args) -- args is table
    local command_names = table.keys(commands)
    if not table.find(command_names, text) then return end
    
    local command_func = commands[text]
    local param_count, _ = debug.info(command_func, "a")

    if #args ~= param_count - 1 then return end
    
    command_func(username, table.unpack(args))
end

local function check_chat()
    -- might move the command behavior in this to a command util file so that multiple files can just have this same func

    local Chat = game:GetService("TextChatService")

    Chat.MessageReceived:Connect(function(message)
        if not message.TextSource then return end
        if message.Text:sub(1, 1) ~= "." then return end
        
        local username = message.TextSource.Name
        local text = message.Text
        local text_splitted = text:split(" ")

        -- the #words ~= 1 is ok because its within the if not name_is_target check, and .join is the only command that is allowed to non-targets
        if not state_util.name_is_target(username) then
            if text_splitted[1] ~= ".join" or #text_splitted ~= 1 then 
                return 
            end
        end

        local potential_cmd = text_splitted[1]
        potential_cmd = potential_cmd:sub(1, 0) .. potential_cmd:sub(2) -- commands begin with .

        table.remove(text_splitted, 1) -- just arguments in chat now

        command(username, potential_cmd, text_splitted)
    end)
    
end

-- start() is like the entrypoint of all background tasks
function chat.start()
    check_chat()
end

return chat
local chat = {}
local connection

local web_import = _G.RES_web_import
local state_util = web_import("src/util/state.lua")

-- nlineahmaudsljsdll

local commands = {}

function commands.join(username) end

function commands.shutdown(username) 
    if username ~= _G.RES_State.owner_username then return end
    state_util.shutdown()
end

function commands.start(username)
    if username ~= _G.RES_State.owner_username then return end
    _G.RES_State.started = true
end

local function command(username, text, args) -- args is table
    local command_func = commands[text]
    if not command_func then return end

    local param_count, _ = debug.info(command_func, "a")

    if #args ~= param_count - 1 then return end
    
    command_func(username, table.unpack(args))
end

local function check_chat()
    -- might move the command behavior in this to a command util file so that multiple files can just have this same func

    if connection and connection.Connected then return end

    local Chat = game:GetService("TextChatService")

    connection = Chat.MessageReceived:Connect(function(message)
        if not message.TextSource then return end
        if message.Text:sub(1, 1) ~= "." then return end
        
        local username = message.TextSource.Name
        local text = message.Text
        local text_splitted = text:split(" ")
        local is_owner = username == _G.RES_State.owner_username

        -- the #words ~= 1 is ok because its within the if not name_is_target check, and .join is the only command that is allowed to non-targets
        if not is_owner and not state_util.name_is_target(username) then
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

function chat.stop()
    if not connection then return end

    connection:Disconnect()
    connection = nil
end

return chat
local state = {}

-- Full shutdown of RES, stops thread, sets state and thread to nil
function state.shutdown()
    local old = _G.RES_Thread -- save old thread to stop it later, because stopping the thread being the first thing in the function will prevent this function from setting _G attributes

    _G.RES_Loaded = false
    _G.RES_State = nil
    _G.RES_Thread = nil

    task.cancel(old)
end

function state.name_is_target(name)
    return table.find(_G.RES_State.targets, name) ~= nil
end

function state.load_task(task)
    local task_module = _G.RES_web_import("src/bg/" .. task .. ".lua")
    task_module.start()
end

return state



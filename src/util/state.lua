local state = {}

-- Full shutdown of RES, stops thread, sets state and thread to nil
function state.shutdown()
    task.cancel(_G.RES_Thread)

    _G.RES_State = nil
    _G.RES_Loaded = false
    _G.RES_Thread = nil
end

return state

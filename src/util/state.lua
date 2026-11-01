local state = {}

-- Full shutdown of RES, stops thread, sets state to and thread nil,
function function state.shutdown()
    task.cancel(_G.RES_Thread)
    _G.RES_Thread = nil
    _G.RES_State = nil
end

return state

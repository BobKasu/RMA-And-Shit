local web_import = _G.RES_web_import
local remote = web_import("util/remote.lua")

local text = {}

function text.text_loop(text_array, count_or_condition_func, delay)

    if type(count_or_condition) == "boolean" then
        while count_or_condition() do -- If it is a 'condition', expected to be a function wrapper that returns the condition
            for _, text in ipairs(text_array) do
                remote.upd_booth_one()
                task.wait(delay)
            end
        end
    end 
    elseif type(count_or_condition) == "number" then
        for i = 1, count do
            for _, text in ipairs(text_array) do
                remote.upd_booth_one()
                task.wait(delay)
            end
        end
    end

end

function text.typewrite(text, delay)

    local curr = ""
    
    while curr ~= text do
        local index = #curr
        
        curr = curr .. text:sub(index + 1, index + 1)
        remote.upd_booth_prop("desc", text)

        task.wait(delay)
    end

    task.wait(0.2)

    remote.upd_booth_prop("desc", text)

end

return text
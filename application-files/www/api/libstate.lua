#!/usr/bin/lua

state_filename="/www/api/output_state.json"

JSON = (loadfile "/www/api/libjson.lua")()

state_init = {}
state_init["1"] = 0;
state_init["2"] = 0;
state_init["log"] = {};


function state_fileexists()
   local f = io.open(state_filename, "r")
   if f ~= nil then io.close(f) return true else return false end
end

function state_writejson(json)
    local f = io.open(state_filename, "w+")
    local json = f:write(json)
    f:close()
end

function state_readjson()
    -- Create file if not exists
    if not state_fileexists()
    then
        state_writejson(JSON:encode(state_init))
    end
    local f = io.open(state_filename, "r")
    local json = f:read()
    f:close()
    return json
end

function state_update(output, state)
    local old_state = JSON:decode(state_readjson())
    local new_state = old_state
    if old_state[tostring(output)] == state
    then
        return false
    else
        new_state[tostring(output)] = state
        table.insert(new_state["log"], os.date("!%Y-%m-%dT%TZ") .. "|" .. tostring(output) .. "|" .. tostring(state))
        state_writejson(JSON:encode(new_state))
        return true
    end
end
        
function state_read(output)
    local state = JSON:decode(state_readjson())
    if state[tostring(output)] == 1
    then
        return true
    else
        return false
    end
end

function state_writeboot()
    local state = JSON:decode(state_readjson())
    table.insert(state["log"], os.date("!%Y-%m-%dT%TZ") .. "|1|" .. "b")
    table.insert(state["log"], os.date("!%Y-%m-%dT%TZ") .. "|2|" .. "b")
    state_writejson(JSON:encode(state)) 
end

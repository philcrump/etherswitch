#!/usr/bin/lua

package.path = package.path .. ";" .. "/www/api/?.lua"
require("libproduct")

state_filename="/www/api/state.json"

JSON = (loadfile "/www/api/libjson.lua")()

function state_init()
    local state = {};
    state["gpio"] = {};
    for index, address in ipairs(product_info().outputs)
    do
        state["gpio"][index] = {}
        state["gpio"][index]["state"] = 0;
        state["gpio"][index]["name"] = "Output " .. index;
        state["gpio"][index]["log"] = {};
    end
    return state
end

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
        state_writejson(JSON:encode(state_init()))
    end
    local f = io.open(state_filename, "r")
    local json = f:read()
    f:close()
    return json
end

function state_rename(output, name)
    local old_state = JSON:decode(state_readjson())
    local new_state = old_state
    if old_state["gpio"][output]["name"] == name
    then
        return false
    else
        new_state["gpio"][output]["name"] = name
        state_writejson(JSON:encode(new_state))
        return true
    end
end

function state_update(output, state)
    local old_state = JSON:decode(state_readjson())
    local new_state = old_state
    if old_state["gpio"][output]["state"] == state
    then
        return false
    else
        new_state["gpio"][output]["state"] = state
        table.insert(new_state["gpio"][output]["log"], {t=os.date("!%Y-%m-%dT%TZ"), d=state} )
        state_writejson(JSON:encode(new_state))
        return true
    end
end
        
function state_read(output)
    local state = JSON:decode(state_readjson())
    print(output)
    if state["gpio"][output]["state"] == 1
    then
        return true
    else
        return false
    end
end

function state_writeboot()
    local state = JSON:decode(state_readjson())
    for index, address in ipairs(state["gpio"])
    do
        table.insert(state["gpio"][index]["log"], {t=os.date("!%Y-%m-%dT%TZ"), d="b"} )
    end
    state_writejson(JSON:encode(state)) 
end

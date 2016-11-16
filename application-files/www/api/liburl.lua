#!/usr/bin/lua

local hex_to_char = function(x)                                                               
  return string.char(tonumber(x, 16))                                                         
end                                                                                           
                                                                                              
local unescape = function(url)                                                                
  return url:gsub("%%(%x%x)", hex_to_char):gsub("+", " ")                                                    
end                                                                                           
                          
-- eg. url_getquery(os.getenv("QUERY_STRING"))
function url_getquery(get_data)
  local cgi = {}                                                                              
  for name, value in string.gfind(get_data, "([^&=]+)=([^&=]+)") do                                  
    name = unescape(name)                                                                     
    value = unescape(value)                                                                   
    cgi[name] = value                                                                         
  end                                                                                         
  return cgi                                                                                  
end

-- eg. url_postquery(io.read("*all"))
function url_postquery(post_data)
  local cgi = {}                                                                              
  for name, value in string.gfind(post_data, "([^&=]+)=([^&=]+)") do                                  
    name = unescape(name)                                                                     
    value = unescape(value)                                                                   
    cgi[name] = value                                                                         
  end                                                                                         
  return cgi                                                                                  
end

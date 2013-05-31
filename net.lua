local p = require 'pinky'
local json = require 'cjson'

local pinky_main;
local pstatus = { data = {}, status = { value = "OK", error = ""}}

function pinky_main(uri)
   pstatus.data = p.exec_command("/bin/netstat -an", nil, 1, " +",true)
   return json.encode(pstatus)
end

return { pinky_main = pinky_main }

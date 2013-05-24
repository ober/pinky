local p = require 'pinky'
local json = require 'cjson'

local function pinky_main(uri)
   return json.encode(p.exec_command("/bin/netstat -an", nil, 1, " +",true))
end

return { pinky_main = pinky_main }

local p = require 'pinky'
local json = require 'cjson'

local pstatus = { data = {}, status = { value = "OK", error = ""}}

local function pinky_main()
   -- call free(1) -m and return values
   -- total:1        used:2       free:3     shared:4    buffers:5     cached:6"}
   pstatus.data = p.exec_command("/usr/bin/free -m", {1,2,3,4,5,6}, 1, " +", true)
   pstatus.data.total = nil

   return json.encode(pstatus)
end

return { pinky_main = pinky_main }

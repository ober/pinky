local p = require 'pinky'
local json = require 'cjson'

local pstatus = { data = {}, status = { value = "OK", error = ""}}

local function pinky_main(uri)
   local one,five,ten =  p.exec_command("/usr/bin/uptime"):match("(%d+%.%d+),? +(%d+%.%d+),? +(%d+%.%d+)$")
   -- 10:57  up 13 days,  1:14, 1 user, load averages: 0.64 0.65 0.70
   pstatus.data = { one = one, five = five, ten = ten }

   return json.encode(pstatus)
end

return { pinky_main = pinky_main }

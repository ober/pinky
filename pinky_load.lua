local p = require 'pinky'

local pinky_main;

function pinky_main(uri,ps)
   local one,five,fifteen =  p.exec_command("/usr/bin/uptime"):match("(%d+%.%d+),? +(%d+%.%d+),? +(%d+%.%d+)$")
   -- 10:57  up 13 days,  1:14, 1 user, load averages: 0.64 0.65 0.70
   ps.data = { one = one, five = five, fifteen = fifteen }

   return ps
end

return { pinky_main = pinky_main }

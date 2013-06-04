local p = require 'pinky'

local pinky_main;

function pinky_main(uri,ps)
   -- call free(1) -m and return values
   -- total:1        used:2       free:3     shared:4    buffers:5     cached:6"}
   ps.data = p.exec_command("/usr/bin/free -m", {1,2,3,4,5,6}, 1, " +", true)
   ps.data.total = nil

   return ps
end

return { pinky_main = pinky_main }

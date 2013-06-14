local p = require 'pinky'

local pinky_main;

function pinky_main(uri,ps)
   ps.data = p.exec_command("/bin/netstat -an", nil, 1, " +",true)
   return ps
end

return { pinky_main = pinky_main }

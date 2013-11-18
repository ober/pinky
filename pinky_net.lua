local p = require 'pinky'

local pinky_main;

function pinky_main(uri,ps)
   ps.data = p.exec_command("/bin/netstat -tan|grep -E '^udp|^tcp'|cat -n|tr '\t' ' '", {2,3,4,5,6,7}, 1, " +", true)
   return ps
end

return { pinky_main = pinky_main }

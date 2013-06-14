local p = require 'pinky'

local pinky_main;

function pinky_main(uri,ps)
   if p.file_exists("/usr/bin/sv") then
      ps.data = p.exec_command("/usr/bin/sv /etc/service/*", nil, 1, " +",true)
   else
      ps.status.value,ps.status.error = "FAIL", "runit not installed"
   end

   return ps
end

return { pinky_main = pinky_main }

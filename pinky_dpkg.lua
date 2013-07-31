local p = require 'pinky'

function pinky_main(uri,ps)
   -- This function is the entry point.
   ps.args = p.split(uri,"/")
   -- Arguments:

   local cmd = "/usr/lib/update-notifier/apt-check --human-readable -p 2>&1"
   ps.data = p.exec_command(cmd,nil,1," +",true)
   return ps
end

return { pinky_main = pinky_main }

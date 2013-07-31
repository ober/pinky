local p = require 'pinky'

function pinky_main(uri,ps)
   -- This function is the entry point.
   ps.args = p.split(uri,"/")
   -- Arguments:

   local cmd1 = "/usr/lib/update-notifier/apt-check --human-readable 2>&1"
   -- local cmd2 = "/usr/lib/update-notifier/apt-check -p 2>&1"
   ps.data.updates = p.exec_command(cmd1,{1} ,4," +",true)
   -- ps.data.packages = p.exec_command(cmd2,{1} ,1," +",true)
   return ps
end

return { pinky_main = pinky_main }

local p = require 'pinky'

local pinky_main;
local search_process;

function pinky_main(uri,ps)
   local args = p.split(uri,"/")

   ps.data = p.exec_command("/bin/ps aux", nil, 11, " +", true)
   if #args == 1 then
      search_process(ps,args[1],out)
   end

   return ps
end

function search_process(ps,app,out)
   if ps[app] then
      ps.status.value,ps.data = "OK", ps[app]
   else
      ps.status.value,ps.status.error = "FAIL", "Could not find a process that matched " .. app
   end
end

return { pinky_main = pinky_main }

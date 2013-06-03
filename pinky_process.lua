local p = require 'pinky'
local json = require 'cjson'

local pinky_main;
local search_process;
local pstatus = { data = {}, status = { value = "OK", error = ""}}

function pinky_main(uri)
   local args = p.split(uri,"/")

   pstatus.data = p.exec_command("/bin/ps aux", nil, 11, " +", true)
   if #args == 1 then
      search_process(ps,args[1],out)
   end

   return json.encode(pstatus)
end

function search_process(ps,app,out)
   if ps[app] then
      pstatus.status.value,pstatus.data = "OK", ps[app]
   else
      pstatus.status.value,pstatus.status.error = "FAIL", "Could not find a process that matched " .. app
   end
end

return { pinky_main = pinky_main }

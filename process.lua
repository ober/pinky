local p = require 'pinky'
local json = require 'cjson'

local function pinky_main(uri)
   local args = p.split(uri,"/")
   local ps =  p.exec_command("/bin/ps aux", nil, 11, " +", true)
   local out = { data = ps, status = { value = "", error = ""} }

   if #args == 0 then
      return json.encode(out)
   elseif #args == 1 then
      return search_process(ps,args[1],out)
   end
end

function search_process(ps,app,out)
   if ps[app] then
      out.status.value,out.data = "OK", ps[app]
   else
      out.status.value,out.status.error = "FAIL", "Could not find a process that matched " .. app
   end
   return json.encode(out)
end

return { pinky_main = pinky_main }

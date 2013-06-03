local p = require 'pinky'
local xml = require 'LuaXml'
local json = require 'cjson'

local pstatus = { data = {}, status = { value = "OK", error = ""}}
local pinky_main;

function pinky_main()

   local status = p.exec_command("/usr/bin/env passenger-status --show=xml")
   if status then
      pstatus.data = p.xml_find_tags(status,{ "active", "count", "max", "global_queue_size", "app_root", "environment", "cpu", "rss", "pss", "real_memory", "vmsize", "command"  } )
   else
      pstatus.status.value,pstatus.status.error = "FAIL
   end
   return json.encode(pstatus)
end

return { pinky_main = pinky_main }

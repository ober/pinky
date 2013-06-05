local p = require 'pinky'
local xml = require 'LuaXml'

local pinky_main;

function pinky_main(uri,ps)
   local cmd_out = p.exec_command("/usr/bin/env passenger-status --show=xml")
   if cmd_out == "" then
     ps.status.value,ps.status.error = "FAIL", "Could not find passenger-status"
   else
     ps.data = p.xml_find_tags(cmd_out, { "active", "count", "max", "global_queue_size", "app_root", "environment", "cpu", "rss", "pss", "real_memory", "vmsize", "command"})
   end

   return ps
end

return { pinky_main = pinky_main }

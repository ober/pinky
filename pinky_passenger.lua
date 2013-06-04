local p = require 'pinky'
local xml = require 'LuaXml'

local pinky_main;

function pinky_main(uri,ps)
   ps.data = p.xml_find_tags(p.exec_command("/usr/bin/env passenger-status --show=xml"),{ "active", "count", "max", "global_queue_size", "app_root", "environment", "cpu", "rss", "pss", "real_memory", "vmsize", "command"  } )
   return ps
end

return { pinky_main = pinky_main }

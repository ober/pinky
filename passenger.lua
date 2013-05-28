local p = require 'pinky'
local xml = require 'LuaXml'
local json = require 'cjson'

local pinky_main;

function pinky_main()
   local out = {
      data = p.xml_find_tags(p.exec_command("/usr/bin/env passenger-status --show=xml"),{ "active", "count", "max", "global_queue_size", "app_root", "environment", "cpu", "rss", "pss", "real_memory", "vmsize", "command"  } ),
      status = { value = "OK", error = "" }}
   return json.encode(out)
end

return { pinky_main = pinky_main }

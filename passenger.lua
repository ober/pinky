local p = require 'pinky'
local xml = require 'LuaXml'
local json = require 'cjson'

local pinky_main;

function pinky_main()
   xmldata = p.exec_command("/usr/bin/eval passenger-status --show=xml")
   local out = {
      data = p.xml_find_tags(,{ "active", "count", "max", "global_queue_size", "app_root", "environment", "cpu", "rss", "pss", "real_memory", "vmsize", "command"  } ),
      status = {
         value = "OK";
         error = "";
      }
   }
   return json.encode(out)
end

return { pinky_main = pinky_main }

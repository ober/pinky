module("vmstat", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /vmstat/ we return usage
   if #args < 2 then
      return json.encode(usage)
   elseif #args == 2 then
      return report_vmstat(args[1],args[2])
   end
end

function report_vmstat()
   -- call free(1) -m and return values
   -- total:1        used:2       free:3     shared:4    buffers:5     cached:6"}
   out = p.exec_command("/usr/bin/vmstat -s", {1,2,3,4,5,6}, {1,2}, " +", true)
   out.total = nil
   return json.encode(out)
end

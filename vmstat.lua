local p = require 'pinky'
local json = require 'cjson'

local pstatus = { data = {}, status = { value = "OK", error = ""}}

function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:

   pstat.data = report_vmstat(args[1],args[2])
   return json.encode(pstat)
end

function report_vmstat()
   -- call free(1) -m and return values
   -- total:1        used:2       free:3     shared:4    buffers:5     cached:6"}
   pstatus.data = p.exec_command("/usr/bin/vmstat -s", {1,2,3,4,5,6}, {1,2}, " +", true)
   pstatus.data.total = nil
end

return { pinky_main = pinky_main }

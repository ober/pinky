local p = require 'pinky'

local pinky_main;
local report_disk;


local function pinky_main(uri,ps)
   local args = p.split(uri,"/")
   -- This function is the entry point.
   -- Arguments:
   -- 0: /port we return usage
   ps = report_disk(ps)

   return ps
end

function report_disk(ps)
   -- Disk report.
   -- Return the output of df(1)
   ps.data = p.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   ps.data.Mounted = nil -- remove header
   ps.status.value = "OK"
   return ps
end

return { pinky_main = pinky_main }

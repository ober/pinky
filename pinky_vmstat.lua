local p = require 'pinky'

function pinky_main(uri,ps)
   -- This function is the entry point.
   ps.args = p.split(uri,"/")
   -- Arguments:

   ps = report_vmstat(ps)
   return ps
end

function report_vmstat(ps)
   -- call free(1) -m and return values
   -- total:1        used:2       free:3     shared:4    buffers:5     cached:6"}
   ps.data = p.exec_command("/usr/bin/vmstat -s", {1,2,3,4,5,6}, {1,2}, " +", true)
   ps.data.total = nil
   return ps
end

return { pinky_main = pinky_main }

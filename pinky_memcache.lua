local p = require 'pinky'

local pinky_main;

function pinky_main(uri,ps)
   -- This function is the entry point.
   ps.args = p.split(uri,"/")
   ps = report_memcache(ps)
   return ps
end

function report_memcache(ps)
   local out = {}
   local cmd_out, cmd_err = io.popen("/bin/bash -c 'echo stats'|/bin/nc localhost 11211")
   if cmd_out then
      for line in cmd_out:lines() do
         local line_array = p.split(line," +")
         if line_array[1]:match("^STAT") then
            out[line_array[2]] = tonumber(line_array[3])
         end
      end
   end

   if cmd_err then
      ps.status.error,ps.status.value = cmd_err, "FAIL"
   end
   ps.data = out
   return ps
end

return { pinky_main = pinky_main }

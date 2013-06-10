local p = require 'pinky'

local pinky_main;

function pinky_main(uri,ps)
   -- This function is the entry point.
   ps.args = p.split(uri,"/")
   ps = report_free(ps)
   return ps
end

function report_free(ps)
   local out = {}
   local cmd_out, cmd_err = io.popen("/usr/bin/free -m")
   print(type(cmd_out))
   if cmd_out then
      for line in cmd_out:lines() do
         local line_array = p.split(line," +")
         if line_array[1]:match("^Mem:") then
            out.noop,out.total,out.used,out.free,out.shared,out.buffers,out.cached = unpack(line_array)
         elseif line_array[1]:match("^-") then
            out.noop,out.noop,out.bc_used,out.bc_free = unpack(line_array)
         elseif line_array[1]:match("^Swap:") then
            out.noop,out.swap_total,out.swap_used,out.swap_free = unpack(line_array)
         end
      end
   end
   out.noop = nil
   ps.data = out
   return ps
end

return { pinky_main = pinky_main }

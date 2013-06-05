local p = require 'pinky'

function pinky_main(uri,ps)
   -- This function is the entry point.
   ps.args = p.split(uri,"/")
   -- Arguments:

   ps = report_vmstat(ps)
   return ps
end


function report_vmstat(ps)
   local out = {}
   local cmd_out, cmd_err = io.popen("/usr/bin/vmstat -s")
   print(type(cmd_out))
   if cmd_out then
      for line in cmd_out:lines() do
        local line_array = p.split(line," +")
        out[table.concat(line_array,"_",2)] = line_array[1]
        print("line is " .. line)
       end
   end
   ps.data = out
   return ps
end

return { pinky_main = pinky_main }

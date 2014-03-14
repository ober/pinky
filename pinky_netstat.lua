local p = require 'pinky'

function pinky_main(uri,ps)
   -- This function is the entry point.
   ps.args = p.split(uri,"/")
   -- Arguments:

   ps = report_netstat(ps)
   return ps
end


function report_netstat(ps)
   local out = {}
   local cmd_out, cmd_err = io.popen("/bin/netstat -s")
   if cmd_out then
      for line in cmd_out:lines() do
         local line_array = p.split(line," +")
         if #line_array > 1 then
            if line_array[1]:match("^%d+") then
               out[table.concat(line_array,"_",2)] = line_array[1]
            elseif line_array[#line_array]:match("^%d+") then
               out[table.concat(line_array,"_",1,#line_array-1):gsub(":","")] = line_array[#line_array]
            end
         end
      end
   end
   ps.data = out
   return ps
end

return { pinky_main = pinky_main }

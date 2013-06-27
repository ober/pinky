local p = require 'pinky'

local pinky_main;

function pinky_main(uri,ps)
   local out = {}
   local terms = {}
   if p.file_exists("/usr/bin/sv") then
      local cmd_out, cmd_err = io.popen("/usr/bin/sudo /usr/bin/sv status /etc/service/*")
      if cmd_out then
         for line in cmd_out:lines() do
            local service = {}
            local line_array = p.split(line," +")
            service.status,service.service_name, service.noop, service.pid, service.uptime = unpack(line_array)
            service.noop,service.pid = nil,service.pid:gsub("%)","")
            if table.concat(line_array):match("TERM") then
               terms[service.status] = line_array
            end
            out[line_array[2]] = service
         end
      end
   else
      ps.status.value,ps.status.error = "FAIL", "runit not installed"
   end

   if #terms > 0 then
      ps.status.value,ps.status.error = "FAIL", "Services found in term state!"
   end

   ps.terms,ps.data = terms,out
   return ps
end

return { pinky_main = pinky_main }

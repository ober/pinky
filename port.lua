local p = require 'pinky'

local success = "succeeded!"
local failure = "failed: Connection refused"

local usage = {
   status = {
      value = "FAIL";
      error = [[
Tcp port check module.
Valid URLS:
/pinky/port/host/port
]];
   }
}

local function pinky_main(uri,ps)
   -- This function is the entry point.
   -- local ip, port = unpack(p.split(uri,"/"))
   ps.ip,ps.port = uri:match("([^/]+)/(%d+)")

   if not ps.port then
      ps = p.do_error(usage,ps)
   end
   ps.ip = p.get_ip(tostring(ps.ip))

   if ps.ip then
      ps = report_port(ps)
   else
      ps = p.do_error("Could not resolve the host provided or the port",ps)
   end

   return ps
end

function report_port(ps)
   local host = ps.host
   local port = ps.port
   local cmd = "/usr/bin/env nc -v -z -w 1 " .. host .. " " .. port .. " 2>&1"
   local nc = p.exec_command(cmd)
   if type(nc) == "table" then
      return p.print_table(nc)
   end

   if nc then
      if string.match(nc,failure) then
         ps = p.do_error(failure,ps)
      elseif string.match(nc,success) then
         ps.status.value = "OK"
      else
         ps = p.do_error(nc,ps)
      end
   else
      ps = p.do_error("nc returned nil", ps)
   end
   return ps
end

return { pinky_main = pinky_main }

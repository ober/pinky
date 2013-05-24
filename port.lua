local p = require 'pinky'
local json = require 'cjson'

local success = "succeeded!"
local failure = "failed: Connection refused"

local usage = {
   data = "";
   status = {
      value = "FAIL";
      error = [[
Tcp port check module.
Valid URLS:
/pinky/port/host/port
]];
   }
}

local function pinky_main(uri)
   -- This function is the entry point.
   -- local ip, port = unpack(p.split(uri,"/"))
   local ip,port = uri:match("([^/]+)/(%d+)")

   if not port then
      return json.encode(usage)
   end
   local ip = p.get_ip(tostring(ip))

   if ip then
      return json.encode(report_port(ip,port))
   else
      return json.encode({ data = {}, status = { value = "FAIL", error = "Could not resolve the host provided or the port" }})
   end
end

function report_port(host,port)
   local cmd = "/usr/bin/env nc -v -z -w 1 " .. host .. " " .. port .. " 2>&1"
   local nc = p.exec_command(cmd)
   if type(nc) == "table" then
      return p.print_table(nc)
   end

   local out = { data = { nc }, status = { value = "", error = ""} }
   if nc then
      if string.match(nc,failure) then
         out.status.value,out.status.error  = "FAIL", failure
      elseif string.match(nc,success) then
         out.status.value = "OK"
      else
         out.status.value,out.status.error  = "FAIL", nc
      end
   else
      out.status.value,out.status.error  = "FAIL", "nc returned nil"
   end
   return json.encode(out)
end

return { pinky_main = pinky_main }

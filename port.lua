module("port", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

local usage = {
   data = "",
   status = {
      value = "FAIL",
      error = [[
Tcp port check module.
Valid URLS:
/pinky/port/host/port
]]
   }
}

function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port/ we return usage
   if #args < 2 then
      return json.encode(usage)
   elseif #args == 2 then
      local ip = p.get_ip(tostring(args[1]))
      local port = tonumber(args[2])

      if ip and port then
         return json.encode(report_port(ip,port))
      else
         return json.encode({ data = {}, status = { value = "FAIL", error = "Could not resolve the host provided or the port" }})
      end
   end
end

function report_port(host,port)

   local cmd = "/usr/bin/env nc -v -z -w 1 " .. host .. " " .. port .. " 2>&1"
   local nc = p.exec_command(cmd)
   if type(nc) == "table" then
      return p.print_table(nc)
   end

   local success = "succeeded!"
   local failure = "failed: Connection refused"
   local out = { data = { nc }, status = { value = "", error = ""} }
   if nc then
      if string.find(nc,failure) then
         out.status.value,out.status.error  = "FAIL", failure
      elseif string.find(nc,success) then
         out.status.value = "OK"
      else
         out.status.value,out.status.error  = "FAIL", nc
      end
   else
      out.status.value,out.status.error  = "FAIL", "nc returned nil"
   end
   return json.encode(out)
end

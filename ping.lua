local p = require 'pinky'
local json = require 'cjson'

local function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port we return usage
   local ip = p.get_ip(tostring(args[1]))
   if ip then
      return json.encode(report_ping(ip))
   else
      return json.encode({ data = {}, status = { value = "FAIL", error = "Could not resolve the host provided " }})
   end
end

function report_ping(host)

   local host_os = p.get_os()
   if host_os == "Darwin" then
      ping = "/sbin/ping -n -c 1 -W 1 " .. host
   elseif host_os == "Linux" then
      ping = "/sbin/ping -n -c 1 -w 1 " .. host
   end

   if ping then
      local ping_out = p.exec_command(ping) -- ,nil,nil," +", true)
      local unknown = 'ping: unknown host'
      local failure = '100%% packet loss,'
      local success = ' 0%% packet loss,'
      local success_osx = ' 0.0%% packet loss,'
      local out = { data = { ping_out }, status = { value = "", error = ""} }

      if ping_out then
         if string.find(ping_out,failure) then
            out.status.value,out.status.error  = "FAIL", failure
         elseif string.find(ping_out,success) then
            out.status.value = "OK"
         elseif string.find(ping_out,success_osx) then
            out.status.value = "OK"
         elseif string.find(ping_out,unknown) then
            out.status.value,out.status.error  = "FAIL", unknown
         else
            out.status.value,out.status.error  = "FAIL", "fall through"
         end
      else
         out.status.value,out.status.error  = "FAIL", "ping returned nil"
      end
      return out
   end
end

return { pinky_main = pinky_main }

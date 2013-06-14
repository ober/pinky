local p = require 'pinky'

local pinky_main;
local report_ping;

local function pinky_main(uri,ps)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port we return usage

   if #args == 1 then
      ps.ip = p.get_ip(tostring(args[1]))
      if ps.ip then
         ps = report_ping(ps)
      else
         ps.status.value,ps.status.error = "FAIL", "Could not resolve the host provided "
      end
   else
      ps.status.value,ps.status.error = "FAIL", "Usage: /pinky/ping/<hostname>"
   end

   return ps
end

function report_ping(ps)
   local host_os = p.get_os()
   local host = ps.ip
   if host_os == "Darwin" then
      ping = "/sbin/ping -n -c 1 -W 1 " .. host
   elseif host_os == "Linux" then
      ping = "/bin/ping -n -c 1 -w 1 " .. host
   end

   if ping then
      local ping_out = p.exec_command(ping) -- ,nil,nil," +", true)
      local unknown = 'ping: unknown host'
      local failure = '100%% packet loss,'
      local success = ' 0%% packet loss,'
      local success_osx = ' 0.0%% packet loss'
      ps.data = ping_out
      ps.ping_time = ping_out:match("time=(%d+%.?%d+)")

      if ping_out then
         if string.find(ping_out,failure) then
            ps.status.value,ps.status.error  = "FAIL", failure
         elseif string.find(ping_out,success) then
            ps.status.value = "OK"
         elseif string.find(ping_out,success_osx) then
            ps.status.value = "OK"
         elseif string.find(ping_out,unknown) then
            ps.status.value,ps.status.error  = "FAIL", unknown
         else
            ps.status.value,ps.status.error  = "FAIL", "fall through"
         end
      else
         ps.status.value,ps.status.error  = "FAIL", "ping returned nil"
      end
   end
   return ps
end

return { pinky_main = pinky_main }

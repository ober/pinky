local p = require 'pinky'
local json = require 'cjson'


local pinky_main;
local report_ping;

local pstatus = { data = {}, status = { value = "OK", error = ""}}

local function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port we return usage
   local ip = p.get_ip(tostring(args[1]))
   if ip then
      report_ping(ip)
   else
      pstatus.status.value,pstatus.status.error = "FAIL", "Could not resolve the host provided "
   end

   return json.encode(pstatus)
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
      local success_osx = ' 0.0%% packet loss'
      pstatus.data = ping_out

      if ping_out then
         if string.find(ping_out,failure) then
            pstatus.status.value,pstatus.status.error  = "FAIL", failure
         elseif string.find(ping_out,success) then
            pstatus.status.value = "OK"
         elseif string.find(ping_out,success_osx) then
            pstatus.status.value = "OK"
         elseif string.find(ping_out,unknown) then
            pstatus.status.value,pstatus.status.error  = "FAIL", unknown
         else
            pstatus.status.value,pstatus.status.error  = "FAIL", "fall through"
         end
      else
         pstatus.status.value,pstatus.status.error  = "FAIL", "ping returned nil"
      end
   end
end

return { pinky_main = pinky_main }

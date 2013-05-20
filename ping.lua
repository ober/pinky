module("ping", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port we return usage
   return report_ping(args[1])
end

function report_ping(host)
   -- Ping report.
   -- Return the output of ping(1)
   local out = p.exec_command("/bin/ping -c 1 -w 1 " .. host, {1,2,3,4,5}, 6, " +",true)
   out = { data = out }
   out.status = { value = "OK", error = "" }
   return json.encode(out)
end

function report_ping(host)
   local cmd = "/bin/ping -n -c 1 -w 1 " .. host .. " 2>&1"
   local ping = p.exec_command(cmd)
   local unknown = 'ping: unknown host'
   local failure = '100%% packet loss,'
   local success = ' 0%% packet loss,'
   local out = { data = { ping }, status = { value = "", error = ""} }
   if ping then
      if string.find(ping,failure) then
         out.status.value,out.status.error  = "FAIL", failure
      elseif string.find(ping,success) then
         out.status.value = "OK"
      elseif string.find(ping,unknown) then
         out.status.value,out.status.error  = "FAIL", unknown
      else
         out.status.value,out.status.error  = "FAIL", "fall through"
      end
   else
      out.status.value,out.status.error  = "FAIL", "ping returned nil"
   end
   return json.encode(out)
end

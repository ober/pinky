module("ping", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port we return usage
   return report_ping()
end

function report_ping(host)
   -- Ping report.
   -- Return the output of ping(1)
   local out = p.exec_command("/bin/ping -c 1 -w 1 " .. host, {1,2,3,4,5}, 6, " +",true)
   out = { data = out }
   out.status = { value = "OK", error = "" }
   return json.encode(out)
end

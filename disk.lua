-- Pinky plugin to check localhost tcp ports availability
module("disk", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port we return usage
   return report_disk()
end

function report_port(host,port)
   local cmd = "/bin/nc -v -z -w 1 " .. host .. " " .. port .. " 2>&1"
   local nc = exec_command(cmd)
   local success = "succeeded!"
   local failure = "failed: Connection refused"
   if nc then
      if string.find(nc,failure) then
         return "FAIL"
      elseif string.find(nc,success) then
         return "OK"
      else
         return "UNKNOWN:" .. nc
      end
   else
      return "Error running nc returned nil"
   end
end

function report_disk()
   -- Disk report.
   -- Return the output of df(1)
   local out = p.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   out.Mounted = nil -- remove header
   out = { data = out }
   out.status = { value = "OK", error = "" }
   return json.encode(out)
end

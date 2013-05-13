module("disk", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port we return usage
   return report_disk()
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

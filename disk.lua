module("disk", package.seeall)
local p = require 'pinky'
local json = require 'cjson'
local RVM_PATH = "/home/jaimef/.rvm/"

function main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /disk we return df(1) output
   return report_disk
end

function report_disk()
   -- Disk report.
   -- Return the output of df(1)
   local out = exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   out.Mounted = nil -- remove header
   out2 = { "data" = out }
   out.status = { "value" = "OK", "error" = nil }
   return json.encode(out)
end

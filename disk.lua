local p = require 'pinky'
local json = require 'cjson'

local pinky_main;
local report_disk;

local pstatus = {
   data = {};
   status = {
      value = "OK";
      error = "";
   }
}

local function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /port we return usage
   report_disk()
   return json.encode(pstatus)
end

function report_disk()
   -- Disk report.
   -- Return the output of df(1)
   pstatus.data = p.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   pstatus.data.Mounted = nil -- remove header
   pstatus.status.value = "OK"
end

return { pinky_main = pinky_main }

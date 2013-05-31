local p = require 'pinky'
local json = require 'cjson'
local lfs = require 'lfs'
local posix = require 'posix'

local pinky_main;
local unicorn_check_version;

function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   pstatus.data = unicorn_check_version()

   return json.encode(pstatus)
end

function unicorn_check_version()
   -- get pid Check that the /data/api/var/unicorn.pid
   pstatus.data = {
      current = posix.readlink("/data/api/current");
      master_wd = posix.readlink("/proc/" .. p.trim(p.read_file("/data/api/var/unicorn.pid")) .. "/cwd");
   }

   if pstatus.data.master_wd == pstatus.data.current then
      pstatus.status.value,pstatus.status.error = "OK",""
   else
      pstatus.status.value,pstatus.status.error = "FAIL","Current unicorn master is running from somewhere other than /data/api/current"
   end
end

return { pinky_main = pinky_main }

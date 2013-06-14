local p = require 'pinky'
local lfs = require 'lfs'
local posix = require 'posix'
local pinky_main;
local unicorn_check_version;

function pinky_main(uri,ps)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   ps,err = unicorn_check_version(ps)

   if err then
      ps.status.value,ps.status.error  = "FAIL", err
   end

   return ps
end

function unicorn_check_version(ps)
   -- get pid Check that the /data/api/var/unicorn.pid
   local pid,err = p.read_file("/data/api/var/unicorn.pid")
   if not err then
      pid = p.trim(pid)
      ps.data = {
         current = posix.readlink("/data/api/current");
         master_wd = posix.readlink("/proc/" ..  pid .. "/cwd");
      }
      if ps.data.master_wd == ps.data.current then
         ps.status.value,ps.status.error = "OK",""
      else
         ps.status.value,ps.status.error = "FAIL","Current unicorn master is running from somewhere other than /data/api/current"
      end

   end
   return ps,err
end

return { pinky_main = pinky_main }

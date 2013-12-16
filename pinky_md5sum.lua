local p = require 'pinky'
local lfs = require 'lfs'
local json = require 'cjson'

local pinky_main;
local stat_file;

function pinky_main(file,ps)
   -- This function is the entry point.
   -- Arguments:
   -- The only argument we take is the full path to a single file.

   valid_files = {
      "/root/.ssh/authorized_keys",
      "/home/deploy/.ssh/authorized_keys",
      "/home/ubuntu/.ssh/authorized_keys"
   }

   if file and file ~= "" then
      file_to_md5 = p.find_file_in_array(valid_files,file)
      if file_to_md5 and file_to_md5 ~= "" then
         ps = md5sum_file(file_to_md5,ps)
      else
         ps = p.do_error("The file passed is not currently supported.", ps)
      end
   else
      ps = p.do_error("Usage: /pinky/md5sum/some/path/to/a/file", ps)
   end

   return ps
end


function md5sum_file(file,ps)
   local cmd_out, cmd_err = io.popen("/usr/bin/sudo /usr/bin/md5sum " .. file)

   if cmd_err then
      ps.status.error,ps.status.value = cmd_err, "FAIL"
   else
      ps.data = cmd_out
   end

   return ps
end

return { pinky_main = pinky_main }

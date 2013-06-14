local p = require 'pinky'
local lfs = require 'lfs'
local json = require 'cjson'

local pinky_main;
local stat_file;

function pinky_main(file,ps)
   -- This function is the entry point.
   -- Arguments:
   -- The only argument we take is the full path to a single file.

   if file and file ~= "" then
      ps = stat_file(file,ps)
   else
      ps = p.do_error("Usage: /pinky/stat/some/path/to/a/file", ps)
   end

   return ps
end

function stat_file(file,ps)
   if p.file_exists(file) then
      ps.data = lfs.attributes(file)
   else
      ps.status.value,ps.status.error = "FAIL", "File does exist!"
   end
   return ps
end

return { pinky_main = pinky_main }

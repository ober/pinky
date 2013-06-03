local p = require 'pinky'
local lfs = require 'lfs'
local json = require 'cjson'

local pinky_main;
local stat_file;

local pstatus = { data = {}, status = { value = "OK", error = ""}}

function pinky_main(file)
   -- This function is the entry point.
   -- Arguments:
   -- The only argument we take is the full path to a single file.

   if file then
      stat_file(file)
   end

   return json.encode(pstatus)
end

function stat_file(file)
   if file_exists(file) then
      pstatus.data = lfs.attributes(file)
   else
      pstatus.status.value,pstatus.status.error = "FAIL", "File does exist!"
   end
end

return { pinky_main = pinky_main }

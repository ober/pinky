local p = require 'pinky'
local json = require 'cjson'

local pinky_main;
local read_file;

function pinky_main(uri,ps)
   -- This function is the entry point.
   -- Arguments:

   ps.data.stack_name = read_file("/data/etc/stack_name")
   ps.data.type_of_instance = read_file("/data/etc/type_of_instance")
   return ps
end

function read_file(file)
   local text = ""
   if p.file_exists(file) then
      local f = io.open(file, "r")
      local text = p.chomp(f:read("*a"))
   end
   return text
end

-- function get_app_version(app)
-- end



-- function get_chef_version()
-- end


return { pinky_main = pinky_main }

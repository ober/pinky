local p = require 'pinky'
local lfs = require 'lfs'

local pinky_main;
local attrdir;

function pinky_main(uri,ps)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   ps.dir = "/proc"
   ps = attrdir(ps)
   return ps
end

function attrdir (ps)
   local dir = ps.dir
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file
            print ("\t "..f)
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
            if attr.mode == "directory" then
                attrdir (f)
            else
               for name, value in pairs(attr) do
                  print (name, value)
               end
            end
        end
    end
    return ps
end

return { pinky_main = pinky_main }

local p = require 'pinky'
local json = require 'cjson'
local lfs = require 'lfs'

local function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /rvm we list rubies
   -- 1: /rvm/version list gems in this version of ruby
   -- 2: /rvm/version/bundler list bundler version

   -- if #args == 0 then
      attrdir("/proc")
   -- elseif #args == 1 then
   --    return json.encode(rvm_gem_list(args[1]))
   -- elseif #args == 2 then
   --    return json.encode(rvm_bundler_info(args[1]))
   -- end
end

function attrdir (path)
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
end

return { pinky_main = pinky_main }

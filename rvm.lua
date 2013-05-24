local p = require 'pinky'
local json = require 'cjson'

local function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /rvm we list rubies
   -- 1: /rvm/version list gems in this version of ruby
   -- 2: /rvm/version/bundler list bundler version

   if #args == 0 then
      return json.encode(rvm_list_rubies())
   elseif #args == 1 then
      return json.encode(rvm_gem_list(args[1]))
   elseif #args == 2 then
      return json.encode(rvm_bundler_info(args[1]))
   end
end

function get_rvms()
   local home = p.get_home()
   local rvms = {
      "/usr/local/rvm/bin/rvm",
      home .. "/.rvm/bin/rvm"
   }
   return p.find_first_file(rvms)
end

function rvm_list_rubies()
   -- return a list of all rubies
   rvm = get_rvms()
   if rvm then
      cmd = "/usr/bin/env " .. rvm .. " list strings"
      return p.exec_command(cmd,{1},1," +", true)
   else
      return "Could not locate a valid rvm binary"
   end
end

function rvm_gem_list(ruby)
   -- return gem list of the ruby provided
   rvm = get_rvms()
   rubies = rvm_list_rubies()
   if rubies[ruby] then
      cmd = "/usr/bin/env " .. rvm .. " " .. rubies[ruby][1] .. " do gem list"
      return p.exec_command(cmd,{2},1," +", true)
   end
   return "Could not find " .. ruby .. " in ruby list"
end

function rvm_bundler_info(ruby)
   -- Return the bundler specific information on this bundler
   local list = rvm_gem_list(ruby)
   return list["bundler"]
end

return { pinky_main = pinky_main }

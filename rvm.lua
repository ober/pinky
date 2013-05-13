module("rvm", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /rvm we list rubies
   -- 1: /rvm/version list gems in this version of ruby
   -- 2: /rvm/version/bundler list bundler version

   if #args == 0 then
      return rvm_list_rubies()
   elseif #args == 1 then
      return rvm_gem_list(args[1])
   elseif #args == 2 then
      return rvm_bundler_info(args[1])
   end
end

function rvm_list_rubies()
   -- return a list of all rubies
   return json.encode(p.lsdir(RVM_PATH .. "/wrappers/"))
end

function rvm_gem_list(ruby)
   -- return gem list of the ruby provided
   cmd = "/usr/bin/env RVM_PATH .. "/wrappers/" .. ruby .. "/gem list"
   return json.encode(p.exec_command(cmd, {2,3,4,5,6}, 1, " +",true))
end

function rvm_bundler_info(ruby)
   -- Return the bundler specific information on this bundler
   cmd = RVM_PATH .. "/gems/" .. ruby .. "@global/bin/bundle info"
   return json.encode(p.exec_command(cmd,{1,2,3,4,5,6}, 1, " +", true))
end

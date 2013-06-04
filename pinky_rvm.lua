local p = require 'pinky'

local pinky_main
local get_rvms
local rvm_list_rubies
local rvm_gem_list

function pinky_main(uri,ps)
   -- This function is the entry point.
   ps.args = p.split(uri,"/")
   -- Arguments:
   -- 0: /rvm we list rubies
   -- 1: /rvm/version list gems in this version of ruby
   -- 2: /rvm/version/bundler list bundler version

   if #args == 0 then
      ps = rvm_list_rubies(ps)
   elseif #args == 1 then
      ps = rvm_gem_list(ps)
   elseif #args == 2 then
      ps = rvm_bundler_info(ps)
   end

   return ps
end

function get_rvms(ps)
   local home = p.get_home()
   local rvms = {
      "/usr/local/rvm/bin/rvm",
      home .. "/.rvm/bin/rvm"
   }
   return p.find_first_file(rvms)
end

function rvm_list_rubies(ps)
   -- return a list of all rubies
   rvm = get_rvms()
   if rvm then
      cmd = "/usr/bin/env " .. rvm .. " list strings"
      ps.data = p.exec_command(cmd,{1},1," +", true)
   else
      ps.status.value, ps.status.error = "FAIL", "Could not locate a valid rvm binary"
   end
end

function rvm_gem_list(ruby)
   -- return gem list of the ruby provided
   rvm = get_rvms()
   rubies = rvm_list_rubies()
   if rubies and rubies[ruby] then
      cmd = "/usr/bin/env " .. rvm .. " " .. rubies[ruby][1] .. " do gem list"
      ps.data = p.exec_command(cmd,{2},1," +", true)
   else
      ps.status.value, ps.status.error = "FAIL", "Could not find " .. ruby .. " in ruby list"
   end
end

function rvm_bundler_info(ruby)
   -- Return the bundler specific information on this bundler
   local list = rvm_gem_list(ruby)
   ps.data = list["bundler"]
end

return { pinky_main = pinky_main }

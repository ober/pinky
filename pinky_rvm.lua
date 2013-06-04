local p = require 'pinky'

local pinky_main
local get_rvms
local rvm_list_rubies
local rvm_gem_list

function pinky_main(uri,ps)
   -- This function is the entry point.
   args = p.split(uri,"/")
   -- Arguments:
   -- 0: /rvm we list rubies
   -- 1: /rvm/version list gems in this version of ruby
   -- 2: /rvm/version/bundler list bundler version

   if #args == 0 then
      ps.data,ps.status.error = rvm_list_rubies()
   elseif #args == 1 then
      ps.data,ps.status.error = rvm_gem_list(args[1])
   elseif #args == 2 then
      ps.data,ps.status.error = rvm_bundler_info(args[1])
   end

   if ps.status.error then
      ps.status.value = "FAIL"
   end
   return ps
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
   local rvm,err = get_rvms()
   local data = ""
   print(rvm)
   if rvm then
      local cmd = "/usr/bin/env " .. rvm .. " list strings"
      data = p.exec_command(cmd,{1},1," +", true)
   else
      err = "Could not locate a valid rvm binary"
   end
   return data,err
end

function rvm_gem_list(ruby)
   -- return gem list of the ruby provided
   local data,err = ""
   local rvm = get_rvms()
   if not rvm then err = "no rvm" end
   local rubies = rvm_list_rubies()
   if not rubies then err = "no rubies" end
   if not rubies[ruby] then err = "Could not find " .. ruby .. " in rubies" end

   if rvm and rubies and rubies[ruby] then
      local cmd = "/usr/bin/env " .. rvm .. " " .. rubies[ruby][1] .. " do gem list"
      data = p.exec_command(cmd,{2},1," +", true)
   else
      err = "Got nil on rvm/rubies/rubies[ruby]"
   end
   return data,err
end

function rvm_bundler_info(ruby)
   -- Return the bundler specific information on this bundler
   local list = rvm_gem_list(ruby)
   local data = list["bundler"]

   print(type(data[1]))

   if data and data[1] and type(data[1]) == "string" then
      data = data[1]:gsub("[%(%)]","")
   else
      local err = "Could not locate bundler gem"
   end
   return data,err
end

return { pinky_main = pinky_main }

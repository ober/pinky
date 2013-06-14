local p = require 'pinky'

local pinky_main
local get_rvms
local rvm_list_rubies
local rvm_gem_list
local rvm_get_info

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
      ps.data,ps.status.error = rvm_gem_info(args[1],args[2])
   end

   if ps.status.error then
      ps.status.value = "FAIL"
   end
   return ps
end

function get_rvms()
   local home = p.get_home()
   local rvms = {
      "/usr/local/rvm/",
      home .. "/.rvm/"
   }
   return p.find_first_file(rvms)
end

function rvm_list_rubies()
   local rvm = get_rvms()
   local dir = rvm .. "/rubies"
   if p.file_exists(dir) then
      return p.lsdir(dir)
   end
end

function rvm_gem_list(ruby)
   local out = {}
   local rvm = get_rvms()
   local dir = rvm .. "/gems/" .. ruby .. "/gems"

   if p.file_exists(dir) then
      local gems = p.lsdir(dir)
      for i,g in ipairs(gems) do
         local gname,gversion  = g:match("([%d%a-_]+)-(%d+%.%d+%.?%d?+?)")
         if gname and gversion then
            out[gname] = gversion
         else
            print("Breakage in gem name " .. g)
         end
      end
   else
      err = "Rvm does not have this ruby: " .. ruby .. " installed!"
   end
   return out,err
end

function rvm_gem_info(ruby,gem)
   local info = rvm_gem_list(ruby)[gem]
   if not info then
      err = "Could not locate gem:" .. gem .. " in ruby: " .. ruby
   end
   return info,err
end

return { pinky_main = pinky_main }

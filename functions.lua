module("functions", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 1: /function
   if #args == 0 then
      return ""
   elseif #args == 1 then
      return show_functions(args[1])
   end
end

function show_functions(module)
   local out = ""
   local mymod = require(module)
   for k,v in pairs(mymod) do
      if type(v)=='function' then
         out = out ..  k .. "\n"
      end
   end
   return out
end

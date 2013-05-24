local p = require 'pinky'
local redis = require "resty.redis"
local red = redis:new()
local json = require 'cjson'

local function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:


   return "we work!"
end

return { pinky_main = pinky_main }

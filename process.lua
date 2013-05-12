module("port", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function pinky_main()
   local out = { data = { nc }, status = { value = "", error = ""} }
   local ps =  p.exec_command("/bin/ps auxwww", nil, 11, " +", true)
   if ps[app] then
      return "OK"
   else
      return "FAIL"
   end
end

function check_process(app)
   local ps =  exec_command("/bin/ps auxwww", nil, 11, " +", true)
   if ps[app] then
      return "OK"
   else
      return "FAIL"
   end
end

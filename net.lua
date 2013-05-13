module("port", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function pinky_main(uri)
   return p.exec_command("/bin/netstat -an", nil, 1, " +",true)
end

module("net", package.seeall)
local p = require 'pinky'
local json = require 'cjson'

function pinky_main(uri)
   return json.encode(p.exec_command("/bin/netstat -an", nil, 1, " +",true))
end

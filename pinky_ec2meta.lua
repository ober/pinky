local p = require 'pinky'

local pinky_main;
local report_ping;

local function pinky_main(uri,ps)
   -- This function is the entry point.
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: /Everything after meta-data that we require

   ps.data.value,ps.data.status,ps.data.conn = fetch(uri)
   if ps.data.status ~= 200 then
      ps.status.value,ps.status.error = "FAIL", "Got a " .. ps.data.status .. " from ec2 " .. "connection info:" .. table.concat(ps.data.conn)
   end

   return ps
end

function fetch(uri)
   local root = "http://169.254.169.254/2012-01-12/meta-data/"
   local http = require "socket.http"
   local ltn12 = require "ltn12"
   return http.request(root .. uri)
end

return { pinky_main = pinky_main }

local p = require 'pinky'
local luasql = require "luasql.mysql"
local yaml = require "lyaml"

local function pinky_main(uri,ps)
   -- This function is the entry point.
   -- /pinky/mysql/check/host
   --
   local config = read_mmtop_config()
   ps.data = mysql_query(host,config.user,config.password,"test","show global status")
   return ps
end

function mysql_connect(host,user,password,db)
   env = assert (luasql.mysql())
   con = assert (env:connect("test",user,password,host))
   return con
end

function mysql_query(host,user,password,db,query)
   -- return a table of the results
   out = {}
   con = mysql_connect(host,user,password,"test")
   cur = con:execute(query)
   row = cur:fetch ({}, "a")
   while row do
      table.insert(out,row)
      -- reusing the table of results
      row = cur:fetch (row, "a")
   end
   return out
end

function read_mmtop_config()
   return yaml.load(p.read_file("/data/pinky-server/.mmtop_config"))
end

return { pinky_main = pinky_main }

local p = require 'pinky'
local luasql = require "luasql.mysql"
local yaml = require "lyaml"

local function pinky_main(uri,ps)
   -- This function is the entry point.
   -- /pinky/mysql/check/host
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: / return usage
   -- 1: mysql
   -- 2: db server
   -- 4: database name
   -- 3: check

   if #args < 1 then
      ps.status = { value = "FAIL", error = "Not enough parameters passed" }
      return out
   end

   local host = args[1]
   local config = read_mmtop_config()
   ps.data = mysql_query(host,config.user,config.password,"test","show slave status")

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
   local home = os.getenv("HOME")
   if not home then
      home = "/home/ubuntu/"
   end
   return yaml.load(p.read_file(home .. "/.mmtop_config"))
end

return { pinky_main = pinky_main }

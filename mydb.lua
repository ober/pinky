module("mydb", package.seeall)
local p = require 'pinky'
local json = require 'cjson'
local luasql = require "luasql.mysql"
local yaml = require "lyaml"

function pinky_main(uri)
   -- This function is the entry point.
   -- /pinky/mysql/check/host
   local out = { data = out, status = { value = "", error = ""} }
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: / return usage
   -- 1: mysql
   -- 2: db server
   -- 4: database name
   -- 3: check

   if #args < 1 then
      out.status.value,out.status.error = "FAIL", "Not enough parameters passed"
      return out
   end

   local host = args[1]
   local config = read_mmtop_config()
   out = mysql_query(host,config.user,config.password,"test","show slave status")

   local out = { data = out, status = { value = "OK", error = ""} }
   return json.encode(out)
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
   return yaml.load(p.read_file(os.getenv("HOME") .. "/.mmtop_config"))
end

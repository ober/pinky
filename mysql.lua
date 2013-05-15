module("mysql", package.seeall)
local p = require 'pinky'
local json = require 'cjson'
local luasql = require "luasql.mysql"
local yaml = require "lyaml"

function pinky_main(uri)
   -- This function is the entry point.
   -- /pinky/mysql/check/host
   local out = "lala" .. "\n"
   local args = p.split(uri,"/")
   -- Arguments:
   -- 0: / return usage
   -- 1: mysql
   -- 2: db server
   -- 4: database name
   -- 3: check
   local check = args[1]
   local host = args[2]

   out = mysql_query(host,"root","test","select bar from wtf")

   local out = { data = out, status = { value = "OK", error = ""} }
   return json.encode(out)
end

function mysql_connect(host,user,db)
   env = assert (luasql.mysql())
   con = assert (env:connect("test","root",nil,localhost))
   return con
end

function mysql_query(host,user,db,query)
   -- return a table of the results
   out = {}
   con = mysql_connect(host,user,db)
   cur = con:execute"select * from wtf"
   row = cur:fetch ({}, "a")
   while row do
      table.insert(out,row)
      -- reusing the table of results
      row = cur:fetch (row, "a")
   end
   return out
end

function report_latency(server,latency)
   -- Mysql report for latency
   -- env = m.mysql.mysql()
   return type(mysql)
   -- local out = p.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   -- out.Mounted = nil -- remove header
   -- out = { data = out }
   -- out.status = { value = "OK", error = "" }
   -- return json.encode(out)
end

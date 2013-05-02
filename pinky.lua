module("pinky", package.seeall)
local json = require 'cjson'

local debug
debug = function(kind, msg)
   if msg then
      msg = kind .. ": " .. msg
   else
      msg = kind
   end
   return ngx.log(ngx.DEBUG, msg)
end

function exec_command(command,fields,key_field,sep)
   local out_table = {}
   local cmd_out, cmd_err = io.popen(command)
   if cmd_out then
      for line in cmd_out:lines() do
         line_array = split(line, sep)
         out_table[line_array[key_field]] = line
      end
      return out_table
   else
      return cmd_err
   end
end

function report_disk()
   -- Disk report.
   -- Return the output of df(1)
   out = exec_command("df", nil, 6, " +")
   out.Mounted = nil -- remove header
   return out
end

function report_proc()
   return exec_command("ps", nil, 6, " +")
end

function report_net()
   return exec_command("netstat -an", nil, 6, " +")
end

function reports(check_type)
   pinky_method = "report" .. "_" .. check_type
   if type(_M[pinky_method]) == "function" then
      return _M[pinky_method]()
   else
      return "Ummm Brain, we have no method called " .. pinky_method .. " And it's really " .. type(pinky_method)
   end
end

-- cribbed from http://stackoverflow.com/questions/1426954/split-string-in-luac
function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

function disk_json()
   return json.encode(reports("disk"))
end

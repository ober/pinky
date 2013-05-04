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

function exec_command(command)
   local cmd_out, cmd_err = io.popen(command)
   local out = ""
   for line in cmd_out:lines() do
      out = out .. line
   end
   return out
end

function exec_command_tokenize(command,fields,key_field,sep)
   local out_table = {}
   local cmd_out, cmd_err = io.popen(command)
   if cmd_out then
      for line in cmd_out:lines() do
         line_array = split(line, sep)
         out_table[line_array[key_field]] = line_array
      end
      -- cmd_out.close
      if fields then
         return return_fields(out_table, fields)
      else
         return out_table
      end
   else
      return cmd_err
   end
end

function return_fields(in_table,fields)
   out_table = {}
   for k,v in pairs(in_table) do
      for I = 1, #fields do
         if v[I] then
            if out_table[k] then
               table.insert(out_table[k],v[I])
            else
               out_table[k] = { v[I] }
            end
         end
      end
   end
   return out_table
end

function report_disk()
   -- Disk report.
   -- Return the output of df(1)
   out = exec_command_tokenize("/bin/df", {1,2,3,4,5}, 6, " +")
   out.Mounted = nil -- remove header
   return out
end

function report_proc()
   return exec_command_tokenize("/bin/ps auxwww", nil, 11, " +")
end

function report_net()
   return exec_command_tokenize("/usr/bin/netstat -an", nil, 1, " +")
end

function report_mem()
   -- call free(1) -m and return values
   -- total:1        used:2       free:3     shared:4    buffers:5     cached:6"}
   out = exec_command_tokenize("/usr/bin/free -m", {1,2,3,4,5,6}, 1, " +")
   out.total = nil
   return out
end

function report_vm()
   -- call free(1) -m and return values
   -- total:1        used:2       free:3     shared:4    buffers:5     cached:6"}
   out = exec_command_tokenize("/usr/bin/vmstat -s", {1,2,3,4,5,6}, {1,2}, " +")
   out.total = nil
   return out
end

function alert_check_process(app)
   local ps =  exec_command_tokenize("/bin/ps auxwww", nil, 11, " +")
   if ps[app] then
      return "OK"
   else
      return "FAIL"
   end
end

function alert_check_port(host,port)
   local cmd = "/bin/nc -v -z -w 1 " .. host .. " " .. port .. " 2>&1"
   local nc = exec_command(cmd)
   local success = "succeeded!"
   local failure = "failed: Connection refused"
   if nc then
      if string.find(nc,failure) then
         return "FAIL"
      elseif string.find(nc,success) then
         return "OK"
      else
         return "UNKNOWN:" .. nc
      end
   else
      return "Error running nc returned nil"
   end
end

function reports(check_type)
   pinky_method = "report" .. "_" .. check_type
   if type(_M[pinky_method]) == "function" then
      return json.encode(_M[pinky_method]())
   else
      return "Ummm Brain, we have no method called " .. pinky_method
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

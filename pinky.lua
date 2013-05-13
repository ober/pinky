module("pinky", package.seeall)
local json = require 'cjson'
local lfs = require 'lfs'

local function debug (kind, msg)
   if msg then
      msg = kind .. ": " .. msg
   else
      msg = kind
   end
   return ngx.log(ngx.DEBUG, msg)
end

function file_exists(filename)
   if filename then
      local fd = io.open(filename,"r")
      if fd then
         io.close(fd)
         return true
      else
         return false
      end
   else
      return false
   end
end

function exec_command(command,fields,key_field,sep,tokenize)
   local out_table = {}
   local out = ""

   if command and not file_exists(split(command, " ")[1]) then
      handle_error("Error: " .. split(command," ")[1] .. " could not be found")
   end

   local cmd_out, cmd_err = io.popen(command)

   if cmd_out then
      for line in cmd_out:lines() do
         if tokenize then
            line_array = split(line, sep)
            out_table[line_array[key_field]] = line_array
         else
            out = out .. line
         end
      end
      if tokenize then
         if fields then
            return return_fields(out_table, fields)
         else
            return out_table
         end
      else
         return out
      end
   else
      return cmd_err
   end
end

function return_fields(in_table,fields)
   local out_table = {}
   for k,v in pairs(in_table) do
      for I = 1, #fields do
         if v[fields[I]] then
            if out_table[k] then
               table.insert(out_table[k],v[fields[I]])
            else
               out_table[k] = { v[fields[I]] }
            end
         end
      end
   end
   return out_table
end

function dispatch(uri)
   local uri = split(uri,"/")
   local PINKY_HOME = "/home/jaimef/pinky"
   local custom_lib = uri[2]
   -- local custom_lib = PINKY_HOME .. "/" .. uri[2] .. ".lua"
   local short_uri = ""

   if #uri < 2 then
      handle_error("Error: Unable to find functions in uri")
   end

   for I=3,#uri do
      short_uri = short_uri .. "/" .. uri[I]
   end


   if not  uri[2] then
      handle_error("uri[2] is nil!")
   end

   if file_exists(PINKY_HOME .. "/" .. uri[2] .. ".lua") then
      local custom_lib = require(custom_lib)
      -- make sure main exists first, then error.
      if type(custom_lib) ~= "table" then
         handle_error("Error: type is " .. type(custom_lib))
      end
      if custom_lib.pinky_main then
         return custom_lib.pinky_main(short_uri)
      else
         handle_error("Could not locate " .. uri[2] .. ".pinky_main")
      end
   else
      handle_error("Error: could not locate " .. custom_lib)
   end
end

-- cribbed from http://stackoverflow.com/questions/1426954/split-string-in-luac
function split(pString, pPattern)
   if not pString or not pPattern then
      return "pString or pPattern were nil"
   end
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

function lsdir (path)
   local out_table = {}
   for file in lfs.dir(path) do
      if file ~= "." and file ~= ".." then
         table.insert(out_table, file)
      end
   end
   return out_table
end

function handle_error(msg)
   return  { data = {}, status = { value = "FAIL", error = msg} }
end

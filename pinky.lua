local json = require 'cjson'
local lfs = require 'lfs'

local debug;
local split;
local file_exists;
local exec_command;
local return_fields;
local dispatch;
local lsdir ;
local read_file;
local get_home;
local get_username;
local get_os;
local find_first_file;
local treewalker;
local trim;
local get_ip;
local print_table;

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
      return  { data = {}, status = { value = "FAIL", error = split(command," ")[1] .. " could not be found" } }
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
   local PINKY_HOME = "/data/pinky-server/vendor/projects/pinky/"
   local custom_lib = uri[2]
   -- local custom_lib = PINKY_HOME .. "/" .. uri[2] .. ".lua"
   local short_uri = ""

   if #uri < 1 then
      return  json.encode({ data = {}, status = { value = "FAIL", error = "Unable to find functions in uri" }})
   end

   for I=3,#uri do
      short_uri = short_uri .. "/" .. uri[I]
   end

   if not uri[2] then
      return json.encode({ data = {}, status = { value = "FAIL", error = "uri[2] is nil!" }})
   end

   if file_exists(PINKY_HOME .. "/" .. uri[2] .. ".lua") then
      local custom_lib = require(custom_lib)
      -- make sure main exists first, then error.
      if type(custom_lib) ~= "table" then
         return json.encode({ data = {}, status = { value = "FAIL", error = "Error: type is " .. type(custom_lib) .. " value:" .. tostring(custom_lib) }})
      end
      if custom_lib.pinky_main then
         return custom_lib.pinky_main(short_uri)
      else
         return json.encode({ data = {}, status = { value = "FAIL", error = "Could not locate " .. uri[2] .. ".pinky_main" }})
      end
   else
      return json.encode({ data = {}, status = { value = "FAIL", error = "Error: could not locate " .. custom_lib }})
   end
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

function read_file(file)
   local fd = io.open(file, "rb")
   local guts = fd:read("*all")
   fd:close()
   return guts
end

function get_home()
   local OS = get_os()
   local USER = get_username()
   if OS == "Darwin" then
      return "/Users/" .. USER .. "/"
   elseif OS == "Linux" then
      return "/home/" .. USER .. "/"
   else
      return "/home/" .. USER .. "/"
   end
end

function get_username()
   return exec_command("/usr/bin/whoami",nil,nil," +",false)
end

function get_os()
   return exec_command("/usr/bin/uname -s",nil,nil," +",false)
end

function find_first_file(files)
   -- We take a table of files, and return the first one that exists
   for file = 1, #files do
      if file_exists(files[file]) then
         return files[file]
      end
   end
end

function treewalker(path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file
            print ("\t "..f)
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
            if attr.mode == "directory" then
                treewalker (f)
            else
                for name, value in pairs(attr) do
                    print (name, value)
                end
            end
        end
    end
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function get_ip(hostname)
   local socket = require 'socket'
   host = socket.dns.toip(hostname)
   if host then
      return tostring(host)
   else
      return host
   end
end

function print_table(in_table)
   local out = ""
   for k,v in pairs(in_table) do
      if type(v) == "table" then
         v = print_table(v)
      end
      if type(k) == "table" then
         k = print_table(k)
      end
      out = out .. " " .. k .. " " .. v
   end
   return out
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


return {
   file_exists = file_exists;
   exec_command = exec_command;
   return_fields = return_fields;
   split = split;
   dispatch = dispatch;
   lsdir  = lsdir ;
   read_file = read_file;
   get_home = get_home;
   get_username = get_username;
   get_os = get_os;
   find_first_file = find_first_file;
   treewalker = treewalker;
   trim = trim;
   get_ip = get_ip;
   print_table = print_table;
}

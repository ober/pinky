local json = require 'cjson'
local lfs = require 'lfs'
local socket = require 'socket'

local debug;
local dispatch;
local do_error;
local exec_command;
local file_exists;
local find_first_file;
local get_home;
local get_ip;
local get_os;
local get_username;
local init;
local lsdir ;
local read_file;
local return_fields;
local split;
local treewalker;
local trim;
local print_table;
local xml_find_tags;

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
   local ps = init()
   local PINKY_HOME = "/data/pinky-server/vendor/projects/pinky/"
   local custom_lib = "pinky_" .. uri[2]
   -- local custom_lib = PINKY_HOME .. "/" .. uri[2] .. ".lua"
   local short_uri = ""

   if #uri < 1 then
      ps = do_error("Unable to find functions in uri", ps)
      -- return  json.encode({ data = {}, status = { value = "FAIL", error =
   end

   for I=3,#uri do
      short_uri = short_uri .. "/" .. uri[I]
   end

   if not uri[2] then
      ps = do_error("No controller passed.",ps)
      -- return json.encode({ data = {}, status = { value = "FAIL", error = "uri[2] is nil!" }})
   end

   if file_exists(PINKY_HOME .. "/" .. custom_lib .. ".lua") then
      local custom_lib = require(custom_lib)
      -- make sure main exists first, then error.
      if type(custom_lib) ~= "table" then
         ps = do_error("Error: type is " .. type(custom_lib) .. " value:" .. tostring(custom_lib),ps)
         -- return json.encode({ data = {}, status = { value = "FAIL", error =
      end
      if custom_lib.pinky_main then
         ps = custom_lib.pinky_main(short_uri,ps)
      else
         ps = do_error("Could not locate " .. uri[2] .. ".pinky_main", ps)
         -- return json.encode({ data = {}, status = { value = "FAIL", error =  }})
      end
   else
      ps = do_error("Error: could not locate " .. custom_lib, ps)
      -- return json.encode({ data = {}, status = { value = "FAIL", error =  }})
   end
   return json.encode(ps)
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
   local guts = ""
   local fd = io.open(file, "rb")
   if fd then
      guts = fd:read("*all")
      fd:close()
   else
      local err = "Could not find " .. file
   end

   return guts,err
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
   return exec_command("/usr/bin/env uname -s",nil,nil," +",false)
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

function xml_find_tags(xmldata,tags)
   local out = {}
   require 'LuaXml'
   local x = xml.eval(xmldata)
   if x then
      for i,t in ipairs(tags) do
         out[t] = xml.find(x,t)[1]
      end
   else
     local err = "No xml found"
   end
   return out,err
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
      if type(v) == "function" then
         v = tostring(v)
      end
      if type(k) == "function" then
         k = tostring(k)
      end
      out = out .. " " .. k .. " " .. v
   end
   return out
end

function do_error(error_msg,ps)
   ps.status.value,ps.status.error  = "FAIL", error_msg
   return ps
end

function do_usage(usage_msg,ps)

end

function init()
   return { system = { time = os.time(), name = socket.dns.gethostname() }, data = {}, status = { value = "OK", error = ""}}
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

-- Provide chomp
function chomp(s)
   return gsub(s,"\n$", "")
end

return {
   dispatch = dispatch;
   do_error = do_error;
   exec_command = exec_command;
   file_exists = file_exists;
   find_first_file = find_first_file;
   get_home = get_home;
   get_ip = get_ip;
   get_os = get_os;
   get_username = get_username;
   init = init;
   lsdir  = lsdir ;
   print_table = print_table;
   read_file = read_file;
   return_fields = return_fields;
   split = split;
   treewalker = treewalker;
   trim = trim;
   xml_find_tags = xml_find_tags;
}

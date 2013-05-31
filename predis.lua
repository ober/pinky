local p = require 'pinky'

local json = require 'cjson'
local redis = require "redis"

local handle_list;
local handle_none;
local handle_set;
local handle_string;
local pinky_main;
local process_redis;
local redis_check;
local redis_connect;
local redis_getdata;
local resque_check;
local singularize;
local usage;



local pstatus = {
   data = {};
   status = {
      value = "OK";
      error = "";
   }
}

local function usage()
   pstatus.status.value = "FAIL"
   pstatus.status.error = [[
Check Redis:
Valid URLS:
/pinky/predis/up      -- Check if redis is up locally.
/pinky/predis/resque  -- Return resque worker information.
]];
end

local function pinky_main(uri)
   -- This function is the entry point.
   local args = p.split(uri,"/")

   if #args == 0 then -- Check if Redis is up return appropriate info.
      usage()
   else
      if args[1] == "up" then
         redis_check()
      elseif args[1] == "workers" then
         process_redis("resque:workers")
      elseif args[1] == "queues" then
         process_redis("resque:queues")
      elseif args[1] == "failed" then
         process_redis("resque:failed")
      elseif args[1] == "loners" then
         process_redis("resque:loners")
      elseif args[1] == "stat" then
         process_redis("resque:stat")
      else
         usage()
      end
   end
   return json.encode(pstatus)
end

function redis_connect(ip,port)
   local ip = ip or '127.0.0.1'
   local port = port or 6379
   return redis.connect(ip,port)
end

function redis_check()
   local client = redis_connect()
   local response = client:ping()
   pstatus.status.value,pstatus.data = "OK", response
end

function handle_list(list,client,parent)
   print("handle_list: list:" .. list .. " parent:" .. parent)
   parent = parent or ""
   local len = client:llen(parent .. list)
   if len then
      len = len > 2000 and 2000 or len
      for l=1,len,1 do
         pstatus.data[parent .. list .. l] = client:lindex(parent .. list,l - 1)
      end
   end
end

function handle_set(set,client,parent)
   parent = parent or ""
   for i, v in ipairs(client:smembers(set)) do
      pstatus.data[parent .. set] = {}
      v = singularize(set) .. ":" .. v
      if v then
         process_redis(v,client,parent)
      end
   end
end

function handle_string(string,client,parent)
   pstatus.data[parent .. string] = client:get(parent .. string)
end

function handle_none(none,client,parent)
   pstatus.data[parent .. none] = client:get(parent .. none)
end

function singularize(name)
   return string.sub(name,1,-2)
end

function process_redis(something,client,parent)
   local parent = parent or ""
   local client = client or redis_connect()
   local type = client:type(something)

   if type == "set" then
      handle_set(something,client,parent)
   elseif type == "list" then
      handle_list(something,client,parent)
   elseif type == "none" then
      handle_none(something,client,parent)
   elseif type == "string" then
      handle_string(something,client,parent)
   else
      print("Unknown type:" .. type)
   end
end

return { pinky_main = pinky_main }

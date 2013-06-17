local p = require 'pinky'
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

local function usage()
   return [[
Check Redis:
Valid URLS:
/pinky/redis/up      -- Check if redis is up locally.
/pinky/redis/workers  -- Return resque worker information.
/pinky/redis/queues  -- Return resque queues information.
/pinky/redis/failed  -- Return resque failed job information. (max 2k)
/pinky/redis/stat  -- Return resque stat entries
/pinky/redis/loners  -- Return resque loners job entries
]];
end

local function pinky_main(uri,ps)
   -- This function is the entry point.
   local args = p.split(uri,"/")

   if #args == 0 then -- Check if Redis is up return appropriate info.
      ps = p.do_error(usage(),ps)
   else
      if args[1] == "up" then
         ps = redis_check(ps)
      elseif args[1] == "monitor" then
         ps = monitor(ps)
      elseif args[1] == "workers" then
         ps = process_redis("resque:workers",nil,nil,ps)
      elseif args[1] == "queues" then
         ps = process_redis("resque:queues",nil,nil,ps)
      elseif args[1] == "failed" then
         ps = process_redis("resque:failed",nil,nil,ps)
      elseif args[1] == "loners" then
         ps = process_redis("resque:loners",nil,nil,ps)
      elseif args[1] == "stat" then
         ps = process_redis("resque:stat",nil,nil,ps)
      elseif args[1] == "mobile_subscriptions" then
         ps = process_redis("mobile_subscriptions:*",nil,nil,ps)
      elseif args[1] == "keys" and #args > 1 then
         ps = process_keys("mobile_subscriptions:*",nil,nil,ps)
      else
         ps.status.value,ps.status.error = "FAIL", usage()
      end
   end
   return ps
end

function redis_connect(ip,port)
   local ip = ip or '127.0.0.1'
   local port = port or 6379
   local client,err = redis.connect(ip,port)
   return client,err
end

function redis_check(ps)
   local client,err = redis_connect()
   if err then
      ps.status.value, ps.status.error = "FAIL", err
   else
      if client:ping() then
         ps.data = "OK! Redis is alive"
      else
         ps.status.value,ps.status.error = "FAIL", "Redis is not pingable!"
      end
   end
   return ps
end


function monitor(ps)
   local client,err = redis_connect()
   if err then
      ps.status.value, ps.status.error = "FAIL", err
   else
      ps.data = {}
      for k,v in  pairs(client:info()) do
         ps.data[k] = v
      end
   end
   return ps
end


function handle_list(list,client,parent,ps)
   print("handle_list: list:" .. list .. " parent:" .. parent)
   parent = parent or ""
   local len = client:llen(parent .. list)
   if len then
      len = len > 2000 and 2000 or len
      for l=1,len,1 do
         ps.data[parent .. list .. l] = client:lindex(parent .. list, l - 1)
      end
   end
end

function handle_set(set,client,parent,ps)
   parent = parent or ""
   for i, v in ipairs(client:smembers(set)) do
      ps.data[parent .. set] = {}
      v = singularize(set) .. ":" .. v
      if v then
         process_redis(v,client,parent)
      end
   end
   return ps
end

function handle_string(string,client,parent,ps)
   ps.data[parent .. string] = client:get(parent .. string)
   return ps
end

function handle_none(none,client,parent,ps)
   print("handle_none:" .. tostring(none) .. " client:" .. tostring(client) .. " parent:" .. tostring(parent) .. " ps:" .. tostring(ps))
   ps.data[parent .. none] = client:get(parent .. none)
   return ps
end

function singularize(name)
   return string.sub(name,1,-2)
end

function process_redis(something,client,parent,ps)
   local parent = parent or ""
   local client = client or redis_connect()
   local type = client:type(something)
   print("type is :" .. type)
   if type == "set" then
      ps = handle_set(something,client,parent,ps)
   elseif type == "list" then
      ps = handle_list(something,client,parent,ps)
   elseif type == "none" then
      ps = handle_none(something,client,parent,ps)
   elseif type == "string" then
      ps = handle_string(something,client,parent,ps)
   else
      print("Unknown type:" .. type)
   end
   return ps
end

return { pinky_main = pinky_main }

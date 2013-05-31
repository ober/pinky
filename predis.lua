local p = require 'pinky'

local json = require 'cjson'
local redis = require "redis"

local pinky_main;
local usage;
local redis_check;
local redis_check;
local resque_check;
local resque_queues;

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
   -- Arguments:

   if #args == 0 then -- Check if Redis is up return appropriate info.
      usage()
   else
      if args[1] == "up" then
         redis_check()
      elseif args[1] == "resque" then
         resque_check()
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

function resque_check()
   local client = redis_connect()
   for i, v in ipairs(client:smembers('resque:workers')) do
      if v then
         print(i .. tostring(v))
         pstatus.data[tostring(v)] = tostring(client:get(v))
      end
   end
end

function resque_queues()
   local client = redis_connect()
   pstatus.data = client:smembers('resque:queues')
end

return { pinky_main = pinky_main }

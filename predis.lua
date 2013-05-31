local p = require 'pinky'

local json = require 'cjson'
local redis = require "redis"

local pinky_main;
local usage;
local redis_check;
local redis_getdata;
local resque_check;

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
      elseif args[1] == "workers" then
         resque_getdata("resque:workers","resque:worker:")
      elseif args[1] == "queues" then
         resque_getdata("resque:queues","resque:queue:")
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

function resque_getdata(set,short)
   set = set or 'resque:workers'
   local client = redis_connect()
   print("smember type is : " .. client:type(set))
   for i, v in ipairs(client:smembers(set)) do
      v = short .. v
      if v then
         local type = client:type(v)
         if type == "list" then
            local len = client:llen(v)
            if len then
               for l=1,len,1 do
                  pstatus.data[tostring(v)] = tostring(client:lindex(v,l - 1))
               end
            else
               print("Empty list")
            end
         elseif type == "none" then
            print("got v:" .. v .. " type:" .. type)
            pstatus.data[tostring(v)] = tostring(client:get(v))
         elseif type == "string" then
            pstatus.data[tostring(v)] = tostring(client:get(v))
         else
            print("Unknown type:", client:type(v))
         end
      end
   end
end

return { pinky_main = pinky_main }

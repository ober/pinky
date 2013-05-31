local p = require 'pinky'
local json = require 'cjson'

local empty;
local foo;
local bar;

local pstatus = { data = {}, status = { value = "OK", error = ""}}

local function pinky_main(uri)
   -- This function is the entry point.
   -- We are passed the rest of the uri.
   local args = p.split(uri,"/")

   if #args == 0 then
      return json.encode(empty())
   elseif #args == 1 then
      return json.encode(foo())
   elseif #args == 2 then
      return json.encode(bar())
   end
end


function empty()
   return "Hello controller called with no args! (e.g. http://localhost/pinky/hello)"
end

function foo()
   return "Hello controller called with one arg, foo! (e.g. http://localhost/pinky/hello/foo)"
end

function bar()
   return "Hello controller called with two args, foo and bar! (e.g. http://localhost/pinky/hello/foo/bar)"
end

return { pinky_main = pinky_main }

local p = require 'pinky'

local pinky_main
local empty
local foo
local bar

function pinky_main(uri,ps)
   -- This function is the entry point.
   -- We are passed the rest of the uri.
   local args = p.split(uri,"/")

   if #args == 0 then
      ps.data = empty()
   elseif #args == 1 then
      ps.data = foo()
   elseif #args == 2 then
      ps.data = bar()
   end
   return ps
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

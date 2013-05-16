package = "Pinky"
version = "0.1-0"
source = {
   url = "http://github.com/ober/pinky"
}
description = {
   summary = ".",
   detailed = [[
      Pinky is a monitoring system built in Lua on top of open-resty.
   ]],
   homepage = "http://github.com/ober/pinky",
   license = "MIT/X11"
}
dependencies = {
   "lua ~> 5.1",
   "lua-cjson ~> 2.1.0-1",
   "luasql-mysql",
   "lyaml",
   "luafilesystem"
}
build = {
   type = "builtin",
   modules = {
      disk = "disk.lua",
      mydb = "mydb.lua",
      memfree = "memfree.lua",
      pinky = "pinky.lua",
      port  = "port.lua",
      process  = "process.lua",
      rvm = "rvm.lua",
      vmstat = "vmstat.lua"
   },
   install = {
      bin = { "pinky" }
   }
}

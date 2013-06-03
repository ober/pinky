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
   "luafilesystem",
   "luasocket",
   "luaposix",
   "luaxml",
   "redis-lua"
}
build = {
   type = "builtin",
   modules = {
      disk = "disk.lua",
      hello = "hello.lua",
      load = "load.lua",
      memfree = "memfree.lua",
      mydb = "mydb.lua",
      net = "net.lua",
      passenger = "passenger.lua",
      ping= "ping.lua",
      port = "port.lua",
      predis  = "predis.lua",
      proc = "proc.lua",
      process  = "process.lua",
      rvm = "rvm.lua",
      status  = "predis.lua",
      unicorn = "unicorn.lua",
      vmstat = "vmstat.lua"
   },
   install = {
      bin = { "pinky" }
   }
}

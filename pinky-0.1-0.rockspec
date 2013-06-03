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
      pinky_disk = "pinky_disk.lua",
      pinky_hello = "pinky_hello.lua",
      pinky_load = "pinky_load.lua",
      pinky_memfree = "pinky_memfree.lua",
      pinky_mydb = "pinky_mydb.lua",
      pinky_net = "pinky_net.lua",
      pinky_passenger = "pinky_passenger.lua",
      pinky_ping= "pinky_ping.lua",
      pinky = "pinky.lua",
      pinky_port = "pinky_port.lua",
      pinky_predis  = "pinky_predis.lua",
      pinky_proc = "pinky_proc.lua",
      pinky_process  = "pinky_process.lua",
      pinky_rvm = "pinky_rvm.lua",
      pinky_status  = "pinky_predis.lua",
      pinky_unicorn = "pinky_unicorn.lua",
      pinky_vmstat = "pinky_vmstat.lua"
   },
   install = {
      bin = { "pinky" }
   }
}

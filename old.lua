function show_functions(module)
   local out = ""
   local mymod = require(module)
   for k,v in pairs(mymod) do
      if type(v)=='function' then
         out = out ..  k .. "\n"
      end
   end
   return out
end

function print_table(in_table)
   local out = ""
   for k,v in pairs(ngx.var) do
      out = out .. " " .. k .. " " .. v
   end
   return out
end


function reports(check_type)
   local pinky_method = "report" .. "_" .. check_type
   if type(_M[pinky_method]) == "function" then
      return json.encode(_M[pinky_method]())
   else
      return "Ummm Brain, we have no method called " .. pinky_method
   end
end

-- repetative shit

function report_load()
   return exec_command("/bin/uptime")
end

function report_iostat()
   return exec_command("/bin/iostat 2|head -n 1")
end

function report_mpstat()
   return exec_command("/bin/uptime")
end

function report_socks()
   return exec_command("/bin/uptime")
end

function report_sar()
   return exec_command("/bin/uptime")
end

function report_uptime()
   return exec_command("/bin/uptime")
end

function report_vmstat()
   return exec_command("/bin/uptime")
end

function report_who()
   return exec_command("/bin/uptime")
end

function report_ps()
   return exec_command("/bin/ps auxwww", nil, 11, " +",true)
end

function report_net()
   return exec_command("/bin/netstat -an", nil, 1, " +",true)
end

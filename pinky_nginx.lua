local p = require 'pinky'
local lfs = require 'lfs'
local json = require 'cjson'
local date = require 'date'

local pinky_main;
local read_file;
local parse_date;

function pinky_main(file,ps)
   -- This function is the entry point.
   -- Arguments:
   -- The only argument we take is the full path to a single file.
   if not ps.minutes then ps.minutes = 10 end
   -- ps.file = file

   if not file or file == "" then
      ps = p.do_error("Usage: /pinky/nginx/some/path/to/a/file", ps)
   end

   if not p.file_exists(file) then
      ps = p.do_error("File not found", ps)
   else
   ps.handle = io.input(file)

   ps = find_pos_for_zone(ps)
   ps = read_lines_at_offset(ps)
   end
   return ps
end

function find_pos_for_zone(ps)
   -- Use binary search to find the point in the log file where
   -- our time range begins
   local BUFSIZE = 2^13 -- 8K
   -- local offset = ps.handle:seek(0)
   local not_found = true

   while not_found do
      -- seek half the distance each pass until we find something. If
      -- we are too close to end we just give up and return end.
      -- read a line,
      ps.handle:seek("set", ps.handle:seek("end")/2)
      local _, _ = ps.handle:read(BUFSIZE, "*line")
      if are_we_in_the_zone() then
         ps.found_position = ps.handle:seek("cur")
         not_found = false
      end
   end -- while
   return ps
end

function are_we_in_the_zone(line_date_time, current_time, minutes)
   local ldate = date(line_date_time)
   local sdate = date(current_time)
   local c = date.diff(sdate, ldate)
   if c:spanminutes() <= minutes then
      return true
   else
      return false
   end
end

function get_time_for_current_line(lines)
   local _,_,_,ld,_ = unpack(p.split(lines," +"))
   ld = ld:gsub("%[","")
   local lt = {}
   local lf = p.split(ld,":")
end

function read_lines_at_offset(ps)
   local BUFSIZE = 2^13 -- 8K
   -- local f = io.input(file) -- open input file
   -- local size_of_file = f:seek("end")
   -- print("size of file:" .. size_of_file)

   if ps.handle then
      while true do
         ps.handle:seek("set", ps.found_position)
         local lines, rest = ps.handle:read(BUFSIZE, "*line")
         if not lines then break end
         if rest then lines = lines .. rest .. '\n' end
         local ldate = get_time_for_current_line(lines)
         local ldate = date(lt.date .. " " .. tostring(lt.hour) .. ":" .. tostring(lt.minute) .. ":" .. tostring(lt.second))
         local sdate = date(ps.system.time)
         local c = date.diff(sdate, ldate)
         if c:spanminutes() <= minutes then
            table.insert(ps.data, lines)
         end
      end
   end
end

function read_file(ps,offset)
   if not minutes then minutes = 100 end
   if p.file_exists(file) then
      local BUFSIZE = 2^13 -- 8K
      local f = io.input(file) -- open input file
      local size_of_file = f:seek("end")
      print("size of file:" .. size_of_file)
      f:seek("set",size_of_file/2)
      if f then
         while true do
            local _, _ = f:read(BUFSIZE, "*line")
            local lines, rest = f:read(BUFSIZE, "*line")
            if not lines then break end
            if rest then lines = lines .. rest .. '\n' end
            local _,_,_,ld,_ = unpack(p.split(lines," +"))
            -- 127.0.0.1 - - [18/Jun/2013:08:57:06 +0000] "GET /up/sms HTTP/1.1" 499 0 "-" "curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3"
            ld = ld:gsub("%[","")
            local lt = {}
            local lf = p.split(ld,":")
            lt.date,lt.hour,lt.minute,lt.second = unpack(lf)
            p.print_table(lt)
            local ldate = date(lt.date .. " " .. tostring(lt.hour) .. ":" .. tostring(lt.minute) .. ":" .. tostring(lt.second))
            local sdate = date(ps.system.time)
            local c = date.diff(sdate, ldate)
            if c:spanminutes() <= minutes then
               table.insert(ps.data, lines)
            end
         end
      else
         ps.status.value,ps.status.error = "FAIL", "Could not read file. Check perms!"
      end
   else
      ps.status.value,ps.status.error = "FAIL", "File does not exist!"
   end
   return ps
end

return { pinky_main = pinky_main }

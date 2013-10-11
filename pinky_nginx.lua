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

   -- if not file or file == "" then
   --    ps = p.do_error("Usage: /pinky/nginx/some/path/to/a/file", ps)
   -- end

   -- if not p.file_exists(file) then
   --    ps = p.do_error("File not found", ps)
   -- else
   -- ps.handle = io.input(file)

   -- ps = find_pos_for_zone(ps)
   -- ps = read_lines_at_offset(ps)
   -- end
   ps.hops = 0
   ps.lines = 0
   ps.lines_match = 0
   if not p.file_exists(file) then return {} end
   ps.handle = assert(io.open(file, "r"))

   ps.index = create_index(ps)
   ps.lines_total = #ps.index
   ps.not_found = true

   ps.range_first = 0
   ps.range_last = ps.index[#ps.index - 1]

   ps.current_position,ps.first_found_range = 0,0

   range_begin = find_begin_range(ps)

   ps.handle:close()
   ps.handle,ps.index = nil,nil -- nil out stuff we don't wish to return
   return ps
end

function find_begin_range(ps)
   ps.hops = ps.hops + 1

  -- Criteria for success is previous line is out of time.

   local iStart,iEnd,iMid = 1,#ps.index,(#ps.index/2)
   while iStart <= iEnd do
      iMid = math.floor((iStart+iEnd)/2)

      local value2 = get_time(line)


   end
   -- Avoid heap allocs for performance
   -- local default_fcompval = function( value ) return value end
   -- local fcompf = function( a,b ) return a < b end

   -- local fcompr = function( a,b ) return a > b end
   -- function table.binsearch( t,value,fcompval,reversed )
   --    -- Initialise functions
   --    local fcompval = fcompval or default_fcompval
   --    local fcomp = reversed and fcompr or fcompf
   --    --  Initialise numbers
   --    local iStart,iEnd,iMid = 1,#t,0
   --    -- Binary Search
   --    while iStart <= iEnd do
   --       -- calculate middle
   --       iMid = math.floor( (iStart+iEnd)/2 )
   --       -- get compare value
   --       local value2 = fcompval( t[iMid] )
   --       -- get all values that match
   --       if value == value2 then
   --          local tfound,num = { iMid,iMid },iMid - 1
   --          while value == fcompval( t[num] ) do
   --             tfound[1],num = num,num - 1
   --          end
   --          num = iMid + 1
   --          while value == fcompval( t[num] ) do
   --             tfound[2],num = num,num + 1
   --          end
   --          return tfound
   --          -- keep searching
   --       elseif fcomp( value,value2 ) then
   --          iEnd = iMid - 1
   --       else
   --          iStart = iMid + 1
   --       end
   --    end
   -- end
   --            end



   find_begin_range(ps)

   return ps.handle:seek("cur")
end





function get_time(line,ps)
   local _,_,_,ld,_ = unpack(p.split(line," +"))
   ld = ld:gsub("%[","")
   local lf = p.split(line,":")
   local lt = {}
   lt.date,lt.hour,lt.minute,lt.second = unpack(lf)
   lt.date = p.split(lt.date,"%[")[2]
   lt.second = p.split(lt.second," +")[1]
   local ldate = date(tostring(lt.date) .. " " .. tostring(lt.hour) .. ":" .. tostring(lt.minute) .. ":" .. tostring(lt.second))
   local sdate = date(ps.system.time)
   local c = date.diff(sdate, ldate)
   if c:spanminutes() <= ps.minutes then
      return true
   else
      return false
   end
end


function create_index(ps)
   lines = {}
   local file = ps.handle
   for line in file:lines() do
      lines[#lines + 1] = file:seek()
   end
   return lines
end

-- tests the functions above
-- local file = 'test.lua'
-- local lines = lines_from(file)

-- -- print all line numbers and their contents
-- for k,v in pairs(lines) do
--   print('line[' .. k .. ']', v)
-- end



return { pinky_main = pinky_main }

-- function find_pos_for_zone(ps)
--    -- Use binary search to find the point in the log file where
--    -- our time range begins
--    local BUFSIZE = 2^13 -- 8K
--    -- local offset = ps.handle:seek(0)
--    local not_found = true

--    while not_found do
--       -- seek half the distance each pass until we find something. If
--       -- we are too close to end we just give up and return end.
--       -- read a line,
--       ps.handle:seek("set", ps.handle:seek("end")/2)
--       local _, _ = ps.handle:read(BUFSIZE, "*line")
--       if are_we_in_the_zone() then
--          ps.found_position = ps.handle:seek("cur")
--          not_found = false
--       end
--    end -- while
--    return ps
-- end

-- function are_we_in_the_zone(line_date_time, current_time, minutes)
--    local ldate = date(line_date_time)
--    local sdate = date(current_time)
--    local c = date.diff(sdate, ldate)
--    if c:spanminutes() <= minutes then
--       return true
--    else
--       return false
--    end
-- end

-- function get_time()
--    local _,_,_,ld,_ = unpack(p.split(lines," +"))
--    ld = ld:gsub("%[","")
--    local lt = {}
--    local lf = p.split(ld,":")
-- end

-- function read_lines_at_offset(ps)
--    local BUFSIZE = 2^13 -- 8K
--    -- local f = io.input(file) -- open input file
--    -- local size_of_file = f:seek("end")
--    -- print("size of file:" .. size_of_file)

--    if ps.handle then
--       while true do
--          ps.handle:seek("set", ps.found_position)
--          local lines, rest = ps.handle:read(BUFSIZE, "*line")
--          if not lines then break end
--          if rest then lines = lines .. rest .. '\n' end

--          -- local ldate = get_time_for_current_line(lines)
--          -- local ldate = date(lt.date .. " " .. tostring(lt.hour) .. ":" .. tostring(lt.minute) .. ":" .. tostring(lt.second))
--          -- local sdate = date(ps.system.time)
--          -- local c = date.diff(sdate, ldate)
--          -- if c:spanminutes() <= minutes then
--          --    table.insert(ps.data, lines)
--         -- end
--       end
--    end
-- end

-- function read_file(ps)
--    if not minutes then minutes = 100 end
--    if p.file_exists(ps.file) then
--       local BUFSIZE = 2^13 -- 8K
--       local f = io.input(ps.file) -- open input file
--       -- local size_of_file = f:seek("end")
--       -- print("size of file:" .. size_of_file)
--       f:seek("set",0)
--       ps.linesets = {}
--       ps.lines = 0
--       if f then
--          while true do
--             -- local _, _ = f:read(BUFSIZE, "*line")
--             local lines, rest = f:read(BUFSIZE, "*line")
--             if not lines then break end
--             if rest then lines = lines .. rest .. '\n' end
--             -- local _,_,_,ld,_ = unpack(p.split(lines," +"))
--             -- 127.0.0.1 - - [18/Jun/2013:08:57:06 +0000] "GET /up/sms HTTP/1.1" 499 0 "-" "curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1 zlib/1.2.3.4 libidn/1.23 librtmp/2.3"
--             -- ld = ld:gsub("%[","")
--             -- local lt = {}
--             -- local lf = p.split(ld,":")
--             -- lt.date,lt.hour,lt.minute,lt.second = unpack(lf)
--             ps.lines = ps.lines + 1
--             -- local ldate = date(tostring(lt.date) .. " " .. tostring(lt.hour) .. ":" .. tostring(lt.minute) .. ":" .. tostring(lt.second))
--             -- local sdate = date(ps.system.time)
--             -- local c = date.diff(sdate, ldate)
--             -- if c:spanminutes() <= minutes then
--             --    table.insert(ps.data, lines)
--             -- end
--          end
--       else
--          ps.status.value,ps.status.error = "FAIL", "Could not read file. Check perms!"
--       end
--    else
--       ps.status.value,ps.status.error = "FAIL", "File does not exist!"
--    end
--    return ps
-- end

-- function file_exists(file)
--   local f = io.open(file, "rb")
--   if f then f:close() end
--   return f ~= nil
-- end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist

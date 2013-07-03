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

   if file and file ~= "" then
      ps = read_file(file,ps,10)
   else
      ps = p.do_error("Usage: /pinky/stat/some/path/to/a/file", ps)
   end

   return ps
end

function read_file(file,ps,minutes)
   if not minutes then minutes = 10 end
   if p.file_exists(file) then
      local BUFSIZE = 2^13 -- 8K
      local f = io.input(file) -- open input file
      print(type(f))
      if f then
         local cc, lc, wc = 0, 0, 0 -- char, line, and word counts
         while true do
            local lines, rest = f:read(BUFSIZE, "*line")
            if not lines then break end
            if rest then lines = lines .. rest .. '\n' end
            local ld,lt = unpack(p.split(lines," +"))
            local ldate = date(ld .. " " .. lt)
            local sdate = date(ps.system.time)
            local c = date.diff(sdate, ldate)
            if c:spanminutes() <= minutes then
               table.insert(ps.data, lines)
            end
            cc = cc + string.len(lines)
            -- count words in the chunk
            local _,t = string.gsub(lines, "%S+", "")
            wc = wc + t
            -- count newlines in the chunk
            _,t = string.gsub(lines, "\n", "\n")
            lc = lc + t
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

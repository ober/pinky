require "lunit"
local pinky = require "pinky"
local json = require 'cjson'

module( "pinky_testcase", lunit.testcase )

-- exec_command
function test_exec_command_nxfile()
   assert_equal('Error: /usr/bin/some_binary_not_there could not be found',pinky.exec_command("/usr/bin/some_binary_not_there"), "Test exec_command on nxfile")
end

function test_exec_command_yes()
   assert_equal("y" ,pinky.exec_command("/usr/bin/yes | head -n 1"), "Test exec_command on yes cmd")
end

function test_exec_command_uptime()
   out = pinky.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   assert_not_nil(out)
   assert_equal({},is_table(out))
   -- is_table(nil)
   -- out = json.decode(pinky.exec_command("/bin/df",{1},1," ",true))
   -- assert_equal("table", type(out), "Test exec_command brings back table")
end

-- file_exists
function test_file_exists_tmp()
   assert_true(pinky.file_exists("/tmp/"), "test if /tmp exists")
end

function test_file_exists_nxfile()
   assert_false(pinky.file_exists("/tmp/LALA.SOME_FILE_THAT_WONT_EXIST"), "test if /tmp/NXFILE exists")
end

-- reports
function test_reports_nxfunction()
   assert_equal('Ummm Brain, we have no method called report_nxfunction', pinky.reports("nxfunction"))
end

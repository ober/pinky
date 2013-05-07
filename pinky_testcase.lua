require "lunit"
local pinky = require "pinky"
local json = require 'cjson'

module( "pinky_testcase", lunit.testcase, package.seeall )

-- exec_command
function test_exec_command_nxfile()
   assert_equal('Error: /usr/bin/some_binary_not_there could not be found',pinky.exec_command("/usr/bin/some_binary_not_there"), "Test exec_command on nxfile")
end

function test_exec_command_yes()
   assert_equal("y" ,pinky.exec_command("/usr/bin/yes | head -n 1"), "Test exec_command on yes cmd")
end

function test_exec_command_df1()
   out = pinky.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   assert_table(out)
end

function test_exec_command_df2()
   out = pinky.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   assert_equal("Filesystem", out.Mounted[1])
end

function test_exec_command_untokenized()
   out = pinky.exec_command("/bin/echo HELLO BRAIN", nil,nil," +",nil)
   assert_equal("HELLO BRAIN", out)
end

function test_exec_command_untokenized2()
   out = pinky.exec_command("/bin/echo HELLO BRAIN", {1,2},1," +",true)
   assert_equal("HELLO BRAIN", out.HELLO[1] .. " " .. out.HELLO[2] )
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

-- split
function test_split_string()
   assert_equal("What", pinky.split('What are we going to do tonight Brain?',' ')[1])
end

-- tests
function test_file_exists_nxfile()
   assert_false(pinky.file_exists("/usr/foobar/lala auxwww"))
end

function test_file_exists_tmp()
   assert_true(pinky.file_exists("/tmp"))
end

function test_file_exists_no_args()
   assert_false(pinky.file_exists())
end

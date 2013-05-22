require "lunit"
local p = require "pinky"
local json = require 'cjson'
local OS = p.get_os()

module( "p_testcase", lunit.testcase, package.seeall )


function setup()
   test_table = {}
   test_table.Alpha = { "A1", "B1", "C1", "D1", "E1" }
   test_table.Beta = { "A2", "B2", "C2", "D2", "E2" }
   test_table.Gamma = { "A3", "B3", "C3", "D3", "E3" }
   test_table.Delta = { "A4", "B4", "C4", "D4", "E4" }
end

-- exec_command
function test_exec_command_nxfile()
   out = p.exec_command("/usr/bin/some_binary_not_there")
   assert_equal("FAIL", out.status.value)
   assert_equal("/usr/bin/some_binary_not_there could not be found", out.status.error)
end

function test_exec_command_yes()
   assert_equal("y" ,p.exec_command("/usr/bin/yes | head -n 1"), "Test exec_command on yes cmd")
end

function test_exec_command_df1()
   out = p.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   assert_table(out)
end

function test_exec_command_df2()
   if OS == "Darwin" then
      out = p.exec_command("/bin/df", {1,2,3,4,5,6,7,8}, 9, " +",true)
   else
      out = p.exec_command("/bin/df", {1,2,3,4,5}, 6, " +",true)
   end
      assert_equal("Filesystem", out.Mounted[1])
end

function test_exec_command_untokenized()
   out = p.exec_command("/bin/echo HELLO BRAIN", nil,nil," +",nil)
   assert_equal("HELLO BRAIN", out)
end

function test_exec_command_untokenized2()
   out = p.exec_command("/bin/echo HELLO BRAIN", {1,2},1," +",true)
   assert_equal("HELLO BRAIN", out.HELLO[1] .. " " .. out.HELLO[2] )
end

-- return_fields
function test_return_fields_1()
   fields = { 1,2,3,4,5 }
   out = p.return_fields(test_table,fields)
   assert_equal(test_table.Gamma[1], out.Gamma[1])
   assert_equal(test_table.Gamma[2], out.Gamma[2])
   assert_equal(test_table.Gamma[3], out.Gamma[3])
   assert_equal(test_table.Gamma[4], out.Gamma[4])
   assert_equal(test_table.Gamma[5], out.Gamma[5])
end

function test_return_fields_2()
   fields = { 1,5 }
   out = p.return_fields(test_table,fields)
   assert_equal(test_table.Gamma[1], out.Gamma[1])
   assert_equal(test_table.Gamma[5], out.Gamma[2])
   assert_nil(out.Gamma[3])
   assert_nil(out.Gamma[4])
   assert_nil(out.Gamma[5])
end

function test_return_fields_3()
   fields = { 5 }
   out = p.return_fields(test_table,fields)
   assert_equal(test_table.Gamma[5], out.Gamma[1])
   assert_nil(out.Gamma[2])
   assert_nil(out.Gamma[3])
   assert_nil(out.Gamma[4])
   assert_nil(out.Gamma[5])
end

function test_return_fields_4()
   fields = { 2, 3, 4, 5 }
   out = p.return_fields(test_table,fields)
   assert_equal(test_table.Gamma[2], out.Gamma[1])
   assert_equal(test_table.Gamma[3], out.Gamma[2])
   assert_equal(test_table.Gamma[4], out.Gamma[3])
   assert_equal(test_table.Gamma[5], out.Gamma[4])
   assert_nil(out.Gamma[5])
end

function test_return_fields_5()
   fields = { 2,4,5 }
   out = p.return_fields(test_table,fields)
   assert_equal(test_table.Gamma[2], out.Gamma[1])
   assert_equal(test_table.Gamma[4], out.Gamma[2])
   assert_equal(test_table.Gamma[5], out.Gamma[3])
   assert_nil(out.Gamma[4])
   assert_nil(out.Gamma[5])
end

-- file_exists
function test_file_exists_tmp()
   assert_true(p.file_exists("/tmp/"), "test if /tmp exists")
end

function test_file_exists_nxfile()
   assert_false(p.file_exists("/tmp/LALA.SOME_FILE_THAT_WONT_EXIST"), "test if /tmp/NXFILE exists")
end

-- reports
-- function test_reports_nxfunction()
--    assert_equal("Error: Unable to find functions in uri", p.dispatch("nxfunction").status.error)
-- end

-- split
function test_split_string()
   assert_equal("What", p.split('What are we going to do tonight Brain?',' ')[1])
end

-- tests
function test_file_exists_nxfile()
   assert_false(p.file_exists("/usr/foobar/lala auxwww"))
end

function test_file_exists_tmp()
   assert_true(p.file_exists("/tmp"))
end

function test_file_exists_no_args()
   assert_false(p.file_exists())
end


-- get_os
function test_get_os()

end

-- get_home
function test_get_home()

end


-- find_first_file
function test_find_first_file_1()
   local tf1 = "/tmp/lua_test_real_long_file"
   local tf2 = "/tmp/lua_test_real_long_file_no_exists"
   files = { tf2, tf1 }
   assert_equal(0, os.execute("/usr/bin/touch " .. tf1))
   assert_equal(tf1,p.find_first_file(files))
end


-- get_username
function test_get_username_1()

end

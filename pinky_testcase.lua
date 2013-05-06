require "lunit"
local pinky = require "pinky"

module( "pinky_testcase", lunit.testcase )

function test_success()
   assert_false(false, "this test never fails")
end

function test_exec_command_nxfile()
   assert_equal('Error: /usr/bin/some_binary_not_there could not be found',pinky.exec_command("/usr/bin/some_binary_not_there"), "Test exec_command on nxfile")
   assert_equal("y" ,pinky.exec_command("/usr/bin/yes | head -n 1"), "Test exec_command on yes cmd")


end

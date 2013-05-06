require "lunit"
require "pinky"

module( "pinky_testcase", lunit.testcase )

function test_success()
   assert_false(false, "this test never fails")
end

function test_exec_command()
   assert_true(exec_command("ls"))
end

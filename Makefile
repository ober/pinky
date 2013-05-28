default: tests

tests:
	@$(HOME)/.luarocks/bin/lunit pinky_testcase.lua

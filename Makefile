default: tests

tests:
	@lunit pinky_testcase.lua
	ls *.lua|grep -Ev "pinky_pinky|hello|proc" |xargs -I"{}" basename {} ".lua"|xargs -n 1 $(HOME)/.luarocks/bin/pinky

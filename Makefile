default: tests

tests:
	@lunit pinky_testcase.lua
	ls *.lua|grep -Ev "hello|pinky|proc"|xargs -I"{}" basename {} ".lua"|xargs -n 1 $(HOME)/.luarocks/bin/pinky

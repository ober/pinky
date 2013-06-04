default: tests

tests:
	@lunit pinky_testcase.lua
	ls *.lua|grep -Ev "hello|pinky|proc"|xargs basename -s ".lua"|xargs -n 1 $(HOME)/.luarocks/bin/pinky

default: tests

tests:
	@lunit tests.lua
	ls *.lua|grep -Ev "hello|pinky.lua|proc"|xargs -I"{}" basename {} ".lua"|xargs -n 1 $(HOME)/.luarocks/bin/pinky

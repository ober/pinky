default: tests

tests:
	@lunit pinky_testcase.lua
	@for LUA in *.lua; \
 	do \
 		@controller=`basename $${LUA} ".lua"`; \
 		$(HOME)/.luarocks/bin/pinky $$(controller); \
 	done;

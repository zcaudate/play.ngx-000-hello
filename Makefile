run:
	resty main.lua

dev:
	echo main.lua | entr -r resty main.lua
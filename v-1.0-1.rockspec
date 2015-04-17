package = "v"
version = "1.0-1"
source = {
	url = "git://github.com/vifino/useful-lua-libraries",
	tag = "v1.0"
}
description = {
	summary = "Useful Lua libraries",
	detailed = [[
		A bunch of useful Lua libraries and functions.
		Created by vifino, rock created by wolfmitchell.
	]],
	homepage="http://github.com/vifino/useful-lua-libraries",
	license = "Eiffel Forum License, version 2"
}
dependencies = {
	"lua >= 5.1"
}
build = {
	type = 'builtin',
	modules = {
		v = "init.lua",
		["v.answers"] = "answers.lua",
		["v.basic"] = "basic.lua",
		["v.crypt"] = "crypt.lua",
		["v.eqator"] = "eqator.lua",
		["v.forth"] = "forth.lua",
		["v.generalFunc"] = "generalFunc.lua",
		["v.html2unicode"] = "html2unicode.lua",
		["v.random"] = "random.lua",
		["v.system"] = "system.lua",
		["v.tblpersistancy"] = "tblpersistancy.lua",
		["v.url"] = "url.lua",
		["v.wolfram"] = "wolfram.lua",
		["v.xml"] = "xml.lua",
		["v.youtube"] = "youtube.lua"
	},
	copy_directories = {}
}

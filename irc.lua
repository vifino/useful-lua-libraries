-- WIP IRC Library, do not use
-- Made by vifino
local socket = require("socket")
irc = {}
local instances = {}
local function splitn(txt,num)
	local o={}
	while #txt>0 do
		table.insert(o,txt:sub(1,num))
		txt=txt:sub(num+1)
	end
	return o
end
local function splitToTable(text, seperator)
	local returnTable = {}
	for word in text:gmatch(seperator) do table.insert(returnTable, word) end
	return returnTable
end
function irc.connect(nserverAddress, nport, nnickname, nusername, nrealname, password)
	local matches =
	  {
	    ["^"] = "%^";
	    ["$"] = "%$";
	    ["("] = "%(";
	    [")"] = "%)";
	    ["%"] = "%%";
	    ["."] = "%.";
	    ["["] = "%[";
	    ["]"] = "%]";
	    ["*"] = "%*";
	    ["+"] = "%+";
	    ["-"] = "%-";
	    ["?"] = "%?";
	    ["\0"] = "%z";
	  }
	local eluap = function(s)
		return (s:gsub(".", matches))
	end
	local currentInstance = {}
	currentInstance["nick"] = nnickname
	currentInstance["address"] = nserverAddress
	currentInstance["port"] = nport
	currentSocket = socket.connect(nserverAddress, nport)
	currentSocket:send("NICK "..nnickname.."\r\n")
	print("NICK "..nnickname)
	currentSocket:send("USER "..nusername .." ~ ~ :"..nrealname.."\r\n")
	currentInstance["socket"] = currentSocket
	function currentInstance.send(self,txt)
		self["socket"]:send(txt.."\r\n")
		return self
	end
	function currentInstance.msg(self,user,text)
		if (user and text) then
			local privmsgStr = "PRIVMSG "..user.." :"
			for i,item in pairs(splitn(text,512-#privmsgStr-4)) do
				print(self["nick"].." -> "..user..": "..item)
				self:send("PRIVMSG "..user.." :"..item)
			end
		else
			print("Error: Not enough arguments.")
		end
		return self
	end
	function currentInstance.join(self,channel)
		self:send("JOIN "..channel)
		return self
	end
	function currentInstance:part(self,channel,reason)
		if reason == nil then
			self:send("PART "..channel)
		else
			self:send("PART "..channel.." :"..reason)
		end
		return self
	end
	function currentInstance.joinTable(self,channels)
		for i,channel in pairs(channels) do
			self:join(channel)
		end
		return self
	end
	function currentInstance.action(self, channel, text)
		print("* "..username.." "..text)
		self:send("PRIVMSG "..channel.." :\01ACTION "..text.."\01")
		return self
	end
	function currentInstance.receive(self)
		local line = self["socket"]:receive()
		if line:match("^PING") then
			self:send(line:gsub("PING","PONG"))
		elseif line:match("^:(.*) KICK (.*) "..username.." :(.*)") then
			local _, channel, kickreason = line:match("^:(.*) KICK (.*) "..username.." :(.*)") 
			self:join(channel)
		end
		return line
	end
	local connected = false
	currentInstance:receive()
	print(type(currentSocket))
	local modeset = false
	while not modeset do
		local line = currentInstance:receive()
		local inputTable = splitToTable(line, "%S+")
		if (inputTable[1] == ":"..nnickname) and (inputTable[2] == "MODE") and (inputTable[3] == nnickname) then
			modeset = true
			print("Matching!")
		elseif line:match(":(.*) 433 * (.*) :Nickname is already in use.") then
			error("Nickname already in use.")
			return nil
		else
			print(line)
		end
	end
	local identified = false
	if password ~= nil then
		print("Password set, identifying...")
		currentSocket:send("PRIVMSG NickServ :identify ".. password.."\r\n")
		identified = true
	end
	return currentInstance
end
-- WIP IRC Library, do not use
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
function irc.spawn(serverAddress, port, nickname, username, realname, password)
    local currentInstance = {}
    currentInstance["nick"] = nickname
    currentInstance["address"] = serverAddress
    currentInstance["port"] = port
    currentSocket = socket.connect(serverAddress, port)
	currentSocket:send("NICK "..nickname.."\r\n")
	print("NICK "..nickname)
	currentSocket:send("USER "..username .." ~ ~ :"..realname.."\r\n")
    currentInstance["socket"] = currentSocket
    function currentInstance.send(self,txt)
	    self["socket"]:send(txt.."\r\n")
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
    end
    function currentInstance.join(self,channel)
        self["socket"]:send("JOIN "..channel)
    end
    function currentInstance:part(self,channel,reason)
        if reason == nil then
            self["socket"]:send("PART "..channel)
        else
            self["socket"]:send("PART "..channel.." :"..reason)
        end
    end
    function currentInstance.joinTable(self,channels)
    	for i,channel in pairs(channels) do
    		self:join(channel)
    	end
    end
    function currentInstance.action(self, channel, text)
    	print("* "..username.." "..text)
    	self["socket"]:send("PRIVMSG "..channel.." :\01ACTION "..text.."\01")
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
	    --if line:match("^:"..username.." MODE "..username.." :") then
	    if (inputTable[1] == ":"..username) and (inputTable[2] == "MODE") and (inputTable[3] == username) then
		    modeset = true
    		print("Matching!")
    	else
    		print(line)
    	end
    end
    if password ~= nil then
    	print("Password set, identifying...")
    	currentSocket:send("PRIVMSG NickServ :identify ".. password)
    	local identified = false
	end
    --if currentInstance["socket"].isAlive() then
    return currentInstance
    --else
    --    return nil
   -- end
end
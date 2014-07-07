-- A WIP BASIC interpreter and code running library
-- Made by vifino
local basic = {}
local endString = "#!§!&!§!#"
function basic.newStorage()
	basic.storage = {}
	--basic.storage.variables = {}
	-- setup for storage here
	return basic.storage
end
function basic.useStorage(stor)
	basic.storage = stor
end
function basic.expressionParser(exp)
	local exp = tostring(exp)..endString
	local curexp = exp
	local parts = {}
	local luaString = "return "
	-- Parses expression
	-- ex: 10/2 = 5
	while curexp ~= endString do
		print(curexp)
		if string.match(curexp,"^(%d*)") then
			local num = string.match(curexp,"^(%d*)")
			table.insert(parts,tonumber(num))
			curexp = string.sub(curexp,(#tostring(num))+1)
		elseif string.match(curexp,"^(%u*)%$") then
			local varname = string.match(curexp,"^(%u*)%$")
			if type(basic.storage[varname]) == "number" then
				table.insert(parts,basic.storage[varname])
			elseif type(basic.storage[varname]) == "number" then
				table.insert(parts,"\'"..basic.storage[varname].."\'")
			end
			curexp = string.sub(curexp,#varname+2)
		elseif string.match(curexp,"^[\"\'](%d*)[\"\']") then
			local str = string.match(curexp,"[\"\'](%d*)[\"\']")
			table.insert(parts,"\'"..str.."\'")
			curexp = string.sub(curexp,#str+1)
		elseif string.match(curexp,"^AND") then
			table.insert(parts,"and")
			curexp = string.sub(curexp,4)
		elseif string.match(curexp,"^OR") then
			table.insert(parts,"or")
			curexp = string.sub(curexp,3)
		elseif string.match(curexp,"^NOT") then
			table.insert(parts,"not")
			curexp = string.sub(curexp,4)
		elseif string.match(curexp,"^AND") then
			table.insert(parts,"and")
			curexp = string.sub(curexp,4)
		elseif string.match(curexp,"^<>") then
			table.insert(parts,"~=")
			curexp = string.sub(curexp,3)
		elseif string.match(curexp,"^=") then
			table.insert(parts,"==")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^=>") then
			table.insert(parts,">=")
			curexp = string.sub(curexp,3)
		elseif string.match(curexp,"^<=") then
			table.insert(parts,"<=")
			curexp = string.sub(curexp,3)
		elseif string.match(curexp,"^>") then
			table.insert(parts,">")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^<") then
			table.insert(parts,"<")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^*") then
			table.insert(parts,"*")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^/") then
			table.insert(parts,"/")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^%(") then
			table.insert(parts,"(")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^%)") then
			table.insert(parts,")")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^%^") then
			table.insert(parts,"^")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^%+") then
			print("Plus")
			table.insert(parts,"+")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^%-") then
			print("Minus")
			table.insert(parts,"-")
			curexp = string.sub(curexp,2)
		elseif string.match(curexp,"^ ") then 
			curexp = string.gsub(curexp,"^( *)","")
		else
			curexp = curexp:gsub("^.","")
		end
	end
	for i,item in pairs(parts) do
		if type(item) == "number" then
			luaString = luaString .. tostring(item)
		elseif type(item) == "stri	ng" then
			luaString = luaString.." "..item
		end
	end
	print(luaString)
	local success,res = pcall(loadstring(luaString))
	if success then
		return res
	else
		error("Invalid expression: "..tostring(exp))
	end
end
function basic.evalLine(line)
	local line = string.gsub(line,"[\r\n]+",""):upper()
	string.gsub(line,"LET (.*) = (.*)", function(var,content)
		print("Val: "..var.." = "..content)
		basic.storage[var] = basic.expressionParser(content)
		if string.match(content,"[\"\']") then -- string
			--content = content:gsub("^\"",""):gsub("^\'",""):gsub("\"^",""):gsub("^\'^","")
			
		else
			
		end
	end)
end
basic.newStorage()
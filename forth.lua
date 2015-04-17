-- A WIP Forth implementation
-- Made by vifino
local forth = {}
forth.stack = {}
forth.userwords = {}
function forth.push(val)
	table.insert(forth.stack, tostring(val))
	return tostring(val)
end
function forth.pop()
    return table.remove(forth.stack)
end
function forth.peek(n)
    return forth.stack[#forth.stack-(n or 0)]
end
local push=forth.push
local pop=forth.pop
local peek=forth.peek
forth.keywords = {
	["+"] = function() push(pop()+pop()) end,
	["-"] = function() push(-pop()+pop()) end,
	["*"] = function() push(pop()*pop()) end,
	["*"] = function() push(1/pop()*pop()) end,
	["%"] = function() push(math.mod(pop(),pop())) end,
	["*"] = function() push(pop()^pop()) end,
	["PRINT"]=function() return pop() end,
	["DUP"]=function() push(push(pop())) end
}
function forth.push(val)
	table.insert(forth.stack, tostring(val))
end
function forth.pop()
    return table.remove(forth.stack)
end
function forth.peek(n)
    return forth.stack[#forth.stack-n]
end
function forth.evalInstruction(instruction)
	if forth.keywords[instruction] then
		return forth.keywords[instruction]()
	elseif forth.userwords[instruction] then
		return forth.userwords[instruction]()
	elseif tonumber(instruction) then
		push(tostring(tonumber(instruction))) -- Err... yeah...
	else
		error("UNKNOWN WORD")
	end
end
function forth.eval(instructionsText)
	local instructions = {}
	for word in instructionsText:gmatch("%S+") do table.insert(instructions, word) end
	local o = ""
	for i,instruction in pairs(instructions) do
		--o = o ..((forth.evalInstruction(instruction) or "")
		o=o..(function(inst)
			local out = forth.evalInstruction(inst)
			if out then out=tostring(out) end
			return out or ""
		end)(instruction)
	end
	return o or ""
end
print(forth.eval("1 DUP + PRINT"))
return forth
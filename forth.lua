-- A WIP Forth implementation
-- Made by vifino
forth = {}
forth.stack = {}
forth.words = {}
function forth.evalInstruction(instruction)
	
end
function forth.eval(instructionsText)
	local instructions = {}
	for word in instructionsText:gmatch(seperator) do table.insert(instructions, word) end
	local o = ""
	for i,instruction in pairs(instructions) do
		--o = o ..((forth.evalInstruction(instruction) or "")
		o=o..(function(inst)
			local out = forth.evalInstruction(inst)
			if out then out=tostring(out).."\n" return out end
		end)(instruction)
	end
	return o or ""
end
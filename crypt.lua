-- Crypt.lua
-- Made by vifino
local crypt = {}
function rot13(str, num)
	return (str:gsub(".", function(char)
		local byte = char:byte() + num
		if(byte < 0) then
			byte = 255 + byte
		elseif(byte > 255) then
			byte = byte - 255
		end
		return string.char( byte )
	end))
end
crypt.rot13 = rot13
function derot13(str, num)
	return crypt.rot13(str, -num)
end
crypt.derot13 = derot13
return crypt
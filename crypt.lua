-- Crypt.lua
-- Made by vifino
local crypt = {}
function crypt.rot13(str, num)
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
function crypt.derot13(str, num)
	return crypt.rot13(str, -num)
end
return crypt
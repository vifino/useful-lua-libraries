-- Lua mail library
-- Made by vifino
-- Dependencies Lua: system.lua
mail = {}
function mail.getMX(domain)
	if not type(domain) == "string" then error("Invalid argument.") end
	local output = system.cmd("nslookup -q=MX "..domain)
	local output = splitbyLines(output)
	for i = 0, 4, 1 do
		output[i] = nil
	end
	local mxlines = {}
	for i in pairs(output) do
		local preference,server = output[i]:match("^"..domain.."	mail exchanger = (%d*) (.*)%.")
		if preference and server then
			mxlines[tonumber(preference)] = server
		end
	end
	return mxlines
end
mx = mail.getMX("google.com")
for k,v in pairs(mx) do
	print(k..": "..v)
end
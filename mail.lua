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
			--table.insert(mxlines,{preference,server})
		end
	end
	return mxlines
end
function mail.lowestMX(domain)
	local mx = mail.getMX(domain)
	local lowestk
	for k,v in pairs(mx) do
		if not lowestk then lowestk = k end
		if k < lowestk then lowestk = k end
	end
	return mx[lowestk], lowestk
end
function mail.mail(from,to,subject,message,replyto) -- For educational use only.
	if not replyto then replyto = from end
	local _,address,ext = to:lower():match("^(.*)@(.*)%.(%l*)")
	local _,heloaddrs = from:lower():match("^(.*)@(.*)%.(%l*)")
	local data = "HELO "..heloaddrs.."\r\nMAIL FROM: <"..from..">\r\nRCPT TO: <"..to..">\r\nDATA\r\nFrom: "..from.."\r\nTo: "..to.."\r\nSubject: "..subject.."\r\nReply-To: "..replyto.."\r\n\r\n"..message:gsub("[\r\n]*","\r\n").."\r\n.\r\nQUIT" -- uh, oh..
	system.cmd("echo \'"..data.."\' > /tmp/fakemailcache")
	return system.cmd("ncat "..mail.lowestMX(address.."."..ext).." 25 --sh-exec \"cat /tmp/fakemailcache\"")
end
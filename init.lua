local v={}
-- Doing stuff this way to allow other submodules to use functions from eachother
local v.submodules = {
	"answers","basic","crypt","eqator","forth",
	"generalFunc","html2unicode","irc","libUtil",
	"mail","random","system","tblpersistancy",
	"url","wolfram","xml","youtube"
}
for k,m in pairs(v.submodules) do
	local mod=require'v.'..m
	local _G[m]=mod
	v[m]=mod
end
return v
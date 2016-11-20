Betting = Betting or {};
Betting.Config = {};
Betting.Wrapper = {};

local dir = "ttt_betting";
local sh = file.Find(dir..'/*.lua', "LUA");
local cl = file.Find(dir..'/client/*.lua', "LUA");

if (SERVER) then
	Betting.Network = {};
	Betting.Entered = {};
	local sv = file.Find(dir..'/server/*.lua', "LUA");

	for k,v in pairs(sh) do
		AddCSLuaFile(dir..'/'..v);
		include(dir..'/'..v);
	end

	for k,v in pairs(sv) do
		include(dir..'/server/'..v);
	end

	for k,v in pairs(cl) do
		AddCSLuaFile(dir..'/client/'..v);
	end
end

if (CLIENT) then
  Betting.Easing = {};
  Betting.Animate = {};
  Betting.UI = Betting.UI or {};
	for k,v in pairs(sh) do
		include(dir..'/'..v);
	end

	for k,v in pairs(cl) do
		include(dir..'/client/'..v);
	end
end

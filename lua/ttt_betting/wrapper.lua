local cfg = Betting.Config;

function Betting.Wrapper.canAfford(ply, amt)
  if (!cfg.pointshop2) then
    return ply:PS_HasPoints(amt);
  else
    return ply.PS2_Wallet.points >= amt;
  end
end

function Betting.Wrapper.getUserGroup(ply)
  local usergroup = "user"; -- default usergroup

  if (istable(evolve)) then -- Evolve
    usergroup = ply:EV_GetRank();
  elseif (istable(serverguard)) then -- Serverguard
    usergroup = serverguard.player:GetRank();
  else -- assume everything else (ULX uses this too)
    usergroup = ply:GetUserGroup();
  end

  return usergroup;
end

function Betting.Wrapper.getMultiplier(ply)
  local usergroup = Betting.Wrapper.getUserGroup(ply);
  print(usergroup);

  local tbl = cfg.userGroups[usergroup];
  if (type(tbl) != "number") then return cfg.multiplier; end

  return tbl;
end

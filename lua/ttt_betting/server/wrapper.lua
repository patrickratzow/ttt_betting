local cfg = Betting.Config;

function Betting.Wrapper.addPoints(ply, amt)
  if (!cfg.pointshop2) then
    ply:PS_GivePoints(amt);
  else
    ply:PS2_AddStandardPoints(amt);
  end
end

function Betting.Wrapper.takePoints(ply, amt)
  if (!cfg.pointshop2) then
    ply:PS_GivePoints(-amt);
  else
    ply:PS2_AddStandardPoints(-amt);
  end
end

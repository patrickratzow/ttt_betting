local cfg = Betting.Config;

function Betting.Wrapper.canAfford(ply, amt)
  if (!cfg.Pointshop2) then
    return ply:PS_HasPoints(amt);
  else
    return ply.PS2_Wallet.points >= amt;
  end
end

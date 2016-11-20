resource.AddFile("resource/fonts/montserrat.ttf");

local cfg = Betting.Config;

hook.Add("TTTBeginRound", "Betting.BeginRound", function()
  timer.Simple(0, function()
    table.Empty(Betting.Entered);

    local plys = player.GetAll();

    if (#plys >= cfg.requiredPlayers) then
      for i, v in pairs(plys) do
        v.Betting_AllowBetting = true;
        v.Betting_HasBet = false;
        Betting.Network.enableHUD(v);
      end

      if (cfg.beginRoundTime > 0) then
        timer.Simple(cfg.beginRoundTime, function()
          local plys = player.GetAll();

          for i, v in pairs(plys) do
            Betting.Network.sendMessage(v, "Betting time is over for this round!");
            v.Betting_AllowBetting = false;
            Betting.Network.disableHUD(v);
          end
        end)
      end
    else
      print("not allowing!");
    end
  end)
end)

hook.Add("TTTEndRound", "Betting.EndRound", function(result)
  for i, v in pairs(Betting.Entered) do
    local ply = v.player;
    local team = v.team;
    local amount = v.amount;
    local multiplier = v.multiplier;

    if (!IsValid(ply)) then return; end
    if (!ply:IsPlayer()) then return; end -- a player???

    if (result == WIN_TRAITOR) then
      if (team == WIN_TRAITOR) then
        local win = math.Round(amount * multiplier);
        Betting.Wrapper.addPoints(ply, win);
        Betting.Network.sendMessage(ply, string.format("You placed %s points on %s and won %s points!",
        amount, "traitors", win));
      else
        Betting.Network.sendMessage(ply, "You lost your bet!");
      end
    elseif (result == WIN_INNOCENT) then
      if (team == WIN_INNOCENT) then
        local win = math.Round(amount * multiplier);
        Betting.Wrapper.addPoints(ply, win);
        Betting.Network.sendMessage(ply, string.format("You placed %s points on %s and won %s points!",
        amount, "innocents", win));
      else
        Betting.Network.sendMessage(ply, "You lost your bet!");
      end
    else -- time limit
      local win = amount;
      Betting.Wrapper.addPoints(ply, win);
      Betting.Network.sendMessage(ply, "Nobody won! Bet has been refunded");
    end
  end
end)

net.Receive("Betting.PlaceBet", function(len, ply)
  local team = net.ReadUInt(4);
  local amt = net.ReadUInt(32);

  local plys = player.GetAll();
  if (#plys < cfg.requiredPlayers) then
    Betting.Network.sendMessage(ply, string.format("There need to be %s players online and theres only %s",
    cfg.requiredPlayers, #plys));
    return;
  end

  if (ply.Betting_HasBet) then
    Betting.Network.sendMessage(ply, "You've already bet!");
    return;
  end

  if (amt < cfg.minimumBet) then
    Betting.Network.sendMessage(ply, "You have to bet at least " .. cfg.minimumBet);
    return;
  end

  if (amt > cfg.maximumBet and cfg.maximumBet != 0) then
    Betting.Network.sendMessage(ply, "You can at max bet " .. cfg.maximumBet);
    return;
  end

  if (!Betting.Wrapper.canAfford(ply, amt)) then
    Betting.Network.sendMessage(ply, "You cannot afford that!");
    return;
  end

  local multiplier = Betting.Wrapper.getMultiplier(ply); 

  Betting.Wrapper.takePoints(ply, amt);
  Betting.Network.sendMessage(ply, string.format("You bet %s points!", amt));

  table.insert(Betting.Entered, { player = ply, team = team, amount = amt, multiplier = multiplier });
  ply.Betting_HasBet = true;

  timer.Simple(0, function()
    Betting.Network.disableHUD(ply);
  end)
end)

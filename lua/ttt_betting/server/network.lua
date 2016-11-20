util.AddNetworkString("Betting.PlaceBet");
util.AddNetworkString("Betting.SendMessage");
util.AddNetworkString("Betting.ChangeHUDState");

local cfg = Betting.Config;

function Betting.Network.sendMessage(ply, msg)
  net.Start("Betting.SendMessage");
    net.WriteString(msg);
  net.Send(ply);
end

function Betting.Network.enableHUD(ply)
  net.Start("Betting.ChangeHUDState");
    net.WriteBool(true);
  net.Send(ply);
end

function Betting.Network.disableHUD(ply)
  net.Start("Betting.ChangeHUDState");
    net.WriteBool(false);
  net.Send(ply);
end

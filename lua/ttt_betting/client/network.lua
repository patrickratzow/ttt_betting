local cfg = Betting.Config;

function Betting.changeHUDState(bool)
  if (!IsValid(Betting.UI.HUDFrame)) then
    Betting.UI.createHUD();
  end

  local w, h = Betting.UI.HUDFrame:GetSize();
  local x, y = Betting.UI.HUDFrame:GetPos();

  if (!bool) then
    Betting.Animate.moveTo(Betting.UI.HUDFrame, 0.3, -w, y, nil, function()
      Betting.UI.HUDFrame:SetKeyboardInputEnabled(false);
      Betting.UI.HUDFrame:SetMouseInputEnabled(false);
      Betting.clicker = false;
      gui.EnableScreenClicker(Betting.clicker);
    end)
  else
    Betting.clicker = false;
    gui.EnableScreenClicker(Betting.clicker);
    Betting.Animate.moveTo(Betting.UI.HUDFrame, 0.3, 5, y, "ease_outback");
  end
end

net.Receive("Betting.SendMessage", function(len)
  chat.AddText(cfg.prefixColor, "[Betting] ", cfg.textColor, net.ReadString());
end)

net.Receive("Betting.ChangeHUDState", function(len)
  local bool = net.ReadBool();
  Betting.changeHUDState(bool);
end)

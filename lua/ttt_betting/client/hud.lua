local function createFont(name, size)
  surface.CreateFont(name, {
    font = "Montserrat",
    size = size,
    weight = 500,
    antialias = true
  } );
end

createFont("Betting.Font.title", 19);
createFont("Betting.Font.buttons", 16);
createFont("Betting.Font.text", 17);

local cfg = Betting.Config;

function Betting.UI.createHUD()
  if (IsValid(Betting.UI.HUDFrame)) then
    return;
  end

  local ply = LocalPlayer();
  local theme = Betting.Theme;
  local scrW, scrH = ScrW(), ScrH();
  local fw = 200;
  local fh = 230;
  local cw = scrW / 2 - fw / 2;
  local ch = scrH / 2 - fh / 2;
  local plyMultiplier = Betting.Wrapper.getMultiplier(ply);

  Betting.UI.HUDFrame = vgui.Create("EditablePanel");
  local frame = Betting.UI.HUDFrame;
  frame:SetSize(fw, fh);
  frame:SetPos(-fw, ch);
  frame.Paint = function(pnl, w, h)
    surface.SetDrawColor(theme.background);
    surface.DrawRect(0, 0, w, h);
  end
  Betting.Animate.moveTo(frame, 0.3, 5, ch);

  local header = vgui.Create("DPanel", frame);
  header:Dock(TOP);
  header.Paint = function(pnl, w, h)
    surface.SetDrawColor(theme.top);
    surface.DrawRect(0, 0, w, h);

    draw.SimpleText("Betting (" .. cfg.cursorKeyName .. " cursor)", "Betting.Font.title", w/2, h/2,
      theme.text.active, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
  end

  local content = vgui.Create("DPanel", frame);
  content:Dock(FILL);
  content:DockMargin(2.5, 2.5, 2.5, 2.5);
  content.Paint = function(pnl, w, h) end

  local text = vgui.Create("DLabel", content);
  text:Dock(TOP);
  text:SetContentAlignment(7);
  text:DockMargin(5, 3, 0, 0);
  text:SetText("Bet on who you think will win!");
  text:SetFont("Betting.Font.text");
  text:SetMultiline(true);
  text:SetWrap(true);
  text:SetTextColor(theme.text.normal);

  local multiplier = vgui.Create("DLabel", content);
  multiplier:Dock(TOP);
  multiplier:SetContentAlignment(7);
  multiplier:DockMargin(5, 2.5, 0, 0);
  multiplier:SetText("Multiplier: x" .. plyMultiplier);
  multiplier:SetFont("Betting.Font.text");
  multiplier:SetMultiline(true);
  multiplier:SetWrap(true);
  multiplier:SetTextColor(theme.text.normal);

  local reward = vgui.Create("DLabel", content);
  reward:Dock(BOTTOM);
  reward:SetContentAlignment(7);
  reward:DockMargin(5, 2.5, 0, 0);
  reward:SetText("Reward: 0");
  reward:SetFont("Betting.Font.text");
  reward:SetMultiline(true);
  reward:SetWrap(true);
  reward:SetTextColor(theme.text.normal);

  local container = vgui.Create("DPanel", frame);
  container:Dock(BOTTOM);
  container:DockMargin(0, 0, 0, 2.5);
  container.Paint = function(pnl, w, h) end

  local textEntry = vgui.Create("DTextEntry", frame);
  textEntry:Dock(BOTTOM);
  textEntry:DockMargin(2.5, 0, 2.5, 2.5);
  textEntry.color = theme.textentry.normal;
  textEntry.textColor = theme.text.normal;
  textEntry:SetFont("Betting.Font.buttons");
  textEntry:SetText("Points");
  textEntry:SetNumeric(true);
  textEntry.Paint = function(pnl, w, h)
    surface.SetDrawColor(pnl.color);
    surface.DrawRect(0, 0, w, h);

    pnl:DrawTextEntryText(pnl.textColor, pnl.textColor, color_white);
  end
  textEntry.OnTextChanged = function(pnl)
    local text = tonumber(pnl:GetText());

    if (text == "" or text == NULL or text == nil) then return; end
    reward:SetText("Reward: " .. text * plyMultiplier);
  end
  local oldGetFocus = textEntry.OnGetFocus;
  textEntry.OnGetFocus = function(pnl)
    oldGetFocus(pnl);
    local text = pnl:GetText();
    text = tonumber(text);
    if (text == nil or text == NULL or text == "") then pnl:SetText(""); end

    frame:MakePopup();
  end
  local oldLoseFocus = textEntry.OnLoseFocus;
  textEntry.OnLoseFocus = function(pnl)
    oldLoseFocus(pnl);
    if (pnl:GetText() == "") then pnl:SetText("Points"); end
    frame:SetKeyboardInputEnabled(false);
  end
  Betting.Animate.textEntry(textEntry);

  local traitor = vgui.Create("DButton", container);
  traitor:Dock(LEFT);
  traitor:DockMargin(2.5, 0, 0, 0);
  traitor:SetText("Traitors");
  traitor:SetContentAlignment(5);
  traitor:SetFont("Betting.Font.buttons");
  traitor.color = theme.interactive.traitor.normal;
  traitor.textColor = theme.text.normal
  traitor.Paint = function(pnl, w, h)
    surface.SetDrawColor(pnl.color);
    surface.DrawRect(0, 0, w, h);

    pnl:SetTextColor(pnl.textColor);
  end
  traitor.DoClick = function(pnl)
    local text = tonumber(textEntry:GetText());
    if (text == "" or text == NULL or text == nil) then return; end
    text = math.abs(text);

    if (text < cfg.minimumBet) then
      textEntry:SetText("You have to bet at least " .. cfg.minimumBet);
      return;
    end

    if (text > cfg.maximumBet and cfg.maximumBet != 0) then
      textEntry:SetText("You can at max bet " .. cfg.maximumBet);
      return;
    end

    if (!Betting.Wrapper.canAfford(ply, text)) then
      textEntry:SetText("Cannot afford that!");
      return;
    end

    net.Start("Betting.PlaceBet");
      net.WriteUInt(WIN_TRAITOR, 4);
      net.WriteUInt(text, 32);
    net.SendToServer();
  end
  Betting.Animate.button(traitor, 1);

  local innocent = vgui.Create("DButton", container);
  innocent:Dock(RIGHT);
  innocent:DockMargin(0, 0, 2.5, 0);
  innocent:SetText("Innocents");
  innocent:SetContentAlignment(5);
  innocent:SetFont("Betting.Font.buttons");
  innocent.color = theme.interactive.innocent.normal;
  innocent.textColor = theme.text.normal
  innocent.Paint = function(pnl, w, h)
    surface.SetDrawColor(pnl.color);
    surface.DrawRect(0, 0, w, h);

    pnl:SetTextColor(pnl.textColor);
  end
  innocent.DoClick = function(pnl)
    local text = tonumber(textEntry:GetText());
    if (text == "" or text == NULL or text == nil) then return; end
    text = math.abs(text);

    if (text < cfg.minimumBet) then
      textEntry:SetText("You have to bet at least " .. cfg.minimumBet);
      return;
    end

    if (text > cfg.maximumBet and cfg.maximumBet != 0) then
      textEntry:SetText("You can at max bet " .. cfg.maximumBet);
      return;
    end

    if (!Betting.Wrapper.canAfford(ply, text)) then
      textEntry:SetText("Cannot afford that!");
      return;
    end

    net.Start("Betting.PlaceBet");
      net.WriteUInt(WIN_INNOCENT, 4);
      net.WriteUInt(text, 32);
    net.SendToServer();
  end
  Betting.Animate.button(innocent, 2);

  frame.PerformLayout = function(pnl, w, h)
    header:SetTall(30);
    container:SetTall(30);
    traitor:SetWide(container:GetWide() / 2 - 2.5);
    innocent:SetWide(container:GetWide() / 2 - 2.5);
    textEntry:SetTall(25);
    text:SizeToContents();
  end
end

local time = CurTime();
Betting.clicker = false;

hook.Add("Think", "Betting.Think", function()
  if (input.IsKeyDown(cfg.cursorKey) and time <= CurTime()) then
    local bool = !Betting.clicker;

    gui.EnableScreenClicker(bool);
    Betting.clicker = bool;
    time = CurTime() + 0.25;

    if (IsValid(Betting.UI.HUDFrame)) then
      Betting.UI.HUDFrame:SetKeyboardInputEnabled(bool);
      Betting.UI.HUDFrame:SetMouseInputEnabled(bool);
    end
  end
end)

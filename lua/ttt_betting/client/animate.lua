function Betting.Animate.moveTo(pnl, duration, x, y, ease, callback)
  local easing = ease or Betting.Config.defaultEase;
  local ease = Betting.Easing[easing];

  local anim = pnl:NewAnimation(duration);
  anim.Pos = Vector(x, y, 0);
  anim.Think = function(anim, pnl, fract)
    local newFract = ease(fract, 0, 1, 1);

    if (!anim.StartPos) then
      anim.StartPos = Vector(pnl.x, pnl.y, 0);
    end

    local pos = LerpVector(newFract, anim.StartPos, anim.Pos);
    pnl:SetPos(pos.x, pos.y);
  end
  anim.OnEnd = function(animData, pnl)
    if (callback) then callback(animData, pnl); end
  end
end

function Betting.Animate.colorTo(pnl, duration, col, text, ease, callback)
  local easing = ease or Betting.Config.defaultEase;
  local ease = Betting.Easing[easing];

  local anim = pnl:NewAnimation(duration);
  anim.Color = col;
  anim.Think = function(anim, pnl, fract)
    local newFract = ease(fract, 0, 1, 1);

    if (!anim.StartColor) then
      if (text) then
        anim.StartColor = pnl.textColor or color_white;
      else
        anim.StartColor = pnl.color or color_white;
      end
    end

    local lerpColor = Betting.Animate.lerpColor(newFract, anim.StartColor, anim.Color);
    if (text) then
      pnl.textColor = lerpColor;
    else
      pnl.color = lerpColor;
    end
  end
  anim.OnEnd = function(animData, pnl)
    if (callback) then callback(animData, pnl); end
  end
end

function Betting.Animate.lerpColor(fract, col, endCol)
  return Color(
    Lerp(fract, col.r, endCol.r),
    Lerp(fract, col.g, endCol.g),
    Lerp(fract, col.b, endCol.b),
    Lerp(fract, col.a or 255, endCol.a or 255)
  );
end

function Betting.Animate.textEntry(pnl, speed)
  if (!speed) then speed = Betting.Config.interactiveSpeed; end

  local text = Betting.Theme.text;
  local theme = Betting.Theme.textentry;

  local active = theme.active;
  local hover = theme.hover;
  local normal = theme.normal;
  local disabled = theme.disabled;

  local oldGetFocus = pnl.OnGetFocus;
  pnl.OnGetFocus = function(self)
    oldGetFocus(self);
    Betting.Animate.colorTo(self, speed, active);
    Betting.Animate.colorTo(self, speed, text.active, true);
  end
  local oldLoseFocus = pnl.OnLoseFocus;
  pnl.OnLoseFocus = function(self)
    oldLoseFocus(self);
    local color = normal;
    local textColor = text.normal;

    if (self:IsHovered()) then
      color = hover;
      textColor = text.hover;
    end

    Betting.Animate.colorTo(self, speed, color);
    Betting.Animate.colorTo(self, speed, textColor, true);
  end
  local oldEntered = pnl.OnCursorEntered or function() end;
  pnl.OnCursorEntered = function(self)
    oldEntered(self);

    if (self:HasFocus()) then return; end

    Betting.Animate.colorTo(self, speed, hover)
    Betting.Animate.colorTo(self, speed, text.hover, true);
  end

  local oldExited = pnl.OnCursorExited or function() end;
  pnl.OnCursorExited = function(self)
    oldExited(self);

    if (self:HasFocus()) then return; end

    Betting.Animate.colorTo(self, speed, normal);
    Betting.Animate.colorTo(self, speed, text.normal, true);
  end
end

function Betting.Animate.button(pnl, team, speed)
  if (!speed) then speed = Betting.Config.interactiveSpeed; end
  if (!team) then team = 1; end

  local theme = Betting.Theme;

  local active;
  local hover;
  local normal;
  local interactive = theme.interactive;

  if (team == 1) then -- traitor
    active = interactive.traitor.active;
    hover = interactive.traitor.hover;
    normal = interactive.traitor.normal;
  elseif (team == 2) then -- innocent
    active = interactive.innocent.active;
    hover = interactive.innocent.hover;
    normal = interactive.innocent.normal;
  end

  local oldEntered = pnl.OnCursorEntered;
  pnl.OnCursorEntered = function(self)
    oldEntered(self);
    Betting.Animate.colorTo(self, speed, hover)
    Betting.Animate.colorTo(self, speed, theme.text.hover, true);
  end

  local oldExited = pnl.OnCursorExited;
  pnl.OnCursorExited = function(self)
    oldExited(self);
    Betting.Animate.colorTo(self, speed, normal);
    Betting.Animate.colorTo(self, speed, theme.text.normal, true);
  end

  local oldMousePressed = pnl.OnMousePressed;
  pnl.OnMousePressed = function(self, code)
    self.DoClick(self);
    oldMousePressed(self, code);
    Betting.Animate.colorTo(self, speed, active);
    Betting.Animate.colorTo(self, speed, theme.text.active, true);
  end

  local oldMouseReleased = pnl.OnMouseReleased;
  pnl.OnMouseReleased = function(self)
    oldMouseReleased(self);
    if (self:IsHovered()) then
      Betting.Animate.colorTo(self, speed, hover);
      Betting.Animate.colorTo(self, speed, theme.text.hover, true);
    else
      Betting.Animate.colorTo(self, speed, normal);
      Betting.Animate.colorTo(self, speed, theme.text.normal, true);
    end
  end
end

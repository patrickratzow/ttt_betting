Betting.Config.defaultEase = "in_quadratic"; -- Default ease used by all things that doesnt have a specified ease.
Betting.Config.interactiveSpeed = 0.2; -- Color transition speed.
Betting.Config.multiplier = 2; -- How much do they get back from winning? If 2 its amount bet * 2 and if they bet 20 they win 40.
Betting.Config.beginRoundTime = 15; -- How many seconds into the round shall betting be allowed?
Betting.Config.prefixColor = Color(255, 0, 0); -- [Betting] color
Betting.Config.textColor = Color(255, 255, 255); -- Everything after [Betting] color
Betting.Config.pointshop2 = false; -- Use Pointshop 2? If false it uses Pointshop 1
Betting.Config.cursorKey = KEY_F9; -- What key should toggle cursor?
Betting.Config.cursorKeyName = "F9"; -- What key is shown on the menu?
Betting.Config.requiredPlayers = 2; -- How many players is required for betting to be activated?
Betting.Config.minimumBet = 250; -- What is minimum bet? Don't make it negative
Betting.Config.maximumBet = 500; -- What is maximum bet? Setting it to 0 disables this
Betting.Config.userGroups = { -- Usergroups that have a different multiplier than normal.
  superadmin = 3,
  admin = 2.5
};

Betting.Theme = {
  background = Color(28, 29, 31),
  top = Color(35, 37, 39),
  traitor = Color(212, 74, 74),
  innocent = Color(74, 212, 74),
  text = {
    active = Color(255, 255, 255, 234),
    hover = Color(255, 255, 255, 177),
    normal = Color(255, 255, 255, 123),
    disabled = Color(255, 255, 255, 74)
  },
  interactive = {
    traitor = {
      active = Color(255, 13, 13),
      hover = Color(238, 28, 28),
      normal = Color(124, 37, 37)
    },
    innocent = {
      active = Color(20, 200, 20),
      hover = Color(26, 183, 26),
      normal = Color(37, 96, 37)
    }
  },
  textentry = {
    active = Color(35, 35, 35),
    hover = Color(40, 40, 40),
    normal = Color(48, 48, 48),
    disabled = Color(70, 70, 70)
  }
};

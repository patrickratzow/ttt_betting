Betting.Easing = {
  in_quadratic = function(t, b, c, d)
    t = t / d;
    local ts = t * t;
    local tc = ts * t;
    return b + c * (ts);
  end,
  ease_outback = function(t, b, c, d)
		t = t / d;
		local ts = t * t;
		local tc = ts * t;
		return b+c*(0.3*tc*ts + -4.305*ts*ts + 11.71*tc + -12.705*ts + 6*t);
	end
};

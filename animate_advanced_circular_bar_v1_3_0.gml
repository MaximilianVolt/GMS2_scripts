#macro ANIMATED_ADVANCED_CIRCULAR_BAR_SMOOTH_UPDATE_CONSTANT 0.0825

function Animated_advanced_circular_bar(x, y, bars = []) constructor
{
	self.x = x;
	self.y = y;
	self.bars = bars;

	static __animate = function(x = [self.x], y = [self.y], refresh_mask = false)
	{
		for (var i = 0; i < array_length(bars); i++)
		{
			bars[i].__draw(x[i % array_length(x)], y[i % array_length(y)], refresh_mask);
		}
	}

	static __animate_positioned = function(position_array, refresh_mask)
	{
		__animate(position_array[0], position_array[1], refresh_mask);
	}

	static __position = function(strength_or_shake_positions, rotation)
	{
		var positions = [[], []], _x = 0, _y = 1;
		var shake_positions = is_struct(strength_or_shake_positions) ? strength_or_shake_positions : shake(strength_or_shake_positions);
		var rotation_positions = [];

		for (var i = 0; i < array_length(bars); i++)
		{
			rotation_positions[i] = bars[i].__rotate(rotation);
			array_push(positions[_x], x + shake_positions.x + rotation_positions[i].x);
			array_push(positions[_y], y + shake_positions.y + rotation_positions[i].y);
		}

		return positions;
	}
}

// Main in Draw or Draw GUI
function animate_advanced_circular_bar(animation_bar, x = [animation_bar.x], y = [animation_bar.y], refresh_mask = false)
{
	animation_bar.__animate(x, y, refresh_mask);
}

function animate_advanced_circular_bar_positioned(animation_bar, position_array, refresh_mask = false)
{
	animation_bar.__animate_positioned(position_array, refresh_mask);
}

function position_animated_advanced_circular_bar(animation_bar, strength_or_shake_positions, rotation)
{
	return animation_bar.__position(strength_or_shake_positions, rotation);
}

#region Animation tool functions
function smoothen(value, target, smoothness = ANIMATED_ADVANCED_CIRCULAR_BAR_SMOOTH_UPDATE_CONSTANT)
{
	return lerp(value, target, smoothness);
}

function approach(value, target, amount)
{
	return (value < target) ? min(value + amount, target) : max(value - amount, target);
}

function flash(bar, start_color, end_color, color_pulse_duration, start_aplha, end_alhpa, alpha_pulse_duration)
{
	bar.__flash(start_color, end_color, color_pulse_duration, start_aplha, end_alhpa, alpha_pulse_duration);
}

function wave(from, to, duration, offset = 0)
{
	var halfWave = (to - from) / 2;
	return from + halfWave + sin((current_time / 1000 + duration * offset) / duration * pi * 2) * halfWave;
}

function shake(strength)
{
	return {x: choose(-strength, strength), y: choose(-strength, strength)};
}

function rotate(bar, rotation_variation)
{
	return bar.__rotate(rotation_variation);
}
#endregion Animation tool functions
#macro SMOOTH_UPDATE_CONSTANT 0.0825

// Constructor
function Animated_advanced_circular_bar(x, y, bars = []) constructor
{
	self.x = x;
	self.y = y;
	self.bars = bars;
}

// Main in Draw or Draw GUI
function animate_advanced_circular_bar(animation_bar, x = [animation_bar.x], y = [animation_bar.y], refresh_mask = false)
{
	with (animation_bar)
	{
		for (var i = 0; i < array_length(bars); i++)
		{
			draw_advanced_circular_bar(bars[i], x[i % array_length(x)], y[i % array_length(y)], refresh_mask);
		}
	}
}

// Animation tool functions
function smoothen(value, target, smoothness = SMOOTH_UPDATE_CONSTANT)
{
	return lerp(value, target, smoothness);
}

function approach(value, target, amount)
{
	return (value < target) ? min(value + amount, target) : max(value - amount, target);
}

function flash(bar, colStart, colEnd, colDuration, alphaStart, alphaEnd, alphaDuration)
{
	bar.color = create_fading(colStart, colEnd, wave(0, 1, colDuration));
	bar.transparency = wave(alphaStart, alphaEnd, alphaDuration);
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

function rotate(bar, rotation)
{
	bar.rotation = clamp((bar.rotation + rotation) % 360, -360, 360);
	var r = bar.radius + 1, r2 = r * sqrt(2), angle = (bar.rotation + 135) % 360;
	return {x: r + lengthdir_x(r2, angle), y: r + lengthdir_y(r2, angle), dir: angle};
}

function position_animated_advanced_circular_bar(animation_bar, strength_or_shake_positions, rotation)
{
	var positions = [[], []], _x = 0, _y = 1;
	var shake_positions = is_struct(strength_or_shake_positions) ? strength_or_shake_positions : shake(strength_or_shake_positions);
	var rotation_positions = [];

	with (animation_bar)
	{
		for (var i = 0; i < array_length(bars); i++)
		{
			rotation_positions[i] = rotate(bars[i], rotation);
			array_push(positions[_x], x + shake_positions.x + rotation_positions[i].x);
			array_push(positions[_y], y + shake_positions.y + rotation_positions[i].y);
		}
	}

	return positions;
}

function animate_advanced_circular_bar_positioned(animation_bar, position_array, refresh_mask = false)
{
	animate_advanced_circular_bar(animation_bar, position_array[0], position_array[1], refresh_mask);
}

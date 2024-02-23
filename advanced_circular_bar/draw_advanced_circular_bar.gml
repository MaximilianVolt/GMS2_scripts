/**
	Returns a new instance of Advanced_circular_bar.
	@param {Real} x
	@param {Real} y
	@param {Array<Struct.Circular_bar>} bars
*/

function advanced_circular_bar_create(x, y, bars)
{
	return new Advanced_circular_bar(x, y, bars);
}



/**
	Draws a specific advanced circular bar.
	@param {Struct.Advanced_circular_bar} animation_bar The bar to draw.
	@param {Array<Real>} [x] The x positions to draw the bars.
	@param {Array<Real>} [y] The y positions to draw the bars.
	@param {Bool} [refresh_mask] Updates the bars' masks.
	@param {Array<Constant.BlendMode>} [blendmodes] The blendmodes to draw the bars.
	@param {Array<Asset.GMShader>} [shaders] The shaders to draw the bars.
*/

function draw_advanced_circular_bar(animation_bar, x = [animation_bar.x], y = [animation_bar.y], refresh_mask = false, blendmodes = [bm_normal], shaders = [undefined])
{
	animation_bar.__draw(x, y, refresh_mask, blendmodes, shaders);
}



/**
	Draws a specific advanced circular bar.
	@param {Struct.Advanced_circular_bar} animation_bar The bar to draw.
	@param {Array<Array<Real>>} position_array The x and y positions to draw the bars.
	@param {Bool} [refresh_mask] Updates the bars' masks.
*/

function draw_advanced_circular_bar_positioned(animation_bar, position_array, refresh_mask = false, blendmodes = [bm_normal], shaders = [undefined])
{
	animation_bar.__draw_positioned(position_array, refresh_mask, blendmodes, shaders);
}



/**
	Returns an array of the calculated coordinates with applied shaking and/or rotation.
	@returns {Array<Array<Real>>}
	@param {Struct.Advanced_circular_bar} animation_bar The bar to position.
	@param {Real | Struct} strength_or_shake_positions The strength value or result to use for the positioning.
	@param rotation The rotation to use for the positioning.
*/

function advanced_circular_bar_position(animation_bar, strength_or_shake_positions, rotation)
{
	return animation_bar.__position(strength_or_shake_positions, rotation);
}



/**
	Unfreezes an advanced circular bar's body.
	@param {Struct.Advanced_circular_bar} bar The bar to activate.
*/

function advanced_circular_bar_activate(animation_bar)
{
	var bar_count = array_length(animation_bar.bars);

	for (var i = 0; i < bar_count; i++)
	{
		animation_bar.bars[@ i].active = true;
	}
}



/**
	Freezes an advanced circular bar's body.
	@param {Struct.Advanced_circular_bar} bar The bar to deactivate.
*/

function advanced_circular_bar_deactivate(animation_bar)
{
	var bar_count = array_length(animation_bar.bars);

	for (var i = 0; i < bar_count; i++)
	{
		animation_bar.bars[@ i].active = false;
	}
}



/**
	Gradually makes a value approach to another.
	@returns {Real}
	@param {Real} value The starting value.
	@param {Real} target The value to approach to.
	@param {Real} [smoothness] The amount to approach the target value with, using interpolation.
*/

function smoothen(value, target, smoothness = ADVANCED_CIRCULAR_BAR_SMOOTHNESS)
{
	return lerp(value, target, smoothness);
}



/**
	Makes a value approach to another.
	@returns {Real}
	@param {Real} value The starting value.
	@param {Real} target The value to approach to.
	@param {Real} amount The amount to approach the target value with.
*/

function approach(value, target, amount)
{
	return (value < target) ? min(value + amount, target) : max(value - amount, target);
}



/**
	Dinamically temporarily changes a bar's color and transparency.
	@param {Struct.Circular_bar} bar The bar to edit.
	@param {Constant.Color} start_color The color at the beginning of the pulse period.
	@param {Constant.Color} end_color The color at the end of the pulse period.
	@param {Real} color_pulse_duration The duration of the color pulse period.
	@param {Real} start_alpha The transparency at the beginning of the pulse period.
	@param {Real} end_alpha The transparency at the end of the pulse period.
	@param {Real} alpha_pulse_duration The duration of the transparency pulse period.
*/

function circular_bar_flash(bar, start_color, end_color, color_pulse_duration, start_aplha, end_alhpa, alpha_pulse_duration)
{
	bar.color = merge_color(start_color, end_color, wave(0, 1, color_pulse_duration));
	bar.transparency = wave(start_aplha, end_alhpa, alpha_pulse_duration);
}



/**
	Sets a value following a corresponding sinusoidal function.
	@returns {Real}
	@param {Real} from The starting value.
	@param {Real} to The ending value.
	@param {Real} duration The duration of the period.
	@param {Real} [offset] The offset of the period.
*/

function wave(from, to, duration, offset = 0)
{
	var half_wave = (to - from) / 2;
	return from + half_wave + sin((current_time / 1000 + duration * offset) / duration * pi * 2) * half_wave;
}



/**
	Returns a struct with random positions.
	@param {Real} strength The strength in pixels of the shaking effect.
*/

function shake(strength)
{
	return {x: choose(-strength, strength), y: choose(-strength, strength)};
}



/**
	Returns a struct with random positions and the direction of the origin point from the bar's center.
	@param {Struct.Circular_bar} bar The bar to rotate.
	@param {Real} rotation_variation The angle to rotate the bar with.
*/

function circular_bar_rotate(bar, rotation_variation)
{
	bar.rotation = (bar.rotation + rotation_variation) % 360;
	var r = bar.radius, r2 = r * sqrt(2), angle = (bar.rotation + 135) % 360;
	return {x: r + lengthdir_x(r2, angle), y: r + lengthdir_y(r2, angle), dir: angle};
}



//---------------------------------------------------------------------------



#region Source code
#macro ADVANCED_CIRCULAR_BAR_SMOOTHNESS 0.0825



/**
 *	@param {Real} x
 *	@param {Real} y
 *	@param {Array<Struct.Circular_bar>} bars
*/

function Advanced_circular_bar(x, y, bars) constructor
{
	self.x = x;
	self.y = y;
	self.bars = bars;



	/**
	 *	@param {Array<Real>} x
	 *	@param {Array<Real>} y
	 *	@param {Bool} refresh_mask
	 *	@param {Array<Constant.BlendMode>} blendmodes
	 *	@param {Array<Asset.GMShader>} shaders
	*/

	static __draw = function(x, y, refresh_mask, blendmodes, shaders)
	{
		var bar_count = array_length(bars);
		var xcoord_count = array_length(x);
		var ycoord_count = array_length(y);
		var shader_count = array_length(shaders);
		var blendmode_count = array_length(blendmodes);

		for (var i = 0; i < bar_count; i++)
		{
			bars[@ i].__draw_master(x[@ i % xcoord_count], y[@ i % ycoord_count], refresh_mask, blendmodes[@ i % blendmode_count], shaders[@ i % shader_count]);
		}
	}



	/**
	 *	@param {Array<Array<Real>>} position_array
	 *	@param {Bool} refresh_mask
	 *	@param {Array<Constant.BlendMode>} blendmodes
	 *	@param {Array<Asset.GMShader>} shaders
	*/

	static __draw_positioned = function(position_array, refresh_mask, blendmodes, shaders)
	{
		__draw(position_array[@ 0], position_array[@ 1], refresh_mask, blendmodes, shaders);
	}



	/**
	 *	@param {Real | Struct} strength_or_shake_positions
	 *	@param {Real} rotation
	*/

	static __position = function(strength_or_shake_positions, rotation)
	{
		var positions = [[], []], _x = 0, _y = 1;
		var shake_positions = is_struct(strength_or_shake_positions) ? strength_or_shake_positions : shake(strength_or_shake_positions);
		var bar_count = array_length(bars);
		var rotation_positions = [];

		for (var i = 0; i < bar_count; i++)
		{
			array_push(rotation_positions, circular_bar_rotate(bars[@ i], rotation));
			array_push(positions[@ _x], x + shake_positions.x + rotation_positions[@ i].x);
			array_push(positions[@ _y], y + shake_positions.y + rotation_positions[@ i].y);
		}

		return positions;
	}
}
#endregion Source code
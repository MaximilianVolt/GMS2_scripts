/**
 * Draws a specific advanced circular bar.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to draw.
 * @param {Array<Real>} [x] - The x positions to draw the bars.
 * @param {Array<Real>} [y] - The y positions to draw the bars.
 * @param {Array<Real>} [xscales] - The x scales of the bars.
 * @param {Array<Real>} [yscales] - The y scales of the bars.
 * @param {Bool} [refresh_mask] - Determines whether the bar masks should be updated (true) or not (false).
 * @param {Array<Constant.BlendMode>} [blendmodes] - The blendmodes to draw the bars with.
 * @param {Array<Asset.GMShader>} [shaders] - The shaders to draw the bars with.
*/

function draw_advanced_circular_bar(animation_bar, x = [animation_bar.x], y = [animation_bar.y], xscales = [1], yscales = [1], refresh_mask = false, blendmodes = [bm_normal], shaders = [undefined])
{
	animation_bar.__draw(x, y, xscales, yscales, refresh_mask, blendmodes, shaders);
}



/**
 * Draws a specific advanced circular bar.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to draw.
 * @param {Array<Array<Real>>} position_array - The arrays of x and y positions to draw the bars.
 * @param {Array<Real>} [xscales] - The x scales of the bars.
 * @param {Array<Real>} [yscales] - The y scales of the bars.
 * @param {Bool} [refresh_mask] - Determines whether the bar masks should be updated (true) or not (false).
 * @param {Array<Constant.BlendMode>} [blendmodes] - The blendmodes to draw the bars with.
 * @param {Array<Asset.GMShader>} [shaders] - The shaders to draw the bars with.
*/

function draw_advanced_circular_bar_positioned(animation_bar, position_array, xscales = [1], yscales = [1], refresh_mask = false, blendmodes = [bm_normal], shaders = [undefined])
{
	animation_bar.__draw_positioned(position_array, xscales, yscales, refresh_mask, blendmodes, shaders);
}



/**
 * Returns a new instance of Advanced_circular_bar.
 * @param {Real} x - The x coordinate of the bar.
 * @param {Real} y - The y coordinate of the bar.
 * @param {Array<Struct.Circular_bar>} bars - The set of bars that make the advanced one.
 * @returns {Struct.Advanced_circular_bar}
*/

function advanced_circular_bar_create(x, y, bars)
{
	return new Advanced_circular_bar(x, y, bars);
}



/**
 * Returns a new instance of Advanced_circular_bar with the copied data.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to copy.
 * @returns {Struct.Advanced_circular_bar}
*/

function advanced_circular_bar_clone(animation_bar)
{
	return animation_bar.__copy();
}



/**
 * Returns the coordinates of a bar.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to get the coordinates from.
 * @returns {Struct}
*/

function advanced_circular_bar_get_coordinates(animation_bar)
{
	return {
		x: animation_bar.x,
		y: animation_bar.y
	};
}



/**
 * Returns the x coordinate of a bar.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to get the x coordinate from.
 * @returns {Real}
*/

function advanced_circular_bar_get_x(animation_bar)
{
	return animation_bar.x;
}



/**
 * Returns the y coordinate of a bar.
 * @param {Struct.Advanced_circular_bar} animation_bar The bar to get the y coordinate from.
 * @returns {Real}
*/

function advanced_circular_bar_get_y(animation_bar)
{
	return animation_bar.y;
}



/**
 * Returns the bars of a bar.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to get the bars from.
 * @returns {Array<Struct.Circular_bar>}
*/

function advanced_circular_bar_get_bars(animation_bar)
{
	return animation_bar.bars;
}



/**
 * Returns the copy of the bars of a bar.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to copy the bars from.
 * @returns {Array<Struct.Circular_bar>}
*/

function advanced_circular_bar_get_bars_copy(animation_bar)
{
	return variable_clone(animation_bar.bars);
}



/**
 * Set a bar's coordinates.
 * @param {Struct.Advanced_circular_bar} - animation_bar The bar to edit.
 * @param {Struct} coordinates - The bar's new coordinates.
*/

function advanced_circular_bar_set_coordinates(animation_bar, coordinates)
{
	animation_bar.x = coordinates.x;
	animation_bar.y = coordinates.y;
}



/**
 * Sets a bar's x coordinate.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to edit.
 * @param {Real} x - The bar's new x coordinate.
*/

function advanced_circular_bar_set_x(animation_bar, x)
{
	animation_bar.x = x;
}



/**
 * Sets a bar's y coordinate.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to edit.
 * @param {Real} y - The bar's new y coordinate.
*/

function advanced_circular_bar_set_y(animation_bar, y)
{
	animation_bar.y = y;
}



/**
 * Sets a bar's bars.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to edit.
 * @param {Array<Struct.Circular_bar>} bars - The bar's new bars.
*/

function advanced_circular_bar_set_bars(animation_bar, bars)
{
	animation_bar.bars = bars;
}



/**
 * Sets a bar's bars.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to edit.
 * @param {Array<Struct.Circular_bar>} bars - The bar's new bars.
*/

function advanced_circular_bar_set_bars_copy(animation_bar, bars)
{
	animation_bar.bars = variable_clone(bars);
}



/**
 * Unfreezes an advanced circular bar's body.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to activate.
*/

function advanced_circular_bar_activate(animation_bar)
{
	animation_bar.__set_status(true);
}



/**
 * Freezes an advanced circular bar's body.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to deactivate.
*/

function advanced_circular_bar_deactivate(animation_bar)
{
	animation_bar.__set_status(false);
}



/**
 * Returns an array of the calculated coordinates with applied shaking and/or rotation.
 * @param {Struct.Advanced_circular_bar} animation_bar - The bar to position.
 * @param {Real | Struct} strength_or_shake_positions - The strength value or result to use for the positioning.
 * @param {Real} rotation - The rotation to use for the positioning.
 * @returns {Array<Array<Real>>}
*/

function advanced_circular_bar_position(animation_bar, strength_or_shake_positions, rotation)
{
	return animation_bar.__position(strength_or_shake_positions, rotation);
}



/**
 * Dinamically edits a bar's color and transparency.
 * @param {Struct.Circular_bar} bar - The bar to edit.
 * @param {Constant.Color | Array<Constant.Color>} [colors] - The colors, in order, during the pulse period.
 * @param {Real} [color_pulse_duration] - The duration of the color pulse period.
 * @param {Real | Array<Real>} [alphas] - The transparencies, in order, during the pulse period.
 * @param {Real} [alpha_pulse_duration] - The duration of the transparency pulse period.
*/

function circular_bar_flash(bar, colors = bar.colors, color_pulse_duration = 1, alphas = bar.alphas, alpha_pulse_duration = 1)
{
	colors = is_array(colors) ? colors : [colors];
	alphas = is_array(alphas) ? alphas : [alphas];
	bar.color = bar.__get_color(colors, wave(0, 1, color_pulse_duration));
	bar.alpha = bar.__get_alpha(alphas, wave(0, 1, alpha_pulse_duration));
}



/**
 * Gradually makes a value approach to another.
 * @param {Real} value  - The starting value.
 * @param {Real} target - The value to approach to.
 * @param {Real} [smoothness] - The amount to approach the target value with, using interpolation.
 * @returns {Real}
*/

function smoothen(value, target, smoothness = 10)
{
	return (target - value) / smoothness + value;
}



/**
 * Makes a value approach to another.
 * @param {Real} value - The starting value.
 * @param {Real} target - The value to approach to.
 * @param {Real} amount - The amount to approach the target value with.
 * @returns {Real}
*/

function approach(value, target, amount)
{
	return (value < target) ? min(value + amount, target) : max(value - amount, target);
}



/**
 * Sets a value following a corresponding sinusoidal function.
 * @param {Real} from - The starting value.
 * @param {Real} to - The ending value.
 * @param {Real} duration - The duration (in seconds) of the period.
 * @param {Real} [offset] - The offset of the period.
 * @returns {Real}
*/

function wave(from, to, duration, offset = 0)
{
	var half_wave = (to - from) / 2;
	return from + half_wave + sin((current_time / 1000 + duration * offset) / duration * pi * 2) * half_wave;
}



/**
 * Returns a struct with random positions.
 * @param {Real} strength - The strength in pixels of the shaking effect.
 * @returns {Struct}
*/

function shake(strength)
{
	return {
		x: choose(-strength, strength),
		y: choose(-strength, strength)
	};
}



//---------------------------------------------------------------------------



#region Source code
/**
 * @param {Real} x
 * @param {Real} y
 * @param {Array<Struct.Circular_bar>} bars
*/

function Advanced_circular_bar(x, y, bars) constructor
{
	self.x = x;
	self.y = y;
	self.bars = bars;



	/**
	 * @returns {Struct.Advanced_circular_bar}
	*/

	static __copy = function()
	{
		return variable_clone(self);
	}



	/**
	 * @param {Bool} status
	*/

	static __set_status = function(status)
	{
		var bar_count = array_length(bars);

		for (var i = 0; i < bar_count; i++)
		{
			bars[@ i].active = status;
		}
	}



	/**
	 * @param {Array<Real>} x
	 * @param {Array<Real>} y
	 * @param {Array<Real>} xscales
	 * @param {Array<Real>} yscales
	 * @param {Bool} refresh_mask
	 * @param {Array<Constant.BlendMode>} blendmodes
	 * @param {Array<Asset.GMShader>} shaders
	*/

	static __draw = function(x, y, xscales, yscales, refresh_mask, blendmodes, shaders)
	{
		var bar_count = array_length(bars);
		var xcoord_count = array_length(x);
		var ycoord_count = array_length(y);
		var xscale_count = array_length(xscales);
		var yscale_count = array_length(yscales);
		var shader_count = array_length(shaders);
		var blendmode_count = array_length(blendmodes);

		for (var i = 0; i < bar_count; i++)
		{
			bars[@ i].__draw_master(x[@ i % xcoord_count], y[@ i % ycoord_count], xscales[@ i % xscale_count], yscales[@ i % yscale_count], refresh_mask, blendmodes[@ i % blendmode_count], shaders[@ i % shader_count]);
		}
	}



	/**
	 * @param {Array<Array<Real>>} position_array
	 * @param {Array<Real>} xscales
	 * @param {Array<Real>} yscales
	 * @param {Bool} refresh_mask
	 * @param {Array<Constant.BlendMode>} blendmodes
	 * @param {Array<Asset.GMShader>} shaders
	*/

	static __draw_positioned = function(position_array, xscales, yscales, refresh_mask, blendmodes, shaders)
	{
		__draw(position_array[@ 0], position_array[@ 1], xscales, yscales, refresh_mask, blendmodes, shaders);
	}



	/**
	 * @param {Real | Struct} strength_or_shake_positions
	 * @param {Real} rotation
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
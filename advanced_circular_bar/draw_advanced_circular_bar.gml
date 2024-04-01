/**
 *	Draws a specific advanced circular bar.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to draw.
 *	@param {Array<Real>} [x] The x positions to draw the bars.
 *	@param {Array<Real>} [y] The y positions to draw the bars.
 *	@param {Array<Real>} [xscales] The x scales of the bars.
 *	@param {Array<Real>} [yscales] The y scales of the bars.
 *	@param {Bool} [refresh_mask] Updates the bars' masks.
 *	@param {Array<Constant.BlendMode>} [blendmodes] The blendmodes to draw the bars.
 *	@param {Array<Asset.GMShader>} [shaders] The shaders to draw the bars.
*/

function draw_advanced_circular_bar(animation_bar, x = [animation_bar.x], y = [animation_bar.y], xscales = [1], yscales = [1], refresh_mask = false, blendmodes = [bm_normal], shaders = [undefined])
{
	animation_bar.__draw(x, y, xscales, yscales, refresh_mask, blendmodes, shaders);
}



/**
 *	Draws a specific advanced circular bar.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to draw.
 *	@param {Array<Array<Real>>} position_array The x and y positions to draw the bars.
 *	@param {Array<Real>} [xscales] The x scales of the bars.
 *	@param {Array<Real>} [yscales] The y scales of the bars.
 *	@param {Bool} [refresh_mask] Updates the bars' masks.
 *	@param {Array<Constant.BlendMode>} [blendmodes] The blendmodes to draw the bars.
 *	@param {Array<Asset.GMShader>} [shaders] The shaders to draw the bars.
*/

function draw_advanced_circular_bar_positioned(animation_bar, position_array, xscales = [1], yscales = [1], refresh_mask = false, blendmodes = [bm_normal], shaders = [undefined])
{
	animation_bar.__draw_positioned(position_array, xscales, yscales, refresh_mask, blendmodes, shaders);
}



/**
 *	Returns a new instance of Advanced_circular_bar.
 *	@param {Real} x The x coordinate of the bar.
 *	@param {Real} y The y coordinate of the bar.
 *	@param {Array<Struct.Circular_bar>} bars The set of bars that build up the advanced one.
*/

function advanced_circular_bar_create(x, y, bars)
{
	return new Advanced_circular_bar(x, y, bars);
}



/**
 *	Returns a new instance of Advanced_circular_bar with the copied data.
 *	@returns {Struct.Advanced_circular_bar}
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to copy.
*/

function advanced_circular_bar_get_copy(animation_bar)
{
	return animation_bar.__copy();
}



/**
 *	Returns the coordinates of a bar.
 *	@returns {Struct}
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to get the coordinates from.
*/

function advanced_circular_bar_get_coordinates(animation_bar)
{
	return {x: animation_bar.x, y: animation_bar.y};
}



/**
 *	Returns the x coordinate of a bar.
 *	@returns {Real}
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to get the x coordinate from.
*/

function advanced_circular_bar_get_x(animation_bar)
{
	return animation_bar.x;
}



/**
 *	Returns the y coordinate of a bar.
 *	@returns {Real}
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to get the y coordinate from.
*/

function advanced_circular_bar_get_y(animation_bar)
{
	return animation_bar.y;
}



/**
 *	Returns the bars of a bar.
 *	@returns {Array<Struct.Circular_bar>}
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to get the bars from.
*/

function advanced_circular_bar_get_bars(animation_bar)
{
	return animation_bar.bars;
}



/**
 *	Returns the copy of the bars of a bar.
 *	@returns {Array<Struct.Circular_bar>}
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to copy the bars from.
*/

function advanced_circular_bar_get_bars_copy(animation_bar)
{
	var bars = animation_bar.bars;
	var bar_count = array_length(bars);

	for (var i = 0; i < bar_count; i++)
	{
		bars[@ i] = bars[@ i].__copy();
	}

	return bars;
}



/**
 *	Set a bar's coordinates.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to change.
 *	@param {Struct} coordinates The bar's new coordinates.
*/

function advanced_circular_bar_set_coordinates(animation_bar, coordinates)
{
	animation_bar.x = coordinates.x;
	animation_bar.y = coordinates.y;
}



/**
 *	Set a bar's x coordinate.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to change.
 *	@param {Real} The bar's new x coordinate.
*/

function advanced_circular_bar_set_x(animation_bar, x)
{
	animation_bar.x = x;
}



/**
 *	Set a bar's y coordinate.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to change.
 *	@param {Real} The bar's new y coordinate.
*/

function advanced_circular_bar_set_y(animation_bar, y)
{
	animation_bar.y = y;
}



/**
 *	Set a bar's bars.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to change.
 *	@param {Array<Struct.Circular_bar>} The bar's new bars.
*/

function advanced_circular_bar_set_bars(animation_bar, bars)
{
	animation_bar.bars = bars;
}



/**
 *	Set a bar's bars.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to change.
 *	@param {Array<Struct.Circular_bar>} The bar's new bars.
*/

function advanced_circular_bar_set_bars_copy(animation_bar, bars)
{
	var bar_count = array_length(bars);

	for (var i = 0; i < bar_count; i++)
	{
		bars[@ i] = bars[@ i].__copy();
	}

	animation_bar.bars = bars;
}



/**
 *	Unfreezes an advanced circular bar's body.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to activate.
*/

function advanced_circular_bar_activate(animation_bar)
{
	animation_bar.__set_status(true);
}



/**
 *	Freezes an advanced circular bar's body.
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to deactivate.
*/

function advanced_circular_bar_deactivate(animation_bar)
{
	animation_bar.__set_status(false);
}



/**
 *	Returns an array of the calculated coordinates with applied shaking and/or rotation.
 *	@returns {Array<Array<Real>>}
 *	@param {Struct.Advanced_circular_bar} animation_bar The bar to position.
 *	@param {Real | Struct} strength_or_shake_positions The strength value or result to use for the positioning.
 *	@param rotation The rotation to use for the positioning.
*/

function advanced_circular_bar_position(animation_bar, strength_or_shake_positions, rotation)
{
	return animation_bar.__position(strength_or_shake_positions, rotation);
}



/**
 *	Gradually makes a value approach to another.
 *	@returns {Real}
 *	@param {Real} value The starting value.
 *	@param {Real} target The value to approach to.
 *	@param {Real} [smoothness] The amount to approach the target value with, using interpolation.
*/

function smoothen(value, target, smoothness = 10)
{
	return (target - value) / smoothness + value;
}



/**
 *	Makes a value approach to another.
 *	@returns {Real}
 *	@param {Real} value The starting value.
 *	@param {Real} target The value to approach to.
 *	@param {Real} amount The amount to approach the target value with.
*/

function approach(value, target, amount)
{
	return (value < target) ? min(value + amount, target) : max(value - amount, target);
}




/**
 *	Sets a value following a corresponding sinusoidal function.
 *	@returns {Real}
 *	@param {Real} from The starting value.
 *	@param {Real} to The ending value.
 *	@param {Real} duration The duration of the period.
 *	@param {Real} [offset] The offset of the period.
*/

function wave(from, to, duration, offset = 0)
{
	var half_wave = (to - from) / 2;
	return from + half_wave + sin((current_time / 1000 + duration * offset) / duration * pi * 2) * half_wave;
}



/**
 *	Returns a struct with random positions.
 *	@param {Real} strength The strength in pixels of the shaking effect.
*/

function shake(strength)
{
	return {x: choose(-strength, strength), y: choose(-strength, strength)};
}



//---------------------------------------------------------------------------



#region Source code



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
	 *	@returns {Struct.Advanced_circular_bar}
	*/

	static __copy = function()
	{
		var bar_copy = json_parse(json_stringify(self));
		static_set(bar_copy, static_get(Advanced_circular_bar));

		return bar_copy;
	}


	/**
	 *	@param {Bool} status
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
	 *	@param {Array<Real>} x
	 *	@param {Array<Real>} y
	 *	@param {Array<Real>} xscales
	 *	@param {Array<Real>} yscales
	 *	@param {Bool} refresh_mask
	 *	@param {Array<Constant.BlendMode>} blendmodes
	 *	@param {Array<Asset.GMShader>} shaders
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
	 *	@param {Array<Array<Real>>} position_array
	 *	@param {Array<Real>} xscales
	 *	@param {Array<Real>} yscales
	 *	@param {Bool} refresh_mask
	 *	@param {Array<Constant.BlendMode>} blendmodes
	 *	@param {Array<Asset.GMShader>} shaders
	*/

	static __draw_positioned = function(position_array, xscales, yscales, refresh_mask, blendmodes, shaders)
	{
		__draw(position_array[@ 0], position_array[@ 1], xscales, yscales, refresh_mask, blendmodes, shaders);
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
/**
 *	Draws a specific circular bar.
 *	@param {Struct.Circular_bar} bar The bar to draw.
 *	@param {Real} [x] Override x position to draw the bar.
 *	@param {Real} [y] Override y position to draw the bar.
 *	@param {Real} [xscale] The x scale of the bar surface.
 *	@param {Real} [yscale] The y scale of the bar surface.
 *	@param {Bool} [refresh_mask] Updates the bar's mask.
 *	@param {Constant.BlendMode} [blendmode] The blendmode to apply to draw the bar.
 *	@param {Asset.GMShader} [shader] The shader to apply to draw the bar.
*/

function draw_circular_bar(bar, x = bar.x, y = bar.y, xscale = 1, yscale = 1, refresh_mask = false, blendmode = bm_normal, shader = undefined)
{
	bar.__draw_master(x, y, xscale, yscale, refresh_mask, blendmode, shader);
}



/**
 *	Returns a new instance of Circular_bar.
 *	@returns {Struct.Circular_bar}
 *	@param {Real} x The x position.
 *	@param {Real} y The y position.
 *	@param {Real} radius The bar's radius.
 *	@param {Real} [width] The bar's width.
 *	@param {Real} [start_angle] The bar's angle at 0%.
 *	@param {Real} [end_angle] The bar's angle at 100%.
 *	@param {Real} [value] The value represented by the bar (0 <= x <= 1).
 *	@param {Real} [precision] The number of sectors used to draw the bar. IMPACTS ON PERFORMANCE.
 *	@param {Array<Constant.Color>} [colors] The colors from 0% to 100% of the value.
 *	@param {Array<Real>} [alphas] The opacities from 0% to 100% of the value.
 *	@param {Real} [edge_type_start] The edge drawn at the bar's 0% angle.
 *	@param {Real} [edge_type_final] The edge drawn at the bar's val% angle.
 *	@param {Array<Struct>} [divisors] The triangles that cut the bar (use circular_bar_divisors_autoset()).
 *	@param {Array<Real>} [edges] The shapes drawn at the divisors' edges in order.
 *	@param {Bool} [activation_override] Freezes the bar's body.
*/

function circular_bar_create(x, y, radius, width = radius, start_angle = 90, end_angle = 450, value = 1, precision = CIRCULAR_BAR_PRECISION_PRESETS.MEDIUM, colors = [c_white, c_white], alphas = [1, 1], edge_type_start = 0, edge_type_final = 0, divisors = [], edges = [0], activation_override = true)
{
	return new Circular_bar(x, y, radius, width, start_angle, end_angle, value, precision, colors, alphas, edge_type_start, edge_type_final, divisors, edges, activation_override);
}



/**
 *	Returns a new instance of Circular_bar.
 *	@returns {Struct.Circular_bar}
 *	@param {Real} x The x position.
 *	@param {Real} y The y position.
 *	@param {Real} radius The bar's radius.
 *	@param {Real} [width] The bar's width.
 *	@param {Real} [center_angle] The bar's middle angle (50%).
 *	@param {Real} [amplitude] The bar's total amplitude.
 *	@param {Real} [value] The value represented by the bar (0 <= x <= 1).
 *	@param {Real} [precision] The number of sectors used to draw the bar. IMPACTS ON PERFORMANCE.
 *	@param {Array<Constant.Color>} [colors] The colors from 0% to 100% of the value.
 *	@param {Array<Real>} [alphas] The colors from 0% to 100% of the value.
 *	@param {Real} [edge_type_start] The edge drawn at the bar's 0% angle.
 *	@param {Real} [edge_type_final] The edge drawn at the bar's val% angle.
 *	@param {Array<Struct>} [divisors] The triangles that cut the bar (use circular_bar_divisors_autoset()).
 *	@param {Array<Real>} [edges] The shapes drawn at the divisors' edges in order.
 *	@param {Bool} [activation_override] Freezes the bar's body.
*/

function circular_bar_create_from_center(x, y, radius, width = radius, center_angle = 270, amplitude = 360, value = 1, precision = CIRCULAR_BAR_PRECISION_PRESETS.MEDIUM, colors = [c_white, c_white], alphas = [1, 1], edge_type_start = 0, edge_type_final = 0, divisors = [], edges = [0], activation_override = true)
{
	var half_amplitude = amplitude / 2;
	return new Circular_bar(x, y, radius, width, center_angle - half_amplitude, center_angle + half_amplitude, value, precision, colors, alphas, edge_type_start, edge_type_final, divisors, edges, activation_override);
}



/**
 *	Creates a bar adapted to the shape of its target given a border width.
 *	@returns {Struct.Circular_bar}
 *	@param {Struct.Circular_bar} target_bar The bar to adapt the border to.
 *	@param {Real} border_width The width of the border.
 *	@param {Real} [precision] The precision to apply to the border bar.
 *	@param {Array<Constant.Color>} [colors] The colors of the border bar.
 *	@param {Array<Real>} [alphas] The opacities of the border bar.
*/

function circular_bar_create_border_bar(target_bar, border_width, precision = target_bar.precision, colors = target_bar.colors, alphas = target_bar.alphas)
{
	return target_bar.__copy(precision, colors, alphas).__border(border_width);
}



/**
 *	Creates a bar's divisor.
 *	@param {Real} position The absolute angle of the divisor's bisector.
 *	@param {Real} amplitude The amplitude of the divisor.
*/

function circular_bar_create_divisor(position, amplitude)
{
	return Circular_bar.__create_divisor(position, amplitude);
}



/**
 *	Returns a new instance of Circular_bar with the copied data.
 *	@return {Struct.Circular_bar}
 *	@param {Struct.Circular_bar} bar The bar to copy.
 *	@param {Real} [precision] The number of segments of the new bar.
 *	@param {Array<Constant.Color>} [colors] The colors of the new bar.
 *	@param {Array<Real>} [alphas] The new opacities of the new bar.
*/

function circular_bar_get_copy(bar, precision = bar.precision, colors = bar.colors, alphas = bar.alphas)
{
	return bar.__copy(precision, colors, alphas);
}



/**
 *	Returns the coordinates of a bar.
 *	@returns {Struct}
 *	@param {Struct.Circular_bar} bar The bar to get the coordinates from.
*/

function circular_bar_get_coordinates(bar)
{
	return {x: bar.x, y: bar.y};
}



/**
 *	Returns the x coordinate of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the x coordinate from.
*/

function circular_bar_get_x(bar)
{
	return bar.x;
}



/**
 *	Returns the y coordinate of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the y coordinate from.
*/

function circular_bar_get_y(bar)
{
	return bar.y;
}



/**
 *	Returns the radius in pixels of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the radius from.
*/

function circular_bar_get_radius(bar)
{
	return bar.radius;
}



/**
 *	Returns the width in pixels of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the width from.
*/

function circular_bar_get_width(bar)
{
	return bar.width;
}



/**
 *	Returns the start angle of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the start angle from.
*/

function circular_bar_get_start_angle(bar)
{
	return bar.start_angle;
}



/**
 *	Returns the end angle of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the end angle from.
*/

function circular_bar_get_end_angle(bar)
{
	return bar.end_angle;
}



/**
 *	Returns the center angle of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the center angle from.
*/

function circular_bar_get_center_angle(bar)
{
	return circular_bar_get_angle_at_value(bar, .5);
}



/**
 *	Returns the value of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the value from.
*/

function circular_bar_get_value(bar)
{
	return bar.value;
}



/**
 *	Returns the precision of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the precision from.
*/

function circular_bar_get_precision(bar)
{
	return bar.precision;
}



/**
 *	Returns the colors of a bar.
 *	@returns {Array<Constant.Color>}
 *	@param {Struct.Circular_bar} bar The bar to get the colors from.
*/

function circular_bar_get_colors(bar)
{
	return bar.colors;
}



/**
 *	Returns the color of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the color from.
*/

function circular_bar_get_color(bar)
{
	return bar.color;
}



/**
 *	Returns the alphas of a bar.
 *	@returns {Array<Real>}
 *	@param {Struct.Circular_bar} bar The bar to get the alphas from.
*/

function circular_bar_get_alphas(bar)
{
	return bar.alphas;
}



/**
 *	Returns the alpha of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the alpha from.
*/

function circular_bar_get_alpha(bar)
{
	return bar.alpha;
}



/**
 *	Returns the edge type start of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the edge type start from.
*/

function circular_bar_get_edge_type_start(bar)
{
	return bar.edge_type_start;
}



/**
 *	Returns the edge type final of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the edge type final from.
*/

function circular_bar_get_edge_type_final(bar)
{
	return bar.edge_type_final;
}



/**
 *	Returns the divisors of a bar.
 *	@returns {Array<Struct>}
 *	@param {Struct.Circular_bar} bar The bar to get the divisors from.
*/

function circular_bar_get_divisors(bar)
{
	return bar.divisors;
}



/**
 *	Returns the copy of the divisors of a bar.
 *	@returns {Array<Struct>}
 *	@param {Struct.Circular_bar} bar The bar to copy the divisors from.
*/

function circular_bar_get_divisors_copy(bar)
{
	return json_parse(json_stringify(bar.divisors));
}



/**
 *	Returns the edges of a bar.
 *	@returns {Array<Real>}
 *	@param {Struct.Circular_bar} bar The bar to get the edges from.
*/

function circular_bar_get_edges(bar)
{
	return bar.edges;
}



/**
 *	Returns the copy of the edges of a bar.
 *	@returns {Array<Real>}
 *	@param {Struct.Circular_bar} bar The bar to copy the edges from.
*/

function circular_bar_get_edges_copy(bar)
{
	return json_parse(json_stringify(bar.edges));
}



/**
 *	Returns the rotation of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the rotation from.
*/

function circular_bar_get_rotation(bar)
{
	return bar.rotation;
}



/**
 *	Returns the border width of a bar.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the border width from.
*/

function circular_bar_get_border_width(bar)
{
	return bar.border_width;
}



/**
 *	Returns the number of sectors currently drawn by the bar to represent its value.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the sector from.
 *	@param {Real} [value] The bar value to retrieve the number of sectors drawn.
*/

function circular_bar_get_sector(bar, value = bar.value)
{
	return bar.__get_sector(value);
}



/**
 *	Returns the relative x and y coordinates of a bar's value's edge given an anchor setting.
 *	@returns {Struct}
 *	@param {Struct.Circular_bar} bar The bar to get the coordinates from.
 *	@param {Real} [value] The bar value to retrieve the coordinates from.
 *	@param {Constant.CIRCULAR_BAR_ANCHORS} [anchor] The anchor setting of the edge.
*/

function circular_bar_get_anchor_point_from_value(bar, value = bar.value, anchor = CIRCULAR_BAR_ANCHORS.CENTER)
{
	return bar.__get_anchor(circular_bar_get_angle_at_value(bar, value), anchor);
}



/**
 *	Returns the relative x and y coordinates of a bar's angle's edge given an anchor setting.
 *	@returns {Struct}
 *	@param {Struct.Circular_bar} bar The bar to get the coordinates from.
 *	@param {Real} [angle] The bar value to retrieve the coordinates from.
 *	@param {Constant.CIRCULAR_BAR_ANCHORS} [anchor] The anchor setting of the edge.
*/

function circular_bar_get_anchor_point_from_angle(bar, angle = circular_bar_get_angle_at_value(bar, bar.value), anchor = CIRCULAR_BAR_ANCHORS.CENTER)
{
	return bar.__get_anchor(angle, anchor);
}



/**
 *	Returns the angle of a bar at a specific value.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the angle from.
 *	@param {Real} [value] The value of the angle to retrieve.
*/

function circular_bar_get_angle_at_value(bar, value = bar.value)
{
	return (bar.end_angle - bar.start_angle) * value + bar.start_angle;
}



/**
 *	Returns the value of a bar at a specific angle.
 *	@returns {Real}
 *	@param {Struct.Circular_bar} bar The bar to get the value from.
 *	@param {Real} [angle] The angle of the value to retrieve.
*/

function circular_bar_get_value_at_angle(bar, angle = circular_bar_get_angle_at_value(bar, bar.value))
{
	return bar.__angle_to_placement_percentage(angle);
}



/**
 *	Sets a bar's coordinates.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Struct} coordinates The bar's new coordinates.
*/

function circular_bar_set_coordinates(bar, coordinates)
{
	bar.x = coordinates.x;
	bar.y = coordinates.y;
}



/**
 *	Sets a bar's x coordinate.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new x coordinate.
*/

function circular_bar_set_x(bar, x)
{
	bar.x = x;
}



/**
 *	Sets a bar's y coordinate.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new y coordinate.
*/

function circular_bar_set_y(bar, y)
{
	bar.y = y;
}



/**
 *	Sets a bar's radius.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new radius.
*/

function circular_bar_set_radius(bar, radius)
{
	bar.radius = radius;
}



/**
 *	Sets a bar's width.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new width.
*/

function circular_bar_set_width(bar, width)
{
	bar.width = width;
}



/**
 *	Sets a bar's start angle.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new start angle.
*/

function circular_bar_set_start_angle(bar, start_angle)
{
	bar.start_angle = start_angle;
}



/**
 *	Sets a bar's end angle.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new end angle.
*/

function circular_bar_set_end_angle(bar, end_angle)
{
	bar.end_angle = end_angle;
}



/**
 *	Sets a bar's value.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new value.
*/

function circular_bar_set_value(bar, value)
{
	bar.value = value;
}



/**
 *	Sets a bar's precision.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new precision.
*/

function circular_bar_set_precision(bar, precision)
{
	bar.precision = precision;
}



/**
 *	Sets a bar's color.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Constant.Color} The bar's new color.
*/

function circular_bar_set_color(bar, color)
{
	bar.color = color;
}



/**
 *	Sets a bar's alpha.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new alpha.
*/

function circular_bar_set_alpha(bar, alpha)
{
	bar.alpha = alpha;
}



/**
 *	Sets a bar's edge type start.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new edge type start.
*/

function circular_bar_set_edge_type_start(bar, edge_type_start)
{
	bar.edge_type_start = edge_type_start;
}



/**
 *	Sets a bar's edge type final.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new edge type final.
*/

function circular_bar_set_edge_type_final(bar, edge_type_final)
{
	bar.edge_type_final = edge_type_final;
}



/**
 *	Sets a bar's divisors.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Array<Struct>} The bar's new divisors.
*/

function circular_bar_set_divisors(bar, divisors)
{
	bar.divisors = divisors;
}



/**
 *	Sets a bar's divisors.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Array<Struct>} The bar's new divisors.
*/

function circular_bar_set_divisors_copy(bar, divisors)
{
	bar.divisors = json_parse(json_stringify(divisors));
}



/**
 *	Sets a bar's edges.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Array<Real>} The bar's new edges.
*/

function circular_bar_set_edges(bar, edges)
{
	bar.edges = edges;
}



/**
 *	Sets a bar's edges.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Array<Real>} The bar's new edges.
*/

function circular_bar_set_edges_copy(bar, edges)
{
	bar.edges = json_parse(json_stringify(edges));
}



/**
 *	Sets a bar's rotation.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new rotation.
*/

function circular_bar_set_rotation(bar, rotation)
{
	bar.rotation = rotation;
}



/**
 *	Sets a bar's border width.
 *	@param {Struct.Circular_bar} bar The bar to change.
 *	@param {Real} The bar's new border width.
*/

function circular_bar_set_border_width(bar, border_width)
{
	bar.border_width = border_width;
}



/**
 *	Sets the colors of a circular bar.
 *	@param {Struct.Circular_bar} bar The bar to edit.
 *	@param {Constant.Color} color_start The color of the bar at 0% of its value.
 *	@param {Constant.Color} color_end The color of the bar at 100% of its value.
*/

function circular_bar_set_colors(bar, color_start, color_end)
{
	bar.__set_colors(color_start, color_end);
}



/**
 *	Sets the alphas of a circular bar.
 *	@param {Struct.Circular_bar} bar The bar to edit.
 *	@param {Constant.Color} alpha_start The alpha of the bar at 0% of its value.
 *	@param {Constant.Color} alpha_end The alpha of the bar at 100% of its value.
*/

function circular_bar_set_alphas(bar, alpha_start, alpha_end)
{
	bar.alphas = [alpha_start, alpha_end];
	bar.alpha = bar.__get_alpha();
}



/**
 *	Adds divisors to a bar.
 *	@param {Struct.Circular_bar} bar The bar to edit.
 *	@param {Array<Struct>} divisors The divisors to add.
*/

function circular_bar_add_divisors(bar, divisors)
{
	array_concat(bar.divisors, divisors);
}



/**
 *	Automatically adds centered divisors to the bar's arc.
 *	@param {Struct.Circular_bar} bar The bar to edit.
 *	@param {Real} divisor_count The number of divisors to set.
 *	@param {Array<Real>} divisor_amplitudes The angles of the divisors (following progression).
 *	@param {Array<Real>} divisor_edges The edges to apply to the divisors (following progression).
*/

function circular_bar_generate_divisors(bar, divisor_count, divisor_amplitudes, divisor_edges)
{
	bar.__auto_generate_divisors(divisor_count, divisor_amplitudes, divisor_edges);
}



/**
 *	Unfreezes a circular bar's body.
 *	@param {Struct.Circular_bar} bar The bar to activate.
*/

function circular_bar_activate(bar)
{
	bar.active = true;
}



/**
 *	Freezes a circular bar's body. Recommended for performance when working with multiple bars.
 *	@param {Struct.Circular_bar} bar The bar to deactivate.
*/

function circular_bar_deactivate(bar)
{
	bar.active = false;
}



/**
 *	Refreshes the bar's surfaces.
 *	@param {Struct.Circular_bar} bar The bar to update.
 *	@param {Bool} [refresh_mask] Defines whether the bar mask has to be updated as well.
 *	@param {Bool} [keep_active] Defines whether the bar's body should be frozen.
*/

function circular_bar_update(bar, refresh_mask = false, keep_active = true)
{
	bar.__update(refresh_mask, keep_active);
}



/**
	Returns a struct with rotated positions and the direction of the origin point from the bar's center.
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
enum CIRCULAR_BAR_ANCHORS
{
	TOP = 0,
	CENTER = 1,
	BOTTOM = 2
}

enum CIRCULAR_BAR_PRECISION_PRESETS
{
	LOW = 18,
	MEDIUM = 36,
	HIGH = 54,
	ULTRA = 72,
	PLUS_ULTRA = 90
}



/**
 *	@param {Real} x
 *	@param {Real} y
 *	@param {Real} radius
 *	@param {Real} width
 *	@param {Real} start_angle
 *	@param {Real} end_angle
  *	@param {Real} value
 *	@param {Real} precision
 *	@param {Array<Constant.Color>} colors
 *	@param {Array<Real>} alphas
 *	@param {Real} edge_type_start
 *	@param {Real} edge_type_final
 *	@param {Array<Struct>} divisors
 *	@param {Array<Real>} edges
 *	@param {Bool} activation_override
*/

function Circular_bar(x, y, radius, width, start_angle, end_angle, value, precision, colors, alphas, edge_type_start, edge_type_final, divisors, edges, activation_override) constructor
{
	#region Constructor
	self.x = x;
	self.y = y;
	self.value = value;
	self.precision = precision;
	self.colors = colors;
	self.color = merge_color(colors[@ 0], colors[@ 1], value);
	self.alphas = alphas;
	self.alpha = (alphas[@ 1] - alphas[@ 0]) * value + alphas[@ 0];
	self.start_angle = start_angle;
	self.end_angle = end_angle;
	self.radius = radius;
	self.width = width;
	self.active = activation_override;
	self.edge_type_start = edge_type_start;
	self.edge_type_final = edge_type_final;
	self.divisors = divisors;
	self.edges = edges;
	self.rotation = 0;
	self.surface = -1;
	self.redraw = true;
	self.mask = -1;
	self.border = false;
	self.border_width = 0;
	#endregion

	#region Base functions
	static edge_translations =
	[
		  1,		// NONE
		  0,		// ROUND
		 .5,		// CHEVRON
		  0,		// RECTANGLE
		 .5,		// BUBBLY - TOP
		 .5,		// BUBBLY - CENTER
		 .5,		// BUBBLY - BOTTOM
		.75,		// DART - TOP
		.75,		// DART - CENTER
		.75,		// DART - BOTTOM
		.75,		// DIAMOND - TOP
		.75,		// DIAMOND - CENTER
		.75,		// DIAMOND - BOTTOM
		 .5,		// TRIANGLE - TOP
		 .5,		// TRIANGLE - CENTER
		 .5,		// TRIANGLE - BOTTOM
		 .5,		// TRAPEZOID - TOP
		 .5,		// TRAPEZOID - CENTER
		 .5,		// TRAPEZOID - BOTTOM
		.75,		// ROUNDED DIAMOND - TOP
		.75,		// ROUNDED DIAMOND - CENTER
		.75			// ROUNDED DIAMOND - BOTTOM
	];



	/**
	 *	@returns {Struct.Circular_bar}
	 *	@param {Real} [precision_override]
	*/

	static __copy = function(precision_override = self.precision, colors = self.colors, alphas = self.alphas)
	{
		var bar_copy = json_parse(json_stringify(self));
		static_set(bar_copy, static_get(Circular_bar));
		bar_copy.precision = precision_override;
		bar_copy.colors = colors;
		bar_copy.alphas = alphas;

		return bar_copy;
	}



	/**
	 *	@param {Bool} [refresh_mask]
	 *	@param {Bool} [active]
	*/

	static __update = function(refresh_mask = false, active = self.active)
	{
		redraw = active;

		if (refresh_mask && surface_exists(mask))
		{
			surface_free(mask);
		}
	}



	/**
	 *	@return {Real}
	*/

	static __get_alpha = function()
	{
		return (alphas[@ 1] - alphas[@ 0]) * value + alphas[@ 0];
	}



	/**
	 *	@return {Struct}
	 *	@param {Real} value
	 *	@param {Real} anchor
	*/

	static __get_anchor = function(angle, anchor)
	{
		var radius = __calculate_variable_radius(value);
		var width = self.width * radius / self.radius;
		var inner = radius - width;

		var p1x = lengthdir_x(inner, angle);
		var p1y = lengthdir_y(inner, angle);
		var p2x = lengthdir_x(radius, angle);
		var p2y = lengthdir_y(radius, angle);
		var mpx = mean(p1x, p2x);
		var mpy = mean(p1y, p2y);

		var _x = 0, _y = 1;
		var positions = [[p2x, mpx, p1x], [p2y, mpy, p1y]];

		return {x: positions[@ _x][@ anchor], y: positions[@ _y][@ anchor]};
	}



	/**
	 *	@param {Real} [value]
	*/

	static __get_sector = function(value = self.value)
	{
		return ceil(value * precision);
	}



	/**
	 *	@param {Constant.Color} color_start
	 *	@param {Constant.Color} color_end
	*/

	static __set_colors = function(color_start, color_end)
	{
		color = merge_color(color_start, color_end, value);
		colors = [color_start, color_end];
	}



	/**
	 *	@param {Real} border_width
	*/

	static __border = function(border_width)
	{
		// I no longer hate this :3
		border = true;
		self.border_width = border_width;
		width += border_width * 2;
		radius += border_width;
		__update(true);

		return self;
	}



	/**
	 *	@returns {Array<Real>}
	*/

	static __get_placement_values = function()
	{
		var placement_values = [];
		var _ = __angle_to_placement_percentage;
		var divisor_count = array_length(divisors);

		for (var i = 0; i < divisor_count; i++)
		{
			array_push(placement_values, _(divisors[@ i].edge_angles[@ 0]), _(divisors[@ i].edge_angles[@ 1]));
		}

		array_sort(placement_values, true);
		return placement_values;
	}



	/**
	 *	@returns {Real}
	 *	@param {Real} angle
	*/

	static __angle_to_placement_percentage = function(angle)
	{
		return (angle - start_angle) / (end_angle - start_angle);
	}
	#endregion

	#region Main
	/**
	 *	@param {Real} x
	 *	@param {Real} y
	 *	@param {Real} xscale
	 *	@param {Real} yscale
	 *	@param {Bool} refresh_mask
	 *	@param {Constant.BlendMode} blendmode
	 *	@param {Asset.GMShader} shader
	*/

	static __draw_master = function(x, y, xscale, yscale, refresh_mask, blendmode, shader)
	{
		if (value <= 0 || alpha <= 0)
		{
			exit;
		}

		__draw(x, y, refresh_mask);

		gpu_set_blendmode(blendmode);

		if (shader != undefined)
		{
			shader_set(shader);
		}

		__finalise_surface(x, y, xscale, yscale);
		color = merge_color(colors[@ 0], colors[@ 1], value);
		alpha = __get_alpha();
	}



	/**
	 *	@param {Real} x
	 *	@param {Real} y
	 *	@param {Bool} refresh_mask
	*/

	static __draw = function(x, y, refresh_mask)
	{
		var side = radius * 2 + 1;

		if (!surface_exists(surface))
		{
			surface = surface_create(side, side);
		}

		__update(refresh_mask);
		surface_set_target(surface);

		if (!redraw)
		{
			return;
		}

		draw_clear_alpha(c_black, 0);

		if (!surface_exists(mask))
		{
			__draw_mask(side);
		}

		__draw_body();

		gpu_set_blendmode(bm_subtract);
		draw_surface(mask, 0, 0);
	}



	/**
	 *	@param {Real} side
	*/

	static __draw_mask = function(side)
	{
		surface_reset_target();
		var mask_precision = min(CIRCULAR_BAR_PRECISION_PRESETS.PLUS_ULTRA, precision);
		var temp_surface = surface_create(side, side);
		surface_set_target(temp_surface);
		__draw_body(mask_precision, 1);
		gpu_set_blendmode(bm_subtract);

		if (width < radius)
		{
			__draw_progression(mask_precision, 1, radius - width);
		}

		if (array_length(divisors))
		{
			__draw_divisors();
		}

		surface_reset_target();
		mask = surface_create(side, side);
		gpu_set_blendmode(bm_subtract);
		surface_set_target(mask);
		draw_clear(c_black);

		draw_surface(temp_surface, 0, 0);
		surface_free(temp_surface);
		surface_reset_target();

		gpu_set_blendmode(bm_normal);
		surface_set_target(surface);
	}



	/**
	 *	@param {Real} [precision_override]
	 *	@param {Real} [value_override]
	*/

	static __draw_body = function(precision_override = self.precision, value_override = self.value)
	{
		__draw_endpoints(__draw_progression(precision_override, value_override));
	}



	/**
	 *	@param {Real} [precision_override]
	 *	@param {Real} [value_override]
	 *	@param {Real} [radius]
	*/

	static __draw_progression = function(precision_override, value_override, radius = self.radius)
	{
		var center = self.radius, _cos, _sin;
		var angle_diff = end_angle - start_angle;
		var rotation_increment = sign(angle_diff);
		var calibrated_start_angle = start_angle - 180;
		var sector_size = abs(angle_diff) / precision_override;
		var sector_count = __get_sector(value_override), angle = start_angle;

		draw_primitive_begin(pr_trianglefan);
		draw_vertex(center, center);

		for (var i = 0; i < sector_count; i++)
		{
			angle = sector_size * i * rotation_increment + calibrated_start_angle;
			_cos = lengthdir_x(radius, angle);
			_sin = lengthdir_y(radius, angle);
			draw_vertex(center - _cos, center - _sin);
		}

		var variable_radius = __calculate_variable_radius(value_override, radius);
		angle = angle_diff * value_override + calibrated_start_angle;
		_cos = lengthdir_x(variable_radius, angle);
		_sin = lengthdir_y(variable_radius, angle);
		draw_vertex(center - _cos, center - _sin);
		draw_primitive_end();

		return angle;
	}



	/**
	 *	@param {Real} [value]
	 *	@param {Real} [radius]
	*/

	static __calculate_variable_radius = function(value = self.value, radius = self.radius)
	{
		// Too much trigonometry, Maximilian out.
		var angle_diff = end_angle - start_angle;
		var rotation_increment = sign(angle_diff);
		var angle = angle_diff * value + start_angle;
		var sector_amplitude = abs(angle_diff) / precision;
		var sector_count = __get_sector(value) - (value < 1);
		var outer_angle = (180 - sector_amplitude) / 2;
		var anchored_angle = start_angle + sector_amplitude * rotation_increment * sector_count;
		// var snap_dir_angle = anchored_angle + sector_amplitude / 2 * sign(angle_diff);
		var sector_angle_diff = abs(angle - anchored_angle) % sector_amplitude;
		var inner_angle = 180 - outer_angle - sector_angle_diff;

		return radius * dsin(outer_angle) / dsin(inner_angle);
	}



	/**
	 *	@param {Real} current_angle
	*/

	static __draw_endpoints = function(current_angle)
	{
		__draw_edges([edge_type_final, edge_type_start], [__angle_to_placement_percentage(current_angle + 180), 0]);
	}



	/**
	 *	@param {Real} x
	 *	@param {Real} y
	 *	@param {Real} xscale
	 *	@param {Real} yscale
	*/

	static __finalise_surface = function(x, y, xscale, yscale)
	{
		surface_reset_target();
		draw_surface_ext(surface, x - radius, y - radius, xscale, yscale, rotation, color, alpha);
		gpu_set_blendmode(bm_normal);
		draw_set_color(c_white);
		draw_set_alpha(1);
		shader_reset();
	}
	#endregion

	#region Divisors management
	/**
	 *	@param {Real} divisor_count
	 *	@param {Array<Real>} divisor_amplitudes
	 *	@param {Array<Real>} divisor_edges
	*/

	static __auto_generate_divisors = function(divisor_count, divisor_amplitudes, divisor_edges)
	{
		var amplitudes_count = array_length(divisor_amplitudes);
		var angle_diff = end_angle - start_angle;
		var start_index = (angle_diff % 360 != 0);
		divisor_count += start_index;
		edges = divisor_edges;
		divisors = [];

		for (var i = start_index; i < divisor_count; i++)
		{
			var position = angle_diff * i / divisor_count + start_angle;
			var amplitude = divisor_amplitudes[@ (i - start_index) % amplitudes_count];
			array_push(divisors, __create_divisor(position, amplitude));
		}

		__update(true);
	}



	/**
	 *	@param {Real} position
	 *	@param {Real} amplitude
	*/

	static __create_divisor = function(position, amplitude)
	{
		var half_amplitude = amplitude / 2;
		return {position, amplitude, edge_angles: [position - half_amplitude, position + half_amplitude]};
	}



	/**
	 *
	*/

	static __draw_divisors = function()
	{
		var divisor_count = array_length(divisors);

		for (var i = 0; i < divisor_count; i++)
		{
			__draw_divisor(divisors[@ i]);
		}

		gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_src_alpha, bm_dest_alpha);
		__draw_edges();
	}



	/**
	 *	@param {Struct} divisor
	*/

	static __draw_divisor = function(divisor)
	{
		var center = radius;
		var len = radius * 1.5;
		var position = divisor.position;
		var angles = divisor.edge_angles;
		var variation = (divisor.amplitude >= 180) * 90;

		var t1x1 = center + lengthdir_x(len, angles[@ 0]);
		var t1y1 = center + lengthdir_y(len, angles[@ 0]);
		var t2x1 = center + lengthdir_x(len, angles[@ 1]);
		var t2y1 = center + lengthdir_y(len, angles[@ 1]);

		var tmx1 = center + lengthdir_x(len, position - variation);
		var tmy1 = center + lengthdir_y(len, position - variation);
		var tmx2 = center + lengthdir_x(len, position + variation);
		var tmy2 = center + lengthdir_y(len, position + variation);
		var tmx3 = center + lengthdir_x(len, position);
		var tmy3 = center + lengthdir_y(len, position);

		draw_primitive_begin(pr_trianglefan);
		draw_vertex(center, center);
		draw_vertex(t1x1, t1y1);
		draw_vertex(tmx1, tmy1);
		draw_vertex(tmx3, tmy3);
		draw_vertex(tmx2, tmy2);
		draw_vertex(t2x1, t2y1);
		draw_primitive_end();
	}



	/**
	 *	@param {Array<Real>} [edges_to_draw]
	 *	@param {Array<Real>} [placement_values]
	*/

	static __draw_edges = function(edges_to_draw = edges, placement_values = __get_placement_values())
	{
		var placements_count = array_length(placement_values);
		var edges_count = array_length(edges_to_draw);
		var angle_diff = end_angle - start_angle;
		var dir = sign(angle_diff) * 90;
		var direction_values = [dir, -dir];

		for (var i = 0; i < placements_count; i++)
		{
			var edge = edges_to_draw[@ i % edges_count];
			var edge_direction = direction_values[@ i % 2];
			var placement_angle = placement_values[@ i] * angle_diff + start_angle;
			__draw_edge(edge, placement_angle, __calculate_variable_radius(placement_values[@ i]), edge_direction);
		}
	}



	/**
	 *	@param {Real} edge
	 *	@param {Real} placement
	 *	@param {Struct} variable_coordinates
	 *	@param {Real} dir
	 *	@param {Real} [ext]
	*/

	static __draw_edge = function(edge, placement, radius, dir, ext = 1)
	{
		var width = self.width * radius / self.radius;
		var center = self.radius;
		var center_x = center;
		var center_y = center;
		dir += placement;

		var edge_selector =
		[
			function(center_x, center_y, radius, width, angle) {__round_edge(center_x, center_y, radius, width, angle)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__chevron_edge(center_x, center_y, radius, width, angle, dir, ext)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__rectangle_edge(center_x, center_y, radius, width, angle, dir, ext)},
			function(center_x, center_y, radius, width, angle) {__bubbly_edge(center_x, center_y, radius, width, angle, CIRCULAR_BAR_ANCHORS.TOP)},
			function(center_x, center_y, radius, width, angle) {__bubbly_edge(center_x, center_y, radius, width, angle, CIRCULAR_BAR_ANCHORS.CENTER)},
			function(center_x, center_y, radius, width, angle) {__bubbly_edge(center_x, center_y, radius, width, angle, CIRCULAR_BAR_ANCHORS.BOTTOM)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__dart_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.TOP)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__dart_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.CENTER)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__dart_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.BOTTOM)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__diamond_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.TOP)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__diamond_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.CENTER)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__diamond_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.BOTTOM)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__triangle_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.TOP)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__triangle_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.CENTER)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__triangle_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.BOTTOM)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__trapezoid_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.TOP)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__trapezoid_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.CENTER)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__trapezoid_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.BOTTOM)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__rounded_diamond_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.TOP)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__rounded_diamond_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.CENTER)},
			function(center_x, center_y, radius, width, angle, dir, ext) {__rounded_diamond_edge(center_x, center_y, radius, width, angle, dir, ext, CIRCULAR_BAR_ANCHORS.BOTTOM)}
		];

		if (border)
		{
			var inner = radius - width;
			var p1x = center_x + lengthdir_x(inner, placement);
			var p1y = center_y + lengthdir_y(inner, placement);
			var p2x = center_x + lengthdir_x(radius, placement);
			var p2y = center_y + lengthdir_y(radius, placement);

			var vector = border_width * edge_translations[@ edge];
			var vect_x = lengthdir_x(vector, dir);
			var vect_y = lengthdir_y(vector, dir);
			var p3x = p1x + vect_x;
			var p3y = p1y + vect_y;
			var p4x = p2x + vect_x;
			var p4y = p2y + vect_y;

			draw_primitive_begin(pr_trianglefan);
			draw_vertex(p1x, p1y);
			draw_vertex(p3x, p3y);
			draw_vertex(p4x, p4y);
			draw_vertex(p2x, p2y);
			draw_primitive_end();

			center_x += vect_x;
			center_y += vect_y;
		}

		if (edge)
		{
			draw_primitive_begin(pr_trianglelist);
			edge_selector[@ edge - 1](center_x, center_y, radius, width, placement, dir, ext);
			draw_primitive_end();
		}
	}
	#endregion

	#region Edges
	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	*/

	static __round_edge = function(center_x, center_y, radius, width, angle)
	{
		var hw = width / 2, mid_point = radius - hw;
		var cx = center_x + lengthdir_x(mid_point, angle);
		var cy = center_y + lengthdir_y(mid_point, angle);

		draw_circle(cx - 1, cy - 1, hw, false);
	}



	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	 *	@param {Real} dir
	 *	@param {Real} ext
	 *	@param {Real} position
	*/

	static __triangle_edge = function(center_x, center_y, radius, width, angle, dir, ext, position)
	{
		var inner = radius - width, hw = width / 2, ew = ext * hw;
		var p1x = center_x + lengthdir_x(inner, angle);
		var p1y = center_y + lengthdir_y(inner, angle);
		var p2x = center_x + lengthdir_x(radius, angle);
		var p2y = center_y + lengthdir_y(radius, angle);
		var mpx = mean(p1x, p2x);
		var mpy = mean(p1y, p2y);

		var _x = 0, _y = 1;
		var positions = [[p2x, mpx, p1x], [p2y, mpy, p1y]];
		var p3x = positions[@ _x][@ position] + lengthdir_x(ew, dir);
		var p3y = positions[@ _y][@ position] + lengthdir_y(ew, dir);

		draw_vertex(p1x, p1y);
		draw_vertex(p2x, p2y);
		draw_vertex(p3x, p3y);
	}



	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	 *	@param {Real} dir
	 *	@param {Real} ext
	 *	@param {Real} position
	*/

	static __trapezoid_edge = function(center_x, center_y, radius, width, angle, dir, ext, position)
	{
		var inner = radius - width, ew = ext * width / 4;
		var p1x = center_x + lengthdir_x(inner, angle);
		var p1y = center_y + lengthdir_y(inner, angle);
		var p2x = center_x + lengthdir_x(radius, angle);
		var p2y = center_y + lengthdir_y(radius, angle);

		var _x = 0, _y = 1;
		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var m1_4x = p1x + xlen / 4;
		var m1_4y = p1y + ylen / 4;
		var m3_4x = p2x - xlen / 4;
		var m3_4y = p2y - ylen / 4;
		var m1_base_positions = [[p1x, m1_4x, m1_4x], [p1y, m1_4y, m1_4y]];
		var m2_base_positions = [[m3_4x, m3_4x, p2x], [m3_4y, m3_4y, p2y]];
		var m1x = m1_base_positions[@ _x][@ position];
		var m1y = m1_base_positions[@ _y][@ position];
		var m2x = m2_base_positions[@ _x][@ position];
		var m2y = m2_base_positions[@ _y][@ position];
		var xdir = lengthdir_x(ew, dir);
		var ydir = lengthdir_y(ew, dir);
		var p3x = m1x + xdir;
		var p3y = m1y + ydir;
		var p4x = m2x + xdir;
		var p4y = m2y + ydir;

		draw_vertex(p1x, p1y);
		draw_vertex(p3x, p3y);
		draw_vertex(p4x, p4y);
		draw_vertex(p1x, p1y);
		draw_vertex(p2x, p2y);
		draw_vertex(p4x, p4y);
	}



	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	 *	@param {Real} dir
	 *	@param {Real} ext
	*/

	static __chevron_edge = function(center_x, center_y, radius, width, angle, dir, ext)
	{
		var inner = radius - width, ew = ext * width / 2, hw = ew / 2;
		var p1x = center_x + lengthdir_x(inner, angle);
		var p1y = center_y + lengthdir_y(inner, angle);
		var p2x = center_x + lengthdir_x(radius, angle);
		var p2y = center_y + lengthdir_y(radius, angle);
		var xdir = lengthdir_x(ew, dir);
		var ydir = lengthdir_y(ew, dir);
		var e1x = p1x + xdir;
		var e1y = p1y + ydir;
		var e2x = p2x + xdir;
		var e2y = p2y + ydir;
		var mpx = mean(p1x, p2x);
		var mpy = mean(p1y, p2y);
		var p3x = mpx + lengthdir_x(hw, dir);
		var p3y = mpy + lengthdir_y(hw, dir);

		draw_vertex(p1x, p1y);
		draw_vertex(e1x, e1y);
		draw_vertex(p3x, p3y);
		draw_vertex(p2x, p2y);
		draw_vertex(e2x, e2y);
		draw_vertex(p3x, p3y);
		draw_vertex(p1x, p1y);
		draw_vertex(p2x, p2y);
		draw_vertex(p3x, p3y);
	}



	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	 *	@param {Real} position
	*/

	static __bubbly_edge = function(center_x, center_y, radius, width, angle, position)
	{
		center_x -= 1;
		center_y -= 1;
		var inner = radius - width, qw = width / 4;
		var p1x = center_x + lengthdir_x(inner, angle);
		var p1y = center_y + lengthdir_y(inner, angle);
		var p2x = center_x + lengthdir_x(radius, angle);
		var p2y = center_y + lengthdir_y(radius, angle);

		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var mpx = mean(p1x, p2x);
		var mpy = mean(p1y, p2y);
		var m3_10x = p1x + xlen * 3 / 10;
		var m3_10y = p1y + ylen * 3 / 10;
		var m6_10x = p2x - xlen * 3 / 10;
		var m6_10y = p2y - ylen * 3 / 10;
		var m2_5x = p1x + xlen * 2 / 5;
		var m2_5y = p1y + ylen * 2 / 5;
		var m3_5x = p2x - xlen * 2 / 5;
		var m3_5y = p2y - ylen * 2 / 5;
		var m1_5x = p1x + xlen / 5;
		var m1_5y = p1y + ylen / 5;
		var m4_5x = p2x - xlen / 5;
		var m4_5y = p2y - ylen / 5;

		var _x = 0, _y = 1;
		var positions = [[[m6_10x, m2_5x, m1_5x], [m4_5x, mpx, m1_5x], [m4_5x, m3_5x, m3_10x]], [[m6_10y, m2_5y, m1_5y], [m4_5y, mpy, m1_5y], [m4_5y, m3_5y, m3_10y]]];
		var b1x = positions[@ _x][@ position][@ 0];
		var b1y = positions[@ _y][@ position][@ 0];
		var mbx = positions[@ _x][@ position][@ 1];
		var mby = positions[@ _y][@ position][@ 1];
		var b2x = positions[@ _x][@ position][@ 2];
		var b2y = positions[@ _y][@ position][@ 2];
		var radius_multipliers = [[.3, .24, .2], [.2, .3, .2], [.2, .24, .3]];
		var radiuses = [width * radius_multipliers[@ position][@ 0], width * radius_multipliers[@ position][@ 1], width * radius_multipliers[@ position][@ 2]];

		draw_circle(b1x, b1y, radiuses[@ 0], false);
		draw_circle(mbx, mby, radiuses[@ 1], false);
		draw_circle(b2x, b2y, radiuses[@ 2], false);
	}



	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	 *	@param {Real} dir
	 *	@param {Real} ext
	*/

	static __rectangle_edge = function(center_x, center_y, radius, width, angle, dir, ext)
	{
		var inner = radius - width, ew = ext * width / 2;
		var p1x = center_x + lengthdir_x(inner, angle);
		var p1y = center_y + lengthdir_y(inner, angle);
		var p2x = center_x + lengthdir_x(radius, angle);
		var p2y = center_y + lengthdir_y(radius, angle);
		var xdir = lengthdir_x(ew, dir);
		var ydir = lengthdir_y(ew, dir);
		var p3x = p1x + xdir;
		var p3y = p1y + ydir;
		var p4x = p2x + xdir;
		var p4y = p2y + ydir;

		draw_vertex(p1x, p1y);
		draw_vertex(p3x, p3y);
		draw_vertex(p4x, p4y);
		draw_vertex(p4x, p4y);
		draw_vertex(p2x, p2y);
		draw_vertex(p1x, p1y);
	}



	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	 *	@param {Real} dir
	 *	@param {Real} ext
	 *	@param {Real} position
	*/

	static __rounded_diamond_edge = function(center_x, center_y, radius, width, angle, dir, ext, position)
	{
		// As of now circles can't be stretched
		// If you come up with a solution to make circles (ellipses, basically) stretch
		// correctly in all angles please do contact me on Discord: maximilian.volt
		ext = 1;

		var inner = radius - width, qw = width / 4, ew = ext * qw;
		var p1x = center_x + lengthdir_x(inner, angle);
		var p1y = center_y + lengthdir_y(inner, angle);
		var p2x = center_x + lengthdir_x(radius, angle);
		var p2y = center_y + lengthdir_y(radius, angle);

		var _x = 0, _y = 1;
		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var mx = mean(p1x, p2x);
		var my = mean(p1y, p2y);
		var m1_4x = p1x + xlen / 4;
		var m1_4y = p1y + ylen / 4;
		var m3_4x = p2x - xlen / 4;
		var m3_4y = p2y - ylen / 4;

		var _dir = sign(dir - angle) * 90;
		var base_direction = angle + _dir;
		var as1_2 = darcsin(.5) * sign(_dir);
		var as1_3 = darcsin(1 / 3) * sign(_dir);
		var angle_differences = [as1_3, as1_2, as1_3];
		var angle_diff = angle_differences[@ position];
		var base_positions = [[m3_4x, mx, m1_4x], [m3_4y, my, m1_4y]];
		var bx = base_positions[@ _x][@ position];
		var by = base_positions[@ _y][@ position];

		var b1xlx = bx + lengthdir_x(ew, base_direction + angle_diff);
		var b1yly = by + lengthdir_y(ew, base_direction + angle_diff);
		var b2xlx = bx + lengthdir_x(ew, base_direction - angle_diff);
		var b2yly = by + lengthdir_y(ew, base_direction - angle_diff);
		var v1_positions = [[b1xlx, b1xlx, bx], [b1yly, b1yly, by]];
		var v2_positions = [[bx, b2xlx, b2xlx], [by, b2yly, b2yly]];
		var v1x = v1_positions[@ _x][@ position];
		var v1y = v1_positions[@ _y][@ position];
		var v2x = v2_positions[@ _x][@ position];
		var v2y = v2_positions[@ _y][@ position];

		draw_circle(bx - 1, by - 1, qw, false);
		draw_vertex(bx, by);
		draw_vertex(p1x, p1y);
		draw_vertex(v1x, v1y);
		draw_vertex(p2x, p2y);
		draw_vertex(v2x, v2y);
		draw_vertex(bx, by);
	}



	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	 *	@param {Real} dir
	 *	@param {Real} ext
	 *	@param {Real} position
	*/

	static __diamond_edge = function(center_x, center_y, radius, width, angle, dir, ext, position)
	{
		var inner = radius - width, ew = ext * width / 4;
		var p1x = center_x + lengthdir_x(inner, angle);
		var p1y = center_y + lengthdir_y(inner, angle);
		var p2x = center_x + lengthdir_x(radius, angle);
		var p2y = center_y + lengthdir_y(radius, angle);

		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var mbx = mean(p1x, p2x);
		var mby = mean(p1y, p2y);
		var m1_4x = p1x + xlen / 4;
		var m1_4y = p1y + ylen / 4;
		var m3_4x = p2x - xlen / 4;
		var m3_4y = p2y - ylen / 4;

		var _x = 0, _y = 1;
		var positions = [[m3_4x, mbx, m1_4x], [m3_4y, mby, m1_4y]];
		var vx = lengthdir_x(ew, dir) + positions[@ _x][@ position];
		var vy = lengthdir_y(ew, dir) + positions[@ _y][@ position];

		draw_vertex(p1x, p1y);
		draw_vertex(p2x, p2y);
		draw_vertex(vx, vy);
	}



	/**
	 *	@param {Real} center_x
	 *	@param {Real} center_y
	 *	@param {Real} radius
	 *	@param {Real} width
	 *	@param {Real} angle
	 *	@param {Real} dir
	 *	@param {Real} ext
	 *	@param {Real} position
	*/

	static __dart_edge = function(center_x, center_y, radius, width, angle, dir, ext, position)
	{
		var inner = radius - width, ew = ext * width / 4;
		var p1x = center_x + lengthdir_x(inner, angle);
		var p1y = center_y + lengthdir_y(inner, angle);
		var p2x = center_x + lengthdir_x(radius, angle);
		var p2y = center_y + lengthdir_y(radius, angle);

		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var m3_16x = p1x + xlen * 3 / 16;
		var m3_16y = p1y + ylen * 3 / 16;
		var m6_16x = p1x + xlen * 3 / 8;
		var m6_16y = p1y + ylen * 3 / 8;
		var m10_16x = p2x - xlen * 3 / 8;
		var m10_16y = p2y - ylen * 3 / 8;
		var m13_16x = p2x - xlen * 3 / 16;
		var m13_16y = p2y - ylen * 3 / 16;

		var _x = 0, _y = 1;
		var positions1 = [[m10_16x, m6_16x, m3_16x], [m10_16y, m6_16y, m3_16y]];
		var positions2 = [[m13_16x, m10_16x, m6_16x], [m13_16y, m10_16y, m6_16y]];
		var b1x = positions1[@ _x][@ position];
		var b1y = positions1[@ _y][@ position];
		var b2x = positions2[@ _x][@ position];
		var b2y = positions2[@ _y][@ position];
		var xdir = lengthdir_x(ew, dir);
		var ydir = lengthdir_y(ew, dir);
		var v1x = b1x + xdir;
		var v1y = b1y + ydir;
		var v2x = b2x + xdir;
		var v2y = b2y + ydir;

		draw_vertex(p1x, p1y);
		draw_vertex(v1x, v1y);
		draw_vertex(b2x, b2y);
		draw_vertex(p2x, p2y);
		draw_vertex(v2x, v2y);
		draw_vertex(b1x, b1y);
	}
	#endregion Edges
}
#endregion Source code
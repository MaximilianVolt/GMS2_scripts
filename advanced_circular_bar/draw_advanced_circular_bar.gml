#macro ADVANCED_CIRCULAR_BAR_MINIMUM_VISIBLE_VALUE 0.005

enum ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS
{
	TOP = 0,
	CENTER = 1,
	BOTTOM = 2
}

enum ADVANCED_CIRCULAR_BAR_QUALITY
{
	LOW = 79,
	MEDIUM = 179,
	HIGH = 359,
	ULTRA = 719,
	PLUS_ULTRA = 999
}

function circular_bar_create(x, y, value = 1, precision = ADVANCED_CIRCULAR_BAR_QUALITY.MEDIUM, colors = [c_black, c_white], transparency = 1, start_angle, end_angle, radius, width, edge_type_start = 0, edge_type_final = 0, divisors = [], edges = [0], activation_override = true)
{
	return new Advanced_circular_bar(x, y, value, precision, colors, transparency, start_angle, end_angle, radius, width, edge_type_start, edge_type_final, divisors, edges, activation_override);
}

function Advanced_circular_bar(x, y, value, precision, colors, transparency, start_angle, end_angle, radius, width, edge_type_start, edge_type_final, divisors, edges, activation_override) constructor
{
	#region Constructor
	self.x = x;
	self.y = y;
	self.value = value;
	self.precision = precision;
	self.colors = colors;
	self.color = merge_color(colors[0], colors[1], value);
	self.transparency = transparency;
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
	self.surface = noone;
	self.redraw = true;
	self.mask = noone;

	#endregion

	static edge_requires_change =
	[
		true,
		false,
		true,
		true,
		false,
		true,
		true,
		true,
		true,
		true,
		true,
		false,
		false,
		false,
		true,
		true,
		true,
		true,
		true,
		true
	];

	#region Base functions
	static __copy = function(precision_override = self.precision)
	{
		var bar_copy = json_parse(json_stringify(self));
		static_set(bar_copy, static_get(Advanced_circular_bar));
		bar_copy.precision = precision_override;
		return bar_copy;
	}

	static __update = function(refresh_mask = false, active = self.active)
	{
		redraw = active;
		if (refresh_mask && surface_exists(mask)) {surface_free(mask);}
	}

	static __get_sector = function(value = self.value)
	{
		return ceil(value * precision) - (value < ADVANCED_CIRCULAR_BAR_MINIMUM_VISIBLE_VALUE);
	}

	static __set_colors = function(color_start, color_end)
	{
		colors = [color_start, color_end];
		color = merge_color(color_start, color_end, value);
	}

	static __make_border_of = function(bar, border_width)
	{
		radius = bar.radius + border_width;
		width = bar.width + 2 * border_width;

		var border_angle = radtodeg(arctan(border_width / (radius + 2 * border_width)));
		var _start_angle = bar.start_angle, _end_angle = bar.end_angle, angle_diff = _end_angle - _start_angle;
		var is_not_explementary = (angle_diff % 360 != 0);
		var dir = sign(angle_diff);
		start_angle = _start_angle - dir * border_angle * edge_requires_change[edge_type_start] * is_not_explementary;
		end_angle = _end_angle + dir * border_angle * edge_requires_change[edge_type_final] * is_not_explementary;

		divisors = json_parse(json_stringify(bar.divisors));
		var edge_placements = __get_placement_values();
		edges = bar.edges;

		// I hate this
		for (var i = 0; i < array_length(divisors); i++)
		{
			with (divisors[i])
			{
				var edge = 0;

				for (var j = 0; j < array_length(edge_angles); j++)
				{
					edge = other.edges[array_get_index(edge_placements, other.__angle_to_placement_percentage(edge_angles[j])) % array_length(other.edges)];
					edge_angles[j] += border_angle * sign(position - edge_angles[j]) * other.edge_requires_change[edge];
				}

				position = mean(edge_angles[0], edge_angles[1]);
				amplitude = abs(edge_angles[0] - edge_angles[1]);
			}
		}

		__update(true);
	}

	static __get_placement_values = function()
	{
		var placement_values = [];
		var _ = __angle_to_placement_percentage;

		for (var i = 0; i < array_length(divisors); i++)
		{
			array_push(placement_values, _(divisors[i].edge_angles[0]), _(divisors[i].edge_angles[1]));
		}

		array_sort(placement_values, true);
		return placement_values;
	}

	static __angle_to_placement_percentage = function(angle)
	{
		return (angle - start_angle) / (end_angle - start_angle);
	}
	#endregion

	#region Main
	static __draw = function(x = self.x, y = self.y, refresh_mask = false)
	{
		if (__get_sector() < 1 || transparency <= 0) {exit;}

		var side = radius * 2 + 1;

		if (!surface_exists(surface))
		{
			surface = surface_create(side, side);
		}

		surface_set_target(surface);
		__update(refresh_mask);

		if (!redraw)
		{
			__finalise_surface(x, y);
			exit;
		}

		draw_clear_alpha(c_black, 0);

		if (!surface_exists(mask))
		{
			mask = surface_create(side, side);
			__draw_mask(side);
		}

		surface_reset_target();
		surface_set_target(surface);
		__draw_body();

		gpu_set_blendmode(bm_subtract);
		draw_surface(mask, 0, 0);
		gpu_set_blendmode(bm_normal);
		__finalise_surface(x, y);

		color = merge_color(colors[0], colors[1], value);
	}

	static __draw_mask = function(side)
	{
		var temp_surface = surface_create(side, side);
		surface_reset_target();

		surface_set_target(temp_surface);
		__draw_body(min(ADVANCED_CIRCULAR_BAR_QUALITY.LOW, precision), 1);

		if (array_length(divisors) > 0)
		{
			__manage_divisors();
		}

		gpu_set_blendmode(bm_subtract);
		draw_circle(radius, radius, radius - width, false);

		gpu_set_blendmode(bm_normal);
		surface_reset_target();
		surface_set_target(mask);
		draw_clear_alpha(c_black, 1);

		gpu_set_blendmode(bm_subtract);
		draw_surface(temp_surface, 0, 0);
		gpu_set_blendmode(bm_normal);
		surface_free(temp_surface);
	}

	static __draw_body = function(precision_override = self.precision, value_override = self.value)
	{
		__draw_endpoints(__draw_progression(precision_override, value_override));
	}

	static __draw_progression = function(precision_override, value_override = self.value)
	{
		// Only likes this radius somehow
		var _radius = radius + 1, sector_count = __get_sector(value_override), angle;

		draw_primitive_begin(pr_trianglefan);
		draw_vertex(_radius, _radius);

		var angle_diff = end_angle - start_angle;
		var rotation_increment = sign(angle_diff);
		var sector_size = abs(angle_diff) / precision_override;
		var calibrated_start_angle = start_angle - 180;

		for (var i = 0; abs(i) <= sector_count; i += rotation_increment)
		{
			angle = sector_size * i + calibrated_start_angle;
			var _cos = lengthdir_x(radius, angle);
			var _sin = lengthdir_y(radius, angle);
			draw_vertex(_radius - _cos, _radius - _sin);
		}

		draw_primitive_end();
		return angle;
	}

	static __draw_endpoints = function(current_angle)
	{
		__draw_edges([edge_type_final, edge_type_start], [__angle_to_placement_percentage(current_angle + 180), 0]);
	}

	/*static __calculate_extension = function(angle)
	{
		//angle += 360;
		var ew = radius - width / 2;
		var mx = lengthdir_x(ew, angle);
		var my = lengthdir_y(ew, angle);
		var mradius = point_distance(radius, radius, mx, my);
		return min(abs(angle * mradius / width / 180), 1);
	}*/

	static __finalise_surface = function(x = self.x, y = self.y)
	{
		surface_reset_target();
		draw_surface_ext(surface, x - radius, y - radius, 1, 1, rotation, color, transparency);
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
	#endregion

	#region Divisors management
	static __add_divisor = function(divisor)
	{
		array_push(divisors, divisor);
	}

	static __auto_generate_divisors = function(divisor_count, divisor_amplitudes, divisor_edges)
	{
		var angle_diff = end_angle - start_angle;
		var start_index = (angle_diff % 360 != 0);
		divisor_count += start_index;
		edges = divisor_edges;
		divisors = [];

		for (var i = start_index; i < divisor_count; i++)
		{
			var position = angle_diff * i / divisor_count + start_angle;
			var amplitude = divisor_amplitudes[(i - start_index) % array_length(divisor_amplitudes)];
			array_push(divisors, __create_divisor(position, amplitude));
		}
	}

	static __create_divisor = function(position, amplitude)
	{
		var half_amplitude = amplitude / 2;
		return {position, amplitude, edge_angles: [position - half_amplitude, position + half_amplitude]};
	}

	static __manage_divisors = function()
	{
		for (var i = 0; i < array_length(divisors); i++)
		{
			__draw_divisor(divisors[i]);
		}

		gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_src_alpha, bm_dest_alpha);
		__draw_edges();
	}

	static __draw_divisor = function(divisor)
	{
		var variation = (divisor.amplitude >= 180) * 90;
		var angles = divisor.edge_angles;
		var position = divisor.position;
		var len = radius * sqrt(2);

		var t1x1 = radius + lengthdir_x(len, angles[0]);
		var t1y1 = radius + lengthdir_y(len, angles[0]);
		var t2x1 = radius + lengthdir_x(len, angles[1]);
		var t2y1 = radius + lengthdir_y(len, angles[1]);

		var tmx3 = radius + lengthdir_x(len, position);
		var tmy3 = radius + lengthdir_y(len, position);
		var tmx1 = radius + lengthdir_x(len, position - variation);
		var tmy1 = radius + lengthdir_y(len, position - variation);
		var tmx2 = radius + lengthdir_x(len, position + variation);
		var tmy2 = radius + lengthdir_y(len, position + variation);

		gpu_set_blendmode(bm_subtract);
		draw_triangle(radius, radius, t1x1, t1y1, tmx1, tmy1, false);
		draw_triangle(radius, radius, t2x1, t2y1, tmx2, tmy2, false);
		draw_triangle(tmx1, tmy1, tmx2, tmy2, tmx3, tmy3, false);
	}

	static __draw_edges = function(edges_to_draw = edges, placement_values = __get_placement_values())
	{
		var angle_diff = end_angle - start_angle;
		var dir = sign(angle_diff) * 90;
		var direction_values = [dir, -dir];

		for (var i = 0; i < array_length(placement_values); i++)
		{
			__draw_edge(edges_to_draw[i % array_length(edges_to_draw)], placement_values[i] * angle_diff + start_angle, direction_values[i % array_length(direction_values)]);
		}
	}

	static __draw_edge = function(edge, placement, dir, ext = 1)
	{
		var edge_selector =
		[
			function(angle) {__round_edge(angle)},
			function(angle) {__bubbly_edge(angle)},
			function(angle, dir, ext) {__chevron_edge(angle, dir, ext)},
			function(angle, dir, ext) {__rectangle_edge(angle, dir, ext)},
			function(angle, dir, ext) {__diamond_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.TOP)},
			function(angle, dir, ext) {__diamond_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.CENTER)},
			function(angle, dir, ext) {__diamond_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.BOTTOM)},
			function(angle, dir, ext) {__triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.TOP)},
			function(angle, dir, ext) {__triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.CENTER)},
			function(angle, dir, ext) {__triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.BOTTOM)},
			function(angle, dir, ext) {__trapezoid_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.TOP)},
			function(angle, dir, ext) {__trapezoid_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.CENTER)},
			function(angle, dir, ext) {__trapezoid_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.BOTTOM)},
			function(angle, dir, ext) {__rounded_diamond_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.TOP)},
			function(angle, dir, ext) {__rounded_diamond_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.CENTER)},
			function(angle, dir, ext) {__rounded_diamond_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.BOTTOM)},
			function(angle, dir, ext) {__dart_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.TOP)},
			function(angle, dir, ext) {__dart_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.CENTER)},
			function(angle, dir, ext) {__dart_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.BOTTOM)}
		];

		if (edge < 1 || edge > array_length(edge_selector)) {return;}
		edge_selector[edge - 1](placement, dir, ext);
	}
	#endregion

	#region Edges
	static __round_edge = function(angle)
	{
		var hw = width / 2;
		var mid_point = radius - hw;
		var cx = radius + lengthdir_x(mid_point, angle);
		var cy = radius + lengthdir_y(mid_point, angle);

		draw_circle(cx, cy, hw, false);
	}

	static __triangle_edge = function(angle, dir, ext, position)
	{
		var in = radius - width;
		var hw = width / 2;
		var ew = ext * hw;
		var p1x = radius + lengthdir_x(in, angle);
		var p1y = radius + lengthdir_y(in, angle);
		var p2x = radius + lengthdir_x(radius, angle);
		var p2y = radius + lengthdir_y(radius, angle);

		angle += dir;

		var mpx = mean(p1x, p2x);
		var mpy = mean(p1y, p2y);

		var _x = 0, _y = 1;
		var positions = [[p2x, mpx, p1x], [p2y, mpy, p1y]];
		var p3x = lengthdir_x(ew, angle) + positions[_x][position];
		var p3y = lengthdir_y(ew, angle) + positions[_y][position];

		draw_triangle(p1x, p1y, p2x, p2y, p3x, p3y, false);
	}

	static __trapezoid_edge = function(angle, dir, ext, position)
	{
		var in = radius - width;
		var hw = width / 2;
		var ew = ext * hw;
		var p1x = radius + lengthdir_x(in, angle);
		var p1y = radius + lengthdir_y(in, angle);
		var p2x = radius + lengthdir_x(radius, angle);
		var p2y = radius + lengthdir_y(radius, angle);

		angle += dir;

		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var m1x = p1x + xlen / 4;
		var m1y = p1y + ylen / 4;
		var m2x = p2x - xlen / 4;
		var m2y = p2y - ylen / 4;
		var p3x = m1x, p3y = m1y;
		var p4x = m2x, p4y = m2y;

		switch (position)
		{
			default:
			break;

			case ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.TOP:
				m1x = p2x - xlen / 2;
				m1y = p2y - ylen / 2;
				m2x = p2x - xlen / 4;
				m2y = p2y - ylen / 4;
				p3x = p1x + lengthdir_x(ew, angle);
				p3y = p1y + lengthdir_y(ew, angle);
				p4x = m2x + lengthdir_x(ew, angle);
				p4y = m2y + lengthdir_y(ew, angle);
			break;

			case ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.CENTER:
				p3x = m1x + lengthdir_x(ew, angle);
				p3y = m1y + lengthdir_y(ew, angle);
				p4x = m2x + lengthdir_x(ew, angle);
				p4y = m2y + lengthdir_y(ew, angle);
			break;

			case ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.BOTTOM:
				m1x = p1x + xlen / 2;
				m1y = p1y + ylen / 2;
				m2x = p1x + xlen / 4;
				m2y = p1y + ylen / 4;
				p3x = m2x + lengthdir_x(ew, angle);
				p3y = m2y + lengthdir_y(ew, angle);
				p4x = p2x + lengthdir_x(ew, angle);
				p4y = p2y + lengthdir_y(ew, angle);
			break;
		}

		draw_triangle(p1x, p1y, m1x, m1y, p3x, p3y, false);
		draw_triangle(m1x, m1y, p3x, p3y, p4x, p4y, false);
		draw_triangle(m2x, m2y, p4x, p4y, m1x, m1y, false);
		draw_triangle(p2x, p2y, m2x, m2y, p4x, p4y, false);
	}

	static __chevron_edge = function(angle, dir, ext)
	{
		var in = radius - width;
		var hw = width / 2;
		var ew = ext * hw;
		var p1x = radius + lengthdir_x(in, angle);
		var p1y = radius + lengthdir_y(in, angle);
		var p2x = radius + lengthdir_x(radius, angle);
		var p2y = radius + lengthdir_y(radius, angle);

		angle += dir;

		var e1x = p1x + lengthdir_x(ew, angle);
		var e1y = p1y + lengthdir_y(ew, angle);
		var e2x = p2x + lengthdir_x(ew, angle);
		var e2y = p2y + lengthdir_y(ew, angle);

		var mpx = mean(p1x, p2x);
		var mpy = mean(p1y, p2y);
		var p3x = mpx + lengthdir_x(ew / 2, angle);
		var p3y = mpy + lengthdir_y(ew / 2, angle);

		draw_triangle(p1x, p1y, e1x, e1y, p3x, p3y, false);
		draw_triangle(p2x, p2y, e2x, e2y, p3x, p3y, false);
		draw_triangle(p1x, p1y, p2x, p2y, p3x, p3y, false);
	}

	static __bubbly_edge = function(angle)
	{
		var hw = width / 2, qw = hw / 2;
		var p1x = radius + lengthdir_x(radius - qw * 3, angle);
		var p1y = radius + lengthdir_y(radius - qw * 3, angle);
		var p2x = radius + lengthdir_x(radius - qw, angle);
		var p2y = radius + lengthdir_y(radius - qw, angle);
		var mpx = radius + lengthdir_x(radius - hw, angle);
		var mpy = radius + lengthdir_y(radius - hw, angle);

		draw_circle(p1x, p1y, qw, false);
		draw_circle(p2x, p2y, qw, false);
		draw_circle(mpx, mpy, width / 5, false);
	}

	static __rectangle_edge = function(angle, dir, ext)
	{
		var in = radius - width;
		var hw = width / 2;
		var ew = ext * hw;
		var p1x = radius + lengthdir_x(in, angle);
		var p1y = radius + lengthdir_y(in, angle);
		var p2x = radius + lengthdir_x(radius, angle);
		var p2y = radius + lengthdir_y(radius, angle);

		angle += dir;

		var p3x = p1x + lengthdir_x(ew, angle);
		var p3y = p1y + lengthdir_y(ew, angle);
		var p4x = p2x + lengthdir_x(ew, angle);
		var p4y = p2y + lengthdir_y(ew, angle);

		draw_triangle(p1x, p1y, p2x, p2y, p3x, p3y, false);
		draw_triangle(p2x, p2y, p3x, p3y, p4x, p4y, false);
	}

	static __rounded_diamond_edge = function(angle, dir, ext, position)
	{
		// As of now circles can't be stretched
		// If you come up with a solution to make circles (ellipses, basically) stretch
		// correctly in all angles please do contact me on Discord: maximilian.volt
		ext = 1;

		var in = radius - width;
		var qw = width / 4;
		var ew = ext * qw;
		var p1x = radius + lengthdir_x(in, angle);
		var p1y = radius + lengthdir_y(in, angle);
		var p2x = radius + lengthdir_x(radius, angle);
		var p2y = radius + lengthdir_y(radius, angle);

		angle += dir;

		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var bx = mean(p1x, p2x);
		var by = mean(p1y, p2y);
		var v1x = bx, v1y = by;
		var v2x = bx, v2y = by;
		var angle_diff = sign(dir) * 30;

		switch (position)
		{
			default:
			break;

			case ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.TOP:
				p2x -= xlen / 4;
				p2y -= ylen / 4;
				bx = p2x;
				by = p2y;

				angle_diff = dir - radtodeg(arctan(2 * sqrt(2)) * sign(dir));
				v1x = bx + lengthdir_x(ew, angle + angle_diff);
				v1y = by + lengthdir_y(ew, angle + angle_diff);
				v2x = bx;
				v2y = by;
			break;

			case ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.CENTER:
				v1x = bx + lengthdir_x(ew, angle + angle_diff);
				v1y = by + lengthdir_y(ew, angle + angle_diff);
				v2x = bx + lengthdir_x(ew, angle - angle_diff);
				v2y = by + lengthdir_y(ew, angle - angle_diff);
			break;

			case ADVANCED_CIRCULAR_BAR_EDGE_POSITIONS.BOTTOM:
				p1x += xlen / 4;
				p1y += ylen / 4;
				bx = p1x;
				by = p1y;

				angle_diff = dir - radtodeg(arctan(2 * sqrt(2)) * sign(dir));
				v2x = bx + lengthdir_x(ew, angle - angle_diff);
				v2y = by + lengthdir_y(ew, angle - angle_diff);
				v1x = bx;
				v1y = by;
			break;
		}

		draw_triangle(p1x, p1y, bx, by, v1x, v1y, false);
		draw_triangle(p2x, p2y, bx, by, v2x, v2y, false);
		draw_circle(bx, by, qw, false);
	}

	static __diamond_edge = function(angle, dir, ext, position)
	{
		var in = radius - width;
		var qw = width / 4;
		var ew = ext * qw;
		var p1x = radius + lengthdir_x(in, angle);
		var p1y = radius + lengthdir_y(in, angle);
		var p2x = radius + lengthdir_x(radius, angle);
		var p2y = radius + lengthdir_y(radius, angle);

		angle += dir;

		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var m14x = p1x + xlen / 4;
		var m14y = p1y + ylen / 4;
		var mbx = mean(p1x, p2x);
		var mby = mean(p1y, p2y);
		var m34x = p2x - xlen / 4;
		var m34y = p2y - ylen / 4;

		var _x = 0, _y = 1;
		var positions = [[m34x, mbx, m14x], [m34y, mby, m14y]];
		var vx = lengthdir_x(ew, angle) + positions[_x][position];
		var vy = lengthdir_y(ew, angle) + positions[_y][position];

		draw_triangle(p1x, p1y, p2x, p2y, vx, vy, false);
	}

	static __dart_edge = function(angle, dir, ext, position)
	{
		var in = radius - width;
		var qw = width / 4;
		var ew = ext * qw;
		var p1x = radius + lengthdir_x(in, angle);
		var p1y = radius + lengthdir_y(in, angle);
		var p2x = radius + lengthdir_x(radius, angle);
		var p2y = radius + lengthdir_y(radius, angle);

		angle += dir;

		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var m316x = p1x + xlen * 3 / 16;
		var m316y = p1y + ylen * 3 / 16;
		var m616x = p1x + xlen * 3 / 8;
		var m616y = p1y + ylen * 3 / 8;
		var m1016x = p2x - xlen * 3 / 8;
		var m1016y = p2y - ylen * 3 / 8;
		var m1316x = p2x - xlen * 3 / 16;
		var m1316y = p2y - ylen * 3 / 16;

		var _x = 0, _y = 1;
		var positions1 = [[m1016x, m616x, m316x], [m1016y, m616y, m316y]];
		var positions2 = [[m1316x, m1016x, m616x], [m1316y, m1016y, m616y]];
		var b1x = positions1[_x][position];
		var b1y = positions1[_y][position];
		var b2x = positions2[_x][position];
		var b2y = positions2[_y][position];
		var v1x = b1x + lengthdir_x(ew, angle);
		var v1y = b1y + lengthdir_y(ew, angle);
		var v2x = b2x + lengthdir_x(ew, angle);
		var v2y = b2y + lengthdir_y(ew, angle);

		draw_triangle(p1x, p1y, v1x, v1y, b2x, b2y, false);
		draw_triangle(p2x, p2y, v2x, v2y, b1x, b1y, false);
	}
	#endregion
}

// Main
function draw_advanced_circular_bar(bar, x = bar.x, y = bar.y, refresh_mask = false)
{
	bar.__draw(x, y, refresh_mask);
}

function circular_bar_copy(bar, precision = bar.precision)
{
	return bar.__copy(precision);
}

function circular_bar_activate(bar)
{
	bar.active = true;
}

function circular_bar_deactivate(bar)
{
	bar.__draw();
	bar.active = false;
}

function circular_bar_update(bar, refresh_mask = false, deactivate = false)
{
	bar.__update(refresh_mask, deactivate);
}

function circular_bar_get_sector(bar, value = bar.value)
{
	return bar.__get_sector(value);
}

function circular_bar_set_colors(bar, color_start, color_end)
{
	bar.__set_colors(color_start, color_end);
}

function circular_bar_auto_set_divisors(bar, divisor_count, divisor_amplitudes, divisor_edges)
{
	bar.__auto_generate_divisors(divisor_count, divisor_amplitudes, divisor_edges);
	bar.__update(true);
}

function circular_bar_add_divisors(bar, divisors)
{
	for (var i = 0; i < array_length(divisors); i++)
	{
		bar.__add_divisor(divisors[i]);
	}
}

function circular_bar_add_divisor(bar, position, amplitude)
{
	bar.__add_divisor(bar.__create_divisor(position, amplitude));
}

function circular_bar_make_border(border_bar, target_bar, border_width)
{
	border_bar.__make_border_of(target_bar, border_width);
}
#macro ADVANCED_CIRCULAR_BAR_TOP 0
#macro ADVANCED_CIRCULAR_BAR_CENTER 1
#macro ADVANCED_CIRCULAR_BAR_BOTTOM 2

function Advanced_circular_bar(x, y, value = 1, precision = 359, colors = [c_black, c_white], transparency = 1, start_angle, end_angle, radius, width, edge_type_start = 0, edge_type_final = 0, divisors = [], edges = [0]) constructor
{
	#region Constructor
	self.x = x;
	self.y = y;
	self.value = value;
	self.precision = precision;
	set_colors(colors[0], colors[1]);
	self.transparency = transparency;
	self.start_angle = start_angle;
	self.end_angle = end_angle;
	self.radius = radius;
	self.width = width;
	self.edge_type_start = edge_type_start;
	self.edge_type_final = edge_type_final;
	self.surface = -1;
	self.mask = -1;
	self.redraw = true;
	self.rotation = 0;
	self.divisors = divisors;
	self.edges = edges;

	update(true);
	#endregion

	#region Base functions
	static copy = function()
	{
		var bar_copy = json_parse(json_stringify(self));
		static_set(bar_copy, static_get(Advanced_circular_bar));
		return bar_copy;
	}

	static update = function(refresh_mask = false)
	{
		redraw = true;
		if (refresh_mask && surface_exists(mask)) {surface_free(mask);}
	}

	static get_sector = function()
	{
		return ceil(value * precision) - (value < 0.005);
	}

	static set_colors = function(color_start, color_end)
	{
		colors = [color_start, color_end];
		color = merge_color(color_start, color_end, value);
	}

	static make_border_of = function(bar, border_width)
	{
		radius = bar.radius + border_width;
		width = bar.width + 2 * border_width;

		// I hate this
		var edge_requires_change = [true, false, true, true, false, true, true, true, false, false, false, true, true, true];
		var border_angle = radtodeg(arctan(border_width / (radius + 2 * border_width)));
		var _start_angle = bar.start_angle, _end_angle = bar.end_angle;
		var dir = sign(_end_angle - _start_angle);
		start_angle = _start_angle - dir * border_angle * edge_requires_change[edge_type_start];
		end_angle = _end_angle + dir * border_angle * edge_requires_change[edge_type_final];

		var edge_placements = get_placement_values(), edges_size = array_length(edge_placements);

		// I hate this even more
		for (var i = 0; i < array_length(divisors); i++)
		{
			with (divisors[i])
			{
				var edge = 0;

				for (var j = 0; j < array_length(edge_angles); j++)
				{
					for (var k = 0; k < edges_size; k++)
					{
						if (other.__angle_to_placement_percentage(edge_angles[j]) == edge_placements[k])
						{
							edge = other.edges[k % array_length(other.edges)];
							break;
						}
					}

					edge_angles[j] += border_angle * sign(position - edge_angles[j]) * edge_requires_change[edge];
				}

				position = mean(edge_angles[0], edge_angles[1]);
				amplitude = abs(edge_angles[0] - edge_angles[1]);
			}
		}

		update(true);
	}

	static get_placement_values = function()
	{
		var placement_values = [];
		var angle_diff = end_angle - start_angle;

		for (var i = 0; i < array_length(divisors); i++)
		{
			var a1 = divisors[i].edge_angles[0] - start_angle;
			var a2 = divisors[i].edge_angles[1] - start_angle;

			array_push(placement_values, a1 / angle_diff, a2 / angle_diff);
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
		if (get_sector() < 1 || transparency <= 0) {exit;}
		update(refresh_mask);

		var side = radius * 2 + 1;

		if (!surface_exists(surface))
		{
			surface = surface_create(side, side);
			redraw = true;
		}

		surface_set_target(surface);

		if (!redraw)
		{
			__finalise_surface();
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
		redraw = false;
	}

	static __draw_mask = function(side)
	{
		var temp_surface = surface_create(side, side);
		surface_reset_target();

		surface_set_target(temp_surface);
		__draw_body();

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
		draw_surface(temp_surface, 0 ,0);
		gpu_set_blendmode(bm_normal);
		surface_free(temp_surface);
	}

	static __draw_body = function()
	{
		__draw_endpoints(__draw_progression());
	}

	static __draw_progression = function()
	{
		// It doesn't like the normal bar radius for some reason
		var _angle, _radius = radius + 1, sector_count = get_sector();

		draw_set_color(color);
		draw_primitive_begin(pr_trianglefan);
		draw_vertex(_radius, _radius);

		var rotation_direction = sign(end_angle - start_angle) * 90;
		var sector_size = abs(end_angle - start_angle) / precision;
		var increment = rotation_direction / 90, calibrated_start_angle = start_angle - 180;

		for (var i = 0; abs(i) <= sector_count; i += increment)
		{
			_angle = sector_size * i + calibrated_start_angle;
			var _cos = lengthdir_x(radius, _angle);
			var _sin = lengthdir_y(radius, _angle);
			draw_vertex(_radius - _cos, _radius - _sin);
		}

		draw_primitive_end();
		return _angle;
	}

	static __draw_endpoints = function(current_angle)
	{
		//var ext = __calculate_extension(current_angle);
		var rotation_direction = sign(end_angle - start_angle) * 90;
		__draw_edge(edge_type_start, start_angle, -rotation_direction, 1);
		__draw_edge(edge_type_final, current_angle + 180, rotation_direction, 1);
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
		draw_set_color(color);
		draw_set_alpha(transparency);
		draw_surface_ext(surface, x - radius, y - radius, 1, 1, rotation, c_white, transparency);
		draw_set_color(c_white);
		draw_set_alpha(1);
	}
	#endregion

	#region Divisors management
	static add_divisor = function(divisor)
	{
		array_push(divisors, divisor);
		array_sort(divisors, function(d1, d2, angle_diff = end_angle - start_angle)
		{
			return (d1.position - start_angle) / angle_diff - (d2.position - start_angle) / angle_diff;
		});
	}

	static auto_generate_divisors = function(_divisor_count, divisor_amplitudes, divisor_edges)
	{
		var angle_diff = end_angle - start_angle;
		var start_index = (angle_diff % 360 != 0);
		_divisor_count += start_index;
		edges = divisor_edges;
		divisors = [];

		for (var i = start_index; i < _divisor_count; i++)
		{
			var position = angle_diff * i / _divisor_count + start_angle;
			var amplitude = divisor_amplitudes[(i - start_index) % array_length(divisor_amplitudes)];
			array_push(divisors, __create_divisor(position, amplitude));
		}
	}

	static __create_divisor = function(position, amplitude)
	{
		var half_amplitude = amplitude / 2;
		return {position, amplitude, edge_angles: [__adapt_angles(position - half_amplitude), __adapt_angles(position + half_amplitude)]};
	}

	static __adapt_angles = function(angle)
	{
		var angle_diff = end_angle - start_angle;
		return ((angle - start_angle) % angle_diff + angle_diff) % angle_diff + start_angle;
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
		var len = radius * sqrt(2);
		var angles = divisor.edge_angles;
		var v1x = radius + lengthdir_x(len, angles[0]);
		var v1y = radius + lengthdir_y(len, angles[0]);
		var v2x = radius + lengthdir_x(len, angles[1]);
		var v2y = radius + lengthdir_y(len, angles[1]);

		gpu_set_blendmode(bm_subtract);
		draw_triangle(radius, radius, v1x, v1y, v2x, v2y, false);
	}

	static __draw_edges = function(edges_to_draw = edges)
	{
		var angle_diff = end_angle - start_angle;
		var dir = (angle_diff % 360 != 0 ? 90 : -90) * sign(-angle_diff);
		var placement_values = get_placement_values();
		var direction_values = [-dir, dir];

		for (var i = 0; i < array_length(placement_values); i++)
		{
			__draw_edge(edges_to_draw[i % array_length(edges_to_draw)], placement_values[i] * angle_diff + start_angle, direction_values[i % array_length(direction_values)]);
		}
	}

	static __draw_edge = function(edge, placement, dir, ext = 1)
	{
		var edge_selector =
		[
			function(angle) {__round_edge(angle);},
			function(angle) {__bubbly_edge(angle);},
			function(angle, dir, ext) {__chevron_edge(angle, dir, ext);},
			function(angle, dir, ext) {__rectangle_edge(angle, dir, ext);},
			function(angle, dir, ext) {__triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_TOP);},
			function(angle, dir, ext) {__triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_CENTER);},
			function(angle, dir, ext) {__triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_BOTTOM);},
			function(angle, dir, ext) {__trapezoid_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_TOP);},
			function(angle, dir, ext) {__trapezoid_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_CENTER);},
			function(angle, dir, ext) {__trapezoid_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_BOTTOM);},
			function(angle, dir, ext) {__rounded_triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_TOP);},
			function(angle, dir, ext) {__rounded_triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_CENTER);},
			function(angle, dir, ext) {__rounded_triangle_edge(angle, dir, ext, ADVANCED_CIRCULAR_BAR_BOTTOM);}
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

		// Perpendicular progression's angle
		angle = radtodeg(arctan2(p1y - p2y, p2x - p1x)) + dir;

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

		angle = radtodeg(arctan2(p1y - p2y, p2x - p1x)) + dir;

		// Quarter bar width's points
		var xlen = p2x - p1x;
		var ylen = p2y - p1y;
		var m1x = p1x + xlen / 4;
		var m1y = p1y + ylen / 4;
		var m2x = p2x - xlen / 4;
		var m2y = p2y - ylen / 4;
		var p3x = m1x, p3y = m1y;
		var p4x = m2x, p4y = m2y;

		// Trapezoid vertexes
		switch (position)
		{
			default:
			break;

			case ADVANCED_CIRCULAR_BAR_TOP:
				m1x = p2x - xlen / 2;
				m1y = p2y - ylen / 2;
				m2x = p2x - xlen / 4;
				m2y = p2y - ylen / 4;
				p3x = p1x + lengthdir_x(ew, angle);
				p3y = p1y + lengthdir_y(ew, angle);
				p4x = m2x + lengthdir_x(ew, angle);
				p4y = m2y + lengthdir_y(ew, angle);
			break;

			case ADVANCED_CIRCULAR_BAR_CENTER:
				p3x = m1x + lengthdir_x(ew, angle);
				p3y = m1y + lengthdir_y(ew, angle);
				p4x = m2x + lengthdir_x(ew, angle);
				p4y = m2y + lengthdir_y(ew, angle);
			break;

			case ADVANCED_CIRCULAR_BAR_BOTTOM:
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

		angle = radtodeg(arctan2(p1y - p2y, p2x - p1x)) + dir;

		// Edges vertexes
		var e1x = p1x + lengthdir_x(ew, angle);
		var e1y = p1y + lengthdir_y(ew, angle);
		var e2x = p2x + lengthdir_x(ew, angle);
		var e2y = p2y + lengthdir_y(ew, angle);

		// Bar's width middle point
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

		angle = radtodeg(arctan2(p1y - p2y, p2x - p1x)) + dir;

		var p3x = p1x + lengthdir_x(ew, angle);
		var p3y = p1y + lengthdir_y(ew, angle);
		var p4x = p2x + lengthdir_x(ew, angle);
		var p4y = p2y + lengthdir_y(ew, angle);

		draw_triangle(p1x, p1y, p2x, p2y, p3x, p3y, false);
		draw_triangle(p2x, p2y, p3x, p3y, p4x, p4y, false);
	}

	static __rounded_triangle_edge = function(angle, dir, ext, position)
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

		angle = radtodeg(arctan2(p1y - p2y, p2x - p1x)) + dir;

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

			case ADVANCED_CIRCULAR_BAR_TOP:
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

			case ADVANCED_CIRCULAR_BAR_CENTER:
				v1x = bx + lengthdir_x(ew, angle + angle_diff);
				v1y = by + lengthdir_y(ew, angle + angle_diff);
				v2x = bx + lengthdir_x(ew, angle - angle_diff);
				v2y = by + lengthdir_y(ew, angle - angle_diff);
			break;

			case ADVANCED_CIRCULAR_BAR_BOTTOM:
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
	#endregion

	#region Secondary animation tool functions
	static __flash = function(start_color, end_color, color_pulse_duration, start_aplha, end_alhpa, alpha_pulse_duration)
	{
		color = merge_color(start_color, end_color, wave(0, 1, color_pulse_duration));
		transparency = wave(start_aplha, end_alhpa, alpha_pulse_duration);
	}

	static __rotate = function(rotation_variation)
	{
		rotation = clamp((rotation + rotation_variation) % 360, -360, 360);
		var r = radius + 1, r2 = r * sqrt(2), angle = (rotation + 135) % 360;
		return {x: r + lengthdir_x(r2, angle), y: r + lengthdir_y(r2, angle), dir: angle};
	}
	#endregion
}

// Main
function draw_advanced_circular_bar(bar, x = bar.x, y = bar.y, refresh_mask = false)
{
	bar.__draw(x, y, refresh_mask);
}

function copy_circular_bar(bar)
{
	return bar.copy();
}

function update_circular_bar(bar, refresh_mask = false)
{
	bar.update(refresh_mask);
}

function get_circular_bar_sector(bar)
{
	return bar.get_sector();
}

function change_circular_bar_colors(bar, color_start, color_end)
{
	bar.set_colors(color_start, color_end);
}

function auto_set_circular_bar_divisors(bar, divisor_count, divisor_amplitudes, divisor_edges)
{
	bar.auto_generate_divisors(divisor_count, divisor_amplitudes, divisor_edges);
}

function add_circular_bar_divisors(bar, divisors)
{
	for (var i = 0; i < array_length(divisors); i++)
	{
		bar.add_divisor(divisors[i]);
	}
}

function add_circular_bar_divisor(bar, position, amplitude)
{
	var half_amplitude = amplitude / 2;
	bar.add_divisor({position, amplitude, edge_angles: [position - half_amplitude, position + half_amplitude]});
}

function make_circular_bar_border(border_bar, target_bar, border_width)
{
	border_bar.make_border_of(target_bar, border_width);
}
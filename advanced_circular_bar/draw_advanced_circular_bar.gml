#macro TOP 0
#macro CENTER 1
#macro BOTTOM 2

// Constructor
function Advanced_circular_bar(x, y, value = 1, precision = 360, colors = [c_black, c_white], transparency = 1, start_angle, end_angle, radius, width, edge_type_start = 0, edge_type_final = 0, divisor_count = 0, divisor_amplitudes = [0], divisor_edge_types = [edge_type_final]) constructor
{
	self.x = x;
	self.y = y;
	self.value = value;
	self.precision = precision;
	self.colors = [set_color_to_array(colors[0]), set_color_to_array(colors[1])];
	self.color = create_fading(self.colors[0], self.colors[1], value);
	self.transparency = transparency;
	self.start_angle = start_angle;
	self.override_start_angle = start_angle;
	self.end_angle = end_angle;
	self.override_end_angle = end_angle;
	self.radius = radius;
	self.width = width;
	self.edge_type_start = edge_type_start;
	self.edge_type_final = edge_type_final;
	self.divisor_count = divisor_count;
	self.divisor_amplitudes = divisor_amplitudes;
	self.divisor_edge_types = divisor_edge_types;
	self.surface = -1;
	self.mask = -1;
	self.redraw = true;
	self.rotation = 0;

	update_circular_bar(self, true);
}

// Main
function draw_advanced_circular_bar(bar, x = bar.x, y = bar.y, refresh_mask = false)
{
	var sector_count = bar.value * bar.precision;

	// Draws the bar only if necessary
	if (sector_count < 1 || bar.transparency <= 0) {exit;}
	update_circular_bar(bar, refresh_mask);

	var start_angle = bar.start_angle, end_angle = bar.end_angle, r = bar.radius;
	var sector_size = abs(end_angle - start_angle) / bar.precision, side = r * 2 + 1;

	// Canvas preparation
	if (!surface_exists(bar.surface))
	{
		bar.surface = surface_create(side, side);
		bar.redraw = true;
	}

	surface_set_target(bar.surface);
	var rotation = bar.rotation, color = bar.color;

	if (!bar.redraw)
	{
		__circular_bar_finalise_surface(bar.surface, x - r, y - r, rotation, color, bar.transparency);
		exit;
	}

	draw_clear_alpha(c_black, 0);

	if (!surface_exists(bar.mask))
	{
		bar.mask = surface_create(side, side);
		__draw_advanced_circular_bar_mask(bar.mask, bar, bar.override_start_angle, bar.override_end_angle);
	}

	surface_reset_target();
	surface_set_target(bar.surface);
	var len = __circular_bar_progress(color, r, start_angle, end_angle, sector_count, sector_size);
	__circular_bar_place_endpoints(r, start_angle, end_angle, len, bar.edge_type_start, bar.edge_type_final, bar.width);

	gpu_set_blendmode(bm_subtract);
	draw_surface(bar.mask, 0, 0);
	gpu_set_blendmode(bm_normal);
	__circular_bar_finalise_surface(bar.surface, x - r, y - r, rotation, color, bar.transparency);

	bar.color = create_fading(bar.colors[0], bar.colors[1], bar.value);
	bar.redraw = false;
}

// Surface for divisors
function __draw_advanced_circular_bar_mask(maskSurface, bar, override_start_angle, override_end_angle)
{
	var start_angle = bar.start_angle, end_angle = bar.end_angle, r = bar.radius;
	var sector_size = abs(end_angle - start_angle) / bar.precision, side = r * 2 + 1;
	var surface = surface_create(side, side);
	surface_reset_target();

	surface_set_target(surface);
	var color = bar.color;
	var len = __circular_bar_progress(color, r, start_angle, end_angle, bar.precision, sector_size);
	var dir = __circular_bar_place_endpoints(r, start_angle, end_angle, len, bar.edge_type_start, bar.edge_type_final, bar.width);

	if (bar.divisor_count > 0)
	{
		__circular_bar_manage_divisors(r, override_start_angle, override_end_angle, bar.divisor_count, bar.divisor_amplitudes, bar.width, bar.divisor_edge_types, dir);
	}

	if (bar.width < r)
	{
		gpu_set_blendmode(bm_subtract);
		draw_circle(r, r, r - bar.width, false);
	}

	gpu_set_blendmode(bm_normal);
	surface_reset_target();
	surface_set_target(maskSurface);
	draw_clear_alpha(c_black, 1);

	gpu_set_blendmode(bm_subtract);
	draw_surface(surface, 0, 0);
	gpu_set_blendmode(bm_normal);
	surface_free(surface);
}

// Body of the circular bar
function __circular_bar_progress(color, radius, start_angle, end_angle, sector_count, sector_size)
{
	var len;
	radius++;
	sector_count++;
	draw_set_color(color);
	draw_primitive_begin(pr_trianglefan);
	draw_vertex(radius, radius);

	// Direction and progression
	var incr = sign(end_angle - start_angle);
	var outer_radius = radius - 1;
	var _start_angle = start_angle - 180;

	for (var i = 0; abs(i) < sector_count; i += incr)
	{
		len = sector_size * i + _start_angle;
		var _cos = lengthdir_x(outer_radius, len);
		var _sin = lengthdir_y(outer_radius, len);
		draw_vertex(radius - _cos, radius - _sin);
	}

	draw_primitive_end();
	return len;
}

function __circular_bar_place_endpoints(radius, start_angle, end_angle, current_angle, extreme_start, extreme_end, width)
{
	var dir = sign(start_angle - end_angle) * 90;
	var ext = __circular_bar_edgetypes_extension(radius, current_angle - start_angle + 180, width);
	__circular_bar_select_edge(extreme_start, radius, start_angle, width, dir, ext);
	__circular_bar_select_edge(extreme_end, radius, current_angle + 180, width, -dir, ext);
	return dir;
}

function __circular_bar_edgetypes_extension(radius, angle, width)
{
	var hw = width / 2;
	var mx = lengthdir_x(radius - hw, angle);
	var my = lengthdir_y(radius - hw, angle);
	var mradius = sqrt(power(mx, 2) + power(my, 2));

	var percAngle = abs(angle * mradius / width / 180);
	return min(percAngle, 1);
}

function __circular_bar_manage_divisors(radius, start_angle, end_angle, divisor_count, divisor_amplitudes, width, borders, dir)
{
	var divisor_start_index = 0, angle_diff = end_angle - start_angle;

	// Adjusts the divisors and divisors' edges' angles
	if (angle_diff % 360 == 0)
	{
		divisor_count *= abs(angle_diff / 360);
	}
	else
	{
		divisor_start_index++;
		divisor_count++;
		dir = -dir;
	}

	var placement_values = [];
	var direction_values = [dir, -dir];
	gpu_set_blendmode(bm_subtract);

	// Draws the divisors and stores the borders' progression values
	for (var i = divisor_start_index; i < divisor_count; i++)
	{
		var bisector = angle_diff * i / divisor_count + start_angle;
		var half_div_angle = divisor_amplitudes[(i - divisor_start_index) % array_length(divisor_amplitudes)] / 2;
		__circular_bar_draw_divisor(radius, half_div_angle, bisector);

		var angle = __circular_bar_adapt_angles(bisector - half_div_angle, start_angle, end_angle);
		array_push(placement_values, abs((angle - start_angle) / angle_diff));

		angle = __circular_bar_adapt_angles(bisector + half_div_angle, start_angle, end_angle);
		array_push(placement_values, abs((angle - start_angle) / angle_diff));
	}

	array_sort(placement_values, true);

	gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_src_alpha, bm_dest_alpha);

	for (var i = 0; i < array_length(placement_values); i++)
	{
		__circular_bar_select_edge(borders[i % array_length(borders)], radius, placement_values[i] * angle_diff + start_angle, width, direction_values[i % array_length(direction_values)], 1);
	}
}

function __circular_bar_adapt_angles(angle, start_angle, end_angle)
{
	var angle_diff = end_angle - start_angle;
	return ((angle - start_angle) % angle_diff + angle_diff) % angle_diff + start_angle;
}

function __circular_bar_draw_divisor(radius, half_div_angle, placement)
{
	var len = radius * sqrt(2);
	var f1x = radius + lengthdir_x(len, placement + half_div_angle);
	var f1y = radius + lengthdir_y(len, placement + half_div_angle);
	var f2x = radius + lengthdir_x(len, placement - half_div_angle);
	var f2y = radius + lengthdir_y(len, placement - half_div_angle);

	draw_triangle(radius, radius, f1x, f1y, f2x, f2y, false);
}

function __circular_bar_finalise_surface(surf, x, y, rotation, color, transparency)
{
	surface_reset_target();
	draw_set_color(color);
	draw_set_alpha(transparency);
	draw_surface_ext(surf, x, y, 1, 1, rotation, c_white, transparency);
	draw_set_color(c_white);
	draw_set_alpha(1);
}

// To call when initialising a bar or updating it graphically
function make_circular_bar_border(border_bar, target_bar, border_width)
{
	var r = target_bar.radius + border_width, w = target_bar.width + 2 * border_width;
	border_bar.radius = r;
	border_bar.width = w;

	var edge_requires_change = [true, false, true, true, false, true, true, true, false, false, false, true, true, true];
	var border_angle = radtodeg(arctan(border_width / (r + 2 * border_width)));
	var start_angle = target_bar.start_angle, end_angle = target_bar.end_angle;
	var dir = sign(end_angle - start_angle);
	border_bar.start_angle = start_angle - dir * border_angle * edge_requires_change[border_bar.edge_type_start];
	border_bar.end_angle = end_angle + dir * border_angle * edge_requires_change[border_bar.edge_type_final];
	change_circular_bar_override_angles(border_bar, start_angle, end_angle);

	var border_bar_divisor_edges = border_bar.divisor_edge_types, borders_size = array_length(border_bar_divisor_edges);
	var amplitudes_size = array_length(border_bar.divisor_amplitudes), angle_change;

	for (var i = 0; i < amplitudes_size; i++)
	{
		angle_change = edge_requires_change[border_bar_divisor_edges[i % borders_size]];
		border_bar.divisor_amplitudes[i] -= 2 * border_angle * angle_change;
	}
}

// Edge type selector
function __circular_bar_select_edge(type, radius, angle, width, dir, ext)
{
	var positions = [CENTER, BOTTOM, TOP], position = positions[type % array_length(positions)];

	var edge_selector =
	[
		function(radius, angle, width) {__circular_bar_round_edge(radius, angle, width);},
		function(radius, angle, width) {__circular_bar_bubbly_edge(radius, angle, width);},
		function(radius, angle, width, dir, ext) {__circular_bar_chevron_edge(radius, angle, width, dir, ext);},
		function(radius, angle, width, dir, ext) {__circular_bar_rectangle_edge(radius, angle, width, dir, ext);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_triangle_edge(radius, angle, width, dir, ext, position);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_triangle_edge(radius, angle, width, dir, ext, position);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_triangle_edge(radius, angle, width, dir, ext, position);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_trapezoid_edge(radius, angle, width, dir, ext, position);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_trapezoid_edge(radius, angle, width, dir, ext, position);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_trapezoid_edge(radius, angle, width, dir, ext, position);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_rounded_triangle_edge(radius, angle, width, dir, ext, position);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_rounded_triangle_edge(radius, angle, width, dir, ext, position);},
		function(radius, angle, width, dir, ext, position) {__circular_bar_rounded_triangle_edge(radius, angle, width, dir, ext, position);}
	];

	if (type < 1 || type > array_length(edge_selector)) {return;}

	ext = 1; // Decomment to turn off extension calculations and viceversa
	edge_selector[type - 1](radius, angle, width, dir, ext, position);
}

function __circular_bar_round_edge(radius, angle, width)
{
	var hw = width / 2;
	var mid_point = radius - hw;
	var cx = radius + lengthdir_x(mid_point, angle);
	var cy = radius + lengthdir_y(mid_point, angle);

	draw_circle(cx, cy, hw, false);
}

function __circular_bar_triangle_edge(radius, angle, width, dir, ext, position)
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

	// Bar's width middle point
	var mpx = (p1x + p2x) / 2;
	var mpy = (p1y + p2y) / 2;
	var p3x = mpx, p3y = mpy;
	var _x = 0, _y = 1;
	var positions = [[p2x, mpx, p1x], [p2y, mpy, p1y]];

	p3x = lengthdir_x(ew, angle) + positions[_x][position];
	p3y = lengthdir_y(ew, angle) + positions[_y][position];

	draw_triangle(p1x, p1y, p2x, p2y, p3x, p3y, false);
}

function __circular_bar_trapezoid_edge(radius, angle, width, dir, ext, position)
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

		case TOP:
			m1x = p2x - xlen / 2;
			m1y = p2y - ylen / 2;
			m2x = p2x - xlen / 4;
			m2y = p2y - ylen / 4;
			p3x = p1x + lengthdir_x(ew, angle);
			p3y = p1y + lengthdir_y(ew, angle);
			p4x = m2x + lengthdir_x(ew, angle);
			p4y = m2y + lengthdir_y(ew, angle);
		break;

		case CENTER:
			p3x = m1x + lengthdir_x(ew, angle);
			p3y = m1y + lengthdir_y(ew, angle);
			p4x = m2x + lengthdir_x(ew, angle);
			p4y = m2y + lengthdir_y(ew, angle);
		break;

		case BOTTOM:
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

function __circular_bar_chevron_edge(radius, angle, width, dir, ext)
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
	var mpx = (p1x + p2x) / 2;
	var mpy = (p1y + p2y) / 2;
	var p3x = mpx + lengthdir_x(ew / 2, angle);
	var p3y = mpy + lengthdir_y(ew / 2, angle);

	draw_triangle(p1x, p1y, e1x, e1y, p3x, p3y, false);
	draw_triangle(p2x, p2y, e2x, e2y, p3x, p3y, false);
	draw_triangle(p1x, p1y, p2x, p2y, p3x, p3y, false);
}

function __circular_bar_bubbly_edge(radius, angle, width)
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

function __circular_bar_rectangle_edge(radius, angle, width, dir, ext)
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

function __circular_bar_rounded_triangle_edge(radius, angle, width, dir, ext, position)
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
	var bx = (p1x + p2x) / 2;
	var by = (p1y + p2y) / 2;
	var v1x = bx, v1y = by;
	var v2x = bx, v2y = by;
	var angle_diff = sign(dir) * 30;

	switch (position)
	{
		default:
		break;

		case TOP:
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

		case CENTER:
			v1x = bx + lengthdir_x(ew, angle + angle_diff);
			v1y = by + lengthdir_y(ew, angle + angle_diff);
			v2x = bx + lengthdir_x(ew, angle - angle_diff);
			v2y = by + lengthdir_y(ew, angle - angle_diff);
		break;

		case BOTTOM:
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

// Tricks the divisors to be placed in the specified angles range
function change_circular_bar_override_angles(bar, override_start_angle = bar.start_angle, override_end_angle = bar.end_angle)
{
	bar.override_start_angle = override_start_angle;
	bar.override_end_angle = override_end_angle;
}

function change_circular_bar_colors(bar, color_1, color_2)
{
	bar.colors = [set_color_to_array(color_1), set_color_to_array(color_2)];
	bar.color = create_fading(bar.colors[0], bar.colors[1], bar.value);
}

function get_circular_bar_sector(bar, value = bar.value)
{
	return ceil(bar.precision * value);
}

// Returns an actual copy and not the reference
function copy_circular_bar(bar)
{
	var _bar = json_parse(json_stringify(bar));
	static_set(_bar, static_get(Advanced_circular_bar));
	return _bar;
}

// To call exclusively when a graphical update is needed
function update_circular_bar(bar, refresh_mask = false)
{
	bar.redraw = true;
	if (!refresh_mask) {exit;}
	if (surface_exists(bar.mask)) {surface_free(bar.mask);}
}

// Recommended usage when editing colours
function set_color_to_array(color)
{
	return (is_array(color)) ? color : [color_get_red(color), color_get_green(color), color_get_blue(color)];
}

function create_fading(start_color, end_color, perc)
{
	var r = fade(start_color[0], end_color[0], perc);
	var g = fade(start_color[1], end_color[1], perc);
	var b = fade(start_color[2], end_color[2], perc);

	return make_color_rgb(r, g, b);
}

function fade(start_color, end_color, value)
{
	return start_color + (end_color - start_color) * min(value, 1);
}
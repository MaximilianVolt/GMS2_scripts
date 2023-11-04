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
	var sectorcount = bar.value * bar.precision;

	// Draws the bar only if necessary
	if (sectorcount < 1 || bar.transparency <= 0) {exit;}
	update_circular_bar(bar, refresh_mask);

	var sA = bar.start_angle, eA = bar.end_angle, r = bar.radius;
	var sectorSize = abs(eA - sA) / bar.precision, side = r * 2 + 1;

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
	var len = __circular_bar_progress(color, r, sA, eA, sectorcount, sectorSize);
	__circular_bar_place_endpoints(r, sA, eA, len, bar.edge_type_start, bar.edge_type_final, bar.width);

	gpu_set_blendmode(bm_subtract);
	draw_surface(bar.mask, 0, 0);
	gpu_set_blendmode(bm_normal);
	__circular_bar_finalise_surface(bar.surface, x - r, y - r, rotation, color, bar.transparency);

	bar.color = create_fading(bar.colors[0], bar.colors[1], bar.value);
	bar.redraw = false;
}

// Surface for divisors
function __draw_advanced_circular_bar_mask(maskSurface, bar, overrideSa, overrideEa)
{
	var sA = bar.start_angle, eA = bar.end_angle, r = bar.radius;
	var sectorSize = abs(eA - sA) / bar.precision, side = r * 2 + 1;
	var surface = surface_create(side, side);
	surface_reset_target();

	surface_set_target(surface);
	var color = bar.color;
	var len = __circular_bar_progress(color, r, sA, eA, bar.precision, sectorSize);
	var dir = __circular_bar_place_endpoints(r, sA, eA, len, bar.edge_type_start, bar.edge_type_final, bar.width);

	if (bar.divisor_count > 0)
	{
		__circular_bar_manage_divisors(r, overrideSa, overrideEa, bar.divisor_count, bar.divisor_amplitudes, bar.width, bar.divisor_edge_types, dir);
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
function __circular_bar_progress(color, radius, start_angle, end_angle, sectorcount, sectorSize)
{
	var len;
	radius++;
	sectorcount++;
	draw_set_color(color);
	draw_primitive_begin(pr_trianglefan);
	draw_vertex(radius, radius);

	// Direction and progression
	var deltaAngle = abs(end_angle - start_angle);
	var incr = (end_angle - start_angle) / deltaAngle;
	var outerRadius = radius - 1;
	var _start_angle = start_angle - 180;

	for (var i = 0; abs(i) < sectorcount; i += incr)
	{
		len = sectorSize * i + _start_angle;
		var _cos = lengthdir_x(outerRadius, len);
		var _sin = lengthdir_y(outerRadius, len);
		draw_vertex(radius - _cos, radius - _sin);
	}

	draw_primitive_end();
	return len;
}

function __circular_bar_place_endpoints(radius, start_angle, end_angle, currentAngle, extremeStart, extremeEnd, width)
{
	var dir = (end_angle < start_angle) ? 90 : -90;
	var ext = __circular_bar_edgetypes_extension(radius, currentAngle - start_angle + 180, width);
	__circular_bar_select_edge(extremeStart, radius, start_angle, width, dir, ext);
	__circular_bar_select_edge(extremeEnd, radius, currentAngle + 180, width, -dir, ext);
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

function __circular_bar_manage_divisors(radius, start_angle, end_angle, divisorCount, divisorAngles, width, borders, dir)
{
	var divisorStartIndex = 0, deltaAngle = end_angle - start_angle;

	// Adjusts the divisors and divisors' edges' angles
	if (deltaAngle % 360 == 0)
	{
		divisorCount *= abs(deltaAngle / 360);
	}
	else
	{
		divisorStartIndex++;
		divisorCount++;
		dir = -dir;
	}

	var placementValues = [];
	var directionValues = [dir, -dir];
	gpu_set_blendmode(bm_subtract);

	// Draws the divisors and stores the borders' progression values
	for (var i = divisorStartIndex; i < divisorCount; i++)
	{
		var midPlacement = deltaAngle * i / divisorCount + start_angle;
		var halfDivAngle = divisorAngles[(i - divisorStartIndex) % array_length(divisorAngles)] / 2;
		__circular_bar_draw_divisor(radius, halfDivAngle, midPlacement);

		var angle = __circular_bar_adapt_angles(midPlacement - halfDivAngle, start_angle, end_angle);
		array_push(placementValues, abs((angle - start_angle) / deltaAngle));

		angle = __circular_bar_adapt_angles(midPlacement + halfDivAngle, start_angle, end_angle);
		array_push(placementValues, abs((angle - start_angle) / deltaAngle));
	}

	array_sort(placementValues, true);

	gpu_set_blendmode_ext_sepalpha(bm_one, bm_one, bm_src_alpha, bm_dest_alpha);

	for (var i = 0; i < array_length(placementValues); i++)
	{
		__circular_bar_select_edge(borders[i % array_length(borders)], radius, placementValues[i] * deltaAngle + start_angle, width, directionValues[i % array_length(directionValues)], 1);
	}
}

function __circular_bar_adapt_angles(angle, start_angle, end_angle)
{
	var deltaAngle = end_angle - start_angle;
	return ((angle - start_angle) % deltaAngle + deltaAngle) % deltaAngle + start_angle;
}

function __circular_bar_draw_divisor(radius, halfDivAngle, placement)
{
	var len = radius * sqrt(2);
	var f1x = radius + lengthdir_x(len, placement + halfDivAngle);
	var f1y = radius + lengthdir_y(len, placement + halfDivAngle);
	var f2x = radius + lengthdir_x(len, placement - halfDivAngle);
	var f2y = radius + lengthdir_y(len, placement - halfDivAngle);

	draw_triangle(radius, radius, f1x, f1y, f2x, f2y, false);
}

function __circular_bar_finalise_surface(surf, x, y, rot, color, transparency)
{
	surface_reset_target();
	draw_set_color(color);
	draw_set_alpha(transparency);
	draw_surface_ext(surf, x, y, 1, 1, rot, c_white, transparency);
	draw_set_color(c_white);
	draw_set_alpha(1);
}

// To call when initialising a bar or updating it graphically
function make_circular_bar_border(border_bar, target_bar, border_width)
{
	var r = target_bar.radius, w = target_bar.width;
	var r2 = r + border_width, w2 = w + 2 * border_width;
	var border_angle = radtodeg(arctan(border_width / (r2 + 2 * border_width)));
	var hasToChangeAngle = [true, false, true, true, false, true, true, true, false, false, false, true, true, true];

	var sA = target_bar.start_angle, eA = target_bar.end_angle;
	border_bar.radius = r2;
	border_bar.width = w2;
	border_bar.start_angle = sA + ((sA > eA) - (sA < eA)) * border_angle * hasToChangeAngle[border_bar.edge_type_start];
	border_bar.end_angle = eA + ((eA > sA) - (eA < sA)) * border_angle * hasToChangeAngle[border_bar.edge_type_final];
	change_circular_bar_override_angles(border_bar, sA, eA);

	var borderBorders = border_bar.divisor_edge_types, borderSize = array_length(borderBorders);
	var angleSizes = array_length(border_bar.divisor_amplitudes), angleChange;

	for (var i = 0; i < angleSizes; i++)
	{
		angleChange = hasToChangeAngle[borderBorders[i % borderSize]];
		border_bar.divisor_amplitudes[i] -= 2 * border_angle * angleChange;
	}
}

// Edge type selector
function __circular_bar_select_edge(border, radius, angle, width, dir, ext)
{
	var positions = [CENTER, BOTTOM, TOP], position = positions[border % array_length(positions)];

	var drawBorderType =
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
		function(radius, angle, width, dir, ext, position) {__circular_bar_rounded_triangle_edge(radius, angle, width, dir, ext, position);},
	];

	if (border < 1 || border > array_length(drawBorderType)) {return;}

	ext = 1; // Decomment to turn off extension calculations and viceversa
	drawBorderType[border - 1](radius, angle, width, dir, ext, position);
}

function __circular_bar_round_edge(radius, angle, width)
{
	var hw = width / 2;
	var midPlacement = radius - hw;
	var cx = radius + lengthdir_x(midPlacement, angle);
	var cy = radius + lengthdir_y(midPlacement, angle);

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

	// 3rd triangle vertex
	switch (position)
	{
		default:
		break;

		case TOP:
			p3x = p2x + lengthdir_x(ew, angle);
			p3y = p2y + lengthdir_y(ew, angle);
		break;

		case CENTER:
			p3x = mpx + lengthdir_x(ew, angle);
			p3y = mpy + lengthdir_y(ew, angle);
		break;

		case BOTTOM:
			p3x = p1x + lengthdir_x(ew, angle);
			p3y = p1y + lengthdir_y(ew, angle);
		break;
	}

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
			m1x = p1x + xlen / 2;
			m1y = p1y + ylen / 2;
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
	var hw = width / 2;
	var p1x = radius + lengthdir_x(radius - hw * 3 / 2, angle);
	var p1y = radius + lengthdir_y(radius - hw * 3 / 2, angle);
	var p2x = radius + lengthdir_x(radius - hw / 2, angle);
	var p2y = radius + lengthdir_y(radius - hw / 2, angle);
	var mpx = radius + lengthdir_x(radius - hw, angle);
	var mpy = radius + lengthdir_y(radius - hw, angle);

	draw_circle(p1x, p1y, hw / 2, false);
	draw_circle(p2x, p2y, hw / 2, false);
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
	var vx = bx, vy = by;

	switch (position)
	{
		default:
		break;

		case TOP:
			p2x -= xlen / 4;
			p2y -= ylen / 4;
			bx = p2x;
			by = p2y;
			vx = bx + lengthdir_x(ew, angle);
			vy = by + lengthdir_y(ew, angle);
		break;

		case CENTER:
			vx = bx + lengthdir_x(ew, angle);
			vy = by + lengthdir_y(ew, angle);
		break;

		case BOTTOM:
			p1x += xlen / 4;
			p1y += ylen / 4;
			bx = p1x;
			by = p1y;
			vx = bx + lengthdir_x(ew, angle);
			vy = by + lengthdir_y(ew, angle);
		break;
	}

	draw_triangle(p1x, p1y, p2x, p2y, vx, vy, false);
	draw_circle(bx, by, qw, false);
}

// Tricks the divisors to be placed in the specified angles range
function change_circular_bar_override_angles(bar, overrideSa = bar.start_angle, overrideEa = bar.end_angle)
{
	bar.override_start_angle = overrideSa;
	bar.override_end_angle = overrideEa;
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

function create_fading(c1, c2, perc)
{
	var r = fade(c1[0], c2[0], perc);
	var g = fade(c1[1], c2[1], perc);
	var b = fade(c1[2], c2[2], perc);

	return make_color_rgb(r, g, b);
}

function fade(colStart, colEnd, value)
{
	return colStart + (colEnd - colStart) * min(value, 1);
}
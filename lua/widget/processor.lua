require("lua/lib/util")
require("lua/lib/render")
require("lua/settings")

local function degrees_to_radians(degrees)
	return degrees * (math.pi / 180.0)
end

local function vector_angle(vector)
	return math.atan2(vector.y, vector.x)
end

local function vector_length(vector)
	return math.sqrt(vector.x * vector.x + vector.y * vector.y)
end

local function vector_factory(radians, length)
	return { x = length * math.cos(radians), y = length * math.sin(radians) }
end

local function vector_rotate(vector, radians)
	local angle = vector_angle(vector) + radians
	local length = vector_length(vector)

	return vector_factory(radians, length)
end

local function cpu_vector(core, size, angle_delta)
	local tmpl = string.format("${cpu cpu%d}", core + 1)
	local length = (tonumber(conky_parse(tmpl)) / 100) * size
	local angle = core * angle_delta

	return vector_factory(angle, length)
end

function processor_widget(cr, x, y)
	local processor_count = 12
	local size = 200
	local center = { x = x, y = y }
	local angle_delta = degrees_to_radians(360.0 / processor_count)
	local color = hex_to_rgba(0xffffff, 0.8)

	cairo_set_line_width(cr, 1)

	for i = 0, 11, 1 do
		local vector = cpu_vector(i, size, angle_delta)

		if i == 0 then
			cairo_move_to(cr, center.x + vector.x, center.y + vector.y)
		else
			cairo_line_to(cr, center.x + vector.x, center.y + vector.y)
		end
	end

	cairo_close_path(cr)
	cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
	cairo_fill(cr)

	render_ring(cr, center, size, 5, { start = 0, stop = 2 * math.pi }, hex_to_rgba(colors.highlight, 0.8))
end

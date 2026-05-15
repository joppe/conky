function hex_to_rgba(color, alpha)
	local mask = 0x100
	local max = 255
	local red = ((color / 0x10000) % mask) / max
	local green = ((color / 0x100) % mask) / max
	local blue = (color % mask) / max

	return { r = red, g = green, b = blue, a = alpha }
end

function degrees_to_radians(degrees)
	local radians = degrees * (2 * math.pi / 360) - math.pi / 2

	return radians
end

function calc_percent(value, max)
	local pct = value / max

	return pct
end

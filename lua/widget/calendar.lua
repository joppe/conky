require("lua/lib/render")

local json = require("lua/lib/json")
local cache = {}
local update_interval = 60 * 60

local function load_events()
	local file = io.popen("node ./node/calendar.js")
	local output = file:read("*a")

	file:close()

	local data = json.decode(output)

	return data.events
end

local function get_events(updates)
	if next(cache) == nil or updates % update_interval == 0 then
		cache = load_events()
	end

	return cache
end

function calendar_widget(cr, updates, x, y)
	local configs = {
		{
			font = fonts.normal,
			size = 18,
			color = hex_to_rgba(colors.highlight, 0.8),
		},
		{
			font = fonts.normal,
			size = 18,
			color = hex_to_rgba(colors.normal, 0.8),
		},
	}
	local events = get_events(updates)
	local rows = {}

	for _, value in pairs(events) do
		table.insert(rows, { value.start, value.summary })
	end

	render_table(cr, rows, configs, { x = x, y = y }, { x = 15, y = 15 })
end

require("lua/settings")
require("lua/lib/render")

function system_widget(cr, x, y)
	local ram = "󰘚"
	local cpu = ""
	local disk = "󰋊"
	local temp = ""
	local kernel = ""

	local texts = {
		{ cpu, conky_parse("${cpu cpu0}%") },
		{ ram, conky_parse("${memperc}% of ${memmax}") },
		{ disk, conky_parse("${fs_used_perc /}% of ${fs_size}") },
		{ temp, conky_parse("${exec sensors | grep 'Package id' | awk '{print $4}'}") },
		{ kernel, conky_parse("${kernel}") },
	}

	local configs = {
		{
			font = fonts.icon,
			size = 18,
			color = hex_to_rgba(colors.highlight, 0.8),
		},
		{
			font = fonts.normal,
			size = 18,
			color = hex_to_rgba(colors.normal, 0.8),
		},
	}

	render_table(cr, texts, configs, { x = x, y = y }, { x = 15, y = 15 })
end

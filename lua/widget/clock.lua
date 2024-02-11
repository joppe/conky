require("lua/lib/conky")
require("lua/settings")

function clock_widget(cr, x, y)
	local text = {
		hours = {
			size = 38,
			font = fonts.normal,
			data = {
				prop = "time",
				arg = "%H",
				value = nil,
			},
			position = {
				x = x + 40,
				y = y + 110,
			},
			foreground = {
				color = colors.normal,
				alpha = 0.8,
			},
		},
		minutes = {
			size = 38,
			font = fonts.normal,
			data = {
				prop = "time",
				arg = "%M",
				value = nil,
			},
			position = {
				x = x + 100,
				y = y + 110,
			},
			foreground = {
				color = colors.highlight,
				alpha = 0.8,
			},
		},
	}
	local rings = {
		hours = {
			radius = 95,
			thickness = 5,
			data = {
				prop = "time",
				arg = "%H",
				max = 24,
			},
			center = {
				x = x + 95,
				y = y + 95,
			},
			foreground = {
				color = colors.highlight,
				alpha = 0.8,
			},
			background = {
				color = colors.background,
				alpha = 0.8,
			},
			angle = {
				start = 0,
				stop = 360,
			},
		},
		minutes = {
			radius = 85,
			thickness = 5,
			data = {
				prop = "time",
				arg = "%M",
				max = 60,
			},
			center = {
				x = x + 95,
				y = y + 95,
			},
			foreground = {
				color = colors.highlight,
				alpha = 0.8,
			},
			background = {
				color = colors.background,
				alpha = 0.8,
			},
			angle = {
				start = 0,
				stop = 360,
			},
		},
		seconds = {
			radius = 75,
			thickness = 5,
			data = {
				prop = "time",
				arg = "%S",
				max = 60,
			},
			center = {
				x = x + 95,
				y = y + 95,
			},
			foreground = {
				color = colors.highlight,
				alpha = 0.8,
			},
			background = {
				color = colors.background,
				alpha = 0.8,
			},
			angle = {
				start = 0,
				stop = 360,
			},
		},
	}

	text.hours.data.value = os.date(text.hours.data.arg)
	text.minutes.data.value = os.date(text.minutes.data.arg)

	setup_rings(cr, rings)
	setup_texts(cr, text)
end

require("lua/lib/conky")
require("lua/settings")

function date_widget(cr, x, y)
	local text = {
		day = {
			size = 42,
			font = fonts.normal,
			data = {
				prop = "time",
				arg = "%A",
				value = nil,
			},
			position = {
				x = x,
				y = y,
			},
			foreground = {
				color = colors.normal,
				alpha = 0.8,
			},
		},
		date = {
			size = 50,
			font = fonts.normal,
			data = {
				prop = "time",
				arg = "%d",
				value = nil,
			},
			position = {
				x = x,
				y = y + 55,
			},
			foreground = {
				color = colors.highlight,
				alpha = 0.8,
			},
		},
		month = {
			size = 22,
			font = fonts.normal,
			data = {
				prop = "time",
				arg = "%B",
				value = nil,
			},
			position = {
				x = x,
				y = y + 110,
			},
			foreground = {
				color = colors.normal,
				alpha = 0.8,
			},
		},
		year = {
			size = 22,
			font = fonts.normal,
			data = {
				prop = "time",
				arg = "%G",
				value = nil,
			},
			position = {
				x = x,
				y = y + 140,
			},
			foreground = {
				color = colors.highlight,
				alpha = 0.8,
			},
		},
	}
	text.day.data.value = os.date(text.day.data.arg)
	text.date.data.value = os.date(text.date.data.arg)
	text.month.data.value = os.date(text.month.data.arg)
	text.year.data.value = os.date(text.year.data.arg)

	setup_texts(cr, text)
end

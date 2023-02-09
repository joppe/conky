require 'lua/conky'
require 'lua/settings'

function clock_widget(cr)
    local text = {
        hours = {
            size = 38,
            font = fonts.normal,
            data = {
                prop = 'time',
                arg = '%H',
                value = nil
            },
            position = {
                x = 1622,
                y = 186
            },
            foreground = {
                color = colors.normal,
                alpha = 0.8
            }
        },
        minutes = {
            size = 38,
            font = fonts.normal,
            data = {
                prop = 'time',
                arg = '%M',
                value = nil
            },
            position = {
                x = 1684,
                y = 186
            },
            foreground = {
                color = colors.highlight,
                alpha = 0.8
            }
        }
    }
    local rings = {
        hours = {
            radius = 95,
            thickness = 5,
            data = {
                prop = 'time',
                arg = '%H',
                max = 24
            },
            center = {
                x = 1675,
                y = 175
            },
            foreground = {
                color = colors.highlight,
                alpha = 0.8
            },
            background = {
                color = colors.background,
                alpha = 0.8
            },
            angle = {
                start = 0,
                stop = 360
            }
        },
        minutes = {
            radius = 85,
            thickness = 5,
            data = {
                prop = 'time',
                arg = '%M',
                max = 60
            },
            center = {
                x = 1675,
                y = 175
            },
            foreground = {
                color = colors.highlight,
                alpha = 0.8
            },
            background = {
                color = colors.background,
                alpha = 0.8
            },
            angle = {
                start = 0,
                stop = 360
            }
        },
        seconds = {
            radius = 75,
            thickness = 5,
            data = {
                prop = 'time',
                arg = '%S',
                max = 60
            },
            center = {
                x = 1675,
                y = 175
            },
            foreground = {
                color = colors.highlight,
                alpha = 0.8
            },
            background = {
                color = colors.background,
                alpha = 0.8
            },
            angle = {
                start = 0,
                stop = 360
            }
        },
    }

    text.hours.data.value = os.date(text.hours.data.arg)
    text.minutes.data.value = os.date(text.minutes.data.arg)

    setup_rings(cr, rings)
    setup_texts(cr, text)
end


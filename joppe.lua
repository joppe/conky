require 'lua/conky'

local colors = {
    highlight = 0x34cdff,
    normal = 0xffffff,
    background = 0x3b3b3b
}
local fonts = {
    normal = 'ProFontIIx Nerd Font Mono'
}

local function clock_widget(cr)
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
                y = 184
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
                y = 184
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

    text.hours.data.value = os.date("%H")
    text.minutes.data.value = os.date ("%M")

    setup_rings(cr, rings)
    setup_texts(cr, text)
end

function conky_main()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )
    local cr = cairo_create(cs)


    local updates = conky_parse('${updates}')
    local update_num = tonumber(updates)

    if update_num > 5 then
        clock_widget(cr)
    end
    
    cairo_destroy(cr)
    cairo_surface_destroy(cs)

    cr = nil
end

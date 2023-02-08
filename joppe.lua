require 'lua/conky'

local function clock_widget(cr)
    local config = {
        hour = {
            radius = 80,
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
                color = 0x34cdff,
                alpha = 0.8
            },
            background = {
                color = 0x3b3b3b,
                alpha = 0.8
            },
            angle = {
                start = 0,
                stop = 360
            }
        },
        minutes = {
            radius = 70,
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
                color = 0x34cdff,
                alpha = 0.8
            },
            background = {
                color = 0x3b3b3b,
                alpha = 0.8
            },
            angle = {
                start = 0,
                stop = 360
            }
        },
        seconds = {
            radius = 60,
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
                color = 0x34cdff,
                alpha = 0.8
            },
            background = {
                color = 0x3b3b3b,
                alpha = 0.8
            },
            angle = {
                start = 0,
                stop = 360
            }
        },
    }

    setup_rings(cr, config)
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
        render_text(cr, '08:23', 26, { x = 100, y = 100 }, hex_to_rgba(0xffffff, 0.8))
    end
    
    cairo_destroy(cr)
    cairo_surface_destroy(cs)

    cr = nil
end

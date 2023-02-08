require 'cairo'

local function hex_to_rgba(color, alpha)
    local mask = 0x100
    local max = 255
    local red = ((color / 0x10000) % mask) / max
    local green = ((color / 0x100) % mask) / max
    local blue = (color % mask) / max

    return {r = red, g = green, b = blue, a = alpha}
end

local function render_ring(cr, center_x, center_y, radius, thickness, angle_start, angle_end, color)
    cairo_new_sub_path(cr)
    cairo_arc(
        cr,
        center_x,
        center_y,
        radius,
        angle_start,
        angle_end
    )

    cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
    cairo_set_line_width(cr, thickness)
    cairo_stroke(cr)
    cairo_close_path(cr)
end

local function render_text(cr, text, position, color)
    cairo_select_font_face(
        cr,
        'ProFontIIx Nerd Font Mono',
        CAIRO_FONT_SLANT_NORMAL,
        CAIRO_FONT_WEIGHT_NORMAL
    )
    cairo_set_font_size(cr, 24)
    cairo_set_source_rgba(
        cr,
        color.r,
        color.g,
        color.b,
        color.a
    )
    cairo_move_to(cr, position['x'], position['y'])
    cairo_show_text(cr, text)
    cairo_stroke(cr)
end

local function degrees_to_radians(degrees)
    local radians = degrees * (2 * math.pi / 360) - math.pi / 2

    return radians
end

local function setup_ring(cr, value, config)
    local angle_start = degrees_to_radians(config['angle']['start'])
    local angle_max = degrees_to_radians(config['angle']['stop'])
    local angle_end = value * (angle_max - angle_start) + angle_start

    render_ring(
        cr,
        config['center']['x'],
        config['center']['y'],
        config['radius'],
        config['thickness'],
        angle_start,
        angle_max,
        hex_to_rgba(config['background']['color'], config['background']['alpha'])
    )
    render_ring(
        cr,
        config['center']['x'],
        config['center']['y'],
        config['radius'],
        config['thickness'],
        angle_start,
        angle_end,
        hex_to_rgba(config['foreground']['color'], config['foreground']['alpha'])
    )
end

local function calc_percent(prop, arg, max)
    local tmpl = string.format('${%s %s}', prop, arg)
    local str = conky_parse(tmpl)
    local value = tonumber(str)
    local pct = value / max

    return pct
end

local function clock_rings(cr)
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

    for key, part in pairs(config) do
        local percent = calc_percent(
            part['data']['prop'],
            part['data']['arg'],
            part['data']['max']
        )

        setup_ring(cr, percent, part)
    end
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
        clock_rings(cr)
        --render_text(cr, '08:23', hex_to_rgba(0xffffff, 0.8))
    end
    
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end

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

local function draw_ring(cr,t,pt)
    local angle_0 = pt['angle']['start'] * (2 * math.pi / 360) - math.pi / 2
    local angle_f = pt['angle']['stop'] * ( 2 * math.pi / 360) - math.pi / 2
    local t_arc= t * (angle_f - angle_0)

    render_ring(
        cr,
        pt['center']['x'],
        pt['center']['y'],
        pt['radius'],
        pt['thickness'],
        angle_0,
        angle_f,
        hex_to_rgba(pt['background']['color'], pt['background']['alpha'])
    )
    render_ring(
        cr,
        pt['center']['x'],
        pt['center']['y'],
        pt['radius'],
        pt['thickness'],
        angle_0,
        angle_0 + t_arc,
        hex_to_rgba(pt['foreground']['color'], pt['foreground']['alpha'])
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

    for key, value in pairs(config) do
        local pct = calc_percent(
            value['data']['prop'],
            value['data']['arg'],
            value['data']['max']
        )

        draw_ring(cr, pct, value)
    end
end

local function render_text(cr, text, color)
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
    cairo_move_to(cr, 80, 160)
    cairo_show_text(cr, text)
    cairo_stroke(cr)
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
        --clock_rings(cr)
        render_text(cr, '08:23', hex_to_rgba(0xffffff, 0.8))
    end
    
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end

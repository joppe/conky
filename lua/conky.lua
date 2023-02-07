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
end

local function draw_ring(cr,t,pt)
    local angle_0 = pt['start_angle'] * (2 * math.pi / 360) - math.pi / 2
    local angle_f = pt['end_angle'] * ( 2 * math.pi / 360) - math.pi / 2
    local t_arc= t * (angle_f - angle_0)

    render_ring(cr, pt['x'], pt['y'], pt['radius'], pt['thickness'], angle_0, angle_f, hex_to_rgba(pt['bg_color'], pt['bg_alpha']))
    render_ring(cr, pt['x'], pt['y'], pt['radius'], pt['thickness'], angle_0, angle_0 + t_arc, hex_to_rgba(pt['fg_color'], pt['fg_alpha']))
end

function conky_main()
   local t = {
        name='time',
        arg='%S',
        max=60,
        bg_color=0x3b3b3b,
        bg_alpha=0.8,
        fg_color=0x34cdff,
        fg_alpha=0.8,
        x=1530,
        y=410,
        radius=30,
        thickness=12,
        start_angle=0,
        end_angle=240
    }

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
        local tmpl = string.format('${%s %s}', t['name'], t['arg'])
        local str = conky_parse(tmpl)
        local value = tonumber(str)
        local pct = value / t['max']

        draw_ring(cr, pct, t)
    end
    
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end

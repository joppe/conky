require 'cairo'

function render_ring(cr, center_x, center_y, radius, thickness, angle_start, angle_end, color)
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

function render_text(cr, text, size, position, color)
    cairo_select_font_face(
        cr,
        'ProFontIIx Nerd Font Mono',
        CAIRO_FONT_SLANT_NORMAL,
        CAIRO_FONT_WEIGHT_NORMAL
    )
    cairo_set_font_size(cr, size)
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

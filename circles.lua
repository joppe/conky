require 'cairo'

function hello(cr)
    print('foo')
    font="Arial"
    font_size=12
    text="hello world"
    xpos=100
    ypos=100
    red=1
    green=1
    blue=1
    alpha=1
    font_slant=CAIRO_FONT_SLANT_NORMAL
    font_face=CAIRO_FONT_WEIGHT_NORMAL
    ----------------------------------
    cairo_select_font_face(cr, font, font_slant, font_face);
    cairo_set_font_size(cr, font_size)
    cairo_set_source_rgba(cr, red, green, blue, alpha)
    cairo_move_to(cr, xpos, ypos)
    cairo_show_text(cr, text)
    cairo_stroke(cr)
end

function conky_main()
    if conky_window == nil then
        return
    end
    
    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)
    
    local updates=tonumber(conky_parse('${updates}'))
    
    if updates>5 then
        print('hello??')
        hello(cr)
    end

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

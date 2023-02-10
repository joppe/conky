require 'lua/widget/clock'
require 'lua/widget/date'
require 'lua/widget/system'
require 'lua/lib/render'

function show_logo()
    render_image(
        '/mnt/extra/work/joppe/conky/img/pop-os.png',
        { x = 400, y = 400 },
        { width = 200, height = 200 }
    )
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


    local updates = tonumber(conky_parse('${updates}'))

    if updates > 5 then
        clock_widget(cr)
        date_widget(cr)
        system_widget(cr)
        show_logo()
--        calendar_widget(cr, updates)
    end

    cairo_destroy(cr)
    cairo_surface_destroy(cs)

    cr = nil
end

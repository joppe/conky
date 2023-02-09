require 'lua/clock'
require 'lua/date'

local function calendar_widget(cr)
    local file = io.popen('node ./node/calendar.js')
    local output = file:read('*a')

    file:close()
    print(output)
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
        date_widget(cr)
        calendar_widget(cr)
    end
    
    cairo_destroy(cr)
    cairo_surface_destroy(cs)

    cr = nil
end

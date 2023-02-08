require 'lua/util'
require 'lua/render'

local function get_value(prop, arg)
    local tmpl = string.format(
        '${%s %s}',
        prop,
        arg
    )
    local str = conky_parse(tmpl)
    local value = tonumber(str)

    return value
end

function setup_ring(cr, value, config)
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
        hex_to_rgba(
            config['background']['color'],
            config['background']['alpha']
        )
    )
    render_ring(
        cr,
        config['center']['x'],
        config['center']['y'],
        config['radius'],
        config['thickness'],
        angle_start,
        angle_end,
        hex_to_rgba(
            config['foreground']['color'],
            config['foreground']['alpha']
        )
    )
end

function setup_rings(cr, configs)
    for key, config in pairs(configs) do
        local percent = calc_percent(
            get_value(
                config['data']['prop'],
                config['data']['arg']
            ),
            config['data']['max']
        )

        setup_ring(cr, percent, config)
    end
end

function setup_text(cr, config)
    local text = get_value(
        config['data']['prop'],
        config['data']['arg']
    )

    render_text(
        cr,
        text,
        config.size,
        config.position,
        hex_to_rgba(
            config['foreground']['color'],
            config['foreground']['alpha']
        )
    )
end

function setup_texts(cr, configs)
    for key, config in pairs(configs) do
       setup_text(cr, config)
    end
end


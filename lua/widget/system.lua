require 'lua/settings'
require 'lua/lib/render'

local function render_table(cr, texts, font, size, position, color, gap)
    local new_position = { x = position.x, y = position.y }

    for i in pairs(texts) do
        local row = texts[i]
        local dimensions = { width = 0, height = 0 }

        for j in pairs(row) do
            local column = row[j]

            dimensions = render_text(
                cr,
                column,
                font,
                size,
                new_position,
                color
            )

            new_position.x = new_position.x + dimensions.width + gap.x
        end

        new_position.x = position.x
        new_position.y = new_position.y + dimensions.height + gap.y
    end
end

function system_widget(cr)
    local config = {
        size = 18,
        font = fonts.normal,
        position = {
            x = 100,
            y = 186
        },
        highlight = {
            text = 'System',
            color = colors.highlight,
            alpha = 0.8
        },
        normal = {
            text = 'Pop!_OS 22.04 LTS x86_64',
            color = colors.normal,
            alpha = 0.8
        }
    }

    --render_duotone_text(
    --    cr,
    --    config.highlight,
    --    config.normal,
    --    config.font,
    --    config.size,
    --    config.position,
    --    15
    --)


    local texts = {
        {'2022-02-08', '09:00', 'JSWorld'},
        {'2022-02-10', '18:30', 'Zocht S6E01'},
        {'2022-02-12', '00:00', 'Eline jarig'},
    }
    render_table(
        cr,
        texts,
        config.font,
        config.size,
        config.position,
        hex_to_rgba(
            config.normal.color,
            config.normal.alpha
        ),
        { x = 15, y = 15 }
    )
end


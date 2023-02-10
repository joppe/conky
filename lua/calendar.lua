local json = require 'lua/json'
local cache = {}
local update_interval = 60

local function load_events()
    local file = io.popen('node ./node/calendar.js')
    local output = file:read('*a')

    file:close()

    local data = json.decode(output)

    return data.events
end

local function get_events(updates)
    if updates % update_interval == 0 then
        cache = load_events()
    end

   return cache
end

function calendar_widget(cr, updates)
    local events = get_events(updates)

    for key, value in pairs(events) do
       print(value.summary)
    end
end

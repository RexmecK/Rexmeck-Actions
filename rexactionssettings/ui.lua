main = {}

function main:init()
    local checkboxes = config.getParameter("checkboxes", {})
    for i,v in pairs(checkboxes) do
        widget.setChecked(v, player.getProperty("rexactions_"..v) or false)
        buttons[v] = function() player.setProperty("rexactions_"..v, widget.getChecked(v)) end
    end
end

function main:update(dt)

end

function main:uninit()

end

buttons = {}

function main:callback(widgetname)
    if buttons[widgetname] then
        buttons[widgetname]()
    end
end
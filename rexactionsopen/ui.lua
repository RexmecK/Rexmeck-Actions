function init()
    if not player.isLounging() then
        world.sendEntityMessage(player.id(), "rexactions.open")
    end
    pane.dismiss()
end
local oldUpdate = update or function() end

local monsterId = config.getParameter("parameters", {}).monsterId or 0

function callback(index, element, parameters)
	world.sendEntityMessage(player.id(), "rexactions.play", index)
end

function update(dt)
	if monsterId and world.entityExists(monsterId) then
		world.callScriptedEntity(monsterId, "blockInteractions")
	end
	oldUpdate(dt)
end
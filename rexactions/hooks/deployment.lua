local oldInit = init or function() end
local oldUpdate = update or function() end

require "/scripts/vec2.lua"

local playerId = 1
local playerFacing = 1
local playerPosition = {0,0}

local monsterId

require "/rexactions/spawner/action.lua"
local function action(index, facing)
	if not index then return false end
	if player.isLounging() then return false end

	local indexes = root.assetJson("/rexactions/actions/actions.json", {})
	local ac = indexes[index]
	if ac then
		local actionpath = "/"
		if type(ac) == "table" then
			actionpath = ac.directory or "/rexactions/actions/"..ac.name.."/"
		elseif type(ac) == "string" then
			actionpath = "/rexactions/actions/"..ac.."/"
		end

		if var == name then
			local vehicleid = rexaction(world.entityPosition(player.id()), actionpath, facing)
			world.callScriptedEntity(vehicleid, "mcontroller.setVelocity", world.entityVelocity(playerId) or {0,0})
			player.lounge(vehicleid)
			return true
		end

	end
	return false
end

require "/RApieMenu/api.lua"
function init(...)
	message.setHandler("rexactions.open", 
		function(_, loc) if not loc then return end 
			local list = root.assetJson("/rexactions/actions/actions.json")
			local newPie = pieMenu(list, "/rexactions/hooks/piecallback.lua", {monsterId = monsterId})
			newPie:open()
		end
	)

	message.setHandler("rexactions.play", 
		function(_, loc, index) if not loc then return end 
			local list = root.assetJson("/rexactions/actions/actions.json")
			if index and list[index] then
				local t = type(list[index])
				if t == "string" then
					action(index, playerFacing)
				elseif t == "table" then
					action(index, playerFacing)
				end
			end
		end
	)

	local result, ret = pcall(oldInit, ...)
	if not result then
		sb.logError(tostring(ret))
		oldInit = function() end
	end
end

local function respawnMonster()
	local conf = root.assetJson("/rexactions/hooks/monsterConfig.json")
	conf.ownerId = entity.id()
	monsterId = world.spawnMonster("mechshielddrone", playerPosition, conf)
	return 
end

local function updateMonster()
	world.callScriptedEntity(monsterId, "mcontroller.setPosition", vec2.add(playerPosition, {0,-0.5}))
	if player.isLounging() then
		world.callScriptedEntity(monsterId, "blockInteractions")
	end
end

function update(...)
	playerId = player.id()

	if playerId and world.entityExists(playerId) then
		playerPosition = world.entityPosition(playerId)
		local playerVel = world.entityVelocity(playerId) or {0,0}
		if playerVel[1] > 0.0 then
			playerFacing = 1
		elseif playerVel[1] < 0.0 then
			playerFacing = -1
		end
	end

	if type(monsterId) == "nil" then
		respawnMonster()
	else --resume if we have our monster
		if monsterId and world.entityExists(monsterId) then
			updateMonster()
		elseif monsterId then
			monsterId = nil
		end
	end

	local result, ret = pcall(oldUpdate, ...)
	if not result then
		sb.logError(tostring(ret))
		oldUpdate = function() end
	end
end


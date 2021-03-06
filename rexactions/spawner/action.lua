function rexaction(position, path, facing)
	local baseConfig = root.assetJson("/rexactions/base/controller/main.customvehicle")
	local result, actionConfig = pcall(root.assetJson, path.."action.config")
	if result then
		local customvehicleConfig = sb.jsonMerge(baseConfig, actionConfig)
		
		customvehicleConfig.directory = path or "/"
		customvehicleConfig.facing = facing or 1
		
		return world.spawnVehicle(customvehicleConfig.name, position, customvehicleConfig)
	else
		sb.logError(tostring(actionConfig))
	end
	return 0
end
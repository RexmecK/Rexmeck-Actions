function rexaction(position, path, facing)
	local baseConfig = root.assetJson("/rexactions/base/controller/main.customvehicle")
	local customvehicleConfig = sb.jsonMerge(baseConfig, root.assetJson(path.."action.config"))

	customvehicleConfig.directory = path or "/"
	customvehicleConfig.facing = facing or 1
	
	return world.spawnVehicle(customvehicleConfig.name, position, customvehicleConfig)
end
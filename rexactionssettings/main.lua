modPath = "/rexactionssettings/"
includePath = modPath.."scripts/"

_included = {}
function include(util)
	if not _included[includePath..util..".lua"] then
		require(includePath..util..".lua")
		_included[includePath..util..".lua"] = true
	end
end

function system(name)
	require(directory(name, modPath.."systems/", ".lua"))
end

function init()
	include "config" --needed to load certain configs
	include "directory" 

	init = function()
		if main and main.init then
			main:init()
		end
	end

	system(config.system or "default")

	init()
end

update_lastInfo = {}
update_info = {}
update_lateInited = false

function update(...)
	update_lastInfo = update_info
	update_info = {...}
	if not update_lateInited and main and main.lateInit then
		update_lateInited = true
		main:lateInit(...)
	end
	if main and main.update then
		main:update(...)
	end
end

function activate(...)
	if main and main.activate then
		main:activate(...)
	end
end

function uninit()
	if main and main.uninit then
		main:uninit()
	end
end

function createTooltip(...)
	if main and main.createTooltip then
		main:createTooltip(...)
	end
end

function callback(...)
	if main and main.callback then
		main:callback(...)
	end
end
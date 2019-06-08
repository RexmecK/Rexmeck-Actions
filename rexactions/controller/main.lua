modPath = "/rexactions/"
corePath = modPath.."controller/"
includePath = corePath.."includes/"

_included = {}
function include(util)
	require(includePath..util..".lua")
	_included[includePath..util..".lua"] = true
end

function init()
	include "configInstance" --needed to load certain configs
	configInstance:init()

	if configInstance.mode then
		require(corePath.."systems/"..configInstance.mode..".lua")
	else
		require(corePath.."systems/edit.lua")
	end

	if main and main.init then
		main:init()
	end
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
	configInstance:uninit()
end
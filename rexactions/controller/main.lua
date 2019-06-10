modPath = "/rexactions/"
corePath = modPath.."controller/"
includePath = corePath.."includes/"

_included = {}
function include(util)
	require(includePath..util..".lua")
	_included[includePath..util..".lua"] = true
end

function init()
	include "config" --needed to load certain configs

	if config.mode then
		require(corePath.."systems/"..config.mode..".lua")
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
end
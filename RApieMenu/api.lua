--[[
	USAGE:

	Element = {text = "text", image = "/ai/ai.png"}

	LuaTable pieMenu(List<Element> list, String callbackScript, [Json parameters])
	
	local newPie = pieMenu(List<Element> list, String callbackScript, [Json parameters])

		ScriptPane newPie.config
			Json newPie.config.parameters
		List<Element> newPie.list
		
		String newPie.callbackScript
			The callbackScript must have this: function callback(Index, Element, parameters) end

		Void newPie:open()

]]


function pieMenu(list, callbackScript, parameters)
	local new = {}
	new.config = root.assetJson("/RApieMenu/ui/main.window")

	new.config.callbackScript = callbackScript
	new.config.list = list or jarray()
	new.config.parameters = parameters or jarray()

	function new:open()
		player.interact("ScriptPane", self.config)
	end

	return new
end
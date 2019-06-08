ownerId = 0
interactive = 0

function init()
	if storage.die then function shouldDie() return true end end
	ownerId = config.getParameter("ownerId")
end

function blockInteractions()
	monster.setInteractive(false)
	interactive = -2
end

function interact(args)
	if args.sourceId and args.sourceId == ownerId and interactive == 1 then
		world.sendEntityMessage(ownerId, "rexactions.open")
		interactive = -2
		monster.setInteractive(false)
	end
end

function update()
	if interactive == 0 then
		monster.setInteractive(true)
		interactive = 1
	elseif interactive < 0 then
		interactive = interactive + 1
	end
end

function uninit()
	storage.die = true
	function shouldDie() return true end
end
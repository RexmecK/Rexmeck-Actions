include "book"

main = {}
main.picked = false

function main:init()
	local callbackScript = config.getParameter("callbackScript")
	if type(callbackScript) == "string" then
		require(callbackScript)
	end
	
	self.list = config.getParameter("list", {})
	self.book = book:new(self.list,10)
	self:initPage()
end

function main:initPage()
	window.pie:add("<<", 
		function()
			window.pie:stylistClear(-1,
				function()
					self.book:previous()
					self:initPage()
				end
			)
		end
	)
	local page = self.book:get()
	for i=1,#page do
		window.pie:add(page[i],
			function()
				if window.pie.clearing then return end
				self:pick(i * self.book:pages())
				self.picked = true
				if i > #page / 2 then
					window.pie:stylistClear(1)
				else
					window.pie:stylistClear(-1)
				end
			end
		)
	end
	window.pie:add(">>", 
		function()
			window.pie:stylistClear(1,
				function()
					self.book:next()
					self:initPage()
				end
			)
		end
	)
end

function main:pick(i)
	if type(callback) == "function" then
		callback(i, self.list[i], config.getParameter("parameters"))
	end
end

function main:update(dt)
	if self.picked and not window.pie.clearing then
		pane.dismiss()
	end
end

function main:uninit()

end


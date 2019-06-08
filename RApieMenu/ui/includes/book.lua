book = {}
book.list = {}
book.per = 5
book.current = 1

function book:new(list, elementperpage)
	local nw = {}
	for i,v in pairs(self) do
		nw[i]=v
	end
	nw.per = elementperpage or 5
	nw.list = list or {}
	return nw
end

function book:next()
	self.current = math.min(self.current + 1, self:pages())
end

function book:previous()
	self.current = math.max(self.current - 1, 1)
end

function book:pages()
	return math.max(math.floor(#self.list / self.per), 1)
end

function book:page()
	return (self.current - 1) * self.per
end

function book:get()
	local offset = self:page()
	local page = {}
	for i=1,self.per do
		page[i] = self.list[offset + i]
	end
	return page
end
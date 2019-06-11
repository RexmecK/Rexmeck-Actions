include "vec2"
include "rect"

local function vec2lerp(a,b,r)
	return {
		a[1] + (b[1] - a[1]) * r,
		a[2] + (b[2] - a[2]) * r
	}
end

local function lerp(a,b,r)
	return a + (b - a) * r
end

module = {}


function module:init()
	self.sizeCanvas = self.canvas:size()
	self.mousePosition = self.canvas:mousePosition()
end


module._elements = {}
module.inner = 25
module.outer = 50
module.clearing = false
module.clearingDirection = 1
module.waitclear = 0
module.stylistWait = 5/60
module.lerpRatio = 0.25
module.fontSize = 8

function module:updateElements(dt)
	if #self._elements == 0 then return end
	local anglePerElement = 360 / #self._elements
	for i,element in pairs(self._elements) do
		self._elements[i].angle = lerp(self._elements[i].angle, anglePerElement * (i - 0.5), self.lerpRatio)
		local target = vec2.rotate({0,self.inner}, math.rad(self._elements[i].angle))
		self._elements[i].position = vec2lerp(self._elements[i].position, target, self.lerpRatio)
	end
end

function module:update(dt)
	if self.clearing and #self._elements > 0 and self.waitclear == 0 then
		if self.clearingDirection >= 0 then
			self._elements[ #self._elements ] = nil
			self.waitclear = self.stylistWait
		elseif self.clearingDirection < 0 then
			table.remove(self._elements, 1)
			self.waitclear = self.stylistWait
		end
	elseif self.clearing and #self._elements == 0 then
		if self.clearingdonefunc then
			self.clearingdonefunc()
		end
		self.clearing = false
	end

	if self.waitclear > 0 then
		self.waitclear = math.max(self.waitclear - dt, 0)
	end

	self:updateMouse(dt)
	self:updateElements(dt)
	self:updateCanvas(dt)
end

local imageSizeCache = {}

local function imageSize(img)
	if imageSizeCache[img] then return imageSizeCache[img] end
	imageSizeCache[img] = root.imageSize(img)
	return imageSizeCache[img]
end

function module:updateCanvas(dt)
	self.canvas:clear()
	self.hovering = false
	local pieelements = #self._elements
	local box = {-16,-16, 16, 16}

	for i,element in pairs(self._elements) do
		local cur = vec2.add(element.position, vec2.mul(self.sizeCanvas, 0.5))
		local curOuter = vec2.add(cur, vec2.rotate({0,self.outer}, math.rad(element.angle)))
		local color = "#aaa"

		if not self.hovering and rect.contains(rect.translate(box,  curOuter), self.mousePosition) then
			self.hovering = i
			color = "#fff"
		end

		-- they look ugly
		--self.canvas:drawRect(rect.translate({-1,-1, 1, 1}, cur), color)
		--self.canvas:drawLine(cur, curOuter, color.."8", 4)
		--self.canvas:drawRect(rect.translate({-1,-1, 1, 1}, curOuter), color)

		self.canvas:drawImage(self.elementImage or "/assetmissing.png", curOuter, 1, "#fff", true)

		if element.image then
			local imageSize1 = imageSize(element.image)
			self.canvas:drawImage(element.image, curOuter, 16 / math.max(imageSize1[1], imageSize1[2]), color, true)
		end

		if element.text then
			local textPositioning = {
				position = curOuter,
				horizontalAnchor = "mid",
				verticalAnchor = "mid",
				wrapWidth = 32
			}

			self.canvas:drawText(element.text, textPositioning, self.fontSize, "#000")
			textPositioning.position[2] = textPositioning.position[2] + 1
			self.canvas:drawText(element.text, textPositioning, self.fontSize, color)
		end
	end
end

function module:updateMouse(dt)
	self.mousePosition = self.canvas:mousePosition()
end

--callbacks

function module:handleMouse(position, button, isdown)
	self.mousePosition = self.canvas:mousePosition()
	if button == 0 and isdown and self.hovering then
		local element = self._elements[self.hovering]
		local cur = vec2.add(element.position, vec2.mul(self.sizeCanvas, 0.5))
		if element.func then
			element.func()
		end
	end
end

self.bindedOnElementClicked = false

local function dir(p,def)
	if p:sub(1,1) == "/" then return p end
	return def..p
end

function module:add(var, func)
	local ne = {
		func = func,
		position = {0,0},
		angle = 0
	}
	if type(var) == "table" then
		ne.image = dir(var.image, var.directory or "")
		ne.text = var.text
	else
		ne.text = tostring(var)
	end

	if self.clearingDirection < 0 then
		ne.angle = 360
	end
	table.insert(self._elements, ne)
end

function module:stylistClear(direction, donefunc)
	if self.clearing then return end
	self.clearingDirection = direction or 1
	self.clearing = true
	self.clearingdonefunc = donefunc
end

function module:clear(donefunc)
	self._elements = {}
end

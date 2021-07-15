--[[
	grid of tiles of cells

	written in a pretty inefficient way for now :)
]]

local tile_size = vec2(9, 16)
local cell_size = vec2(3, 3)

local texture = love.graphics.newImage("cp437_ibm_pc.png")
local quad = love.graphics.newQuad(0,0,0,0,texture:getDimensions())

local tile = class({
	name = "tile",
})

function tile:new(ox, oy, z, glyph, colour)
	self.offset = vec2(ox, oy)
	self.z = z
	self.glyph = glyph
	self.colour = colour
end

function tile:draw()
	love.graphics.push()
	love.graphics.translate(self.offset.x * tile_size.x, self.offset.y * tile_size.y)
	love.graphics.setColor(color.unpack_argb(self.colour))
	--note: wont work for non-ascii, we can cross that bridge when we get there
	local b = self.glyph:byte(1)
	local x = b % 32
	local y = math.floor(b / 32)
	quad:setViewport(
		x * tile_size.x,
		y * tile_size.y,
		tile_size.x,
		tile_size.y
	)
	love.graphics.draw(texture, quad)
	love.graphics.pop()
end

function tile:set(glyph, colour)
	self.glyph = glyph
	self.colour = colour
end

function tile.compare_z(a, b)
	return a.z < b.z
end

local cell = class({
	name = "cell",
})

function cell:new(x, y)
	self.pos = vec2(x, y) --could be implicit
	self.tiles = {}
end

function cell:draw()
	love.graphics.push()
	love.graphics.translate(
		self.pos.x * cell_size.x * tile_size.x,
		self.pos.y * cell_size.y * tile_size.y
	)
	table.stable_sort(self.tiles, tile.compare_z)
	for _, v in ipairs(self.tiles) do
		v:draw()
	end
	love.graphics.pop()
end

function cell:at(ox, oy, z)
	return functional.find_match(self.tiles, function(v)
		return v.offset.x == ox and v.offset.y == oy and v.z == z
	end)
end

function cell:set(ox, oy, z, glyph, colour)
	local to_remove = glyph == nil or glyph == ""
	local t = self:at(ox, oy, z)
	if t then
		if to_remove then
			table.remove_value(self.tiles, t)
		else
			t:set(glyph, colour or 0xffffffff)
		end
		return
	end
	if not to_remove then
		table.insert(self.tiles, tile(ox, oy, z, glyph, colour))
	end
end

function cell:clear()
	self.tiles = {}
end

local grid = class()

function grid:new(w, h)
	self.cells = functional.generate(w, function(x)
		return functional.generate(h, function(y)
			return cell(x, y)
		end)
	end)
end

function grid:draw(w, h)
	love.graphics.push("all")
	for _, row in ipairs(self.cells) do
		for i, v in ipairs(row) do
			v:draw()
		end
	end
	love.graphics.pop()
end

function grid:clear(x, y)
	self.cells[x][y]:clear()
end

function grid:set(x, y, ox, oy, z, glyph, colour)
	self.cells[x][y]:set(ox, oy, z, glyph, colour)
end

function grid:set_template(x, y, z, template, colour)
	local lines = template
	local longest_line = functional.find_max(lines, function(v)
		return #v
	end)
	local w = #longest_line
	local h = #lines
	local cell = self.cells[x][y]
	for i, line in ipairs(lines) do
		local oy = i - math.floor(h / 2)
		for j = 1, #line do
			local ox = j - math.floor(w / 2)
			local glyph = line:sub(j, j)
			cell:set(ox, oy, z, glyph, colour)
		end
	end
end

return grid

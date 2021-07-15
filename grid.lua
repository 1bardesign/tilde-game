--[[
	grid of tiles of cells

	written in a pretty inefficient way for now :)
]]

local texture = love.graphics.newImage("cga8x8thick.png")
texture:setFilter("nearest", "nearest")
local texture_geometry = vec2(16, 16)
local quad = love.graphics.newQuad(0,0,0,0,texture:getDimensions())

local tile_size = vec2(texture:getDimensions()):vdivi(texture_geometry)
local cell_size = vec2(3, 3)
local cell_step_y = 1
local cell_step_z = 1
--visual size, for debug rectangle and maybe culling?
local cell_visual = cell_size:smul(1, cell_step_y)

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
	love.graphics.translate(
		math.floor(self.offset.x * tile_size.x),
		math.floor((self.offset.y * cell_step_y - self.z * cell_step_z) * tile_size.y)
	)
	love.graphics.setColor(color.unpack_argb(self.colour))
	--note: wont work for non-ascii, we can cross that bridge when we get there
	local b = self.glyph:byte(1)
	local x = math.floor(b % texture_geometry.x)
	local y = math.floor(b / texture_geometry.x)
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
		math.floor(self.pos.x * cell_visual.x * tile_size.x),
		math.floor(self.pos.y * cell_visual.y * tile_size.y)
	)

	if love.keyboard.isDown("`") then
		love.graphics.setColor(colour.unpack_argb(0xff404040))
		love.graphics.rectangle(
			"line",
			-tile_size.x,
			-tile_size.y,
			tile_size.x * cell_visual.x,
			tile_size.y * cell_visual.y
		)
	end

	table.stable_sort(self.tiles, tile.compare_z)
	for _, v in ipairs(self.tiles) do
		v:draw()
	end

	love.graphics.pop()
end

function cell:tile(ox, oy, z)
	return functional.find_match(self.tiles, function(v)
		return v.offset.x == ox and v.offset.y == oy and v.z == z
	end)
end

function cell:set(ox, oy, z, glyph, colour)
	local to_remove =
		glyph == nil
		or glyph == ""
		or glyph == " "

	local t = self:tile(ox, oy, z)
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
	self.size = vec2(w, h)
	self.cells = functional.generate(self.size.y, function(y)
		return functional.generate(self.size.x, function(x)
			return cell(x, y)
		end)
	end)
end

function grid:draw(w, h)
	love.graphics.push("all")
	for _, row in ipairs(self.cells) do
		for _, v in ipairs(row) do
			v:draw()
		end
	end
	love.graphics.pop()
end

function grid:cell(x, y)
	x = math.floor(x)
	y = math.floor(y)
	assert(x > 0 and x <= self.size.x, "x out of range")
	assert(y > 0 and y <= self.size.y, "y out of range")
	return self.cells[y][x]
end

function grid:clear(x, y)
	self:cell(x, y):clear()
end

function grid:set(x, y, ox, oy, z, glyph, colour)
	self:cell(x, y):set(ox, oy, z, glyph, colour)
end

function grid:set_template(x, y, template)
	local cell = self:cell(x, y)
	local z = #template - 1
	for _, lines in ipairs(template) do
		local longest_line = functional.find_max(lines, function(v)
			if type(v) == "string" then
				return #v
			end
			return nil
		end)
		local w = #longest_line
		local h = #lines
		local colour = 0xff00ff
		local i = 0
		for _, v in ipairs(lines) do
			if type(v) == "number" then
				--new line colour
				colour = v
			else
				--new template line
				i = i + 1
				local line = v
				local oy = i - math.floor(h / 2) - 1
				for j = 1, #line do
					local ox = j - math.floor(w / 2) - 1
					local glyph = line:sub(j, j)
					cell:set(ox, oy, z, glyph, colour)
				end
			end
		end
		--inverse z order
		z = z - 1
	end
end

--export
grid.cell_size = cell_visual:vmul(tile_size):round()

return grid

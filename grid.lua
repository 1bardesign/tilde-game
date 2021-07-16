--[[
	grid of tiles of cells

	written in a pretty inefficient way for now :)
]]

--config
local cell_size = vec2(3, 3)

--
local tile = class({
	name = "tile",
})

function tile:new(ox, oy, z, glyph, colour)
	self.offset = vec2(ox, oy)
	self.z = z
	self.glyph = glyph
	self.colour = colour
end

function tile:draw(x, y, display)
	display:add(
		x + self.offset.x,
		y + self.offset.y,
		self.z,
		self.glyph,
		self.colour
	)
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

function cell:draw(display)
	local x = self.pos.x * cell_size.x
	local y = self.pos.y * cell_size.y
	for _, v in ipairs(self.tiles) do
		v:draw(x, y, display)
	end
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

function grid:draw(display)
	for _, row in ipairs(self.cells) do
		for _, v in ipairs(row) do
			v:draw(display)
		end
	end
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

function grid:parse_template(template, f)
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
		local cx = math.floor((cell_size.x - w) / 2)
		local cy = math.floor((cell_size.y - h) / 2)
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
				local oy = i + cy - 1
				for j = 1, #line do
					local ox = j + cx - 1
					local glyph = line:sub(j, j)
					f(ox, oy, z, glyph, colour)
				end
			end
		end
		--inverse z order
		z = z - 1
	end
end

function grid:set_template(x, y, template)
	local cell = self:cell(x, y)
	grid:parse_template(template, function(ox, oy, z, glyph, colour)
		cell:set(ox, oy, z, glyph, colour)
	end)
end

--export
grid.cell_size = cell_size

return grid




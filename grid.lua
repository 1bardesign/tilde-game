--[[
	grid of cells that store a template for rendering and a solid mask

	written in a pretty inefficient way for now :)
]]

--config
local cell_size = vec2(3, 3)

local space_glyph = (" "):byte(1)

--doesn't actually rely on grid
local function parse_template(template, f)
	local z = #template - 1
	for _, lines in ipairs(template) do
		local w = 0
		for i, v in ipairs(lines) do
			if type(v) == "string" then
				w = math.max(w, #v)
			end
		end
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
					local glyph = line:byte(j)
					if glyph ~= space_glyph then
						f(ox, oy, z, glyph, colour)
					end
				end
			end
		end
		--inverse z order
		z = z - 1
	end
end

--cells are now fairly vestigial, could be refactored into just grid
local cell = class({
	name = "cell",
})

function cell:new(x, y)
	self.pos = vec2(x, y) --could be implicit
	self.template = false
	self.solid = false
	self.type = "empty"
	self.elevation = 0
end

local _inline_celldraw_display
local _inline_celldraw_self
local _inline_celldraw_x
local _inline_celldraw_y
local function _inline_celldraw(ox, oy, z, glyph, colour)
	_inline_celldraw_display:add(
		_inline_celldraw_x + ox,
		_inline_celldraw_y + oy,
		z + _inline_celldraw_self.elevation,
		glyph, colour
	)
end
function cell:draw(display)
	if not self.template then
		return
	end
	_inline_celldraw_x = self.pos.x * cell_size.x
	_inline_celldraw_y = self.pos.y * cell_size.y
	_inline_celldraw_display = display
	_inline_celldraw_self = self
	parse_template(self.template, _inline_celldraw)
end

local grid = class({
	name = "grid",
})

function grid:new(w, h)
	self.size = vec2(w, h)
	self.cells = functional.generate(self.size.y, function(y)
		return functional.generate(self.size.x, function(x)
			return cell(x, y)
		end)
	end)
end

function grid:draw(display, near)
	local halfsize = vec2(love.graphics.getDimensions())
		:vdivi(cell_size)
		:vdivi(display.tile_size)
		:sdivi(ZOOM_LEVEL)
		:sdivi(2) --halfsize
		:saddi(2) --pad margin in case of tall tiles
	for _, row in ipairs(self.cells) do
		for _, v in ipairs(row) do
			if intersect.aabb_point_overlap(near, halfsize, v.pos) then
				v:draw(display)
			end
		end
	end
end

function grid:cell(x, y)
	x = math.floor(x)
	y = math.floor(y)
	assert(self:in_bounds(x, y), "attempt to get cell out of bounds")
	return self.cells[y][x]
end

function grid:clear(x, y)
	self:cell(x, y):clear()
end

function grid:set(x, y, template, solid, type, elevation)
	local cell = self:cell(x, y)
	cell.template = template
	cell.solid = solid
	cell.type = type or (solid and "wall" or "empty")
	cell.elevation = elevation or 0
end

function grid:in_bounds(x, y)
	return (x > 0 and x <= self.size.x)
		and (y > 0 and y <= self.size.y)
end

function grid:solid_at(x, y)
	return not self:in_bounds(x, y) or self:cell(x, y).solid
end

function grid:water_at(x, y)
	return self:in_bounds(x, y) and self:cell(x, y).type == "water"
end

--export
grid.cell_size = cell_size
grid.parse_template = parse_template

return grid




--[[
	z sorted "3d" ascii renderer

	chuck glyphs at it with xyz positions, they'll be drawn properly sorted as a big batch
]]

local texture = love.graphics.newImage("cga8x8thick_edit.png")
texture:setFilter("nearest", "nearest")

local quad = love.graphics.newQuad(0,0,0,0,texture:getDimensions())

local texture_geometry = vec2(16, 16)
local tile_size = vec2(texture:getDimensions()):vdivi(texture_geometry)

local ascii3d = class()

function ascii3d:new()
	self.queue = {}
end

function ascii3d:add(x, y, z, glyph, colour, rotation, scale)
	table.insert(self.queue, {x, y, z, glyph, colour, rotation or 0, scale or 1})
end

local function z_sort(a, b)
	--z
	if a[3] < b[3] then return true end
	--y
	if a[3] == b[3] and a[2] < b[2] then return true end
	return false
end

function ascii3d:draw()
	table.stable_sort(self.queue, z_sort)
	love.graphics.push("all")
	for _, v in ipairs(self.queue) do
		local x, y, z, glyph, colour, rotation, scale = table.unpack7(v)
		if z > 1 then
			-- TODO: Make blurry / faded / something
			--(likely write out z to a separate mask for various effects)
		end

		local sx = x * tile_size.x
		local sy = (y - z) * tile_size.y
		local b = glyph:byte(1)
		local tx = math.floor(b % texture_geometry.x)
		local ty = math.floor(b / texture_geometry.x)
		quad:setViewport(
			tx * tile_size.x,
			ty * tile_size.y,
			tile_size.x,
			tile_size.y
		)
		love.graphics.setColor(color.unpack_argb(colour))
		love.graphics.draw(
			texture, quad,
			sx, sy,
			rotation,
			scale, scale,
			tile_size.x / 2,
			tile_size.x / 2
		)
	end
	love.graphics.pop()
	self.queue = {}
end

return ascii3d

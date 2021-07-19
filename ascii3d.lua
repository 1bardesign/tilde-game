--[[
	z sorted "3d" ascii renderer

	chuck glyphs at it with xyz positions, they'll be drawn properly sorted as a big batch
]]

local texture = love.graphics.newImage("assets/cga8x8thick_edit.png")
texture:setFilter("nearest", "nearest")

local quad = love.graphics.newQuad(0,0,0,0,texture:getDimensions())

local texture_geometry = vec2(16, 16)

local ascii3d = class()

ascii3d.tile_size = vec2(texture:getDimensions()):vdivi(texture_geometry)

function ascii3d:new()
	self.queue = {}
	self.pool = {}
end

function ascii3d:add(x, y, z, glyph, colour, rotation, scale)
	local t = table.remove(self.pool)
	if not t then
		t = {}
	end
	t[1] = x
	t[2] = y
	t[3] = z
	t[4] = glyph
	t[5] = colour
	t[6] = rotation or 0
	t[7] = scale or 1
	table.insert(self.queue, t)
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

		local sx = x * self.tile_size.x
		local sy = (y - z) * self.tile_size.y
		local b = glyph
		local tx = math.floor(b % texture_geometry.x)
		local ty = math.floor(b / texture_geometry.x)
		local uv_pad = 1 / 32 --pixels
		--account for pad
		local tw = self.tile_size.x - uv_pad * 2
		local th = self.tile_size.y - uv_pad * 2
		scale = scale * self.tile_size.x / tw
		quad:setViewport(
			tx * self.tile_size.x + uv_pad,
			ty * self.tile_size.y + uv_pad,
			tw, th
		)

		love.graphics.setColor(color.unpack_argb(colour))
		love.graphics.draw(
			texture, quad,
			sx, sy,
			rotation,
			scale, scale,
			tw / 2,
			th / 2
		)
	end
	love.graphics.pop()
	self.pool = self.queue --reuse for next time
	self.queue = {}
end

return ascii3d

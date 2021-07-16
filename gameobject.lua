--[[
	base game object
]]

local gameobject = class()

function gameobject:new(game_state)
	self.game_state = game_state
	self.grid = game_state.grid
end

function gameobject:update(dt)
	--dummy
end

function gameobject:tick()
	--dummy
end

function gameobject:draw_template_at(display, pos, template)
	local x, y = pos:vmul(self.grid.cell_size):unpack()
	self.grid:parse_template(template, function(ox, oy, z, glyph, colour)
		display:add(x + ox, y + oy, z, glyph, colour)
	end)
end

function gameobject:draw(display)
	--dummy
end

function gameobject:keypressed(k)
	--dummy
end

return gameobject

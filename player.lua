local player = class({
	extends = require("gameobject"),
})

function player:new(game_state, pos)
	self:super(game_state)
	self.pos = pos
	self.tile_pos = pos:copy()
	self.move_queue = {}
	self.template = require("templates").player
end

function player:update(dt)
	self.pos:lerpi(self.tile_pos, 0.1)
end

function player:tick()
	if #self.move_queue > 0 then
		local move = table.shift(self.move_queue)
		--if not blocked,
		self.tile_pos:vaddi(move)
	end
end

function player:keypressed(k)
	local move = nil
	if k == "up" or k == "w" then move = vec2(0, -1) end
	if k == "down" or k == "s" then move = vec2(0, 1) end
	if k == "left" or k == "a" then move = vec2(-1, 0) end
	if k == "right" or k == "d" then move = vec2(1, 0) end
	if move then
		table.insert(self.move_queue, move)
	end
end

function player:draw(display)
	self:draw_template_at(display, self.pos, self.template)
end

return player

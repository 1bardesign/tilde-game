--generate a real awesome world and write it back into the game state

local template = require("templates");

return function(game_state)
	local grid = game_state.grid
	for y = 1, grid.size.y do
		for x = 1, grid.size.x do
			local t = template.grass
			local r = love.math.random();
			if r < 0.1 then
				t = template.flowers
			elseif r < 0.2 then
				t = template.tree
			elseif r < 0.22 then
				t = template.rocks
			end
			grid:set_template(
				x, y,
				table.pick_random(t)
			)
		end
	end
end

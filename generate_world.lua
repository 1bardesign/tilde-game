--generate a real awesome world and write it back into the game state

local template = require("templates");
local grid = require("grid")
local exported_map = require("exported_map")

return function(game_state)
	local width = exported_map.layers[1].width;
	local height = exported_map.layers[1].height;
	assert( #exported_map.layers[1].data == width * height );

	game_state.grid = grid(width, height)
	game_state.player_spawns = {}
	game_state.snake_spawns = {}
	
	local grid = game_state.grid;
	-- parse data
	for y=1, grid.size.y do
		for x=1, grid.size.x do
			local type = exported_map.layers[1].data[ x + ( y - 1 ) * grid.size.x ];

			if type == 25 then
				-- trees
				grid:set(
					x, y,
					table.pick_random(template.tree),
					true
				)
			elseif type == 44 then
				-- an empty collision space
				grid:set(
					x, y,
					nil,
					true
				)
			elseif type == 47 then
				-- flowers
				grid:set(
					x, y,
					table.pick_random(template.flowers),
					false
				)
			elseif type == 220 then
				local has_rock_above = y == 1 or exported_map.layers[1].data[ x + ( y - 2 ) * grid.size.x ] == 220;

				-- rocks
				grid:set(
					x, y,
					has_rock_above and table.pick_random(template.rock_full) or table.pick_random(template.rocks),
					true
				)
			elseif type == 2 then
				table.insert( game_state.player_spawns, vec2( x, y ) )
			elseif type == 84 then
				table.insert( game_state.snake_spawns, vec2( x, y ) )
			else
				assert( type == 0, tostring( type ) )

				-- empty / grass
				if love.math.random() < 0.3 then
					grid:set(
						x, y,
						table.pick_random(template.grass),
						false
					)
				end
			end
		end
	end
end

--generate a real awesome world and write it back into the game state

local template = require("templates");
local grid = require("grid")
local exported_map = require("exported_map")

return function(game_state)
	local tile_layer = exported_map.layers[1]
	local tile_data = tile_layer.data
	local width = tile_layer.width;
	local height = tile_layer.height;
	assert( #tile_data == width * height, "tilemap dimensions match data" );

	game_state.grid = grid(width, height)
	game_state.player_spawn = nil;
	game_state.spawns = {};
	
	local grid = game_state.grid;
	-- parse data
	for y=1, grid.size.y do
		for x=1, grid.size.x do
			local type = tile_data[ x + ( y - 1 ) * grid.size.x ];

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
			elseif type == 8 then
				-- mushrooms
				grid:set(
					x, y,
					table.pick_random(template.mushrooms),
					false
				)
			elseif type == 47 then
				-- flowers
				if love.math.random() < 0.5 then
					grid:set(
						x, y,
						table.pick_random(template.flowers),
						false
					)
				end
			elseif type == 220 then
				local has_rock_above = y == 1 or tile_data[ x + ( y - 2 ) * grid.size.x ] == 220;

				-- rocks
				grid:set(
					x, y,
					has_rock_above and table.pick_random(template.rock_full) or table.pick_random(template.rocks),
					true
				)
			elseif type == 248 then
				-- water
				grid:set(
					x, y,
					table.pick_random(template.water),
					false,
					-1
				)
			elseif type == 48 then
				-- path
				grid:set(
					x, y,
					table.pick_random(template.path),
					false
				)
			elseif type == 241 then
				-- door
				grid:set(
					x, y,
					template.house.door,
					true
				)
			elseif type == 204 then
				-- door
				grid:set(
					x, y,
					table.pick_random(template.house.wall),
					true
				)
			elseif type == 36 then
				local has_roof_above = tile_data[ x + ( y - 2 ) * grid.size.x ] == type;

				-- roof
				grid:set(
					x, y,
					has_roof_above and template.house.roof or template.house.roof_top,
					true
				)
			elseif type == 2 then
				game_state.player_spawn = vec2( x, y )
			elseif type == 103 then
				game_state.spawns["frog"] = game_state.spawns["frog"] or {}
				table.insert( game_state.spawns["frog"], vec2( x, y ) )
			else
				if not ( type == 0 or type == 33) then
					error("unknown tile type" .. tostring( type ))
				end

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

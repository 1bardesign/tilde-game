return {
	sound = {
		move = love.audio.newSource( "assets/wav/move3.wav", "static" ),
		move_water = love.audio.newSource( "assets/wav/move_water.wav", "static" ),
		serpent_move = love.audio.newSource( "assets/wav/move1.wav", "static" ),
		serpent_growl = love.audio.newSource( "assets/wav/serpent_growl.wav", "static" ),
		frog_jump = love.audio.newSource( "assets/wav/frog_jump.wav", "static" ),
		deer_jump = love.audio.newSource( "assets/wav/deer_jump.wav", "static" ),
		oh = love.audio.newSource( "assets/wav/oh.wav", "static" ),
	},
	play = function( sound, volume )
		sound:setVolume( volume and volume or 1 )
		sound:play()
	end,
	play_positional = function( sound, volume, game_state, pos )
		local dist_sq = game_state.player.camera_pos:distance_squared(pos)
		local max_dist = 20
		if dist_sq < max_dist then
			local gain = ( volume and volume or 1 ) * ( 1 - dist_sq / max_dist );
			sound:setVolume( gain )
			sound:play()
		end
	end,
}

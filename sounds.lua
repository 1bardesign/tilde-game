return {
	sound = {
		move = love.audio.newSource( "wav/player_jump.wav", "static" ),
		serpent_move = love.audio.newSource( "wav/move1.wav", "static" ),
		serpent_growl = love.audio.newSource( "wav/serpent_growl.wav", "static" ),
		frog_jump = love.audio.newSource( "wav/frog_jump.wav", "static" ),
		-- etc
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
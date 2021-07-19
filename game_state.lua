local grid = require("grid")

local palette = require("palette.pigment")
local sounds = require("sounds")

local state = class()

local use_shader = true

--setup instance
function state:new()
	ZOOM_LEVEL = math.ceil(love.graphics.getHeight() / 1080 * 3)

	self.background_colour = palette.dark
	local function screen_canvas()
		return love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	end
	--storage for game screen
	self.canvas = screen_canvas()
	--storage for blurred game screen
	self.blur_shader = love.graphics.newShader([[
		uniform vec2 res;
		uniform vec2 radius;
		vec4 effect(vec4 c, Image t, vec2 uv, vec2 px) {
			vec4 accum = vec4(0.0);
			float total = 0.0;
			for (float oy = -radius.y; oy <= radius.y; oy++) {
				for (float ox = -radius.x; ox <= radius.x; ox++) {
					accum += Texel(t, uv + vec2(ox, oy) / res);
					total++;
				}
			}
			return accum / total;
		}
	]])
	self.blur_shader:send("res", {love.graphics.getDimensions()})
	self.blurred = {screen_canvas(), screen_canvas()}
	--storage for feedback effects
	self.current_frame = screen_canvas()
	self.last_frame = screen_canvas()

	self.shader = love.graphics.newShader([[
		uniform float vignette_scale;
		uniform float vignette_darken_scale;
		uniform vec4 vignette_colour;
		uniform float time;
		uniform vec2 res;
		uniform Image distortion_tex;
		uniform vec2 distortion_res;
		uniform vec2 distortion_flow;
		uniform float distortion_scale;

		uniform Image noise_tex;
		uniform vec2 noise_res;
		uniform vec2 noise_offset;

		uniform Image blurred;
		uniform Image last_frame;

		uniform vec2 camera_pos;
		uniform float camera_scale;

		uniform float feedback_amount;

		vec4 effect(vec4 c, Image t, vec2 uv, vec2 px) {
			float d = length((uv - vec2(0.5)) * vec2(1.0, res.y / res.x)) * 2.0;
			float distortion_min = -0.1;
			float distortion_max = 1.5;
			float distortion_amount = clamp(mix(distortion_min, distortion_max, d), 0.0, 1.0);
			distortion_amount = distortion_amount * distortion_scale;
			float distortion_domainwarp = 5.0;
			float distortion_distance = 5.0;
			float distortion_res_scale = 0.2;
			vec2 pos = (px / camera_scale) - camera_pos;
			vec2 distortion_uv = pos / distortion_res * distortion_res_scale + distortion_flow / distortion_res * time;
			vec2 distortion = vec2(0.0);
			for (int i = 0; i < 3; i++) {
				distortion = (Texel(distortion_tex, distortion_uv).rg - vec2(0.5)) * 2.0;
				distortion_uv = distortion_uv + distortion / distortion_res * distortion_domainwarp;
			}
			//blur in distance
			vec4 sharp = Texel(t, uv);
			vec4 blur = Texel(blurred, uv);
			float blur_amount = clamp(mix(-0.2, 1.2, d), 0.0, 1.0);
			c *= mix(sharp, blur, blur_amount);
			//apply vignette
			float vignette_amount = max(0.0, mix(-0.2, 1.0, d));
			c.rgb = mix(c.rgb, vignette_colour.rgb, vignette_amount * vignette_scale);
			c.rgb *= 1.0 - vignette_amount * vignette_darken_scale;
			//lerp last frame
			vec2 zoom_uv = uv;
			//sample distorted
			vec2 uv_distortion_offset = distortion / res * distortion_amount;
			zoom_uv -= uv_distortion_offset.yx * distortion_distance;

			//and feedback scaled old frame
			zoom_uv = (zoom_uv - vec2(0.5)) * 0.99 + vec2(0.5);

			float old_frame_amount = clamp(mix(0.1, 0.9, d), 0.0, 1.0) * feedback_amount;
			vec4 feedback_px = Texel(last_frame, zoom_uv);
			feedback_px = mix(feedback_px, vignette_colour, 0.1);
			c = mix(c, feedback_px, old_frame_amount);

			//and finally noise grain
			vec4 grain = Texel(noise_tex, px / noise_res + noise_offset);
			c.rgb += (grain.rgb - vec3(0.5)) * 2.0 * 0.01 * grain.a;

			return c;
		}
	]])
	do
		do
			local res = 512
			local id = love.image.newImageData(res, res, "rg16")
			id:mapPixel(function(x, y)
				local period = 40.1
				return
					love.math.noise(x / period, y / period),
					love.math.noise((y + 190) / period, (x - 360) / period)
			end)
			local distortion_tex = love.graphics.newImage(id)
			distortion_tex:setWrap("repeat")
			self.shader:send("distortion_tex", distortion_tex)
			self.shader:send("distortion_res", {distortion_tex:getDimensions()})
		end

		do
			local res = 512
			local id = love.image.newImageData(res, res, "rgba8")
			id:mapPixel(function(x, y)
				return
					love.math.random(),
					love.math.random(),
					love.math.random(),
					love.math.random()
			end)
			local noise_tex = love.graphics.newImage(id)
			noise_tex:setWrap("repeat")
			self.shader:send("noise_tex", noise_tex)
			self.shader:send("noise_res", {noise_tex:getDimensions()})
		end

		self.shader:send("res", {love.graphics.getDimensions()})

		self.shader:send("vignette_colour", {colour.unpack_argb(palette.dark)})
		self.shader:send("distortion_flow", {3.3, 2.3})
	end

	-- synthesize rain noise
	local denver = require("denver")
	self.rain_noise = denver.get({waveform='pinknoise', length=6})
	self.rain_noise:setLooping( true )
	self.rain_noise:setVolume( 0 )
	love.audio.play(self.rain_noise)

	self.ambient_loop = love.audio.newSource( "wav/ambience.wav", "static" )
	self.ambient_loop:setLooping( true )
	self.ambient_loop:setVolume( 0 )
	love.audio.play(self.ambient_loop)
end

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
	self.display = require("ascii3d")()
	self.ui_display = require("ascii3d")()
	self.objects = {}
	self.message_stack = {}
	self.rain_timer = 0
	self.rain_gain = 0
	self.quietude = 0

	--stackable effects
	self.is_raining = 0
	self.is_dark = 0
	self.is_quiet = 0

	self:update_shader_targets()

	require("generate_world")(self) -- populates the structures below
	assert( self.grid )
	assert( self.player_spawn )
	assert( self.spawns )
	assert( self.regions )

	local player_spawn = self.player_spawn;
	self.player = require("player")(self, player_spawn )
	table.insert(self.objects, self.player)
	
	for k, positions in pairs( self.spawns ) do
		if k == "frog" then
			for _, pos in ipairs( positions ) do
				local frog = require("frog")( self, pos.x, pos.y )
				table.insert(self.objects, frog)
			end
		elseif k == "bird" then
			for _, pos in ipairs( positions ) do
				local bird = require("bird")( self, pos.x, pos.y )
				table.insert(self.objects, bird)
			end
		elseif k == "deer" then
			for _, pos in ipairs( positions ) do
				local deer = require("deer")( self, pos.x, pos.y )
				table.insert(self.objects, deer)
			end
		end
		-- etc
		-- local snake_spawn = tablex.take_random( self.spawns );
		-- self.snake = require("ohno_a_snake")( self, snake_spawn.x, snake_spawn.y )
		-- table.insert(self.objects, self.snake)
	end
	
	self.player_regions = set()
	self.player_seen = set()

	self:update_player_region( player_spawn )
	self.time_since_last_tick = 0
end

function state:tick()
	for _, v in ipairs(self.objects) do
		v:tick()
	end
end

function state:update_shader_targets()
	self.blur_target =
		(self.is_raining > 0 or self.is_dark > 0) and 8.0
		or 4.0
	self.vignette_target =
		self.is_raining > 0 and 1.0
		or 0.1
	self.darken_target =
		self.is_dark > 0 and 3.0
		or self.is_raining > 0 and 1.0
		or 0.0
	self.distortion_target =
		self.is_raining > 0 and 1.0
		or 0.0
	self.feedback_target =
		self.is_raining > 0 and 1.0
		or self.is_quiet > 0 and 0.5
		or 0.15

	--update towards target effect amount
	local lerp_speed = 0.05
	self.blur_amount = math.lerp(self.blur_amount or self.blur_target, self.blur_target, lerp_speed)
	self.vignette_amount = math.lerp(self.vignette_amount or self.vignette_target, self.vignette_target, lerp_speed)
	self.darken_amount = math.lerp(self.darken_amount or self.darken_target, self.darken_target, lerp_speed)
	self.distortion_amount = math.lerp(self.distortion_amount or self.distortion_target, self.distortion_target, lerp_speed)
	self.feedback_amount = math.lerp(self.feedback_amount or self.feedback_target, self.feedback_target, lerp_speed)
end

function state:update(dt)
	-- tick in soft-realtime
	self.time_since_last_tick = self.time_since_last_tick + dt
	if self.time_since_last_tick > 0.1 then
		self.time_since_last_tick = 0
		self:tick()
	end

	--update everything
	for _, v in ipairs(self.objects) do
		v:update(dt)
	end

	--update effects etc
	if self.is_raining > 0 then
		self.rain_timer = self.rain_timer + dt
		if self.rain_gain < 1 then
			self.rain_gain = math.min( 1, self.rain_gain + dt )
		end
	elseif self.rain_gain > 0 then
		self.rain_gain = math.max( 0, self.rain_gain - dt )
	end

	if self.is_quiet > 0 then
		if self.quietude < 1 then
			self.quietude = math.min( 1, self.quietude + dt * .2 )
		end
	elseif self.quietude > 0 then
		self.quietude = math.max( 0, self.quietude - dt * .2 )
	end

	-- Update ambient mix
	self.rain_noise:setVolume( 0.25 * self.rain_gain * ( 1 - self.quietude ) )
	self.ambient_loop:setVolume( ( 1 - self.rain_gain ) * ( 1 - self.quietude ) )
end

function state:update_player_region( pos )
	-- Detect overlapping regions
	local regions = set()
	local region_properties = {} -- this won't handle multiple regions with same name, but is fine for us
	for _, region in pairs( self.regions ) do
		name = region[1]
		center = region[2]
		hs = region[3]
		properties = region[4]
		if intersect.aabb_point_overlap( center, hs, pos ) then
			regions:add( name )
			region_properties[name] = properties
		end
	end

	local new_regions = regions:copy()
	new_regions:subtract_set( self.player_regions )

	local old_regions = self.player_regions:copy()
	old_regions:subtract_set( regions )

	local add_message = function( msg )
		for i=1,#self.message_stack do
			local priority = msg.priority or 0
			local p = self.message_stack[i].priority or 0
			if p > priority then
				for j=i+1,#self.message_stack+1 do
					self.message_stack[j] = self.message_stack[j-1]
				end
				self.message_stack[i] = msg
				return
			end
		end

		-- Else put on top
		table.insert( self.message_stack, msg )
	end

	for _, region in ipairs( new_regions:values_readonly() ) do
		local custom_text = region_properties[region] and region_properties[region].Text or nil
		if region == "Start" then
			if not self.player_seen:has( region ) then
				add_message( { text = "A Forest Walk", region_bound = region } )
			end
		elseif region == "WrongWay" then
			add_message( { text = custom_text or "It's Time To Go Home", region_bound = region } )
			sounds.play( sounds.sound.oh, 0.5 )
		elseif region == "Fork" then
			add_message( { text = custom_text or "A Fork In The Path", region_bound = region } )
		elseif region == "Entrance" then
			add_message( { text = custom_text or "Nobody's Home", region_bound = region, priority = 1 } )
			sounds.play( sounds.sound.oh, 0.5 )
		elseif region == "House" then
			add_message( { text = custom_text or "A House In The Forest", region_bound = region } )
		elseif region == "Feature" and custom_text then
			add_message( { text = custom_text, region_bound = region } )
			sounds.play( sounds.sound.oh, 0.5 )
		elseif region == "Rain" then
			self.is_raining = self.is_raining + 1
		elseif region == "Quiet" then
			self.is_quiet = self.is_quiet + 1
		elseif region == "Dark" then
			self.is_dark = self.is_dark + 1
		elseif region == "Finish" then
			-- TODO: Fade out - back to titles/credits
		end
	end


	for _, region in ipairs( old_regions:values_readonly() ) do
		-- Generic region exit actions
		self.message_stack = functional.remove_if( self.message_stack, function( msg ) return msg.region_bound == region; end )
		
		-- Specific region exit actions
		-- TODO: When exit "Start" for first time zoom camera out a little
		if region == "Rain" then
			self.is_raining = self.is_raining - 1
		elseif region == "Quiet" then
			self.is_quiet = self.is_quiet - 1
		elseif region == "Dark" then
			self.is_dark = self.is_dark - 1
		end
	end
 
	self.player_seen:add_set( regions )
	self.player_regions = regions
end

function state:draw()
	--set up camera
	love.graphics.push("all")
	love.graphics.translate(
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2
	)
	love.graphics.scale(ZOOM_LEVEL)
	local cx, cy = self.player.camera_pos
		:vmul(self.grid.cell_size)
		:vmuli(self.display.tile_size)
		:smuli(-1)
		:unpack()
	love.graphics.translate(cx, cy)
	--draw world
	love.graphics.setCanvas(self.canvas)
	love.graphics.setShader()
	love.graphics.clear(colour.unpack_argb(self.background_colour))
	self.grid:draw(self.display, self.player.camera_pos)
	--draw objects
	for _, v in ipairs(self.objects) do
		v:draw(self.display)
	end

	-- draw dynamic effects
	if self.is_raining > 0 then
		-- TODO: doesnt need to be on display layer
		local x = math.floor( self.player.camera_pos.x )
		local y = math.floor( self.player.camera_pos.y ) + 2
		local dt = ( self.rain_timer % 0.3 ) / 0.3
		for dx=-30,30,1 do
			for dy=-20,20,1 do
				local px = ( x + dx )*self.grid.cell_size.x + dt * 3
				local py = ( y + dy )*self.grid.cell_size.y + dt * 9
				self.display:add( px, py, 10, '|', palette.blue)
			end
		end
	end


	--display
	self.display:draw()

	-- draw message
	local msg = self.message_stack[#self.message_stack]
	if msg then
		local x = self.player.camera_pos.x - #msg.text / self.grid.cell_size.x / 2
		local y = self.player.camera_pos.y + 6
		for i=1,#msg.text do
			local char = msg.text:sub(i)
			self.ui_display:add( i + x*self.grid.cell_size.x, y*self.grid.cell_size.y, 0, char, palette.white)
		end
	end
	self.ui_display:draw()

	--screenspace stuff
	love.graphics.origin()
	love.graphics.setBlendMode("alpha", "premultiplied")

	if use_shader then
		self:update_shader_targets()

		--blur current frame
		local blur_rad = self.blur_amount
		love.graphics.setCanvas(self.blurred[1])
		self.blur_shader:send("radius", {blur_rad, 0})
		love.graphics.setShader(self.blur_shader)
		love.graphics.draw(self.canvas)
		love.graphics.setCanvas(self.blurred[2])
		self.blur_shader:send("radius", {0, blur_rad})
		love.graphics.setShader(self.blur_shader)
		love.graphics.draw(self.blurred[1])

		--effects
		love.graphics.setCanvas(self.current_frame)
		love.graphics.clear(colour.unpack_argb(self.background_colour))
		love.graphics.setShader(self.shader)

		local vigenette_speed = 1 / 20
		local vignette_time = math.sin(love.timer.getTime() * math.tau * vigenette_speed) * 0.5 + 0.5

		local distortion_speed = 1 / 13
		local distortion_time = math.sin(love.timer.getTime() * math.tau * distortion_speed) * 0.5 + 0.5

		self.shader:send("vignette_scale", math.lerp(0.6, 0.8, vignette_time) * self.vignette_amount)
		self.shader:send("vignette_darken_scale", math.lerp(0.5, 0.25, vignette_time) * self.darken_amount)
		self.shader:send("distortion_scale", math.lerp(0.2, 0.8, distortion_time) * self.distortion_amount)
		self.shader:send("time", love.timer.getTime())
		self.shader:send("camera_pos", {cx, cy})
		self.shader:send("camera_scale", 2)
		self.shader:send("last_frame", self.last_frame)
		self.shader:send("blurred", self.blurred[2])
		self.shader:send("noise_offset", {love.math.random(), love.math.random()})
		self.shader:send("feedback_amount", self.feedback_amount)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.canvas)
	else
		love.graphics.setCanvas(self.current_frame)
		love.graphics.draw(self.canvas)
	end
	love.graphics.setCanvas()
	love.graphics.setShader()
	love.graphics.draw(self.current_frame)
	self.current_frame, self.last_frame = self.last_frame, self.current_frame
	love.graphics.pop()
end

function state:keypressed(k)
	self.player:keypressed(k)
end

function state:keyreleased(k)
	self.player:keyreleased(k)
end

return state

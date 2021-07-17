local grid = require("grid")

local palette = require("palette.pigment")
local template = require("templates")

local state = class()

local use_shader = false

--setup instance
function state:new()
	self.background_colour = palette.dark
	--storage for game screen
	self.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	--storage for blurred game screen
	self.blurred = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	self.blur_shader = love.graphics.newShader([[
		uniform vec2 res;
		vec4 effect(vec4 c, Image t, vec2 uv, vec2 px) {
			vec4 accum = vec4(0.0);
			float total = 0.0;
			const float r = 2.0;
			for (float oy = -r; oy <= r; oy++) {
				for (float ox = -r; ox <= r; ox++) {
					accum += Texel(t, uv + vec2(ox, oy) / res);
					total++;
				}
			}
			return accum / total;
		}
	]])
	self.blur_shader:send("res", {love.graphics.getDimensions()})
	--storage for feedback effects
	self.current_frame = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	self.last_frame = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

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

			float old_frame_amount = clamp(mix(0.1, 0.9, d), 0.0, 1.0);
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
end

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
	self.display = require("ascii3d")()
	self.ui_display = require("ascii3d")()
	self.objects = {}
	self.message_stack = {}
	self.is_raining = false
	self.rain_timer = 0
	self.rain_gain = 0

	require("generate_world")(self) -- populates the structures below
	assert( self.grid )
	assert( self.player_spawn )
	assert( self.spawns )
	assert( self.regions )

	local player_spawn = self.player_spawn;
	self.player = require("player")(self, player_spawn )
	table.insert(self.objects, self.player)
	
	for k,poses in pairs( self.spawns ) do
		if k == "frog" then
			for _, pos in ipairs( poses ) do
				local frog = require("frog")( self, pos.x, pos.y )
				table.insert(self.objects, frog)
			end
		elseif k == "bird" then
			for _, pos in ipairs( poses ) do
				local bird = require("bird")( self, pos.x, pos.y )
				table.insert(self.objects, bird)
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
	if self.is_raining then
		self.rain_timer = self.rain_timer + dt
		if self.rain_gain < 1 then
			self.rain_gain = math.min( 1, self.rain_gain + dt )
		end
	elseif self.rain_gain > 0 then
		self.rain_gain = math.max( 0, self.rain_gain - dt )
	end

	self.rain_noise:setVolume( 0.25 * self.rain_gain )
	
end

function state:update_player_region( pos )
	-- Detect overlapping regions
	local regions = set()
	for _, region in pairs( self.regions ) do
		name = region[1]
		center = region[2]
		hs = region[3]
		if intersect.aabb_point_overlap( center, hs, pos ) then
			regions:add( name )
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
		if region == "Start" then
			if not self.player_seen:has( region ) then
				add_message( { text = "A Forest Walk", region_bound = region } )
			end
		elseif region == "WrongWay" then
			add_message( { text = "Wrong Way", region_bound = region } )
		elseif region == "Fork" then
			add_message( { text = "A Fork In The Path", region_bound = region } )
		elseif region == "Entrance" then
			add_message( { text = "Nobody's Home", region_bound = region, priority = 1 } )
		elseif region == "House" then
			add_message( { text = "A House In The Forest", region_bound = region } )
		elseif region == "Rain" then
			self.is_raining = true
			use_shader = true
		elseif region == "Dark" then
			-- TODO: Trigger dark / for instance
			-- use_shader = true
		end
	end


	for _, region in ipairs( old_regions:values_readonly() ) do
		-- Generic region exit actions
		self.message_stack = functional.remove_if( self.message_stack, function( msg ) return msg.region_bound == region; end )
		
		-- Specific region exit actions
		-- TODO: When exit "Start" for first time zoom camera out a little
		if region == "Rain" then
			self.is_raining = false
			use_shader = false
		elseif region == "Dark" then
			-- use_shader = false
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
	love.graphics.scale(2)
	local cx, cy = self.player.camera_pos:vmul(grid.cell_size):smuli(8):smuli(-1):unpack()
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
	if self.is_raining then
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
		--blur current frame
		love.graphics.setCanvas(self.blurred)
		love.graphics.setShader(self.blur_shader)
		love.graphics.draw(self.canvas)

		--effects
		love.graphics.setCanvas(self.current_frame)
		love.graphics.clear(colour.unpack_argb(self.background_colour))
		love.graphics.setShader(self.shader)
		local vigenette_speed = 1 / 20
		local vignette_time = math.sin(love.timer.getTime() * math.tau * vigenette_speed) * 0.5 + 0.5
		local vignette_overall = 0.5
		local distortion_speed = 1 / 13
		local distortion_time = math.sin(love.timer.getTime() * math.tau * distortion_speed) * 0.5 + 0.5
		self.shader:send("vignette_scale", math.lerp(0.6, 0.8, vignette_time) * vignette_overall)
		self.shader:send("vignette_darken_scale", math.lerp(0.5, 0.25, vignette_time) * vignette_overall)
		self.shader:send("distortion_scale", math.lerp(0.2, 0.8, distortion_time))
		self.shader:send("time", love.timer.getTime())
		self.shader:send("camera_pos", {cx, cy})
		self.shader:send("camera_scale", 2)
		self.shader:send("last_frame", self.last_frame)
		self.shader:send("blurred", self.blurred)
		self.shader:send("noise_offset", {love.math.random(), love.math.random()})
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(self.canvas)

		love.graphics.setCanvas()
		love.graphics.draw(self.current_frame)
		self.current_frame, self.last_frame = self.last_frame, self.current_frame
	else
		love.graphics.setCanvas()
		love.graphics.draw(self.canvas)
	end
	love.graphics.pop()
end

function state:keypressed(k)
	--hand off to objects
	for _, v in ipairs(self.objects) do
		v:keypressed(k)
	end
end

return state

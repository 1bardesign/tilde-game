local grid = require("grid")

local palette = require("palette.pigment")
local template = require("templates")

local state = class()

--setup instance
function state:new()
	self.background_colour = palette.dark
	self.current_frame = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	self.last_frame = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	self.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
	self.shader = love.graphics.newShader([[
		uniform float vignette_amount;
		uniform vec4 vignette_colour;
		uniform float time;
		uniform vec2 res;
		uniform Image distortion_tex;
		uniform vec2 distortion_res;
		uniform vec2 distortion_flow;

		uniform Image last_frame;

		uniform vec2 camera_pos;
		uniform float camera_scale;

		vec4 effect(vec4 c, Image t, vec2 uv, vec2 px) {
			float d = length(uv - vec2(0.5)) * 2.0;
			float distortion_min = -0.1;
			float distortion_max = 1.5;
			float distortion_amount = clamp(mix(distortion_min, distortion_max, d), 0.0, 1.0);
			float distortion_domainwarp = 35.0;
			float distortion_distance = 5.0;
			float distortion_res_scale = 0.2;
			vec2 pos = (px / camera_scale) - camera_pos;
			vec2 distortion_uv = pos / distortion_res * distortion_res_scale + distortion_flow / distortion_res * time;
			vec2 distortion = vec2(0.0);
			for (int i = 0; i < 5; i++) {
				distortion = (Texel(distortion_tex, distortion_uv).rg - vec2(0.5)) * 2.0;
				distortion_uv = distortion_uv + distortion.yx / distortion_res * distortion_domainwarp;
			}
			//sample
			vec2 uv_distortion_offset = distortion / res * distortion_amount;
			vec4 undistorted = Texel(t, uv + uv_distortion_offset * distortion_distance);
			vec4 distorted = Texel(t, uv);
			c *= mix(undistorted, distorted, 0.2);
			//apply vignette
			c.rgb = mix(c.rgb, vignette_colour.rgb, d * vignette_amount);
			//lerp last frame
			vec2 zoom_uv = uv;
			zoom_uv -= uv_distortion_offset.yx * distortion_distance;
			zoom_uv = (zoom_uv - vec2(0.5)) * 0.975 + vec2(0.5);
			c = mix(c, Texel(last_frame, zoom_uv), mix(0.25, 0.9, d));
			return c;
		}
	]])
	do
		local res = 512
		local id = love.image.newImageData(res, res, "rg8")
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
		self.shader:send("res", {love.graphics.getDimensions()})
		self.shader:send("vignette_colour", {colour.unpack_argb(palette.dark)})
		self.shader:send("distortion_flow", {3.3, 2.3})
	end
end

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
	self.display = require("ascii3d")()
	self.objects = {}
	
	require("generate_world")(self) -- populates the structures below
	assert( self.grid )
	assert( self.spawns )

	local player_spawn = tablex.take_random( self.spawns );
	self.player = require("player")(self, player_spawn )
	table.insert(self.objects, self.player)

	local snake_spawn = tablex.take_random( self.spawns );
	self.snake = require("ohno_a_snake")( self, snake_spawn.x, snake_spawn.y, self.grid )
	table.insert(self.objects, self.snake)
	
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
	--display
	self.display:draw()

	--effects
	love.graphics.setCanvas(self.current_frame)
	love.graphics.setShader(self.shader)
	self.shader:send("vignette_amount", math.lerp(0.6, 0.8, math.sin(love.timer.getTime()) * 0.5 + 0.5))
	self.shader:send("time", love.timer.getTime())
	self.shader:send("camera_pos", {cx, cy})
	self.shader:send("camera_scale", 2)
	self.shader:send("last_frame", self.last_frame)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.origin()
	love.graphics.draw(self.canvas)
	love.graphics.pop()

	love.graphics.draw(self.current_frame)
	self.current_frame, self.last_frame = self.last_frame, self.current_frame
end

function state:keypressed(k)
	--hand off to objects
	for _, v in ipairs(self.objects) do
		v:keypressed(k)
	end
end

return state

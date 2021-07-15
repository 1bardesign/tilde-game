local grid = require("grid")

local state = class()

function state:new()
	--setup instance
end

local flowers = {
	{
		"U  ",
		"| U",
		"  |",
	},
	{
		" U ",
		" | ",
		"   ",
	},
	{
		"   ",
		" U ",
		" | ",
	},
}

local trees = {
	{
		" t ",
		"ttt",
		" | ",
	},
	{
		"ttt",
		"t|t",
		" | ",
	},
}

function state:enter()
	--setup anything to be done on state enter here (ie reset everything)
	self.grid = grid(20, 20)
	self.grid:set(
		1, 1,
		0, 0,
		0,
		"@", 0xffffffff
	)

	for i = 1, 10 do
		self.grid:set_template(
			i, 2,
			0,
			table.pick_random(flowers), 0xff800080
		)
	end
	for i = 1, 10 do
		self.grid:set_template(
			i, 3,
			0,
			table.pick_random(trees), 0xff008000
		)
	end
end

function state:update(dt)
	--update each tick
end

function state:draw()
	self.grid:draw()
end

function state:keypressed(k)
	--handle keypresses
end

return state

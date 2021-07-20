-- Note file encoding is CP-437

local palette = require("src.palette.pigment")

local template = {
	frog = {
		glyph_sit = 'î',
		glyph_anim_head = 'î',
		glyph_anim_legs = 'Í',
	},
	bird = {
		frame_1 = {
			{
				palette.yellow,
				"\\/ ",
				"   ",
				"   ",
			},
		},
		frame_2 = {
			{
				palette.yellow,
				"   ",
				"/\\ ",
				"   ",
			},
		}
	},
	deer = {
		frame_1 = {
			{
				palette.white,
				"    ",
				"    ",
				" " .. string.char(29) .. "  ",
				"Ï   ",
				"    ",
			},
			{
				palette.yellow,
				"    ",
				"    ",
				" €  ",
				" €‹,",
				"    ",
			},
			{
				palette.yellow,
				"    ",
				"    ",
				"    ",
				" €€ ",
				" ÔÔ ",
			},
		},
		frame_2 = {
			{
				palette.white,
				"    ",
				"    ",
				" " .. string.char(29) .. "  ",
				"Ï   ",
				"    ",
			},
			{
				palette.yellow,
				"    ",
				"    ",
				" €  ",
				" €‹,",
				"    ",
			},
			{
				palette.yellow,
				"    ",
				"    ",
				"    ",
				"=€€=",
				"    ",
			},
		},
	},
	snake = {
		head = {
			{
				palette.purple,
				"   ",
				"| |",
				"   ",
			},
			{
				palette.white,
				"   ",
				" ß ",
				"   ",
			},
			{
				palette.yellow,
				"< >",
				"| |",
				"---",
			},
			{
				palette.white,
				"   ",
				"   ",
				"   ",
			},
		},
		body = {
			n = {
				{
					palette.yellow,
					"√ ¥",
					"√ ¥",
					"   ",
				},

				{
					palette.white,
					"   ",
					"| |",
					"   ",
				},

				{
					palette.purple,
					"   ",
					"   ",
					"~~~",
				},
			},
			s = {
				{
					palette.yellow,
					"√ ¥",
					"√ ¥",
					"   ",
				},

				{
					palette.white,
					"   ",
					"| |",
					"   ",
				},
				
				{
					palette.purple,
					"   ",
					"   ",
					"~~~",
				},
			},
			e = {
				{
					palette.yellow,
					"   ",
					"-~-",
					"   ",
				},

				{
					palette.yellow,
					"   ",
					"   ",
					"mmm",
				},
				
				{
					palette.purple,
					"   ",
					"   ",
					"~~~",
				},
			},
			w = {
				{
					palette.yellow,
					"   ",
					"-~-",
					"   ",
				},

				{
					palette.yellow,
					"   ",
					"   ",
					"mmm",
				},
				
				{
					palette.purple,
					"   ",
					"   ",
					"~~~",
				},
			},
		},
		tail = {
			n = {
				{
					palette.yellow,
					"\\ /",
					" o ",
					"   ",
				},
				{
					palette.yellow,
					"   ",
					"   ",
					"   ",
				},
			},
			s = {
				{
					palette.yellow,
					" o ",
					"/ \\",
					"   ",
				},
				{
					palette.yellow,
					"   ",
					"   ",
					"   ",
				},
			},
			e = {
				{
					palette.yellow,
					" o-",
					"  \\",
					"   ",
				},
			},
			w = {
				{
					palette.yellow,
					"-o ",
					"/  ",
					"   ",
				},
			}
		},
	},
}

return template

-- Note file encoding is CP-437

local palette = require("palette.pigment")

local template = {
	frog = {
		glyph_sit = '”',
		glyph_anim_head = '”',
		glyph_anim_legs = 'ê',
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
				" § ",
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
					"Ã ´",
					"Ã ´",
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
					"Ã ´",
					"Ã ´",
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

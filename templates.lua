-- Note file encoding is CP-437

local palette = require("palette.pigment")

local template = {
	player = {
		{
			palette.white,
			"   ",
			" " .. string.char( 1 ) .. " ",
			"   ",
		},
		{
			palette.grey,
			"   ",
			" " .. string.char( 19 ) .. " ",
			"   ",
		},
	},
	flowers = {
		{
			{
				palette.purple,
				"   ",
				"U  ",
				"   ",
			},
			{
				palette.fawn,
				"   ",
				"|  ",
				"   ",
			},
		},
		{
			{
				palette.purple,
				"   ",
				"   ",
				"  U",
			},
			{
				palette.fawn,
				"   ",
				"   ",
				"  |",
			},
		},
		{
			{
				palette.purple,
				"   ",
				" U ",
				"   ",
			},
			{
				palette.fawn,
				"   ",
				" | ",
				"   ",
			},
		},
		{
			{
				palette.fawn,
				"   ",
				" ù ",
				"   ",
			},
		},
		{
			{
				palette.fawn,
				"  ù",
				"   ",
				"ù  ",
			},
		},
		{
			{
				palette.yellow,
				"   ",
				" O ",
				"   ",
			},
			{
				palette.green,
				"   ",
				" v ",
				"   ",
			},
		},
		{
			{
				palette.yellow,
				"   ",
				"O  ",
				"  O",
			},
			{
				palette.green,
				"   ",
				"v  ",
				"  v",
			},
		},
	},
	tree = {
		{
			{
				palette.green,
				"∞∞∞∞∞",
				"∞∞∞∞∞",
				"     ",
			},
			{
				palette.brown,
				"   ",
				" ∫Ÿ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
		},
		{
			{
				palette.green,
				" ∞∞∞ ",
				"∞∞∞∞∞",
				"     ",
			},
			{
				palette.brown,
				"   ",
				"¿∫ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ∫Ÿ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
		},
		{
			{
				palette.green,
				" ∞∞∞ ",
				"∞∞∞∞∞",
				" ∞ ∞ ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				"¿∫ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
		},
		{
			{
				palette.green,
				-- TODO: nicer way
				"  " .. string.char( 30 ) .. "  ",
				" " .. string.char( 30 ) .. string.char( 30 ) .. string.char( 30 ) .. " ",
				" " .. string.char( 30 ) .. string.char( 30 ) .. string.char( 30 ) .. " ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ∫ ",
				"   ",
			},
		},
	},
	grass = {
		{
			{
				palette.fawn,
				",  ",
				"   ",
				"   ",
			},
		},
		{
			{
				palette.fawn,
				"   ",
				",, ",
				"   ",
			},
		},
		{
			{
				palette.fawn,
				"   ",
				"   ",
				"  ,",
			},
		},
		{
			{
				palette.fawn,
				" ,,",
				" ,,",
				"   ",
			},
		},
	},	
	rocks = {
		{
			{
				palette.grey,
				"‹≤≤",
				"≤≤≤",
				"≤≤≤",
			},
		},
		{
			{
				palette.grey,
				"±±±",
				"±±±",
				"±±±",
			},
		},
		{
			{
				palette.grey,
				"±±±",
				"≤≤±",
				"≤≤≤",
			},
		},
		{
			{
				palette.grey,
				"±± ",
				"±±±",
				"±≤≤",
			},
		},
		{
			{
				palette.grey,
				"   ",
				" ±±",
				"±±±",
			},
		},
		{
			{
				palette.grey,
				"   ",
				" ±‹",
				"±±±",
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
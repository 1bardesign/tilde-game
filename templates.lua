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
				palette.purple,
				"   ",
				" ? ",
				"   ",
			},
		},
		{
			{
				palette.purple,
				"   ",
				"?  ",
				"  ?",
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
				palette.fawn,
				"≤≤≤",
				"≤≤≤",
				"≤≤≤",
			},
		},
	}
}

return template
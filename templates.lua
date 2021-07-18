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
	mushrooms = {
		{
			{
				palette.purple,
				"   ",
				" " .. string.char(24) .. " ",
				"   ",
			},
		},
		{
			{
				palette.purple,
				string.char(24) .. "  ",
				"   ",
				"  " .. string.char(24)
			},
		},
		{
			{
				palette.purple,
				"  " .. string.char(24),
				"   ",
				string.char(24) .. "  ",
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
	tree_2 = {
		{
			{
				palette.white,
				"∞∞∞∞∞",
				"∞∞∞∞∞",
				"     ",
			},
			{
				palette.purple,
				"   ",
				" ∫Ÿ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" ∫ ",
				"   ",
			},
		},
		{
			{
				palette.white,
				" ∞∞∞ ",
				"∞∞∞∞∞",
				"     ",
			},
			{
				palette.purple,
				"   ",
				"¿∫ ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" ∫Ÿ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" ∫ ",
				"   ",
			},
		},
		{
			{
				palette.white,
				" ∞∞∞ ",
				"∞∞∞∞∞",
				" ∞ ∞ ",
			},
			{
				palette.purple,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				"¿∫ ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" ∫ ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" ∫ ",
				"   ",
			},
		},
	},
	grass = {
		check_1 = {
			{
				{
					palette.fawn,
					", ,",
					" , ",
					", ,",
				},
			},
			{
				{
					palette.fawn,
					", ,",
					" , ",
					", ,",
				},
			},
			{
				{
					palette.fawn,
					", ,",
					" , ",
					", ,",
				},
			},
			{
				{
					palette.fawn,
					", ,",
					",, ",
					",,,",
				},
			},
			{
				{
					palette.fawn,
					",,,",
					",,,",
					",,,",
				},
			},
			{
				{
					palette.fawn,
					", ,",
					"   ",
					", ,",
				},
			},
		},
		check_2 = {
			{
				{
					palette.fawn,
					" , ",
					", ,",
					" , ",
				},
			},
			{
				{
					palette.fawn,
					" , ",
					", ,",
					" , ",
				},
			},
			{
				{
					palette.fawn,
					" , ",
					", ,",
					" , ",
				},
			},
			{
				{
					palette.fawn,
					",,,",
					",,,",
					",,,",
				},
			},
			{
				{
					palette.fawn,
					"   ",
					", ,",
					" , ",
				},
			},
		},
		misc = {
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
					"   ",
					"   ",
					"  v",
				},
			},
			{
				{
					palette.fawn,
					"   ",
					",  ",
					"   ",
				},
			},
			{
				{
					palette.fawn,
					"  ,",
					" , ",
					"   ",
				},
			},
		}
	},	
	rock_full = {
		{
			{
				palette.grey,
				"≤≤≤",
				"≤≤≤",
				"≤≤≤",
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
	rock_footings = {
		{
			{
				palette.grey,
				"≤≤≤",
				"≤≤≤",
				"±≤≤",
			},
		},
		{
			{
				palette.grey,
				"≤≤≤",
				"≤≤≤",
				"±≤±",
			},
		},
		{
			{
				palette.grey,
				"≤≤≤",
				"≤≤≤",
				"±ﬂ±",
			},
		},
	},
	boulders = {
		{
			{
				palette.grey,
				"  ‹",
				"‹‹ ",
				"±± ",
			},
		},
		{
			{
				palette.grey,
				" ‹ ",
				"‹± ",
				"±± ",
			},
		},
		{
			{
				palette.grey,
				"‹  ",
				" ‹‹",
				" ±±",
			},
		},
	},
	water = {
		{
			{
				palette.blue,
				"   ",
				"   ",
				"   ",
			},
			{
				palette.blue,
				"˜˜˜",
				"˜˜˜",
				"˜˜˜",
			},
		},
	},
	water_weed = {
		{
			{
				palette.green,
				",  ",
				"|  ",
				"  ,",
				"  .",
			},
			{
				palette.blue,
				"˜˜˜",
				"˜˜˜",
				"˜˜˜",
			},
		},
		{
			{
				palette.green,
				"   ",
				" , ",
				" | ",
				",  ",
			},
			{
				palette.blue,
				"˜˜˜",
				"˜˜˜",
				"˜˜˜",
			},
		},
		{
			{
				palette.purple,
				"   ",
				",  ",
				palette.green,
				"| ,",
				" ,|",
			},
			{
				palette.blue,
				"˜˜˜",
				"˜˜˜",
				"˜˜˜",
			},
		},
		{
			{
				palette.green,
				" , ",
				" | ",
				palette.purple,
				",  ",
				palette.green,
				"|  ",
			},
			{
				palette.blue,
				"˜˜˜",
				"˜˜˜",
				"˜˜˜",
			},
		},
	},
	shoreline = {
		u = {
			{
				{
					palette.green,
					", ,",
					" , ",
					"   ",
				},
			},
			{
				{
					palette.fawn,
					", ,",
					" , ",
					"   ",
				},
			},
		},
		d = {
			{
				{
					palette.green,
					"   ",
					" , ",
					", ,",
				}
			},
			{
				{
					palette.fawn,
					"   ",
					" , ",
					", ,",
				}
			},
		},
		l = {
			{
				{
					palette.green,
					",  ",
					" , ",
					",  ",
				}
			},
			{
				{
					palette.fawn,
					",  ",
					" , ",
					",  ",
				}
			},
		},
		r = {
			{
				{
					palette.green,
					"  ,",
					" , ",
					"  ,",
				}
			},
			{
				{
					palette.fawn,
					"  ,",
					" , ",
					"  ,",
				}
			},
		},
	},
	path = {
		{
			{
				palette.dark_lighter,
				"∞∞∞",
				"∞∞∞",
				"∞∞∞",
			},
		},
		{
			{
				palette.dark_lighter,
				"∞∞ ",
				"∞ ∞",
				"  ∞",
			},
		},
		{
			{
				palette.dark_lighter,
				" ∞ ",
				"∞∞ ",
				" ∞∞",
			},
		},
		{
			{
				palette.dark_lighter,
				" ∞ ",
				"∞ ∞",
				" ∞",
			},
		},
		{
			{
				palette.dark_lighter,
				"∞ ∞",
				" ∞ ",
				"∞ ∞",
			},
		},
	},
	bridge = {
		vertical = {
			{
				palette.brown,
				"∫±∫",
				"∫±∫",
				"∫±∫",
			},
		},
		horizontal = {
			{
				palette.brown,
				"ÕÕÕ",
				"±±±",
				"ÕÀÕ",
			},
		},
	},
	house = {
		door = {
			{
				palette.brown,
				"   ",
				"‹‹‹",
			},
			{
				palette.brown,
				"   ",
				"ÀÕÀ",
			},
			{
				palette.brown,
				"   ",
				"∫ ∫",
			},
			{
				palette.brown,
				"   ",
				"∫ ∫",
			},
		},
		wall = {
			{
				{
					palette.brown,
					"   ",
					"…Õª",
				},
				{
					palette.brown,
					"   ",
					"π±Ã",
				},
				{
					palette.brown,
					"   ",
					"∫±∫",
				},
				{
					palette.brown,
					"   ",
					"‹‹‹",
				},
			},
			{
				{
					palette.brown,
					"   ",
					"…Õª",
				},
				{
					palette.brown,
					"   ",
					"π‹Ã",
				},
				{
					palette.brown,
					"   ",
					"∫ ∫",
				},
				{
					palette.brown,
					"   ",
					"‹‹‹",
				},
			},
			{
				{
					palette.brown,
					"   ",
					"…Õª",
				},
				{
					palette.brown,
					"   ",
					"π∫Ã",
				},
				{
					palette.brown,
					"   ",
					"∫∫∫",
				},
				{
					palette.brown,
					"   ",
					"‹‹‹",
				},
			},
		},
		roof = {
			{
				palette.yellow,
				"±±±",
				"±±±",
				"±±±",
			},
			{
				palette.yellow,
				"   ",
				"   ",
				"   ",
			},
		},
		roof_top = {
			{
				palette.yellow,
				"",
				"±±±",
				"±±±",
			},
			{
				palette.yellow,
				"   ",
				"   ",
				"   ",
			},
		},
		roof_trim = {
			{
				palette.yellow,
				"---",
				"±±±",
				"±±±",
			},
			{
				palette.yellow,
				"   ",
				"   ",
				"   ",
			},
		},
	}
}

return template

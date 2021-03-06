-- Note file encoding is CP-437

local palette = require("src.palette.pigment")

local template = {
	player = {

		{
			palette.white,
			string.char( 1 ),
		},
		-- {
		-- 	palette.yellow,
		-- 	"Ϋ",
		-- },
		{
			palette.grey,
			string.char( 19 ),
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
				"  ",
				"   ",
			},
		},
		{
			{
				palette.fawn,
				"  ",
				"   ",
				"  ",
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
	crop = {
		{
			{
				palette.yellow,
				"*",
			},
			{
				palette.green,
				"",
			},
			{
				palette.green,
				"",
			},
		},
		{
			{
				palette.green,
				",",
			},
			{
				palette.green,
				"",
			},
			{
				palette.green,
				"",
			},
		},
		{
			{
				palette.yellow,
				"*",
			},
			{
				palette.green,
				"",
			},
		},
		{
			{
				palette.green,
				",",
			},
			{
				palette.green,
				"",
			},
		},
	},
	tree = {
		{
			{
				palette.green,
				"°°°°°",
				"°°°°°",
				"     ",
			},
			{
				palette.brown,
				"   ",
				" ΊΩ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" Ί ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" Ί ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" Ί ",
				"   ",
			},
		},
		{
			{
				palette.green,
				" °°° ",
				"°°°°°",
				"     ",
			},
			{
				palette.brown,
				"   ",
				"ΐΊ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" ΊΩ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" Ί ",
				"   ",
			},
		},
		{
			{
				palette.green,
				" °°° ",
				"°°°°°",
				" ° ° ",
			},
			{
				palette.brown,
				"   ",
				" Ί ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				"ΐΊ ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" Ί ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" Ί ",
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
				" Ί ",
				"   ",
			},
			{
				palette.brown,
				"   ",
				" Ί ",
				"   ",
			},
		},
	},
	tree_2 = {
		{
			{
				palette.white,
				"°°°°°",
				"°°°°°",
				"     ",
			},
			{
				palette.purple,
				"   ",
				" ΊΩ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" Ί ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" Ί ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" Ί ",
				"   ",
			},
		},
		{
			{
				palette.white,
				" °°° ",
				"°°°°°",
				"     ",
			},
			{
				palette.purple,
				"   ",
				"ΐΊ ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" ΊΩ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" Ί ",
				"   ",
			},
		},
		{
			{
				palette.white,
				" °°° ",
				"°°°°°",
				" ° ° ",
			},
			{
				palette.purple,
				"   ",
				" Ί ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				"ΐΊ ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" Ί ",
				"   ",
			},
			{
				palette.purple,
				"   ",
				" Ί ",
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
				"²²²",
				"²²²",
				"²²²",
			},
		},
	},
	rocks = {
		{
			{
				palette.grey,
				"ά²²",
				"²²²",
				"²²²",
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
				"²²±",
				"²²²",
			},
		},
		{
			{
				palette.grey,
				"±± ",
				"±±±",
				"±²²",
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
				" ±ά",
				"±±±",
			},
		},
	},
	rock_footings = {
		{
			{
				palette.grey,
				"²²²",
				"²²²",
				"±²²",
			},
		},
		{
			{
				palette.grey,
				"²²²",
				"²²²",
				"±²±",
			},
		},
		{
			{
				palette.grey,
				"²²²",
				"²²²",
				"±ί±",
			},
		},
	},
	boulders = {
		{
			{
				palette.grey,
				" ±²",
				"ά±±",
				"²² ",
			},
		},
		{
			{
				palette.grey,
				" ά ",
				"±² ",
				"²²±",
			},
		},
		{
			{
				palette.grey,
				"ά  ",
				"± ±",
				" ²²",
			},
		},
		{
			{
				palette.grey,
				" ά ",
				"  ά",
				"ά²²",
			},
		},
		{
			{
				palette.grey,
				"  ά",
				" ²²",
				" ά ",
			},
		},
		{
			{
				palette.grey,
				"ά  ",
				"²² ",
				"  ά",
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
				"χχχ",
				"χχχ",
				"χχχ",
			},
		},
	},
	waterfall = {
		{
			{
				palette.dark,
				"άΫά",
				palette.blue,
				"χχχ",
				palette.grey,
				"   ",
			},
			{
				palette.dark,
				"ΫΫΫ",
				palette.blue,
				"vvv",
				palette.grey,
				"   ",
			},
			{
				palette.dark,
				"ΫΫΫ",
				palette.blue,
				"vvv",
				palette.grey,
				"   ",
			},
			{
				palette.dark,
				"ΫΫΫ",
				palette.blue,
				"vvv",
				palette.grey,
				"   ",
			},
			{
				palette.blue,
				"vvv",
				"±±±",
				"χχχ",
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
				"χχχ",
				"χχχ",
				"χχχ",
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
				"χχχ",
				"χχχ",
				"χχχ",
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
				"χχχ",
				"χχχ",
				"χχχ",
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
				"χχχ",
				"χχχ",
				"χχχ",
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
				"°°°",
				"°°°",
				"°°°",
			},
		},
		{
			{
				palette.dark_lighter,
				"°° ",
				"° °",
				"  °",
			},
		},
		{
			{
				palette.dark_lighter,
				" ° ",
				"°° ",
				" °°",
			},
		},
		{
			{
				palette.dark_lighter,
				" ° ",
				"° °",
				" °",
			},
		},
		{
			{
				palette.dark_lighter,
				"° °",
				" ° ",
				"° °",
			},
		},
	},
	bridge = {
		vertical = {
			{
				palette.brown,
				"Ί±Ί",
				"Ί±Ί",
				"Ί±Ί",
			},
		},
		horizontal = {
			{
				palette.brown,
				"ΝΝΝ",
				"±±±",
				"ΝΛΝ",
			},
		},
	},
	house = {
		door = {
			{
				palette.brown,
				"   ",
				"άάά",
			},
			{
				palette.brown,
				"   ",
				"ΛΝΛ",
			},
			{
				palette.brown,
				"   ",
				"Ί Ί",
			},
			{
				palette.brown,
				"   ",
				"Ί Ί",
			},
		},
		wall = {
			{
				{
					palette.brown,
					"   ",
					"ΙΝ»",
				},
				{
					palette.brown,
					"   ",
					"Ή±Μ",
				},
				{
					palette.brown,
					"   ",
					"Ί±Ί",
				},
				{
					palette.brown,
					"   ",
					"άάά",
				},
			},
			{
				{
					palette.brown,
					"   ",
					"ΙΝ»",
				},
				{
					palette.brown,
					"   ",
					"ΉάΜ",
				},
				{
					palette.brown,
					"   ",
					"Ί Ί",
				},
				{
					palette.brown,
					"   ",
					"άάά",
				},
			},
			{
				{
					palette.brown,
					"   ",
					"ΙΝ»",
				},
				{
					palette.brown,
					"   ",
					"ΉΊΜ",
				},
				{
					palette.brown,
					"   ",
					"ΊΊΊ",
				},
				{
					palette.brown,
					"   ",
					"άάά",
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
				"πππ",
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

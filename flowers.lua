local Palette = {
    FlowerPurple = nil,
}; -- imported
local Sprite = {
    ascii = function( char )
        return char;
    end
}; -- imported

-- Generic flower functions
local function Flower3x3( template, colour )
    return {
        radius = 0,
        depth = 3,
        get = function( self, dx, dy, i, j )
            local char = template[j]:sub( i );
            if char then
                return { Sprite.ascii( char ), colour, nil };
            end
        end
    };
end

local function Flower1x1( char, colour )
    return {
        radius = 0,
        depth = 1,
        get = function( self, dx, dy, i, j )
            return { Sprite.ascii( char ), colour, nil };
        end
    };
end

-- Specific flower types
local Flowers = { 
    Test = Flower1x1( 'x', Palette.FlowerPurple ),
    Tulip = Flower3x3( { '   ','U U', '| |' }, Palette.FlowerPurple ),
};

-- Adds glyphs to world
local function AddFlower( world, x, y, flower )
    local r = flower.radius;
    local d = flower.depth;
    for dx=-r,r do
        for dy=-r,r do
            for i=1,d do
                for j=1,d do
                    if world:isValidCoord( x + dx, y + dy ) then
                        local glyph = flower:get( dx, dy, i, j );
                        if glyph then
                            local coord = { x + dx, y + dy, i, j }; -- Coord ( x, y, subx, suby)
                            world:setDepth( x + dx, y + dy, d );
                            world:setGlyph( coord, glyph );
                        end
                    end
                end
            end
        end
    end
end

local function Test()
    -- Test interface
    local width = 5;
    local height = 5;
    local world = {
        width = width,
        height = height,
        glyphs = {},
        depths = {},
        isValidCoord = function( self, x, y )
            return x > 0 and x < self.width and y > 0 and y < self.height;
        end,
        setDepth = function( self, x, y, depth )
            self.depths[ x + y * self.width ] = depth;
        end,
        setGlyph = function( self, coord, glyph )
            -- TODO: support sub glyphs
            self.glyphs[ coord[1] + coord[2] * self.width ] = glyph;
        end
    };

    AddFlower( world, 1, 1, Flowers.Test );
    AddFlower( world, 3, 3, Flowers.Test );
    AddFlower( world, 4, 2, Flowers.Test );
    AddFlower( world, 2, 4, Flowers.Tulip );

    local output = "";
    for y=1,world.height do
        for x=1,world.width do
            local glyph = world.glyphs[ x + y * world.width ];
            local depth = world.depths[ x + y * world.width ];
            if depth == nil or depth == 1 then
                output = output .. ( glyph and glyph[1] or '.' );
            else
                output = output .. '#'; -- '#' indicates deeper cell
            end
        end
        output = output .. '\n';
    end
    print( output );
end

Test();

local world_pos = class()

function world_pos:new( x, y, dx, dy )
	self.p = vec2( x, y );
	self.d = vec2( dx, dy );
end

function world_pos:copy()
	return world_pos( self.p.x, self.p.y, self.d.x, self.d.y )
end

function world_pos:add( pdir, ddir )
	local new_pos = self:copy()

	if pdir then
		new_pos.p:vaddi( pdir )
	end
	
	if ddir then
		new_pos.d:vaddi( ddir )
		-- Wrap
		if new_pos.d.x < 1 then
			new_pos.p.x = new_pos.p.x - 1
			new_pos.d.x = 3
		elseif new_pos.d.x > 3 then
			new_pos.p.x = new_pos.p.x + 1
			new_pos.d.x = 1
		end

		-- Wrap
		if new_pos.d.y < 1 then
			new_pos.p.y = new_pos.p.y - 1
			new_pos.d.y = 3
		elseif new_pos.d.y > 3 then
			new_pos.p.y = new_pos.p.y + 1
			new_pos.d.y = 1
		end
	end

	return new_pos
end

function world_pos:to_world_coords( cell_size )
	return self.p:vmul(cell_size):vadd(self.d)
end


return world_pos;


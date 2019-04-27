--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Tile = Class{}

function Tile:init(x, y, name, frame, type)
    self.x = x
    self.y = y
    self.name = name
    self.io = TILE_INFO[self.name].io
    self.type = type or TILE_INFO[self.name].defaultType
    self.frame = frame
end

function Tile:update(dt)

end

function Tile:render()
	--[[print(self.io)
	print(self.name)
	print(self.type)
	print(self.frame)
	print(gFrames[self.io])
	print(gFrames[self.io][self.name])
	print(gFrames[self.io][self.name][self.type])
	print(gFrames[self.io][self.name][self.type][self.frame])]]
	love.graphics.draw(gTextures[self.io], gFrames[self.io][self.name][self.type][self.frame],
	(self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
end

function Tile:updateQuad(tiles)
	local above = ''
    local below = ''
    local right = ''
    local left = ''
    local top_right = ''
    local bottom_right = ''
    local bottom_left = ''
    local top_left = ''

    -- get name of surrounding tiles
    if tiles[self.y - 1] then
    	if tiles[self.y - 1][self.x] then
        	above = tiles[self.y - 1][self.x].name
       	end

       	if tiles[self.y - 1][self.x + 1] then
       	    top_right = tiles[self.y - 1][self.x + 1].name
       	end

       	if tiles[self.y - 1][self.x - 1] then
       	    top_left = tiles[self.y - 1][self.x - 1].name
       	end       	
    end

    if tiles[self.y + 1] then
    	if tiles[self.y + 1][self.x] then
        	below = tiles[self.y + 1][self.x].name
    	end

    	if tiles[self.y + 1][self.x + 1] then
    	    bottom_right = tiles[self.y + 1][self.x + 1].name
    	end

    	if tiles[self.y + 1][self.x - 1] then
    	    bottom_left = tiles[self.y + 1][self.x - 1].name
    	end
    end

    if tiles[self.y][self.x + 1] then
        right = tiles[self.y][self.x + 1].name
    end

    if tiles[self.y][self.x - 1] then
        left = tiles[self.y][self.x - 1].name
    end

    if self.name == 'grass' then
    	self:grassFindQuad(above, right, below, left, top_right, bottom_right, bottom_left, top_left)
    elseif self.name == 'sand' then
    	self:sandFindQuad(above, right, below, left, top_right, bottom_right, bottom_left, top_left)
    end
end

function Tile:grassFindQuad(above, right, below, left, top_right, bottom_right, bottom_left, top_left)
	-- find right frame based on surrounding names
	if self:checkGrass(above) then
	    if self:checkGrass(right) then
	        if self:checkGrass(below) then
	            if self:checkGrass(left) then
	                --check corners
	                if self:checkGrass(top_right) then
	                    if self:checkGrass(bottom_right) then
	                        if self:checkGrass(bottom_left) then
	                            if self:checkGrass(top_left) then
	                                self.frame = TILE_INFO['grass']['getFrame']()
	                            elseif top_left == 'sand' then
	                                self.frame = 71
	                            end
	                        -- bottom_left == 'sand'
	                        else
	                        	if self:checkGrass(top_left) then
	                        		self.frame = 55
	                        	elseif top_left == 'sand' then
	                        		print('error, quad non-existent for both top_left and bottom_left sand')
	                        	end
	                        end
	                    -- bottom_right == 'sand'
	                    elseif self:checkGrass(bottom_left) then
	                        if self:checkGrass(top_left) then
	                            self.frame = 53
	                        else
	                            print('error, quad non-existent for both top_left and bottom_right sand')
	                        end
	                    -- bottom_left == 'sand'
	                    elseif self:checkGrass(top_left) then
	                    	print('error, quad non-existent for both bottom_left and bottom_right sand')
	                    else
	                        print('error, quad non-existent for both bottom_left and bottom_right and top_left sand')
	                    end
	                -- top_right == 'sand'
	                elseif self:checkGrass(bottom_right) then
	                    if self:checkGrass(bottom_left) then
	                        if self:checkGrass(top_left) then
	                            self.frame = 69
	                        else
	                            print('error, quad non-existent for both top_left and top_right sand')
	                        end
	                    -- bottom_left == 'sand'
	                    elseif self:checkGrass(top_left) then
	                        print('error, quad non-existent for both top_right and bottom_left sand')
	                    else
	                        print('error, quad non-existent for both top_right and bottom_left and top_left sand')
	                    end
	                -- bottom_right == 'sand'
	                elseif self:checkGrass(bottom_left) then
	                    if self:checkGrass(top_left) then
	                        print('error, quad non-existent for both top_right and bottom_right sand')
	                    else
	                        print('error, quad non-existent for both top_right and bottom_right and top_left sand')
	                    end
	                -- bottom_left == 'sand'
	                elseif self:checkGrass(top_left) then
	                    print('error, quad non-existent for both top_right and bottom_right and bottom_left sand')
	                else
	                    print('error, quad non-existent for all corners sand')
	                end
	                -- end check corners

	            -- left == 'sand'
	            else
	                -- check corners						-- this chunk cuts some corners since tile sheet is missing some tiles
	                if self:checkGrass(top_right) then
	                    if self:checkGrass(bottom_right) then
	                        self.frame = 63
	                    else
	                        print('error, quad non-existent for left and bottom_right sand')
	                    end
	                elseif self:checkGrass(bottom_right) then
	                	print('error, quad non-existent for left and top_right sand')
	                else
	                    print('error, quad non-existent for left and top_right and bottom_right sand')
	                end
	                -- end check corners
	            end
	        -- below == 'sand'
	        elseif self:checkGrass(left) then
	            -- check corners
	            if top_right then
	                if top_left then
	                    self.frame = 30
	                else
	                    self.frame = 31
	                end
	            elseif top_left then
	                self.frame = 32
	            else
	                self.frame = 29
	            end
	            -- end check corners

	        -- left == 'sand'
	        else
	            -- check corners
	            if top_right then
	                self.frame = 10
	            else
	                self.frame = 9
	            end
	            -- end check corners

	        end
	    elseif below then
	        if left then
	            -- check corners
	            if top_left then
	                if bottom_left then
	                    self.frame = 26
	                else
	                    self.frame = 28
	                end
	            elseif bottom_left then
	                self.frame = 27
	            else
	                self.frame = 25
	            end
	            -- end check corners

	        else
	            self.frame = 6
	        end
	    elseif left then
	        -- check corners
	        if top_left then
	            self.frame = 16
	        else
	            self.frame = 15
	        end
	        -- end check corners

	    else
	        self.frame = 2
	    end
	elseif right then
	    if below then
	        if left then
	            -- check corners
	            if bottom_right then
	                if bottom_left then
	                    self.frame = 22
	                else
	                    self.frame = 23
	                end
	            elseif bottom_left then
	                self.frame = 24
	            else
	                self.frame = 21
	            end
	            -- end check corners

	        else
	            -- check corners
	            if bottom_right then
	                self.frame = 12
	            else
	                self.frame = 11
	            end
	            -- end check corners

	        end
	    elseif left then
	        self.frame = 7
	    else
	        self.frame = 3
	    end
	elseif below then
	    if left then
	        -- check corners
	        if bottom_left then
	            self.frame = 14
	        else
	            self.frame = 13
	        end
	        -- end check corners

	    else
	        self.frame = 4
	    end
	elseif left then
	    self.frame = 5
	else
	    self.frame = 1
	end
end

function Tile:checkGrass(name)
	return (name == 'grass' or name == 'small-ledge' or name == 'ledge')
end
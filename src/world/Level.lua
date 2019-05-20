--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Level = Class{}

function Level:init(width, height)
    self.width = width
    self.height = height

    -- for map making
    self.layer = 'base'
    self.name = TILE_NAMES[self.layer][1]
    self.type = 1
    self.frame = 1

    self:createMaps()

    self.currentLayer = self.baseLayer

    self.player = Player {
        level = self,
        type = 'player',
        name = 'Juan',
        gender = 'boy',
        animations = ENTITY_DEFS['player']['boy'].animations,
        mapX = 1,
        mapY = 10,
        width = ENTITY_DEFS['player']['boy'].width,
        height = ENTITY_DEFS['player']['boy'].height,
        xOffset = ENTITY_DEFS['player']['boy'].xOffset,
        yOffset = ENTITY_DEFS['player']['boy'].yOffset
    }

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }
    self.player.stateMachine:change('idle')

    camX = math.floor(self.player.x + self.player.width / 2) - VIRTUAL_WIDTH / 2
    camY = math.floor(self.player.y + self.player.height / 2) - VIRTUAL_HEIGHT / 2

    self.mouseGridX = math.floor(gMouse.x / TILE_SIZE) + 1
    self.mouseGridY = math.floor(gMouse.y / TILE_SIZE) + 1

    self.currentFMSelection = 1
    self.currentPocket = 1
end

function Level:createMaps()
    self.baseLayer = TileMap(self.width, self.height)
    self.secondLayer = TileMap(self.width, self.height)

    -- fill the base tiles table with random grass IDs
    for y = 1, self.height do
        table.insert(self.baseLayer.tiles, {})

        for x = 1, self.width do
            table.insert(self.baseLayer.tiles[y], Tile(x, y, 'grass', self.frame))
        end
    end

    -- place tall grass in the tall grass layer
    for y = 11, self.height do
        self.secondLayer.tiles[y] = {}

        for x = 1, self.width do
            table.insert(self.secondLayer.tiles[y], Tile(x, y, 'tall-grass', self.frame))
        end
    end
end

function Level:update(dt)
	camX = math.floor(self.player.x + self.player.width / 2) - VIRTUAL_WIDTH / 2
	camY = math.floor(self.player.y + self.player.height / 2) - VIRTUAL_HEIGHT / 2

    self.player:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(MenuState{
            closeable = true,
            menu = Menu {
                x = VIRTUAL_WIDTH - 90,
                y = 2,
                width = 90,
                height = VIRTUAL_HEIGHT / 2,
                rows = #self.player.fieldMenuItems,
                columns = 1,
                numDispRows = #self.player.fieldMenuItems - 2,
                numDispColumns = 1,
                items = self.player.fieldMenuItems,
                currentSelection = self.currentFMSelection,
                type = 'scroll',
            }
        })
    end

    self:changeMap()
end

function Level:render()
    --love.graphics.print('x: ' .. gMouse.mapX .. ', y: ' .. gMouse.mapY, 10, 30)

    -- make player in center
    love.graphics.push()
    love.graphics.translate(-camX, -camY)

    self.baseLayer:render()
    self.secondLayer:render()
    self.player:render()

    -- render grass on top of player
    if self.secondLayer.tiles[self.player.mapY] and
        self.secondLayer.tiles[self.player.mapY][self.player.mapX] and
        self.secondLayer.tiles[self.player.mapY][self.player.mapX].name == 'tall-grass' and
        not (self.player.stateMachine.currentStateName == 'walk' and self.player.direction == 'up') then

        love.graphics.draw(gTextures['outside'], gFrames['outside']['half-tall-grass'][1][1],
            (self.player.mapX - 1) * TILE_SIZE, (self.player.mapY - 1) * TILE_SIZE)
    end

    -- if player is walking, render grass on the tile player is walking to
    if self.player.stateMachine.currentStateName == 'walk' and
        (self.player.direction == 'left' or self.player.direction == 'right') and
        self.secondLayer.tiles[self.player.mapY] and
        self.secondLayer.tiles[self.player.mapY] [self.player.mapX - DIRECTION_TO_COORDS[self.player.direction]['x']] and
        self.secondLayer.tiles[self.player.mapY] [self.player.mapX - DIRECTION_TO_COORDS[self.player.direction]['x']].name == 'tall-grass' then

        love.graphics.draw(gTextures['outside'], gFrames['outside']['half-tall-grass'][1][1],
            (self.player.mapX - DIRECTION_TO_COORDS[self.player.direction]['x'] - 1) * TILE_SIZE, (self.player.mapY - 1) * TILE_SIZE)
    end

    -- remove translate so everything else is in right position
    love.graphics.pop()

    -- render tile menu
    for k, tile in pairs(gFrames['outside'][self.name][self.type]) do
        love.graphics.draw(gTextures['outside'], tile, ((k - 1) % 8) * TILE_SIZE, math.floor((k - 1) / 8) * TILE_SIZE)
        --print('x: ' .. ((k - 1) % 8) * TILE_SIZE)
        --print('y: ' .. math.floor((k - 1) / 8) * TILE_SIZE)
    end

    local frameX = (self.frame - 1) % 8 * TILE_SIZE
    local frameY = (math.ceil(self.frame / 8) - 1) * TILE_SIZE

    -- frame selector
    love.graphics.setColor(1, 0, 1, 1)
    love.graphics.line(frameX, frameY, frameX, frameY + TILE_SIZE, frameX + TILE_SIZE, frameY + TILE_SIZE, frameX + TILE_SIZE, frameY, frameX, frameY)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(gFonts['small'])
    love.graphics.print(self.layer, 5, 10)
    love.graphics.print(self.name, 5, 20)
    love.graphics.print(self.type, 5, 30)
    love.graphics.print(self.frame, 5, 40)
    love.graphics.print(gMouse.x, 5, 50)
    love.graphics.print(gMouse.y, 5, 60)
    love.graphics.print(gMouse.mapX, 5, 70)
    love.graphics.print(gMouse.mapY, 5, 80)
    love.graphics.print(self.mouseGridX, 5, 90)
    love.graphics.print(self.mouseGridY, 5, 100)
    love.graphics.print(self.frame, 5, 110)
end

function Level:changeMap() 
	-- update layer  
    if love.keyboard.isDown('1') then
    	if self.layer ~= 'base' then
	        self.layer = 'base'
	        self.currentLayer = self.baseLayer
	        self.type = 1
	        self.name = TILE_NAMES[self.layer][1]
            self.frame = 1
	    end
    elseif love.keyboard.isDown('2') then
    	if self.layer ~= 'second' then
	        self.layer = 'second'
	        self.currentLayer = self.secondLayer
	        self.type = 1
	        self.name = TILE_NAMES[self.layer][1]
            self.frame = 1
	    end
    end

    -- update name
    if love.keyboard.isDown('q') then
    	self.name = TILE_NAMES[self.layer][1] or TILE_NAMES[self.layer][#TILE_NAMES[self.layer]]
        self.type = 1
        self.frame = 1
    elseif love.keyboard.isDown('w') then
    	self.name = TILE_NAMES[self.layer][2] or TILE_NAMES[self.layer][#TILE_NAMES[self.layer]]
        self.type = 1
        self.frame = 1
    elseif love.keyboard.isDown('e') then
    	self.name = TILE_NAMES[self.layer][3] or TILE_NAMES[self.layer][#TILE_NAMES[self.layer]]
        self.type = 1
        self.frame = 1
    elseif love.keyboard.isDown('r') then
    	self.name = TILE_NAMES[self.layer][4] or TILE_NAMES[self.layer][#TILE_NAMES[self.layer]]
        self.type = 1
        self.frame = 1
    elseif love.keyboard.isDown('t') then
    	self.name = TILE_NAMES[self.layer][5] or TILE_NAMES[self.layer][#TILE_NAMES[self.layer]]
        self.type = 1
        self.frame = 1
    elseif love.keyboard.isDown('y') then
    	self.name = TILE_NAMES[self.layer][6] or TILE_NAMES[self.layer][#TILE_NAMES[self.layer]]
        self.type = 1
        self.frame = 1
    end

    -- update type
    if love.keyboard.wasPressed('a') then
    	if self.type > 1 then
    		self.type = self.type - 1
    	end
    elseif love.keyboard.wasPressed('s') then
    	if self.type < TILE_INFO[self.name].types then
    		self.type = self.type + 1
    	end
    end

	if gMouse.x <= TILE_SIZE * 8 then
		-- pick frame
		if love.mouse.isDown(1) then
			self.mouseGridX = math.floor(gMouse.x / TILE_SIZE) + 1
			self.mouseGridY = math.floor(gMouse.y / TILE_SIZE) + 1

			if (self.mouseGridY - 1) * 8 + self.mouseGridX <= #gFrames['outside'][self.name][self.type] then
				self.frame = (self.mouseGridY - 1) * 8 + self.mouseGridX
			end
		end
	else
		-- place tile
        if love.mouse.isDown(1) then
            if not self.currentLayer.tiles[gMouse.mapY] then
                self.currentLayer.tiles[gMouse.mapY] = {}
            end

            self.currentLayer.tiles[gMouse.mapY][gMouse.mapX] = Tile(gMouse.mapX, gMouse.mapY, self.name, self.frame, self.type)
        -- remove tile
        elseif love.mouse.isDown(2) then
            if self.currentLayer.tiles[gMouse.mapY] then
                self.currentLayer.tiles[gMouse.mapY][gMouse.mapX] = nil
            end
        end
    end
end
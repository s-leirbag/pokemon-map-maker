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

    self:createMaps()

    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        mapX = 1,
        mapY = 1,
        width = 16,
        height = 16,
    }

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self) end,
        ['idle'] = function() return PlayerIdleState(self.player) end
    }
    self.player.stateMachine:change('idle')

    -- for map making
    self.mode = 'base' -- options are 'base', 'second'
    self.type = 'grass' -- depends on mode

    self.camX = math.floor(self.player.x + self.player.width / 2) - VIRTUAL_WIDTH / 2
    self.camY = math.floor(self.player.y + self.player.height / 2) - VIRTUAL_HEIGHT / 2
end

function Level:createMaps()
    self.baseLayer = TileMap(self.width, self.height)
    self.secondLayer = TileMap(self.width, self.height)

    -- fill the base tiles table with random grass IDs
    for y = 1, self.height do
        table.insert(self.baseLayer.tiles, {})

        for x = 1, self.width do
            table.insert(self.baseLayer.tiles[y], Tile(x, y, 'grass', self.baseLayer.tiles))
        end
    end

    -- place tall grass in the tall grass layer
    for y = 11, self.height do
        self.secondLayer.tiles[y] = {}

        for x = 1, self.width do
            table.insert(self.secondLayer.tiles[y], Tile(x, y, 'tall-grass', self.baseLayer.tiles))
        end
    end
end

function Level:update(dt)
    self.player:update(dt)

    self:changeMap()
end

function Level:render()
    -- make player in center
    love.graphics.push()

    self.camX = math.floor(self.player.x + self.player.width / 2) - VIRTUAL_WIDTH / 2
    self.camY = math.floor(self.player.y + self.player.height / 2) - VIRTUAL_HEIGHT / 2
    love.graphics.translate(-self.camX, -self.camY)

    self.baseLayer:render()
    self.secondLayer:render()
    self.player:render()

    -- render grass on top of player
    if self.secondLayer.tiles[self.player.mapY] and
        self.secondLayer.tiles[self.player.mapY][self.player.mapX] and
        self.secondLayer.tiles[self.player.mapY][self.player.mapX].type == 'tall-grass' and
        not (self.player.stateMachine.currentStateName == 'walk' and self.player.direction == 'up') then

        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][TILE_INFO['half-tall-grass']['getFrame']()],
            (self.player.mapX - 1) * TILE_SIZE, (self.player.mapY - 1) * TILE_SIZE)
    end

    -- if player is walking, render grass on the tile player is walking to
    if self.player.stateMachine.currentStateName == 'walk' and
        (self.player.direction == 'left' or self.player.direction == 'right') and
        self.secondLayer.tiles[self.player.mapY] and
        self.secondLayer.tiles[self.player.mapY] [self.player.mapX - DIRECTION_TO_COORDS[self.player.direction]['x']] and
        self.secondLayer.tiles[self.player.mapY] [self.player.mapX - DIRECTION_TO_COORDS[self.player.direction]['x']].type == 'tall-grass' then

        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][TILE_INFO['half-tall-grass']['getFrame']()],
            (self.player.mapX - DIRECTION_TO_COORDS[self.player.direction]['x'] - 1) * TILE_SIZE, (self.player.mapY - 1) * TILE_SIZE)
    end

    -- remove translate so everything else is in right position
    love.graphics.pop()
end

function Level:changeMap()
    -- position
    self.mouseX, self.mouseY = love.mouse.getPosition()
    self.mouseX, self.mouseY = push:toGame(self.mouseX, self.mouseY)
    self.mouseX = self.mouseX + self.camX
    self.mouseY = self.mouseY + self.camY

    self.mouseMapX = math.floor(self.mouseX / 16) + 1
    self.mouseMapY = math.floor(self.mouseY / 16) + 1

    print('x: ' .. self.mouseMapX .. ', y: ' .. self.mouseMapY)
    
    if love.keyboard.isDown('q') then
        self.type = TILE_TYPES[self.mode][1]
    elseif love.keyboard.isDown('w') then
        self.type = TILE_TYPES[self.mode][2]
    --[[elseif love.keyboard.isDown('e') then
        self.type = TILE_TYPES[self.mode][3]
    elseif love.keyboard.isDown('r') then
        self.type = TILE_TYPES[self.mode][4]
    elseif love.keyboard.isDown('t') then
        self.type = TILE_TYPES[self.mode][5]
    elseif love.keyboard.isDown('y') then
        self.type = TILE_TYPES[self.mode][6]
    elseif love.keyboard.isDown('u') then
        self.type = TILE_TYPES[self.mode][7]
    elseif love.keyboard.isDown('i') then
        self.type = TILE_TYPES[self.mode][8]
    elseif love.keyboard.isDown('o') then
        self.type = TILE_TYPES[self.mode][9]
    elseif love.keyboard.isDown('p') then
        self.type = TILE_TYPES[self.mode][10] ]]
    end

    if self.mode == 'base' then
        if love.mouse.isDown(1) then
            if not self.baseLayer.tiles[self.mouseMapY] then
                self.baseLayer.tiles[self.mouseMapY] = {}
            end

            self.baseLayer.tiles[self.mouseMapY][self.mouseMapX] = Tile(self.mouseMapX, self.mouseMapY, self.type, self.baseLayer.tiles)
        elseif love.mouse.isDown(2) then
            if self.baseLayer.tiles[self.mouseMapY] then
                self.baseLayer.tiles[self.mouseMapY][self.mouseMapX] = nil
            end
        end

        --self:updateQuads(self.baseLayer)
    elseif self.mode == 'second' then

    end
end

function Level:updateQuads(tileMap)
    for y, row in pairs(tileMap.tiles) do
        for x, tile in pairs(tileMap.tiles) do
            tile:updateQuad(tileMap.tiles)
        end
    end
end
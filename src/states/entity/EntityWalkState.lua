--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityWalkState = Class{__includes = EntityBaseState}

function EntityWalkState:init(entity, level)
    self.entity = entity
    self.level = level
    
    self.canWalk = false
end

function EntityWalkState:enter(params)
    self:attemptMove()
end

function EntityWalkState:attemptMove(run)
    if run == true then
        self.entity:changeAnimation('run-' .. tostring(self.entity.direction))
    else
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    end

    local toX, toY = self.entity.mapX, self.entity.mapY

    toX = toX + DIRECTION_TO_COORDS[self.entity.direction]['x']
    toY = toY + DIRECTION_TO_COORDS[self.entity.direction]['y']

    -- go idle if invalid move
    if not (
    	-- inside boundaries
    	(toX >= 1 and toX <= self.level.width and toY >= 1 and toY <= self.level.height and
    	-- "to" tile exists and is not solid
		self.level.baseLayer.tiles[toY] and self.level.baseLayer.tiles[toY][toX] and not self.level.baseLayer.tiles[toY][toX].solid) and
		-- 2nd layer "to" tile doesn't exist or exists and is not solid
    	(not self.level.secondLayer.tiles[toY] or not self.level.secondLayer.tiles[toY][toX] or not self.level.secondLayer.tiles[toY][toX].solid)
    ) then
        self.entity:changeState('idle')
        self.entity:changeAnimation('idle-' .. tostring(self.entity.direction))
        return
    end

    self.entity.mapY = toY
    self.entity.mapX = toX

    Timer.tween(run == true and 0.11 or 0.2, {
        [self.entity] = {x = (toX - 1) * TILE_SIZE, y = (toY - 1) * TILE_SIZE - ENTITY_TILE_OFFSET}
    }):finish(function()
        if love.keyboard.isDown('up') then
            self.entity.direction = 'up'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown('down') then
            self.entity.direction = 'down'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown('right') then
            self.entity.direction = 'right'
            self.entity:changeState('walk')  
        elseif love.keyboard.isDown('left') then
            self.entity.direction = 'left'
            self.entity:changeState('walk')
        else
            self.entity:changeState('idle')
        end
    end)
end
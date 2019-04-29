--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('idle-' .. self.entity.direction)

        Timer.after(0.06, function()
            if self.entity.stateMachine.currentStateName == 'idle' and love.keyboard.isDown('up') then
                self.entity:changeState('walk')
            end
        end)
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('idle-' .. self.entity.direction)

        Timer.after(0.06, function()
            if self.entity.stateMachine.currentStateName == 'idle' and love.keyboard.isDown('down') then
                self.entity:changeState('walk')
            end
        end)
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('idle-' .. self.entity.direction)

        Timer.after(0.06, function()
            if self.entity.stateMachine.currentStateName == 'idle' and love.keyboard.isDown('right') then
                self.entity:changeState('walk')
            end
        end)
    elseif love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('idle-' .. self.entity.direction)

        Timer.after(0.06, function()
            if self.entity.stateMachine.currentStateName == 'idle' and love.keyboard.isDown('left') then
                self.entity:changeState('walk')
            end
        end)
    end
end
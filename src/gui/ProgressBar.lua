--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ProgressBar = Class{}

function ProgressBar:init(def)
    self.x = def.x
    self.y = def.y
    
    self.width = def.width
    self.height = def.height
    
    self.healthBar = def.healthBar
    self.color = def.color

    self.value = def.value
    self.max = def.max
end

function ProgressBar:setMax(max)
    self.max = max
end

function ProgressBar:setValue(value)
    self.value = value
end

function ProgressBar:update()

end

function ProgressBar:render()
    -- multiplier on width based on progress
    local renderWidth = (self.value / self.max) * self.width

    -- draw main bar, with calculated width based on value / max
    if self.healthBar then
        -- color based on health
        if self.value > self.max / 2 then
            love.graphics.setColor(0.21, 0.82, 0.20, 1)
        elseif self.value > self.max / 5 then
            love.graphics.setColor(0.85, 0.78, 0.13, 1)
        else
            love.graphics.setColor(0.74, 0.13, 0.13, 1)
        end
    else
        love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
    end
    
    if self.value > 0 then
        love.graphics.rectangle('fill', self.x, self.y, renderWidth, self.height, 3)
    end

    -- draw outline around actual bar
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height, 3)
    love.graphics.setColor(1, 1, 1, 1)
end
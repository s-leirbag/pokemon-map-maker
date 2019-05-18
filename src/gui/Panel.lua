--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Panel = Class{}

function Panel:init(x, y, width, height, border)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.border = border or 2

    self.visible = true
end

function Panel:update(dt)

end

function Panel:render()
    if self.visible then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 3)
        love.graphics.setColor(0.22, 0.22, 0.22, 255)
        love.graphics.rectangle('fill', self.x + self.border, self.y + self.border, self.width - self.border * 2, self.height - self.border * 2, 3)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Panel:toggle()
    self.visible = not self.visible
end
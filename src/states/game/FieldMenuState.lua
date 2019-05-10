--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

FieldMenuState = Class{__includes = BaseState}

function FieldMenuState:init(level)
	self.level = level
	self.player = self.level.player
    self.menu = Menu {
        x = VIRTUAL_WIDTH - 70,
        y = 2,
        width = 70,
        height = VIRTUAL_HEIGHT - 4,
        rows = #self.player.fieldMenuItems,
        columns = 1,
        items = self.player.fieldMenuItems,
        currentSelection = self.level.currentFMSelection,
    }
end

function FieldMenuState:update(dt)

end

function FieldMenuState:render()

end
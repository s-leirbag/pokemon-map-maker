BagState = Class{__includes = BaseState}

function BagState:init(level)
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
    self.pocket = level.pocket -- from 1 to 8
end

function BagState:update(dt)

end

function BagState:render()
    love.graphics.draw(gFrames['bag']['background'][self.pocket], VIRTUAL_WIDTH / 2 - 128, VIRTUAL_HEIGHT / 2 - 96)
    love.graphics.draw(gFrames['bag'][self.player.gender][self.pocket], VIRTUAL_WIDTH / 2 - 114, VIRTUAL_HEIGHT / 2 - 84)
end
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
    self.pocket = self.level.currentPocket -- from 1 to 8
end

function BagState:update(dt)
    if love.keyboard.wasPressed('right') then
        if self.pocket < 8 then
            self.pocket = self.pocket + 1

            -- tween?
        end
    elseif love.keyboard.wasPressed('left') then
        if self.pocket > 1 then
            self.pocket = self.pocket - 1
        end
    end
end

function BagState:render()
    love.graphics.draw(gTextures['bag-background'], gFrames['bag']['background'][self.pocket], VIRTUAL_WIDTH / 2 - 128, VIRTUAL_HEIGHT / 2 - 96)
    love.graphics.draw(gTextures['bag'], gFrames['bag'][self.player.gender][self.pocket], VIRTUAL_WIDTH / 2 - 114, VIRTUAL_HEIGHT / 2 - 84)
end
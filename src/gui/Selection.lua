--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Selection class gives us a list of textual items that link to callbacks;
    this particular implementation only has one dimension of items (vertically),
    but a more robust implementation might include columns as well for a more
    grid-like selection, as seen in many kinds of interfaces and games.
]]

Selection = Class{}

function Selection:init(def)
    if def.cursor == false then
        self.cursor = false
    else
        self.cursor = true
    end

    self.items = def.items
    self.font = def.font or gFonts['medium']

    self.x = def.x
    self.y = def.y
    self.height = def.height
    self.width = def.width

    self.numRows = def.rows or #self.items
    self.numColumns = def.columns or 1

    if def.currentSelection then     
        self.currentSelection = def.currentSelection
        self.row = math.ceil(self.currentSelection / self.numColumns)
        self.column = self.currentSelection - (self.row - 1) * self.numColumns
    else
        self.currentSelection = 1
        self.row = 1
        self.column = 1
    end

    -- TYPES
    -- - evenly spaced out
    -- - scroll
    -- - space between(gapHeight & gapWidth) is specified not calculated
    -- - start a menu state pls as well

    self.padding = def.padding or 0
    self.padding = self.padding + 6
    self.gapHeight = (self.height - self.padding) / self.numRows
    self.gapWidth = (self.width - self.padding * 2) / self.numColumns
end

function Selection:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('space') then
        self.items[self.currentSelection].onSelect(self.currentSelection)
        
        if self.cursor then
            gSounds['blip']:stop()
            gSounds['blip']:play()
        end
    end

    if self.cursor then 
        if love.keyboard.wasPressed('up') then
            if self.row ~= 1 then
                self.row = self.row - 1

                gSounds['blip']:stop()
                gSounds['blip']:play()
            else       
                gSounds['blop']:stop()
                gSounds['blop']:play()
            end
        elseif love.keyboard.wasPressed('down') then
            if self.row ~= self.numRows then
                self.row = self.row + 1
                
                gSounds['blip']:stop()
                gSounds['blip']:play()
            else       
                gSounds['blop']:stop()
                gSounds['blop']:play()
            end
        end

        if love.keyboard.wasPressed('left') then
            if self.column ~= 1 then
                self.column = self.column - 1
                
                gSounds['blip']:stop()
                gSounds['blip']:play()
            else       
                gSounds['blop']:stop()
                gSounds['blop']:play()
            end
        elseif love.keyboard.wasPressed('right') then
            if self.column ~= self.numColumns then
                self.column = self.column + 1
                
                gSounds['blip']:stop()
                gSounds['blip']:play()
            else       
                gSounds['blop']:stop()
                gSounds['blop']:play()
            end
        end

        self.currentSelection = (self.row - 1) * self.numColumns + self.column
    end
end

function Selection:render()
    for row = 1, self.numRows do
        local paddedY = self.y + (row - 1) * self.gapHeight + (self.gapHeight / 2) - self.font:getHeight() / 2

        for column = 1, self.numColumns do
            local paddedX = self.x + self.padding + (column - 1) * self.gapWidth

            love.graphics.setFont(self.font)
            love.graphics.printf(self.items[(row - 1) * self.numColumns + column].text, paddedX, paddedY, self.gapWidth, self.items[(row - 1) * self.numColumns + column].align)

            -- draw selection marker if we're at the right index and cursor setting is true
            if (row - 1) * self.numColumns + column == self.currentSelection and self.cursor then
                love.graphics.setLineWidth(1)
                love.graphics.line(paddedX - 2, paddedY,
                    paddedX - 2, paddedY + self.font:getHeight(),
                    paddedX - 2 + self.gapWidth, paddedY + self.font:getHeight(),
                    paddedX - 2 + self.gapWidth, paddedY,
                    paddedX - 2, paddedY)
            end
        end
    end
end
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
        self.cursorColor = def.cursorColor or {r = 1, g = 0.15, b = 0.15, a = 1}
        self.color = def.color or {r = 1, g = 1, b = 1, a = 1}
    end

    self.items = def.items
    self.font = def.font or gFonts['medium']

    self.numRows = def.rows or #self.items
    self.numColumns = def.columns or 1

    -- types/stuff left to do
    -- - gapHeight & gapWidth are specified not calculated
    -- - gapHeight & gapWidth are based on text length
    -- - make custom colors for each item

    local border = def.border or 2
    self.padding = def.padding or 4
    self.padding = self.padding + border
    self.spacing = def.spacing or 4

    self.x = def.x + self.padding
    self.y = def.y + self.padding
    self.width = def.width - 2 * self.padding
    self.height = def.height - 2 * self.padding

    self.type = def.type or 'evenly-spaced'
    if self.type == 'evenly-spaced' then
        self.gapHeight = self.height / self.numRows
        self.gapWidth = self.width / self.numColumns

        if def.currentSelection then     
            self.currentSelection = def.currentSelection
            self.row = math.ceil(self.currentSelection / self.numColumns)
            self.column = self.currentSelection - (self.row - 1) * self.numColumns
        else
            self.currentSelection = 1
            self.row = 1
            self.column = 1
        end
    elseif self.type == 'scroll' then
        self.rowOffset = 0
        self.columnOffset = 0
        self.numDispRows = def.numDispRows
        self.numDispColumns = def.numDispColumns
        self.gapHeight = self.height / self.numDispRows
        self.gapWidth = self.width / self.numDispColumns

        if def.currentSelection then     
            self.currentSelection = def.currentSelection
            self.row = math.ceil(self.currentSelection / self.numColumns)
            self.column = self.currentSelection - (self.row - 1) * self.numColumns
            self.dispRow = 1 -- ?
            self.dispColumn = 1
        else
            self.currentSelection = 1
            self.row = 1
            self.column = 1
            self.dispRow = 1
            self.dispColumn = 1
        end
    end
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

                if self.type == 'scroll' then
                    if self.dispRow == 1 then
                        self.rowOffset = self.rowOffset - 1
                    else
                        self.dispRow = self.dispRow - 1
                    end
                end

                gSounds['blip']:stop()
                gSounds['blip']:play()
            else       
                gSounds['blop']:stop()
                gSounds['blop']:play()
            end
        elseif love.keyboard.wasPressed('down') then
            if self.row ~= self.numRows then
                self.row = self.row + 1

                if self.type == 'scroll' then
                    if self.dispRow == numDispRows then
                        self.rowOffset = self.rowOffset + 1
                    else
                        self.dispRow = self.dispRow + 1
                    end
                end
                
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

                if self.type == 'scroll' then
                    if self.dispColumn == 1 then
                        self.columnOffset = self.columnOffset - 1
                    else
                        self.dispColumn = self.dispColumn - 1
                    end
                end
                
                gSounds['blip']:stop()
                gSounds['blip']:play()
            else       
                gSounds['blop']:stop()
                gSounds['blop']:play()
            end
        elseif love.keyboard.wasPressed('right') then
            if self.column ~= self.numColumns then
                self.column = self.column + 1
                
                if self.type == 'scroll' then
                    if self.dispColumn == numDispColumns then
                        self.columnOffset = self.columnOffset + 1
                    else
                        self.dispColumn = self.dispColumn + 1
                    end
                end

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
    love.graphics.setFont(self.font)

    if self.type == 'evenly-spaced' then
        for row = 1, self.numRows do
            local textY = self.y + (row - 1) * self.gapHeight + self.gapHeight / 2 - self.font:getHeight() / 2

            for column = 1, self.numColumns do
                local textX = self.x + (column - 1) * self.gapWidth + (column - 1) * self.spacing / 2

                love.graphics.setColor(self.color.r or 1, self.color.g or 1, self.color.b or 1, self.color.a or 1)
                love.graphics.printf(self.items[(row - 1) * self.numColumns + column].text, textX, textY, self.gapWidth - column * self.spacing / 2, self.items[(row - 1) * self.numColumns + column].align or 'left')

                -- draw selection marker if we're at the right index and cursor setting is true
                if (row - 1) * self.numColumns + column == self.currentSelection and self.cursor then
                    love.graphics.setColor(self.cursorColor.r or 1, self.cursorColor.g or 0, self.cursorColor.b or 0, self.cursorColor.a or 1)
                    love.graphics.rectangle('line', textX - 2, textY - 2, self.gapWidth, self.font:getHeight() + 4, 1)
                end
            end
        end
    elseif self.type == 'scroll' then
        for row = 1, self.numDispRows do
            local textY = self.y + (row - 1) * self.gapHeight + self.gapHeight / 2 - self.font:getHeight() / 2

            for column = 1, self.numDispColumns do
                local textX = self.x + (column - 1) * self.gapWidth + (column - 1) * self.spacing / 2

                love.graphics.setColor(self.color.r or 1, self.color.g or 1, self.color.b or 1, self.color.a or 1)
                love.graphics.printf(self.items[(row + self.rowOffset - 1) * self.numColumns + column + self.columnOffset].text, textX, textY, self.gapWidth - column * self.spacing / 2, self.items[(row + self.rowOffset - 1) * self.numColumns + column + self.columnOffset].align or 'left')

                -- EDIT SELECTION MARKER
                -- draw selection marker if we're at the right index and cursor setting is true
                if (row + self.rowOffset - 1) * self.numColumns + column + self.columnOffset == self.currentSelection and self.cursor then
                    love.graphics.setColor(self.cursorColor.r or 1, self.cursorColor.g or 0, self.cursorColor.b or 0, self.cursorColor.a or 1)
                    love.graphics.rectangle('line', textX - 2, textY - 2, self.gapWidth, self.font:getHeight() + 4, 1)
                end
            end
        end
    end
end
--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

TileMap = Class{}

function TileMap:init(width, height)
    self.tiles = {}
    self.width = width
    self.height = height
end

function TileMap:render()
    for y = 1, self.height do
        if self.tiles[y] then
            for x, tile in pairs(self.tiles[y]) do
                tile:render()
            end
        end
    end
end
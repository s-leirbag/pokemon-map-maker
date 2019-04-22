--[[
    GD50
    Legend of Zelda

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 16

ENTITY_TILE_OFFSET = TILE_SIZE / 4

DIRECTION_TO_COORDS = {
    ['left'] = {
    	['x'] = -1,
    	['y'] = 0
    },
    ['right'] = {
    	['x'] = 1,
    	['y'] = 0
    },
    ['up'] = {
    	['x'] = 0,
    	['y'] = -1
    },
    ['down'] = {
    	['x'] = 0,
    	['y'] = 1
    }
}
TILE_INFO = {
    ['grass'] = {
    	['id'] = 'grass',
    	['getFrame'] = function() return math.random(46, 47) end,
    	['solid'] = false
    },
    ['empty'] = {
    	['id'] = 'empty',
    	['getFrame'] = function() return 101 end,
    	['solid'] = false
    },
    ['tall-grass'] = {
    	['id'] = 'tall-grass',
    	['getFrame'] = function() return 42 end,
    	['solid'] = false
    },
    ['half-tall-grass'] = {
    	['id'] = 'half-tall-grass',
    	['getFrame'] = function() return 50 end,
    	['solid'] = false
    },
    ['sand'] = {
        ['id'] = 'sand',
        ['getFrame'] = function() return 62 end,
        ['solid'] = false
    }
}

TILE_TYPES = {
    ['base'] = {
        'grass',
        'sand',

    }
}
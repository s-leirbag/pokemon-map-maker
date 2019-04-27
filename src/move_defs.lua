MOVE_TYPES = {
    'normal', 'earth', 'fire', 'water', 'wind', 'metal', 'ice', 'rock', 'forest'
}

--[[MOVE_KEYS = {
    ['tackle'] = 1,
    ['scratch'] = 2,
    ['slam'] = 3,
    ['growl'] = 4,
    ['earthquake'] = 1,
    ['sand storm'] = 2,
    ['ground slam'] = 3,
    ['dust shot'] = 4,
    ['fire breath'] = 1,
    ['burn'] = 2,
    ['eruption'] = 3,
    ['torch'] = 4,
    ['leaf spin'] = 1,
    ['ivy slap'] = 2,
    ['flower blast'] = 3,
    ['poison dart'] = 4
}]]

MOVES = {
    ['normal'] = {
        {
            text = 'Tackle',
            type = 'normal',
            category = 'damage',
        },
        {
            text = 'Scratch',
            type = 'normal',
            category = 'damage',
        },
        {
            text = 'Slam',
            type = 'normal',
            category = 'damage',
        },
        {
            text = 'Growl',
            type = 'normal',
            category = 'status',
        }
    },
    ['earth'] = {
        {
            text = 'Earthquake',
            type = 'earth',
        },
        {
            text = 'Sand Storm',
            type = 'earth',
        },
        {
            text = 'Ground Slam',
            type = 'earth',
        },
        {
            text = 'Dust Shot',
            type = 'earth',
        }
    },
    ['fire'] = {
        {
            text = 'Fire Breath',
            type = 'fire',
        },
        {
            text = 'Burn',
            type = 'fire',
        },
        {
            text = 'Eruption',
            type = 'fire',
        },
        {
            text = 'Torch',
            type = 'fire',
        }
    },
    ['forest'] = {
        {
            text = 'Leaf Spin',
            type = 'forest',
        },
        {
            text = 'Ivy Slap',
            type = 'forest',
        },
        {
            text = 'Flower Blast',
            type = 'forest',
        },
        {
            text = 'Poison Dart',
            type = 'forest',
        }
    }
}
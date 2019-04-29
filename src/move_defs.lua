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

-- range is -6 to 6
MAX_RANGE = 12

MOVES = {
    ['normal'] = {
        {
            text = 'Tackle',
            type = 'normal',
            power = 40,
            pp = 35,
            accuracy = 100,
            contact = true,
            range = 5,
        },
        {
            text = 'Scratch',
            type = 'normal',
            power = 40,
            pp = 35,
            accuracy = 100,
            contact = true,
            range = 5,
        },
        {
            text = 'Slam',
            type = 'normal',
            power = 80,
            pp = 20,
            accuracy = 75,
            contact = true,
            range = 5,
        },
        {
            text = 'Growl',
            type = 'normal',
            power = 0,
            pp = 40,
            accuracy = 100,
            stats = {
                {'attack', 1}
            },
            contact = false,
            range = MAX_RANGE,
        },
        {
            text = 'Reel In',
            type = 'normal',
            power = 0,
            pp = 25,
            accuracy = 100,
            stats = {
                {'range', 5}
            },
            contact = false,
            range = MAX_RANGE,
        },
        {
            text = 'Retreat',
            type = 'normal',
            power = 0,
            pp = 25,
            accuracy = 100,
            stats = {
                {'range', -5}
            },
            contact = false,
            range = MAX_RANGE,
        },
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
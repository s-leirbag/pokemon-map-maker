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

-- range from pokemon to pokemon is -6 to 6
MAX_RANGE = 12

MOVES = {
    ['normal'] = {
        {
            text = 'Tackle',
            type = 'normal',
            basePP = 35,
            accuracy = 100,
            contact = true,
            range = 5,
            power = 40,
        },
        {
            text = 'Scratch',
            type = 'normal',
            basePP = 35,
            accuracy = 100,
            contact = true,
            range = 5,
            power = 40,
        },
        {
            text = 'Slam',
            type = 'normal',
            basePP = 20,
            accuracy = 75,
            contact = true,
            range = 5,
            power = 80,
        },
        {
            text = 'Growl',
            type = 'normal',
            basePP = 40,
            accuracy = 100,
            contact = false,
            range = MAX_RANGE,
            pStats = {
                attack = 1,
            },
        },
        {
            text = 'Reel In',
            type = 'normal',
            basePP = 25,
            accuracy = 100,
            contact = false,
            range = MAX_RANGE,
            oStats = {
                position = -5,
            },
        },
        {
            text = 'Retreat',
            type = 'normal',
            basePP = 25,
            accuracy = 100,
            contact = false,
            range = MAX_RANGE,
            pStats = {
                position = -5,
            },
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
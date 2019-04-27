ENTITY_DEFS = {
    ['player'] = {
        ['boy'] = {
            width = 16,
            height = 16,
            yOffset = 4,
            animations = {
                ['walk-left'] = {
                    frames = {5, 6, 7, 8},
                    interval = 0.15,
                    texture = 'boy-run'
                },
                ['walk-right'] = {
                    frames = {9, 10, 11, 12},
                    interval = 0.15,
                    texture = 'boy-run'
                },
                ['walk-down'] = {
                    frames = {1, 2, 3, 4},
                    interval = 0.15,
                    texture = 'boy-run'
                },
                ['walk-up'] = {
                    frames = {13, 14, 15, 16},
                    interval = 0.15,
                    texture = 'boy-run'
                },
                ['idle-left'] = {
                    frames = {5},
                    texture = 'boy-run'
                },
                ['idle-right'] = {
                    frames = {9},
                    texture = 'boy-run'
                },
                ['idle-down'] = {
                    frames = {1},
                    texture = 'boy-run'
                },
                ['idle-up'] = {
                    frames = {13},
                    texture = 'boy-run'
                },
            }
        },
        ['girl'] = {
            width = 16,
            height = 16,
            yOffset = 4,
            animations = {
                ['walk-left'] = {
                    frames = {5, 6, 7, 8},
                    interval = 0.15,
                    texture = 'girl-run'
                },
                ['walk-right'] = {
                    frames = {9, 10, 11, 12},
                    interval = 0.15,
                    texture = 'girl-run'
                },
                ['walk-down'] = {
                    frames = {1, 2, 3, 4},
                    interval = 0.15,
                    texture = 'girl-run'
                },
                ['walk-up'] = {
                    frames = {13, 14, 15, 16},
                    interval = 0.15,
                    texture = 'girl-run'
                },
                ['idle-left'] = {
                    frames = {5},
                    texture = 'girl-run'
                },
                ['idle-right'] = {
                    frames = {9},
                    texture = 'girl-run'
                },
                ['idle-down'] = {
                    frames = {1},
                    texture = 'girl-run'
                },
                ['idle-up'] = {
                    frames = {13},
                    texture = 'girl-run'
                },
            }
        },
    },
    ['npc'] = {
        animations = {
            ['walk-left'] = {
                frames = {16, 17, 18, 17},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-right'] = {
                frames = {28, 29, 30, 29},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-down'] = {
                frames = {4, 5, 6, 5},
                interval = 0.15,
                texture = 'entities'
            },
            ['walk-up'] = {
                frames = {40, 41, 42, 41},
                interval = 0.15,
                texture = 'entities'
            },
            ['idle-left'] = {
                frames = {17},
                texture = 'entities'
            },
            ['idle-right'] = {
                frames = {29},
                texture = 'entities'
            },
            ['idle-down'] = {
                frames = {5},
                texture = 'entities'
            },
            ['idle-up'] = {
                frames = {41},
                texture = 'entities'
            },
        }
    }
}
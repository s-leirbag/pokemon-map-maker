Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Party'
require 'src/Pokemon'
require 'src/pokemon_defs'
require 'src/move_defs'
require 'src/StateMachine'
require 'src/Util'

require 'src/battle/BattleSprite'
require 'src/battle/Opponent'

require 'src/entity/entity_defs'
require 'src/entity/Entity'
require 'src/entity/Player'

require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/ProgressBar'
require 'src/gui/Selection'
require 'src/gui/Textbox'

require 'src/states/BaseState'
require 'src/states/StateStack'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerWalkState'

require 'src/states/game/BattleState'
require 'src/states/game/BattleMenuState'
require 'src/states/game/BattleMessageState'
require 'src/states/game/FightMenuState'
require 'src/states/game/DialogueState'
require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/TakeTurnState'
require 'src/states/game/LevelUpState'

require 'src/world/Level'
require 'src/world/tile_defs'
require 'src/world/Tile'
require 'src/world/TileMap'

gTextures = {
    ['outside'] = love.graphics.newImage('graphics/tilesets/Outside.png'),
    
    ['boy-run'] = love.graphics.newImage('graphics/characters/player/boy/boy_run.png'),
    ['boy-bike'] = love.graphics.newImage('graphics/characters/player/boy/boy_bike.png'),
    ['boy-surf'] = love.graphics.newImage('graphics/characters/player/boy/boy_surf.png'),
    ['boy-fish'] = love.graphics.newImage('graphics/characters/player/boy/boy_fish.png'),
    ['girl-run'] = love.graphics.newImage('graphics/characters/player/girl/girl_run.png'),
    ['girl-bike'] = love.graphics.newImage('graphics/characters/player/girl/girl_bike.png'),
    ['girl-surf'] = love.graphics.newImage('graphics/characters/player/girl/girl_surf.png'),
    ['girl-fish'] = love.graphics.newImage('graphics/characters/player/girl/girl_fish.png'),

    ['zigzagoon-back'] = love.graphics.newImage('graphics/pokemon/battle/aardart-back.png'),
    ['zigzagoon-front'] = love.graphics.newImage('graphics/pokemon/battle/aardart-front.png'),
    ['agnite-back'] = love.graphics.newImage('graphics/pokemon/battle/agnite-back.png'),
    ['agnite-front'] = love.graphics.newImage('graphics/pokemon/battle/agnite-front.png'),
    ['anoleaf-back'] = love.graphics.newImage('graphics/pokemon/battle/anoleaf-back.png'),
    ['anoleaf-front'] = love.graphics.newImage('graphics/pokemon/battle/anoleaf-front.png'),
    ['bamboon-back'] = love.graphics.newImage('graphics/pokemon/battle/bamboon-back.png'),
    ['bamboon-front'] = love.graphics.newImage('graphics/pokemon/battle/bamboon-front.png'),
    ['cardiwing-back'] = love.graphics.newImage('graphics/pokemon/battle/cardiwing-back.png'),
    ['cardiwing-front'] = love.graphics.newImage('graphics/pokemon/battle/cardiwing-front.png'),
}

gFrames = {
	['outside'] = GenerateOutsideQuads(),
    ['player'] = GeneratePlayerQuads()
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}

gSounds = {
    ['field-music'] = love.audio.newSource('sounds/field_music.wav', 'static'),
    ['battle-music'] = love.audio.newSource('sounds/battle_music.mp3', 'static'),
    ['blip'] = love.audio.newSource('sounds/blip.wav', 'static'),
    ['blop'] = love.audio.newSource('sounds/blop.wav', 'static'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav', 'static'),
    ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
    ['run'] = love.audio.newSource('sounds/run.wav', 'static'),
    ['heal'] = love.audio.newSource('sounds/heal.wav', 'static'),
    ['exp'] = love.audio.newSource('sounds/exp.wav', 'static'),
    ['levelup'] = love.audio.newSource('sounds/levelup.wav', 'static'),
    ['victory-music'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['intro-music'] = love.audio.newSource('sounds/intro.mp3', 'static')
}
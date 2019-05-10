--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

FightMenuState = Class{__includes = BaseState}

function FightMenuState:init(battleState)
    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]

    for k, move in pairs(self.playerPokemon.currentMoves) do
        move.onSelect = function(currentSelection)
            -- pop fight menu
            gStateStack:pop()
            gStateStack:push(TakeTurnState(self.battleState, move))
            self.battleState.currentFMSelection = currentSelection
        end
    end
    
    self.fightMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH - 140,
        height = 64,
        rows = 2,
        columns = 2,
        items = self.playerPokemon.currentMoves,
        currentSelection = self.battleState.currentFMSelection,
    }
end

function FightMenuState:update(dt)
    self.fightMenu:update(dt)

    if love.keyboard.isDown('z') then
        gStateStack:pop()
        gStateStack:push(BattleMenuState(battleState))
    end
end

function FightMenuState:render()
    self.fightMenu:render()
end
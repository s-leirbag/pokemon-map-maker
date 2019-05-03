--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleMenuState = Class{__includes = BaseState}

function BattleMenuState:init(battleState)
    self.battleState = battleState
    
    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - 160,
        y = VIRTUAL_HEIGHT - 64,
        width = 160,
        height = 64,
        rows = 2,
        columns = 2,
        currentSelection = self.battleState.currentBMSelection,
        items = {
            {
                text = 'Fight',
                onSelect = function(currentSelection)
                    -- pop battle menu
                    gStateStack:pop()
                    self.battleState.currentBMSelection = currentSelection
                    gStateStack:push(FightMenuState(self.battleState))
                end
            },
            {
                text = 'Bag',
                onSelect = function()
                    --gStateStack:pop()
                    --gStateStack:push(BagState(self.battleState))
                end
            },
            {
                text = 'Pokemon',
                onSelect = function()
                    --gStateStack:pop()
                    --gStateStack:push(PokemonState(self.battleState))
                end
            },
            {
                text = 'Run',
                onSelect = function()
                    gSounds['run']:play()
                    
                    -- pop battle menu
                    gStateStack:pop()

                    -- show a message saying they successfully ran, then fade in
                    -- and out back to the field automatically
                    gStateStack:push(BattleMessageState('You fled successfully!',
                        function() end), false)
                    Timer.after(0.5, function()
                        gStateStack:push(FadeInState({
                            r = 1, g = 1, b = 1
                        }, 1,
                        
                        -- pop message and battle state and add a fade to blend in the field
                        function()

                            -- resume field music
                            gSounds['field-music']:play()

                            -- pop message state
                            gStateStack:pop()

                            -- pop battle state
                            gStateStack:pop()

                            print('before fade out'..#gStateStack.states)
                            gStateStack:push(FadeOutState({
                                r = 1, g = 1, b = 1
                            }, 1, function()
                                print('after fade out: '..#gStateStack.states)
                                -- do nothing after fade out ends
                            end))
                        end))
                    end)
                end
            }
        }
    }
end

function BattleMenuState:update(dt)
    self.battleMenu:update(dt)
end

function BattleMenuState:render()
    self.battleMenu:render()
end
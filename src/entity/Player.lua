--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    self.level = def.level

    Entity.init(self, def)

    self.party = Party {
        pokemon = {
            Pokemon(Pokemon.getRandomDef(), 5)
        }
    }

    self.fieldMenuItems = {
        {
            text = 'Pokemon',
            onSelect = function(currentSelection)
                -- pop field menu state
                gStateStack:pop()
                gStateStack:push(PartyState())
                self.level.currentFMSelection = currentSelection
            end
        },
        {
            text = 'Bag',
            onSelect = function(currentSelection)
                gStateStack:pop()
                gStateStack:push(BagState())
                self.level.currentFMSelection = currentSelection
            end
        },
        {
            text = self.name,
            onSelect = function(currentSelection)
                -- gStateStack:pop()
                -- gStateStack:push(PlayerInfoState())
                -- self.level.currentFMSelection = currentSelection
            end
        },
        {
            text = 'Save',
            onSelect = function(currentSelection)
                -- gStateStack:pop()
                -- gStateStack:push(SaveState())
                -- self.level.currentFMSelection = currentSelection
            end
        },
        {
            text = 'Settings',
            onSelect = function(currentSelection)
                gStateStack:pop()
                gStateStack:push(SettingsState())
                self.level.currentFMSelection = currentSelection
            end
        },
        {
            text = 'Exit',
            onSelect = function(currentSelection)
                -- gStateStack:pop()
                -- gStateStack:push(ExitState())
                -- self.level.currentFMSelection = currentSelection
            end
        },
    }
end
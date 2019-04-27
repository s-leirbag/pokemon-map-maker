LevelUpState = Class{__includes = BaseState}

function LevelUpState:init(stats, onClose)
    self.textbox = Textbox(0, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 64, 'Congratulations! Level Up!', gFonts['medium'])

    self.onClose = onClose

    self.stats = stats

    self.statsMenu = Menu {
        cursor = false,
        x = VIRTUAL_WIDTH - 75,
        y = 0,
        width = 75,
        height = 125,
        rows = 4,
        columns = 2,
        items = {
            {
                text = 'HP',
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = '+' .. self.stats.HPIncrease,
                align = 'right',
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = 'Atk',
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = '+' .. self.stats.attackIncrease,
                align = 'right',
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = 'Def',
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = '+' .. self.stats.defenseIncrease,
                align = 'right',
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = 'Spd',
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = '+' .. self.stats.speedIncrease,
                align = 'right',
                onSelect = function()
                    self:nextMenu()
                end
            }
        }
    }

    --[[self.statsMenu = Menu {
        cursor = false,
        x = VIRTUAL_WIDTH - 70,
        y = 0,
        width = 70,
        height = 125,
        items = {
            {
                text = 'HP +' .. self.stats.HPIncrease,
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = 'Atk +' .. self.stats.attackIncrease,
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = 'Def +' .. self.stats.defenseIncrease,
                onSelect = function()
                    self:nextMenu()
                end
            },
            {
                text = 'Spd +' .. self.stats.speedIncrease,
                onSelect = function()
                    self:nextMenu()
                end
            }
        }
    }]]
end

function LevelUpState:update(dt)
    self.statsMenu:update(dt)
end

function LevelUpState:render()
    self.textbox:render()
    self.statsMenu:render(dt)
end

function LevelUpState:nextMenu()
    self.statsMenu = Menu {
        cursor = false,
        x = VIRTUAL_WIDTH - 75,
        y = 0,
        width = 75,
        height = 125,
        rows = 4,
        columns = 2,
        items = {
            {
                text = 'HP',
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = self.stats.HP + self.stats.HPIncrease,
                align = 'right',
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = 'Atk',
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = self.stats.attack + self.stats.attackIncrease,
                align = 'right',
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = 'Def',
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = self.stats.defense + self.stats.defenseIncrease,
                align = 'right',
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = 'Spd',
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = self.stats.speed + self.stats.speedIncrease,
                align = 'right',
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            }
        }
    }

    --[[self.statsMenu = Menu {
        cursor = false,
        x = VIRTUAL_WIDTH - 75,
        y = 0,
        width = 75,
        height = 125,
        items = {
            {
                text = 'HP ' .. self.stats.HP + self.stats.HPIncrease,
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = 'Atk ' .. self.stats.attack + self.stats.attackIncrease,
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = 'Def ' .. self.stats.defense + self.stats.defenseIncrease,
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            },
            {
                text = 'Spd ' .. self.stats.speed + self.stats.speedIncrease,
                onSelect = function()
                    gStateStack:pop()
                    self:onClose()
                end
            }
        }
    }]]
end
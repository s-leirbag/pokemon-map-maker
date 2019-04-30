--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

TakeTurnState = Class{__includes = BaseState}

function TakeTurnState:init(battleState, playerMove)
    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]
    self.opponentPokemon = self.battleState.opponent.party.pokemon[1]

    self.playerSprite = self.battleState.playerSprite
    self.opponentSprite = self.battleState.opponentSprite

    -- figure out which pokemon is faster, as they get to attack first
    if self.playerPokemon.speed > self.opponentPokemon.speed then
        self.firstPokemon = self.playerPokemon
        self.secondPokemon = self.opponentPokemon
        self.firstSprite = self.playerSprite
        self.secondSprite = self.opponentSprite
        self.firstBar = self.battleState.playerHealthBar
        self.secondBar = self.battleState.opponentHealthBar
        self.firstMove = playerMove
        self.secondMove = MOVES[self.secondPokemon.type][math.random(3, 6)]
    else
        self.firstPokemon = self.opponentPokemon
        self.secondPokemon = self.playerPokemon
        self.firstSprite = self.opponentSprite
        self.secondSprite = self.playerSprite
        self.firstBar = self.battleState.opponentHealthBar
        self.secondBar = self.battleState.playerHealthBar
        self.firstMove = MOVES[self.secondPokemon.type][math.random(3, 6)]
        self.secondMove = playerMove
    end
end

function TakeTurnState:enter(params)
    self:attack(self.firstMove, self.firstPokemon, self.secondPokemon, self.firstSprite, self.secondSprite, self.firstBar, self.secondBar,

    function()
        Timer.after(0.5, function()
            self:attack(self.secondMove, self.secondPokemon, self.firstPokemon, self.secondSprite, self.firstSprite, self.secondBar, self.firstBar,
            
            function()
                -- remove the last attack state from the stack
                gStateStack:pop()
                gStateStack:push(BattleMenuState(self.battleState))
            end)
        end)
    end)
end

function TakeTurnState:attack(move, attacker, defender, attackerSprite, defenderSprite, attackerkBar, defenderBar, onEnd)
    -- this message is not allowed to take input at first, so it stays on the stack
    -- during the animation
    gStateStack:push(BattleMessageState(attacker.name .. ' used ' .. move.text .. '!',
        function() end, false))

    Timer.after(0.8, function()
        -- if move still has power points
        if attacker.pp[move.text] > 0 then
            -- lower move's power points by 1
            attacker.pp[move.text] = attacker.pp[move.text] - 1

            -- if defender is within range of move
            if math.abs(attacker.position - defender.position) <= move.range then

                -- if move lands
                local accStatStage = attacker.statStages.accuracy - defender.statStages.evasion
                accStatStage = math.abs(accStatStage) > 6 and 6 * math.abs(accStatStage) / accStatStage or accStatStage
                if math.random(100) <= move.accuracy * math.max(3, 3 + accStatStage) / math.max(3, 3 - accStatStage) then
                    -- attack sound
                    gSounds['powerup']:stop()
                    gSounds['powerup']:play()

                    -- blink the attacker sprite three times (turn on and off blinking 6 times)
                    Timer.every(0.1, function()
                        attackerSprite.blinking = not attackerSprite.blinking
                    end)
                    :limit(6)
                    :finish(function()
                        -- pop attack message
                        gStateStack:pop()
                        
                        if move.oStats then
                            self:power(false, move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, onEnd)
                            self:bStats(false, move, attacker, defender, onEnd)
                            self:pStats(false, move, attacker, defender, onEnd)
                            self:oStats(true, move, attacker, defender, onEnd)
                        elseif move.pStats then
                            self:power(false, move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, onEnd)
                            self:bStats(false, move, attacker, defender, onEnd)
                            self:pStats(true, move, attacker, defender, onEnd)
                        elseif move.bStats then
                            self:power(false, move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, onEnd)
                            self:bStats(true, move, attacker, defender, onEnd)
                        else
                            self:power(true, move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, onEnd)
                        end
                    end)
                else
                    -- pop attack message
                    gStateStack:pop()
                    -- push a message saying attack missed
                    gStateStack:push(BattleMessageState(attacker.name .. '\'s attack missed!',
                        function() onEnd() end))
                end
            else
                -- pop attack message
                    gStateStack:pop()
                -- push a message saying defender is too far
                if math.random(2) == 1 then
                    gStateStack:push(BattleMessageState(defender.name .. ' is too far!',
                        function() onEnd() end))
                else
                    gStateStack:push(BattleMessageState(defender.name .. ' is out of range!',
                        function() onEnd() end))
                end
            end
        else
            -- pop attack message
                    gStateStack:pop()
            -- push a message saying out of pp
            gStateStack:push(BattleMessageState(move.name .. 'has no pp left!',
                function() onEnd() end))
        end
    end)
end

function TakeTurnState:power(last, move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, onEnd)
    if move.power then
        -- after finishing the blink, play a hit sound and flash the opacity of
        -- the defender a few times
        gSounds['hit']:stop()
        gSounds['hit']:play()

        Timer.every(0.1, function()
            defenderSprite.opacity = defenderSprite.opacity == 0.25 and 1 or 0.25
        end)
        :limit(6)
        :finish(function()
            local dmg = ( ((2 * attacker.level / 5) + 2) * move.power * attacker.attack / defender.defense ) / 50 + 2

            -- multipliers
            local multiplier = math.random(0.85, 1)
            if math.random(16) == 1 then
                multiplier = multiplier * 1.5
            end
            if attacker.type == move.type then
                multiplier = multiplier * 1.5
            end

            dmg = dmg * multiplier

            Timer.tween(0.5, {
                [defenderBar] = {value = defender.currentHP - dmg}
            })
            :finish(function()
                defender.currentHP = defender.currentHP - dmg

                -- check to see whether the player or enemy died
                if self:checkDeaths() then 
                    gStateStack:pop()
                    return
                end

                if last == true then
                    onEnd()
                end
            end)
        end)
    end
end

function TakeTurnState:bStats(last, move, attacker, defender, onEnd)

end

function TakeTurnState:pStats(last, move, attacker, defender, onEnd)
    if move.pStats then
        if last == true then
            if move.pStats.evasion then
                last = 'evasion'
            elseif move.pStats.accuracy then
                last = 'accuracy'
            elseif move.pStats.speed then
                last = 'speed'
            elseif move.pStats.defense then
                last = 'defense'
            elseif move.pStats.attack then
                last = 'attack'
            elseif move.pStats.position then
                last = 'position'
            end
        end

        if move.pStats.attack then
            local strStat = 'attack'
            if math.abs(attacker.statStages.attack) == 6 then
                if math.random(2) == 1 then
                    -- push new message
                    gStateStack:push(BattleMessageState(attacker.name .. '\'s ' .. strStat .. ' won\'t go any ' .. attacker.statStages.attack == 6 and 'higher!' or 'lower!',
                        function()
                            if last == strStat then
                                onEnd()
                            end
                        end))
                else
                    -- push new message
                    gStateStack:push(BattleMessageState('Nothing happened!',
                        function()
                            if last == strStat then
                                onEnd()
                            end
                        end))
                end
            else
                attacker.statStages.attack = attacker.statStages.attack + move.pStats.attack

                local actualEffect

                if math.abs(attacker.statStages.attack) > 6 then
                    actualEffect = move.pStats.attack - (attacker.statStages.attack - 6 * math.abs(attacker.statStages.attack) / attacker.statStages.attack)
                    attacker.statStages.attack = 6 * math.abs(attacker.statStages.attack) / attacker.statStages.attack
                else
                    actualEffect = move.pStats.attack
                end

                if actualEffect == 1 then
                    -- push new message
                    gStateStack:push(BattleMessageState(attacker.name .. '\'s ' .. strStat .. ' rose!',
                        function()
                            if last == strStat then
                                onEnd()
                            end
                        end))
                elseif actualEffect == 2 then
                    -- push new message
                    gStateStack:push(BattleMessageState(attacker.name .. '\'s ' .. strStat .. ' sharply rose!',
                        function()
                            if last == strStat then
                                onEnd()
                            end
                        end))
                elseif actualEffect >= 3 then
                    -- push new message
                    gStateStack:push(BattleMessageState(attacker.name .. '\'s ' .. strStat .. ' rose drastically!',
                        function()
                            if last == strStat then
                                onEnd()
                            end
                        end))
                elseif actualEffect == -1 then
                    -- push new message
                    gStateStack:push(BattleMessageState(attacker.name .. '\'s ' .. strStat .. ' fell!',
                        function()
                            if last == strStat then
                                onEnd()
                            end
                        end))
                elseif actualEffect == -2 then
                    -- push new message
                    gStateStack:push(BattleMessageState(attacker.name .. '\'s ' .. strStat .. ' harshly fell!',
                        function()
                            if last == strStat then
                                onEnd()
                            end
                        end))
                elseif actualEffect <= -3 then
                    -- push new message
                    gStateStack:push(BattleMessageState(attacker.name .. '\'s ' .. strStat .. ' severely fell!',
                        function()
                            if last == strStat then
                                onEnd()
                            end
                        end))
                end
            end
        end

        if move.pStats.defense then

        end
    end
end

function TakeTurnState:oStats(last, move, attacker, defender, onEnd)

end

function TakeTurnState:checkDeaths()
    if self.playerPokemon.currentHP <= 0 then
        self:faint()
        return true
    elseif self.opponentPokemon.currentHP <= 0 then
        self:victory()
        return true
    end

    return false
end

function TakeTurnState:faint()

    -- drop player sprite down below the window
    Timer.tween(0.2, {
        [self.playerSprite] = {y = VIRTUAL_HEIGHT}
    })
    :finish(function()
        
        -- when finished, push a loss message
        gStateStack:push(BattleMessageState('You fainted!',
    
        function()

            -- fade in black
            gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()
                
                -- restore player pokemon to full health
                self.playerPokemon.currentHP = self.playerPokemon.HP

                -- resume field music
                gSounds['battle-music']:stop()
                gSounds['field-music']:play()
                
                -- pop off the battle state and back into the field
                gStateStack:pop()
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1, function() 
                    gStateStack:push(DialogueState('Your Pokemon has been fully restored; try again!'))
                end))
            end))
        end))
    end)
end

function TakeTurnState:victory()

    -- drop enemy sprite down below the window
    Timer.tween(0.2, {
        [self.opponentSprite] = {y = VIRTUAL_HEIGHT}
    })
    :finish(function()
        -- play victory music
        gSounds['battle-music']:stop()

        gSounds['victory-music']:setLooping(true)
        gSounds['victory-music']:play()

        -- when finished, push a victory message
        gStateStack:push(BattleMessageState('Victory!',
        
        function()

            -- sum all IVs and multiply by level to get exp amount
            local exp = (self.opponentPokemon.HPIV + self.opponentPokemon.attackIV +
                self.opponentPokemon.defenseIV + self.opponentPokemon.speedIV) * self.opponentPokemon.level

            gStateStack:push(BattleMessageState('You earned ' .. tostring(exp) .. ' experience points!',
                function() end, false))

            Timer.after(1.5, function()
                gSounds['exp']:play()

                -- animate the exp filling up
                Timer.tween(0.5, {
                    [self.battleState.playerExpBar] = {value = math.min(self.playerPokemon.currentExp + exp, self.playerPokemon.expToLevel)}
                })
                :finish(function()
                    
                    -- pop exp message off
                    gStateStack:pop()

                    self.playerPokemon.currentExp = self.playerPokemon.currentExp + exp

                    -- level up if we've gone over the needed amount
                    if self.playerPokemon.currentExp > self.playerPokemon.expToLevel then
                        
                        gSounds['levelup']:play()

                        -- set our exp to whatever the overlap is
                        self.playerPokemon.currentExp = self.playerPokemon.currentExp - self.playerPokemon.expToLevel

                        local stats = {
                            HP = self.playerPokemon.HP,
                            attack = self.playerPokemon.attack,
                            defense = self.playerPokemon.defense,
                            speed = self.playerPokemon.speed
                        }

                        stats['HPIncrease'], stats['attackIncrease'], stats['defenseIncrease'], stats['speedIncrease'] = self.playerPokemon:levelUp()

                        gStateStack:push(LevelUpState(stats, function() self:fadeOutWhite() end))
                    else
                        self:fadeOutWhite()
                    end
                end)
            end)
        end))
    end)
end

function TakeTurnState:fadeOutWhite()
    -- fade in
    gStateStack:push(FadeInState({
        r = 1, g = 1, b = 1
    }, 1, 
    function()

        -- resume field music
        gSounds['victory-music']:stop()
        gSounds['field-music']:play()
        
        -- pop off the battle state
        gStateStack:pop()
        gStateStack:push(FadeOutState({
            r = 1, g = 1, b = 1
        }, 1, function() end))
    end))
end
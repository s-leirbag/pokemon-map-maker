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
        self.secondMove = self.secondPokemon.currentMoves[math.random(2)]
    else
        self.firstPokemon = self.opponentPokemon
        self.secondPokemon = self.playerPokemon
        self.firstSprite = self.opponentSprite
        self.secondSprite = self.playerSprite
        self.firstBar = self.battleState.opponentHealthBar
        self.secondBar = self.battleState.playerHealthBar
        self.firstMove = self.secondPokemon.currentMoves[math.random(2)]
        self.secondMove = playerMove
    end
end

function TakeTurnState:enter(params)
    self:makeMove(self.firstMove, self.firstPokemon, self.secondPokemon, self.firstSprite, self.secondSprite, self.firstBar, self.secondBar,

    function()
        Timer.after(0.5, function()
            self:makeMove(self.secondMove, self.secondPokemon, self.firstPokemon, self.secondSprite, self.firstSprite, self.secondBar, self.firstBar,
            
            function()
                -- remove the last attack state from the stack
                gStateStack:pop()
                gStateStack:push(self.battleState.battleMenuState)
            end)
        end)
    end)
end

function TakeTurnState:makeMove(move, attacker, defender, attackerSprite, defenderSprite, attackerkBar, defenderBar, onEnd)
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
                            self:power(move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, function()
                                self:bStats(move, attacker, defender, function()
                                    self:poStats(move.pStats, attacker, defender, 'user', function()
                                        self:poStats(move.oStats, defender, attacker, 'other', onEnd)
                                    end)
                                end)
                            end)
                        elseif move.pStats then
                            self:power(move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, function()
                                self:bStats(move, attacker, defender, function()
                                    self:poStats(move.pStats, attacker, defender, 'user', onEnd)
                                end)
                            end)
                        elseif move.bStats then
                            self:power(move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, function()
                                self:bStats(move, attacker, defender, onEnd)
                            end)
                        else
                            self:power(move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, onEnd)
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

function TakeTurnState:power(move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite, onEnd)
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
            local dmg = ( ((2 * attacker.level / 5) + 2) * move.power * (attacker.attack * attacker.multipliers.attack) / (defender.defense * defender.multipliers.defense) ) / 50 + 2

            -- multipliers
            local multiplier = 1--math.random(0.85, 1)
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

                onEnd()
            end)
        end)
    else
        onEnd()
    end
end

function TakeTurnState:bStats(move, attacker, defender, onEnd)
    onEnd()
end

-- player/opponent stat changes are interchangeable
-- u_o other means who is affected, the move's user or the other
function TakeTurnState:poStats(stats, affected, other, u_o, onEnd)
    if stats then
        ------------ FIX INFO MUST CHANGE ACTUAL STATS
        local info = {
            stats = stats,
            affected = affected,
            other = other,
            u_o = u_o,
            onEnd = onEnd
        }

        local position = function()
            local after = onEnd
            if stats.position then
                local strStat = 'position'
                -- reached limit
                if math.abs(affected.position) == 6 then
                    if math.random(2) == 1 then
                        self:pushMoveMessage(affected.name .. ' can\'t move farther ' .. (affected.position == 6 and 'forward!' or 'back!'), after)
                    else
                        self:pushMoveMessage('Nothing happened!', after)
                    end
                else
                    local actualEffect

                    -- user is player
                    if affected.position < other.position then
                        -- collides with other
                        if affected.position + stats.position >= other.position then
                            actualEffect = other.position - affected.position - 1
                            affected.position = affected.position + actualEffect
                        -- exceeds limit
                        elseif affected.position + stats.position < -6 then
                            actualEffect = -6 - affected.position
                            affected.position = affected.position + actualEffect
                        -- all good
                        else
                            actualEffect = stats.position
                            affected.position = affected.position + actualEffect
                        end    
                    -- user is opponent, user position < other position
                    else
                        if affected.position - stats.position <= other.position then
                            actualEffect = affected.position - other.position - 1
                            affected.position = affected.position - actualEffect
                        elseif affected.position - stats.position > 6 then
                            actualEffect = affected.position - 6
                            affected.position = affected.position - actualEffect
                        else
                            actualEffect = stats.position
                            affected.position = affected.position - actualEffect
                        end
                    end

                    -- if they are right next to each other and trying to move past the other
                    if actualEffect == 0 then
                        self:pushMoveMessage(affected.name .. ' and ' .. other.name .. ' are too close!', after)
                    elseif u_o == 'other' then
                        if actualEffect == 1 then
                            self:pushMoveMessage(affected.name .. ' was pulled in!', after)
                        elseif actualEffect == 2 then
                            self:pushMoveMessage(affected.name .. ' was sharply pulled closer!', after)
                        elseif actualEffect >= 3 then
                            self:pushMoveMessage(affected.name .. ' was drastically pulled in!', after)
                        elseif actualEffect == -1 then
                            self:pushMoveMessage(affected.name .. ' was pushed back!', after)
                        elseif actualEffect == -2 then
                            self:pushMoveMessage(affected.name .. ' was sharply pushed back!', after)
                        elseif actualEffect <= -3 then
                            self:pushMoveMessage(affected.name .. ' was drastically thrusted back!', after)
                        end
                    else
                        if actualEffect == 1 then
                            self:pushMoveMessage(affected.name .. ' stepped forward!', after)
                        elseif actualEffect == 2 then
                            self:pushMoveMessage(affected.name .. ' took a big step forward!', after)
                        elseif actualEffect >= 3 then
                            self:pushMoveMessage(affected.name .. ' rushed forward!', after)
                        elseif actualEffect == -1 then
                            self:pushMoveMessage(affected.name .. ' stepped back!', after)
                        elseif actualEffect == -2 then
                            self:pushMoveMessage(affected.name .. ' took a big step back!', after)
                        elseif actualEffect <= -3 then
                            self:pushMoveMessage(affected.name .. ' leaped back!', after)
                        end
                    end
                end
            else
                after()
            end
        end

        local evasion = function()
            local after = position
            if stats.evasion then
                affected.statStages.evasion, affected.multipliers.evasion = self:statChange('evasion', stats.evasion, affected.statStages.evasion, affected.multipliers.evasion, affected, after)
            else
                after()
            end
        end

        local accuracy = function()
            local after = evasion
            if stats.accuracy then
                affected.statStages.accuracy, affected.multipliers.accuracy = self:statChange('accuracy', stats.accuracy, affected.statStages.accuracy, affected.multipliers.accuracy, affected, after)
            else
                after()
            end
        end

        local speed = function()
            local after = accuracy
            if stats.speed then
                affected.statStages.speed, affected.multipliers.speed = self:statChange('speed', stats.speed, affected.statStages.speed, affected.multipliers.speed, affected, after)
            else
                after()
            end
        end

        local defense = function()
            local after = speed
            if stats.defense then
                affected.statStages.defense, affected.multipliers.defense = self:statChange('defense', stats.defense, affected.statStages.defense, affected.multipliers.defense, affected, after)
            else
                after()
            end
        end

        local attack = function()
            local after = defense
            if stats.attack then
                affected.statStages.attack, affected.multipliers.attack = self:statChange('attack', stats.attack, affected.statStages.attack, affected.multipliers.attack, affected, after)
            else
                after()
            end
        end

        attack()
    else
        onEnd()
    end
end

function TakeTurnState:statChange(strStat, effect, statStage, multiplier, affected, onEnd)
    if math.abs(statStage) == 6 then
        if math.random(2) == 1 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' won\'t go any ' .. (statStage == 6 and 'higher!' or 'lower!'), onEnd)
        else
            self:pushMoveMessage('Nothing happened!', onEnd)
        end
    else
        local actualEffect

        if math.abs(statStage + effect) > 6 then
            actualEffect = 6 * math.abs(statStage) / statStage - statStage
            statStage = statStage + actualEffect
        else
            actualEffect = effect
            statStage = statStage + actualEffect
        end

        -- update multiplier
        multiplier = math.max(2, 2 + statStage) / math.max(2, 2 - statStage)

        if actualEffect == 1 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' rose!', onEnd)
        elseif actualEffect == 2 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' sharply rose!', onEnd)
        elseif actualEffect >= 3 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' rose drastically!', onEnd)
        elseif actualEffect == -1 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' fell!', onEnd)
        elseif actualEffect == -2 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' harshly fell!', onEnd)
        elseif actualEffect <= -3 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' severely fell!', onEnd)
        end
    end

    return statStage, multiplier
end

function TakeTurnState:pushMoveMessage(message, onEnd)
    gStateStack:push(BattleMessageState(message,
        onEnd))
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
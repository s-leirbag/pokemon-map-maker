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
                            self:power(false, move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite)
                            self:bStats(false, move, attacker, defender)
                            self:poStats(false, move.pStats, attacker, defender)
                            self:poStats(true, move.oStats, defender, attacker)
                        elseif move.pStats then
                            self:power(false, move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite)
                            self:bStats(false, move, attacker, defender)
                            self:poStats(true, move.pStats, attacker, defender, onEnd)
                        elseif move.bStats then
                            self:power(false, move, attacker, defender, attackerBar, defenderBar, attackerSprite, defenderSprite)
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

                if last == true then
                    onEnd()
                end
            end)
        end)
    end
end

function TakeTurnState:bStats(last, move, attacker, defender, onEnd)

end

-- player/opponent stat changes are interchangeable
function TakeTurnState:poStats(last, stats, affected, other, onEnd)
    if stats then
        if last == true then
            if stats.position then
                last = 'position'
            elseif stats.evasion then
                last = 'evasion'
            elseif stats.accuracy then
                last = 'accuracy'
            elseif stats.speed then
                last = 'speed'
            elseif stats.defense then
                last = 'defense'
            elseif stats.attack then
                last = 'attack'
            end
        end

        if stats.attack then
            affected.statStages.attack, affected.multipliers.attack = self:statChange(last == 'attack', 'attack', stats.attack, affected.statStages.attack, affected.multipliers.attack, affected, onEnd)
        end
        if stats.defense then
            affected.statStages.defense, affected.multipliers.defense = self:statChange(last == 'defense', 'defense', stats.defense, affected.statStages.defense, affected.multipliers.defense, affected, onEnd)
        end
        if stats.speed then
            affected.statStages.speed, affected.multipliers.speed = self:statChange(last == 'speed', 'speed', stats.speed, affected.statStages.speed, affected.multipliers.speed, affected, onEnd)
        end
        if stats.accuracy then
            affected.statStages.accuracy, affected.multipliers.accuracy = self:statChange(last == 'accuracy', 'accuracy', stats.accuracy, affected.statStages.accuracy, affected.multipliers.accuracy, affected, onEnd)
        end
        if stats.evasion then
            affected.statStages.evasion, affected.multipliers.evasion = self:statChange(last == 'evasion', 'evasion', stats.evasion, affected.statStages.evasion, affected.multipliers.evasion, affected, onEnd)
        end
        if stats.position then
            -- FIX POSITION PROBLEM, OPPONENT VS PLAYER + - CHANGES
            local strStat = 'position'
            if math.abs(affected.position) == 6 then
                if math.random(2) == 1 then
                    self:pushMoveMessage(affected.name .. 'can\'t move farther ' .. (affected.position == 6 and 'forward!' or 'back!'), last, onEnd)
                else
                    self:pushMoveMessage('Nothing happened!', last == 'position', onEnd)
                end
            elseif math.abs(affected.position - other.position) == 1 then
                self:pushMoveMessage(affected.name .. ' and ' .. other.name .. ' are too close!')
            else
                local actualEffect

                if math.abs(affected.position + effect) > 6 then
                    actualEffect = 6 * math.abs(affected.position) / affected.position - affected.position
                    affected.position = affected.position + actualEffect
                elseif affected.position < other.position and affected.position + effect >= other.position then
                    actualEffect = other.position - affected.position - 1
                    affected.position = affected.position + actualEffect
                elseif affected.position > other.position and affected.position + effect <= other.position then
                    actualEffect = other.position - affected.position - 1
                    affected.position = affected.position + actualEffect
                else
                    actualEffect = effect
                    affected.position = affected.position + actualEffect
                end

                if actualEffect == 1 then
                    self:pushMoveMessage(affected.name .. 'stepped forward!', last == 'position', onEnd)
                elseif actualEffect == 2 then
                    self:pushMoveMessage(affected.name .. 'took a big step forward!', last == 'position', onEnd)
                elseif actualEffect >= 3 then
                    self:pushMoveMessage(affected.name .. 'rushed forward!', last == 'position', onEnd)
                elseif actualEffect == -1 then
                    self:pushMoveMessage(affected.name .. 'stepped back!', last == 'position', onEnd)
                elseif actualEffect == -2 then
                    self:pushMoveMessage(affected.name .. 'took a big step back!', last == 'position', onEnd)
                elseif actualEffect <= -3 then
                    self:pushMoveMessage(affected.name .. 'leaped back!', last == 'position', onEnd)
                end
            end
        end
    end
end

function TakeTurnState:statChange(last, strStat, effect, statStage, multiplier, affected, onEnd)
    if math.abs(statStage) == 6 then
        if math.random(2) == 1 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' won\'t go any ' .. (statStage == 6 and 'higher!' or 'lower!'), last, onEnd)
        else
            self:pushMoveMessage('Nothing happened!', last, onEnd)
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
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' rose!', last, onEnd)
        elseif actualEffect == 2 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' sharply rose!', last, onEnd)
        elseif actualEffect >= 3 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' rose drastically!', last, onEnd)
        elseif actualEffect == -1 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' fell!', last, onEnd)
        elseif actualEffect == -2 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' harshly fell!', last, onEnd)
        elseif actualEffect <= -3 then
            self:pushMoveMessage(affected.name .. '\'s ' .. strStat .. ' severely fell!', last, onEnd)
        end
    end

    return statStage, multiplier
end

function TakeTurnState:pushMoveMessage(message, last, onEnd)
    gStateStack:push(BattleMessageState(message,
        function()
            if last then
                onEnd()
            end
        end))
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
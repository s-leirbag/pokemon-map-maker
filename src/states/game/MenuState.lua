MenuState = Class{__includes = BaseState}

function MenuState:init(def)
	self.menu = def.menu
	self.closeable = def.closeable
	self.onClose = def.onClose or function() end

	if def.onEnter then
		def.onEnter()
	end
end

function MenuState:update(dt)
	self.menu:update(dt)

	if self.closeable then
		if love.keyboard.isDown('z') then
		    gStateStack:pop()
		    self.onClose()
		end
	end
end

function MenuState:render()
	self.menu:render()
end
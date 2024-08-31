-- local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Die").extends(gfx.sprite)

function Die:init(posX, posY)
	Die.super.init(self)

	self.value = 1
	self.isLocked = false
	self.isRolling = false
	self.isSelected = false
	self.images = gfx.imagetable.new("images/die")

	self:setupRoller()
	self:randomizeValue()
	self:moveTo(posX, posY)

	self.lock = Lock(self.isLocked)
	self.lock:moveTo(posX, posY - self.height - 4)
	self.lock:add()
end

function Die:setSelected(isSelected)
	-- log("[Die] setting selected", self.value, isSelected and "Y" or "N")
	self.isSelected = isSelected
	self:setImageDrawMode(isSelected and gfx.kDrawModeInverted or gfx.kDrawModeCopy)
end

function Die:confirmSelection()
	self.isLocked = not self.isLocked
	self.lock:setLocked(self.isLocked)
end

function Die:cheatValue(value)
	self.value = value
	self:setImage(self.images:getImage(self.value))
end

function Die:randomizeValue()
	local previousValue = self.value

	-- no repeats
	while self.value == previousValue do
		self.value = math.random(6)
	end

	self:setImage(self.images:getImage(self.value))
end

function Die:setupRoller()
	self.roller = playdate.timer.new(50)
	self.roller.repeats = true
	self.roller.timerEndedCallback = function()
		self:randomizeValue()
	end

	self.roller:pause()
end

function Die:startRolling()
	if self.isRolling or self.isLocked then return end

	self.isRolling = true
	self.roller:start()
end

function Die:stopRolling()
	if not self.isRolling then return end

	self.isRolling = false
	self.roller:pause()
end

return Die

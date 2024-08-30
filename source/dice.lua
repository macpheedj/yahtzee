local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Dice").extends(gfx.sprite)

function Dice:init()
	Dice.super.init(self)

	self.isHeld = false
	self.isRolling = false
	self.value = 1
	self.images = gfx.imagetable.new("images/die")

	self:setupRoller()
	self:randomizeValue()
end

function Dice:randomizeValue()
	local previousValue = self.value

	-- no repeats
	while self.value == previousValue do
		self.value = math.random(6)
	end

	self:setImage(self.images:getImage(self.value))
end

function Dice:setupRoller()
	self.roller = playdate.timer.new(50)
	self.roller.repeats = true
	self.roller.timerEndedCallback = function()
		self:randomizeValue()
	end

	self.roller:pause()
end

function Dice:startRolling()
	if self.isRolling or self.isHeld then return end

	self.isRolling = true
	self.roller:start()
end

function Dice:stopRolling()
	if not self.isRolling then return end

	self.isRolling = false
	self.roller:pause()
end

function Dice:update()
	if DEBUG then
		if pd.buttonJustPressed(pd.kButtonA) then self:startRolling() end
		if pd.buttonJustPressed(pd.kButtonB) then self:stopRolling() end
	end
end

return Dice

local gfx <const> = playdate.graphics

class("Dice").extends(gfx.sprite)

function Dice:init()
	Dice.super.init(self)

	self.isHeld = false
end

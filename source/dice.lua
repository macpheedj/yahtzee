local gfx <const> = playdate.graphics

class("Dice").extends(gfx.sprite)

function Dice:init()
	Dice.super.init(self)

	self.isHeld = false
	self.images = gfx.imagetable.new("images/die")

	self:randomizeDie()
end

function Dice:randomizeDie()
	local rng = math.random(6)
	local image = self.images:getImage(rng)
	self:setImage(image)
end

return Dice

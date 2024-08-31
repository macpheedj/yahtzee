local gfx <const> = playdate.graphics

class("Lock").extends(gfx.sprite)

function Lock:init(isLocked)
	self.images = gfx.imagetable.new("images/lock")
	self:setLocked(isLocked)
end

function Lock:setLocked(isLocked)
	self:setImage(self.images:getImage(isLocked and 1 or 2))
end

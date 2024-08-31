local gfx <const> = playdate.graphics

class("Scoreboard").extends(gfx.sprite)

function Scoreboard:init()
	self:moveTo(200, 40)
	self:add()
end

function Scoreboard:displayRoll(roll)
	local text = "*Roll\n" .. roll .. "*"
	local image = gfx.imageWithText(text, 72, 48, nil, nil, nil, kTextAlignment.center)
	self:setImage(image)
end

function Scoreboard:displayScore()
	local text = "*Score\n" .. SCORE .. "*"
	local image = gfx.imageWithText(text, 72, 48, nil, nil, nil, kTextAlignment.center)
	self:setImage(image)
end

function Scoreboard:previewScore(points)
	local text = "*Score\n" .. SCORE .. " + " .. points .. "*"
	local image = gfx.imageWithText(text, 72, 48, nil, nil, nil, kTextAlignment.center)
	self:setImage(image)
end

return Scoreboard

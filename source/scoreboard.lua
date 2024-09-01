local gfx <const> = playdate.graphics

class("Scoreboard").extends(gfx.sprite)

function Scoreboard:init()
	self.toggleBool = false
	self:moveTo(200, 36)
	self:add()
end

function Scoreboard:displayFinal()
	local text = "*Final Score\n" .. SCORE .. "*"
	local image = gfx.imageWithText(text, 72, 48, nil, nil, nil, kTextAlignment.center)
	self:setImage(image)
end

function Scoreboard:displayStop()
	local text = "*A or B\nto STOP*"
	local image = gfx.imageWithText(text, 72, 48, nil, nil, nil, kTextAlignment.center)
	self:setImage(image)
end

function Scoreboard:displayRoll()
	local text = ROLL == 0 and "*Crank to\nROLL*" or "*Roll\n" .. ROLL .. "*"
	local image = gfx.imageWithText(text, 72, 48, nil, nil, nil, kTextAlignment.center)
	self:setImage(image)
end

function Scoreboard:displayScore()
	local text = "*Score\n" .. SCORE .. "*"
	local image = gfx.imageWithText(text, 72, 48, nil, nil, nil, kTextAlignment.center)
	self:setImage(image)
end

function Scoreboard:previewScore(points)
	local text = "*Score\n" .. "+" .. points .. "*"
	local image = gfx.imageWithText(text, 72, 48, nil, nil, nil, kTextAlignment.center)
	self:setImage(image)
end

function Scoreboard:toggleDisplay()
	self.toggleBool = not self.toggleBool

	if self.toggleBool then self:displayScore() end
	if not self.toggleBool then self:displayRoll() end
end

function Scoreboard:startToggling()
	self.toggleTimer = playdate.timer.new(1000)
	self.toggleTimer.repeats = true
	self.toggleTimer.timerEndedCallback = function()
		self:toggleDisplay()
	end
end

function Scoreboard:stopToggling()
	if self.toggleTimer == nil then return end
	self.toggleTimer:pause()
end

return Scoreboard

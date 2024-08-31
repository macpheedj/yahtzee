-- local pd <const> = playdate
local gfx <const> = playdate.graphics
-- local font = gfx.font.new('fonts/Razzle')

local margin = 4
local padding = margin * 2
local scoreSize = 48
local scoreSizeHalf = scoreSize / 2
local screenWidth, screenHeight = 400, 240

local positions = {
	-- TOP ROW LEFT
	{ x = padding + scoreSizeHalf,                                            y = padding + scoreSizeHalf },
	{ x = padding + scoreSizeHalf + margin + scoreSize,                       y = padding + scoreSizeHalf },
	{ x = padding + scoreSizeHalf + margin * 2 + scoreSize * 2,               y = padding + scoreSizeHalf },

	-- TOP ROW RIGHT
	{ x = screenWidth - padding - scoreSizeHalf - margin * 2 - scoreSize * 2, y = padding + scoreSizeHalf },
	{ x = screenWidth - padding - scoreSizeHalf - margin - scoreSize,         y = padding + scoreSizeHalf },
	{ x = screenWidth - padding - scoreSizeHalf,                              y = padding + scoreSizeHalf },

	-- BOTTOM ROW LEFT
	{ x = padding + scoreSizeHalf,                                            y = padding + scoreSizeHalf + margin + scoreSize },
	{ x = padding + scoreSizeHalf + margin + scoreSize,                       y = padding + scoreSizeHalf + margin + scoreSize },
	{ x = padding + scoreSizeHalf + margin * 2 + scoreSize * 2,               y = padding + scoreSizeHalf + margin + scoreSize },

	-- BOTTOM ROW RIGHT
	{ x = screenWidth - padding - scoreSizeHalf - margin * 2 - scoreSize * 2, y = padding + scoreSizeHalf + margin + scoreSize },
	{ x = screenWidth - padding - scoreSizeHalf - margin - scoreSize,         y = padding + scoreSizeHalf + margin + scoreSize },
	{ x = screenWidth - padding - scoreSizeHalf,                              y = padding + scoreSizeHalf + margin + scoreSize },

	-- YAHTZEE
	{ x = 200,                                                                y = padding + scoreSizeHalf + margin + scoreSize }
}

class("Score").extends(gfx.sprite)

function Score:init(positionIndex)
	self.points = 0
	self.index = positionIndex
	self.isSelected = false
	self.images = gfx.imagetable.new("images/scores/score")

	self:setupImage()
	self:setupPosition()
end

function Score:setupImage()
	self:setImage(self.images:getImage(self.index))
end

function Score:setupPosition()
	self:moveTo(positions[self.index].x, positions[self.index].y)
end

function Score:getDiceValues(dice)
	local values = {}

	for i, die in ipairs(dice) do
		-- print("value: ", die.value)
		values[i] = die.value
	end

	return values
end

function Score:scoreTopRow(values)
	print("scoring top row: ", self.index)

	for _, value in ipairs(values) do
		print("vs value: ", value)
		if self.index == value then
			self.points += value
		end
	end

	print("score: ", self.points)
	print("")
	return self.points
end

function Score:checkEligibility(dice)
	local values = self:getDiceValues(dice)

	if self.index <= 6 then return self:scoreTopRow(values) > 0 end
end

return Score

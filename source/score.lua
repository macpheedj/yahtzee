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
	self.values = {}
	self.points = 0
	self.numberMatching = 1 -- starts @ 1, increment for each match
	self.isYahtzee = true -- we are yahtzee until proven otherwise
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
	print("[Score] getting dice values for score #", self.index)
	self.values = {}

	table.sort(dice)

	for i, die in ipairs(dice) do
		self.values[i] = die.value

		if i > 1 then
			if self.values[i - 1] ~= self.values[i] then
				self.isYahtzee = false
			else
				self.numberMatching += 1
			end
		end
	end

	print("[Score] number matching:, ", self.numberMatching)
	print("[Score] ", self.isYahtzee and "is yahtzee btw" or "is NOT yahtzee")
	return self.values
end

function Score:scoreTopRow()
	print("scoring top row: ", self.index)

	for _, value in ipairs(self.values) do
		print("vs value: ", value)
		if self.index == value then
			self.points += value
		end
	end

	print("score: ", self.points)
	print("")
	return self.points
end

function Score:scoreNOfAKind(n, values)

end

function Score:checkEligibility(dice)
	self:getDiceValues(dice)

	if self.index <= 6 then return self:scoreTopRow() > 0 end
end

return Score

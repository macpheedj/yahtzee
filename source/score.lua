local gfx <const> = playdate.graphics

local margin = 4
local padding = margin * 2
local scoreSize = 48
local scoreSizeHalf = scoreSize / 2
local screenWidth = 400

local positions = {
	-- TOP ROW LEFT
	{ x = padding + scoreSizeHalf,                                            y = padding * 1.5 + scoreSizeHalf },
	{ x = padding + scoreSizeHalf + margin + scoreSize,                       y = padding * 1.5 + scoreSizeHalf },
	{ x = padding + scoreSizeHalf + margin * 2 + scoreSize * 2,               y = padding * 1.5 + scoreSizeHalf },

	-- TOP ROW RIGHT
	{ x = screenWidth - padding - scoreSizeHalf - margin * 2 - scoreSize * 2, y = padding * 1.5 + scoreSizeHalf },
	{ x = screenWidth - padding - scoreSizeHalf - margin - scoreSize,         y = padding * 1.5 + scoreSizeHalf },
	{ x = screenWidth - padding - scoreSizeHalf,                              y = padding * 1.5 + scoreSizeHalf },

	-- BOTTOM ROW LEFT
	{ x = padding + scoreSizeHalf,                                            y = padding * 1.5 + scoreSizeHalf + margin + scoreSize },
	{ x = padding + scoreSizeHalf + margin + scoreSize,                       y = padding * 1.5 + scoreSizeHalf + margin + scoreSize },
	{ x = padding + scoreSizeHalf + margin * 2 + scoreSize * 2,               y = padding * 1.5 + scoreSizeHalf + margin + scoreSize },

	-- BOTTOM ROW RIGHT
	{ x = screenWidth - padding - scoreSizeHalf - margin * 2 - scoreSize * 2, y = padding * 1.5 + scoreSizeHalf + margin + scoreSize },
	{ x = screenWidth - padding - scoreSizeHalf - margin - scoreSize,         y = padding * 1.5 + scoreSizeHalf + margin + scoreSize },
	{ x = screenWidth - padding - scoreSizeHalf,                              y = padding * 1.5 + scoreSizeHalf + margin + scoreSize },

	-- YAHTZEE
	{ x = 200,                                                                y = padding * 1.5 + scoreSizeHalf + margin + scoreSize }
}

class("Score").extends(gfx.sprite)

function Score:init(positionIndex)
	self.values = {}
	self.points = 0
	self.isYahtzee = true -- we are yahtzee until proven otherwise
	self.index = positionIndex
	self.isSelected = false
	self.images = gfx.imagetable.new("images/scores/score")
	self.numberAppearing = {}
	self.isDisabled = false

	for i = 1, 6 do self.numberAppearing[i] = 0 end

	self:setImage(self.images:getImage(self.index))
	self:moveTo(positions[self.index].x, positions[self.index].y)
end

function Score:setSelected(isSelected)
	-- log("[Score] setting selected", self.index, isSelected and "Y" or "N")
	self.isSelected = isSelected
	self:setImageDrawMode(isSelected and gfx.kDrawModeInverted or gfx.kDrawModeCopy)
end

function Score:confirmSelection()
	log("[Score] confirming selection", self.index)
	self.isDisabled = true
	SCORE += self.points

	if self.index <= 6 then
		SUBTOTAL += self.points

		if SUBTOTAL >= 63 and not SUBTOTAL_CLAIMED then
			SUBTOTAL_CLAIMED = true
			SCORE += 35
		end
	end

	if self.isYahtzee and BONUS_ELIGIBLE then
		SCORE += 100
	end

	if self.index == 13 and self.isYahtzee then
		BONUS_ELIGIBLE = true
	end

	local image = self.images:getImage(self.index)
	image = image:fadedImage(0.5, gfx.image.kDitherTypeDiagonalLine)
	self:setImage(image)
end

function Score:getDiceValues(dice)
	log("[Score] getting dice values for score #", self.index)
	self.values = {}

	-- sort a copy of the dice to maintain proper input order
	local diceCopy = {}
	table.move(dice, 1, #dice, 1, diceCopy)
	table.sort(diceCopy, function (a, b)
		return a.value < b.value
	end)

	-- reset numberAppearing
	for i = 1, 6 do self.numberAppearing[i] = 0 end
	self.isYahtzee = true

	for i, die in ipairs(diceCopy) do
		self.values[i] = die.value
		self.numberAppearing[die.value] += 1

		if i > 1 then
			if self.values[i - 1] ~= self.values[i] then
				self.isYahtzee = false
			end
		end
	end

	return self.values
end

function Score:getBonusValue()
	local bonus = 0

	if self.index <= 6 then
		if SUBTOTAL < 63 and SUBTOTAL + self.points >= 63 then
			bonus += 35
		end
	end

	if self.isYahtzee and BONUS_ELIGIBLE then
		bonus += 100
	end

	return bonus
end

function Score:getMatchCount()
	table.sort(self.numberAppearing)
	return self.numberAppearing[#self.numberAppearing], self.numberAppearing[#self.numberAppearing - 1]
end

function Score:sumValues()
	-- log("[Score] summing values")
	local total = 0

	for _, value in ipairs(self.values) do
		-- log("[Score] value", value)
		total += value
	end

	return total
end

function Score:scoreTopRow()
	log("[Score] scoring top row: ")
	self.points = 0

	for _, value in ipairs(self.values) do
		-- log(self.index, value)
		if self.index == value then
			self.points += value
		end
	end

	log("[Score] score: ", self.points)
	log("")
	return self.points, self:getBonusValue()
end

function Score:scoreNOfAKind(n)
	log("[Score] scoring " .. n .. " of a kind")
	local matchCount = self:getMatchCount()

	if matchCount >= n then
		self.points = self:sumValues()
	else
		self.points = 0
	end

	log("[Score] score: ", self.points)
	log("")
	return self.points, self:getBonusValue()
end

function Score:scoreFullHouse()
	log("[Score] scoring full house")
	if self.isYahtzee and BONUS_ELIGIBLE then
		self.points = 25
		return self.points, self:getBonusValue()
	end

	local count1, count2 = self:getMatchCount()

	if count1 == 3 and count2 == 2 then
		log("[Score] full house!")
		self.points = 25
	else
		self.points = 0
	end

	log("[Score] score: ", self.points)
	log("")
	return self.points, self:getBonusValue()
end

function Score:crawlNumberAppearing(start, count)
	log("crawl no. appearing: start = " .. start .. ", count = " .. count)
	local isStraight = true

	-- account for 1-index
	count -= 1

	for i = start, start + count do
		log(i .. " = " .. self.numberAppearing[i])
		if self.numberAppearing[i] == 0 then
			isStraight = false
			break
		end
	end

	return isStraight
end

function Score:scoreSmallStraight()
	log("[Score] scoring small straight")
	if self.isYahtzee and BONUS_ELIGIBLE then
		self.points = 30
		return self.points, self:getBonusValue()
	end

	if (
		self:crawlNumberAppearing(1, 4) or
		self:crawlNumberAppearing(2, 4) or
		self:crawlNumberAppearing(3, 4)
	) then
		-- log("is small straight")
		self.points = 30
	else
		-- log("is NOT small straight")
		self.points = 0
	end

	log("[Score] score: ", self.points)
	log("")
	return self.points, self:getBonusValue()
end

function Score:scoreLargeStraight()
	log("[Score] scoring large straight")
	if self.isYahtzee and BONUS_ELIGIBLE then
		self.points = 40
		return self.points, self:getBonusValue()
	end

	if (
		self:crawlNumberAppearing(1, 5) or
		self:crawlNumberAppearing(2, 5)
	) then
		log("is large straight")
		self.points = 40
	else
		log("is NOT large straight")
		self.points = 0
	end

	log("[Score] score: ", self.points)
	log("")
	return self.points, self:getBonusValue()
end

function Score:scoreChance()
	log("[Score] scoring chance")
	self.points = self:sumValues()
	log("[Score] score: ", self.points)
	log("")
	return self.points, self:getBonusValue()
end

function Score:scoreYahtzee()
	log("[Score] scoring yahtzee")
	if self.isYahtzee then
		self.points = 50
	else
		self.points = 0
	end

	log("[Score] score: ", self.points)
	log("")
	return self.points, 0
end

function Score:getScoreValue(dice)
	self:getDiceValues(dice)

	if self.index <= 6 then return self:scoreTopRow()
	elseif self.index == 7 then return self:scoreNOfAKind(3)
	elseif self.index == 8 then return self:scoreNOfAKind(4)
	elseif self.index == 9 then return self:scoreFullHouse()
	elseif self.index == 10 then return self:scoreSmallStraight()
	elseif self.index == 11 then return self:scoreLargeStraight()
	elseif self.index == 12 then return self:scoreChance()
	elseif self.index == 13 then return self:scoreYahtzee()
	end
end

return Score

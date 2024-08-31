SCORE = 0
SUBTOTAL = 0
BONUS_ELIGIBLE = false

class("Game").extends()

function Game:init()
	self.dice = {}
	self.scores = {}

	self:reset()
	self:setupDice()
	self:setupScores()
end

function Game:reset()
	SCORE = 0
	SUBTOTAL = 0
	BONUS_ELIGIBLE = false
end

function Game:setupScores()
	self.scores = {}

	for i = 1, 13 do
		self.scores[i] = Score(i)
		self.scores[i]:add()
	end
end

function Game:setupDice()
	self.dice = {}

	local scale = 1.5
	local width = 48 * scale
	local margin = 4
	local padding = margin * 2
	local start_position = ((48 / scale) * scale) - margin

	for i = 1, 5 do
		local offset = ((i - 1) * width) + (i * margin)

		self.dice[i] = Die()
		self.dice[i]:setScale(scale)
		self.dice[i]:moveTo(start_position + offset, 240 - width / 2 - padding)
		self.dice[i]:add()
	end

	return self.dice
end

return Game

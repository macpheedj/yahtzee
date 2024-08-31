SCORE = 0
SUBTOTAL = 0
BONUS_ELIGIBLE = false

local pd <const> = playdate
local gfx <const> = playdate.graphics

class("Game").extends(gfx.sprite)

function Game:init()
	self.dice = {}
	self.scores = {}
	self.roll = 1

	self.states = {
		STANDBY= "STANDBY",
		ROLLING = "ROLLING",
		SELECTING = "SELECTING",
	}
	self.state = self.states.STANDBY

	self:reset()
	self:add()
end

function Game:setState(state)
	assert(self.states[state], "[Game] invalid state: " .. state)
	log("[Game] setting state", state)

	self.state = state
	self:deselectAll()

	if self.state == self.states.SELECTING then
		self.scores[1]:setSelected(true)
	end
end

function Game:reset()
	-- log("[Game] reset")
	SCORE = 0
	SUBTOTAL = 0
	BONUS_ELIGIBLE = false

	self.dice = {}
	self.scores = {}

	self:setupDice()
	self:setupScores()
	self:setupSelection()
end

function Game:setupScores()
	-- log("[Game] setup scores")
	self.scores = {}

	for i = 1, 13 do
		self.scores[i] = Score(i)
		self.scores[i]:add()
	end
end

function Game:setupDice()
	-- log("[Game] setup dice")
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

function Game:setupSelection()
	self.selectionRow = 1
	self.selectionIndex = 1
	self.selectionIndices = {
		{ 1, 2, 3, 4,  5,  6 },
		{ 7, 8, 9, 13, 10, 11, 12 },
		{ 1, 2, 3, 4,  5 },
	}
	self.selectionInstructions = {
		-- TOP ROW
		{
			-- ACES
			{
				[pd.kButtonUp] = { row = 3, index = 1 },
				[pd.kButtonDown] = { row = 2, index = 1 },
				[pd.kButtonLeft] = { row = 1, index = 6 },
				[pd.kButtonRight] = { row = 1, index = 2 },
			},
			-- TWOS
			{
				[pd.kButtonUp] = { row = 3, index = 2 },
				[pd.kButtonDown] = { row = 2, index = 2 },
				[pd.kButtonLeft] = { row = 1, index = 1 },
				[pd.kButtonRight] = { row = 1, index = 3 },
			},
			-- THREES
			{
				[pd.kButtonUp] = { row = 3, index = 3 },
				[pd.kButtonDown] = { row = 2, index = 3 },
				[pd.kButtonLeft] = { row = 1, index = 2 },
				[pd.kButtonRight] = { row = 1, index = 4 },
			},
			-- FOURS
			{
				[pd.kButtonUp] = { row = 3, index = 3 },
				[pd.kButtonDown] = { row = 2, index = 5 },
				[pd.kButtonLeft] = { row = 1, index = 3 },
				[pd.kButtonRight] = { row = 1, index = 5 },
			},
			-- FIVES
			{
				[pd.kButtonUp] = { row = 3, index = 4 },
				[pd.kButtonDown] = { row = 2, index = 6 },
				[pd.kButtonLeft] = { row = 1, index = 4 },
				[pd.kButtonRight] = { row = 1, index = 6 },
			},
			-- SIXES
			{
				[pd.kButtonUp] = { row = 3, index = 5 },
				[pd.kButtonDown] = { row = 2, index = 7 },
				[pd.kButtonLeft] = { row = 1, index = 5 },
				[pd.kButtonRight] = { row = 1, index = 1 },
			},
		},

		-- MIDDLE ROW
		{
			-- 3 OF A KIND
			{
				[pd.kButtonUp] = { row = 1, index = 1 },
				[pd.kButtonDown] = { row = 3, index = 1 },
				[pd.kButtonLeft] = { row = 2, index = 7 },
				[pd.kButtonRight] = { row = 2, index = 2 },
			},
			-- 4 OF A KIND
			{
				[pd.kButtonUp] = { row = 1, index = 2 },
				[pd.kButtonDown] = { row = 3, index = 2 },
				[pd.kButtonLeft] = { row = 2, index = 1 },
				[pd.kButtonRight] = { row = 2, index = 3 },
			},
			-- FULL HOUSE
			{
				[pd.kButtonUp] = { row = 1, index = 3 },
				[pd.kButtonDown] = { row = 3, index = 3 },
				[pd.kButtonLeft] = { row = 2, index = 2 },
				[pd.kButtonRight] = { row = 2, index = 4 },
			},
			-- YAHTZEE
			{
				[pd.kButtonUp] = { row = 1, index = 3 },
				[pd.kButtonDown] = { row = 3, index = 3 },
				[pd.kButtonLeft] = { row = 2, index = 3 },
				[pd.kButtonRight] = { row = 2, index = 5 },
			},
			-- SMALL STRAIGHT
			{
				[pd.kButtonUp] = { row = 1, index = 4 },
				[pd.kButtonDown] = { row = 3, index = 3 },
				[pd.kButtonLeft] = { row = 2, index = 4 },
				[pd.kButtonRight] = { row = 2, index = 6 },
			},
			-- LARGE STRAIGHT
			{
				[pd.kButtonUp] = { row = 1, index = 5 },
				[pd.kButtonDown] = { row = 3, index = 4 },
				[pd.kButtonLeft] = { row = 2, index = 5 },
				[pd.kButtonRight] = { row = 2, index = 7 },
			},
			-- CHANCE
			{
				[pd.kButtonUp] = { row = 1, index = 6 },
				[pd.kButtonDown] = { row = 3, index = 5 },
				[pd.kButtonLeft] = { row = 2, index = 6 },
				[pd.kButtonRight] = { row = 2, index = 1 },
			},
		},

		-- BOTTOM ROW
		{
			-- FIRST
			{
				[pd.kButtonUp] = { row = 2, index = 1 },
				[pd.kButtonDown] = { row = 1, index = 1 },
				[pd.kButtonLeft] = { row = 3, index = 5 },
				[pd.kButtonRight] = { row = 3, index = 2 },
			},
			-- SECOND
			{
				[pd.kButtonUp] = { row = 2, index = 2 },
				[pd.kButtonDown] = { row = 1, index = 2 },
				[pd.kButtonLeft] = { row = 3, index = 1 },
				[pd.kButtonRight] = { row = 3, index = 3 },
			},
			-- THIRD
			{
				[pd.kButtonUp] = { row = 2, index = 4 },
				[pd.kButtonDown] = { row = 1, index = 3 },
				[pd.kButtonLeft] = { row = 3, index = 2 },
				[pd.kButtonRight] = { row = 3, index = 4 },
			},
			-- FOURTH
			{
				[pd.kButtonUp] = { row = 2, index = 6 },
				[pd.kButtonDown] = { row = 1, index = 5 },
				[pd.kButtonLeft] = { row = 3, index = 3 },
				[pd.kButtonRight] = { row = 3, index = 5 },
			},
			-- FIFTH
			{
				[pd.kButtonUp] = { row = 2, index = 7 },
				[pd.kButtonDown] = { row = 1, index = 6 },
				[pd.kButtonLeft] = { row = 3, index = 4 },
				[pd.kButtonRight] = { row = 3, index = 1 },
			},
		},
	}
end

function Game:rollDice()
	log("[Game] roll dice")
	self:setState(self.states.ROLLING)

	for _, die in ipairs(self.dice) do
		if not die.isHeld then
			die:startRolling()
		end
	end
end

function Game:stopNextDie(index)
	log("[Game] stopping die", index)
	if index > #self.dice then
		pd.timer.performAfterDelay(200, function()
			self:setState(self.states.SELECTING)
		end)
	else
		local die = self.dice[index]

		if die.isRolling then
			pd.timer.performAfterDelay(200, function()
				die:stopRolling()
				self:stopNextDie(index + 1)
			end)
		else
			self:stopNextDie(index + 1)
		end
	end
end

function Game:stopRolling()
	log("[Game] stop rolling")
	self:stopNextDie(1)
end

function Game:start()
	
end

function Game:deselectAll()
	for _, die in ipairs(self.dice) do die:setSelected(false) end
	for _, score in ipairs(self.scores) do score:setSelected(false) end
end

function Game:handleSelectionInput()
	self:deselectAll()

	local instructions = self.selectionInstructions[self.selectionRow][self.selectionIndex]
	local input = pd.buttonJustPressed(pd.kButtonUp) and pd.kButtonUp or
		pd.buttonJustPressed(pd.kButtonDown) and pd.kButtonDown or
		pd.buttonJustPressed(pd.kButtonLeft) and pd.kButtonLeft or
		pd.buttonJustPressed(pd.kButtonRight) and pd.kButtonRight

	self.selectionRow = instructions[input].row
	self.selectionIndex = instructions[input].index

	local index = self.selectionIndices[self.selectionRow][self.selectionIndex]

	if self.selectionRow < 3 then
		self.scores[index]:setSelected(true)
	else
		self.dice[index]:setSelected(true)
	end
end

function Game:update()
	if pd.buttonJustPressed(pd.kButtonA) then self:rollDice() end
	if pd.buttonJustPressed(pd.kButtonB) then self:stopRolling() end

	if self.state == self.states.SELECTING then
		if (
			pd.buttonJustPressed(pd.kButtonUp) or
			pd.buttonJustPressed(pd.kButtonDown) or
			pd.buttonJustPressed(pd.kButtonLeft) or
			pd.buttonJustPressed(pd.kButtonRight)
		) then
			self:handleSelectionInput()
		end
	end
end

return Game

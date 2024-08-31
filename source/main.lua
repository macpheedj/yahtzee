import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "score"
import "dice"

DEBUG = true
BONUS_ELIGIBLE = false

local gfx <const> = playdate.graphics

dice = {}
scores = {}

function setupScores()
	scores = {}

	for i = 1, 13 do
		scores[i] = Score(i)
		scores[i]:add()
	end
end

function setupDice()
	dice = {}

	local scale = 1.5
	local width = 48 * scale
	local margin = 4
	local padding = margin * 2
	local start_position = ((48 / scale) * scale) - margin

	for i = 1, 5 do
		local offset = ((i - 1) * width) + (i * margin)

		dice[i] = Dice()
		dice[i]:setScale(scale)
		dice[i]:moveTo(start_position + offset, 240 - width / 2 - padding)
		dice[i]:add()
	end

	for _, die in ipairs(dice) do
		setmetatable(die, {
			__lt = function(dieA, dieB)
				return dieA.value < dieB.value
			end
		})
	end

	return dice
end

function gameStart()
	print("hello world")
	math.randomseed(playdate.getSecondsSinceEpoch())

	setupScores()
	setupDice()

end

gameStart()

function playdate.update()

	if DEBUG then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			for _, score in ipairs(scores) do
				score:checkEligibility(dice)
			end
		end
		-- if pd.buttonJustPressed(pd.kButtonB) then self:stopRolling() end
	end

    gfx.sprite.update()
    playdate.timer.updateTimers()

end

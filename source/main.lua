import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "dice"

DEBUG = true

local gfx <const> = playdate.graphics

function setupDice()
	local dice = {}
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

	return dice
end

function gameStart()
	print("hello world")
	math.randomseed(playdate.getSecondsSinceEpoch())

	setupDice()
end

gameStart()

function playdate.update()

    gfx.sprite.update()
    playdate.timer.updateTimers()

end

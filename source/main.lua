import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "game"
import "die"
import "score"

DEBUG = true

local gfx <const> = playdate.graphics

function log(...)
	if DEBUG then
		print(...)
	end
end

function loop(index, length)
	return index < 1 and length or index > length and 1 or index
end

function gameStart()
	math.randomseed(playdate.getSecondsSinceEpoch())

	Game()
end

function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()

	if DEBUG then
		playdate.drawFPS(0, 0)
	end
end

function playdate.keyPressed(key)
	if not DEBUG then return end

	if key == "8" then return end
	if key == "9" then return end
	if key == "0" then return end
end

gameStart()

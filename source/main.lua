import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "dice"

local gfx <const> = playdate.graphics

function gameStart()
	print("hello world")
	math.randomseed(playdate.getSecondsSinceEpoch())

	local die = Dice()
	die:moveTo(200, 120)
	die:add()
end

gameStart()

function playdate.update()

    gfx.sprite.update()
    playdate.timer.updateTimers()

end

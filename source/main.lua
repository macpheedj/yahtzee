import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

function gameStart()
	print("hello world")
end

gameStart()

function playdate.update()

    gfx.sprite.update()
    playdate.timer.updateTimers()

end

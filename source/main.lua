import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "game"
import "lock"
import "die"
import "score"
import "scoreboard"

DEBUG = false
GAME = nil

local gfx <const> = playdate.graphics

function log(...)
	if DEBUG then
		print(...)
	end
end

function loop(index, length)
	return index < 1 and length or index > length and 1 or index
end

function makeMenu()
	local menu = playdate.getSystemMenu()

	menu:addMenuItem("score: 0", function () end)
	menu:addMenuItem("subtotal: 0", function () end)
	menu:addMenuItem("new game", function()
		if GAME == nil then return end
		GAME:reset()
	end)
end

function gameStart()
	math.randomseed(playdate.getSecondsSinceEpoch())

	GAME = Game()
	makeMenu()
end

function playdate.gameWillPause()
	local menu = playdate.getSystemMenu()
	local items = menu:getMenuItems()

	for _, item in ipairs(items) do
		local title = item:getTitle()
		if string.sub(title, 1, 5) == "score" then item:setTitle("score: " .. SCORE) end
		if string.sub(title, 1, 8) == "subtotal" then item:setTitle("subtotal: " .. SUBTOTAL) end
	end
end

function playdate.update()
    gfx.sprite.update()
    playdate.timer.updateTimers()

	if DEBUG then
		playdate.drawFPS(0, 0)
	end
end

function playdate.keyPressed(key)
	if GAME == nil then return end
	if not DEBUG then return end

	if key == "8" then GAME:printScores() end
	if key == "9" then
		GAME.dice[1]:cheatValue(6)
		GAME.dice[2]:cheatValue(6)
		GAME.dice[3]:cheatValue(6)
		GAME.dice[4]:cheatValue(6)
		GAME.dice[5]:cheatValue(6)
	end
	if key == "0" then
		GAME.dice[1]:cheatValue(1)
		GAME.dice[2]:cheatValue(2)
		GAME.dice[3]:cheatValue(3)
		GAME.dice[4]:cheatValue(4)
		GAME.dice[5]:cheatValue(5)
	end
end

gameStart()

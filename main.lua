Map = require("map")
local Vector = require("vector")
Player = require("player")

function love.load()
	map = Map.new(22, 14)
	love.window.setMode(1440, 960)
	love.window.setTitle("Maze Runner")

	love.graphics.setBackgroundColor(33, 33, 33)

	love.graphics.setDefaultFilter('nearest', 'nearest' )

	font = love.graphics.newFont("assets/Kubasta.ttf", 30)
	love.graphics.setFont(font)

	canvas = love.graphics.newCanvas(360, 240)

	player = Player.new()
	player.pos.x = 200
	player.pos.y = 120
end

function love.update(dt)
	player:update(dt, map)
end

function love.draw()
	love.graphics.setColor(250, 250, 250)

	love.graphics.setCanvas(canvas)
		canvas:clear()
		map:draw()
		player:draw()
	love.graphics.setCanvas()

	love.graphics.draw(canvas, 0, 0, 0, 4, 4)
end

Map = require("map")
local Vector = require("vector")
Player = require("player")
Enemy = require("enemy")

function love.load()
	
	playing = false
	text = "Press enter to play!"

	map = Map.new(22, 14)
	love.window.setMode(1440, 960)
	love.window.setTitle("Maze Runner")

	love.graphics.setBackgroundColor(33, 33, 33)

	love.graphics.setDefaultFilter('nearest', 'nearest' )

	font = love.graphics.newFont("assets/Kubasta.ttf", 30)
	love.graphics.setFont(font)

	backgroundCanvas = love.graphics.newCanvas(368, 240)

	background = love.graphics.newImage("assets/ground.png")
	love.graphics.setCanvas(backgroundCanvas)
	
	for x=0, 6 do
		for y=0, 4 do
			love.graphics.draw(background, x*64, y*64)
		end
	end

	love.graphics.setCanvas()

	canvas = love.graphics.newCanvas(368, 240)

	player = Player.new()
	player.pos.x = 200
	player.pos.y = 120

	enemy = Enemy.new()
	enemy.pos.x = 100
	enemy.pos.y = 100

	enemy2 = Enemy.new()
	enemy2.pos.x = 300
	enemy2.pos.y = 200
end

function reset()
	enemy.pos.x = 100
	enemy.pos.y = 100
	enemy.vel = Vector.new()

	enemy2.pos.x = 300
	enemy2.pos.y = 200
	enemy2.vel = Vector.new()
end

function love.update(dt)
	if playing then	
		player:update(dt, map)
		enemy:update(dt, map, player)
		enemy2:update(dt, map, player)
		if (player.pos - enemy.pos):length() < 10 or (player.pos - enemy.pos):length() < 10 then 
			playing = false
			text = "You got rekt! Press enter to play again"
			reset()
		end
	else
		enemy.animation:update(dt)
		enemy2.animation:update(dt)
	end
end

function love.keypressed(key, isrepeat)
	if key == "return" and not playing then playing = true end
end

function love.draw()
	love.graphics.setCanvas(canvas)

		canvas:clear()
		love.graphics.draw(backgroundCanvas)
		map:draw()
		player:draw()
		enemy:draw()
		enemy2:draw()

		if not playing then
			love.graphics.printf(text, 50, 20, 260)
		end

	love.graphics.setCanvas()

	love.graphics.draw(canvas, 0, 0, 0, 4, 4)
	end

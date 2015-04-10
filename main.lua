Map = dofile("map.lua")

function love.load()
	map = Map.new(10, 10)
	love.window.setMode(1440, 960)

	love.graphics.setBackgroundColor(33, 33, 33)

	love.graphics.setDefaultFilter('nearest', 'nearest' )

	font = love.graphics.newFont("assets/Kubasta.ttf", 30)
	love.graphics.setFont(font)

	canvas = love.graphics.newCanvas(360, 240)
end

function love.draw()
	love.graphics.setColor(250, 250, 250)

	love.graphics.setCanvas(canvas)
		map:draw()
	love.graphics.setCanvas()

	love.graphics.draw(canvas, 0, 0, 0, 4, 4)
end

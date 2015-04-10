function love.load()
	love.window.setMode(1440, 960)

	love.graphics.setBackgroundColor(33, 33, 33)

	love.graphics.setDefaultFilter('nearest', 'nearest' )

	sprite = love.graphics.newImage("assets/test.png")

	font = love.graphics.newFont("assets/Kubasta.ttf", 30)
	love.graphics.setFont(font)

	canvas = love.graphics.newCanvas(360, 240)
	love.graphics.setCanvas(canvas)
		canvas:clear()
		love.graphics.setColor(100, 0, 0)
		love.graphics.print("Hello world!", 100, 100)
		love.graphics.draw(sprite, 50, 50);
	love.graphics.setCanvas()
end

function love.draw()
	love.graphics.setColor(250, 250, 250)
	love.graphics.draw(canvas, 0, 0, 0, 4, 4)
end

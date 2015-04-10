local Map = {}
Map.__index = Map

function Map.new(width, height)
	local self = {}
	setmetatable(self, Map)

	self.width = width;
	self.height = height;

	self.tiles = {}
	for x=0, width do
		self.tiles[x] = {}
		for y=0, height do
			self.tiles[x][y] = 1
		end
	end

	self.tileImage= love.graphics.newImage("assets/basic-tile.png")

	return self
end

function Map:draw()
	for x=0, self.width do
		for y=0, self.height do
			if self.tiles[x][y] == 1 then
				love.graphics.draw(self.tileImage, x * 16, y * 16)
			end
		end
	end
end

return Map

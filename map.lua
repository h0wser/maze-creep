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
			self.tiles[x][y] = 0
		end
	end

	for i=0, height do
		self.tiles[0][i] = 1
		self.tiles[width][i] = 1
	end

	for i=0, width do
		self.tiles[i][0] = 1
		self.tiles[i][height] = 1
	end

	for i=3, width - 3 do
		self.tiles[i][3] = 1
	end

	self.tileImage= love.graphics.newImage("assets/basic-tile.png")

	return self
end

function Map:isSolidTile(x, y)
	if x > self.width or x < 1 or y > self.height or y < 1 then return true end
	return self.tiles[x][y] ~= 0

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

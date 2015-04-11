local Spritesheet = {}
Spritesheet.__index = Spritesheet

-- Frame speed is in seconds
function Spritesheet.new(filename, frameSize, frameSpeed)
	local self = {}
	setmetatable(self, Spritesheet)

	self.sprite = love.graphics.newImage(filename)
	self.frameSpeed = frameSpeed
	self.frameSize = frameSize
	self.playing = false
	self.currentFrame = 0
	self.frameCount = self.sprite:getWidth() / frameSize.x

	self.frameTimer = 0

	self.quad = love.graphics.newQuad(0, 0, self.frameSize.x, self.frameSize.y, self.sprite:getDimensions())

	return self
end

function Spritesheet:setPlaying(playing)
	self.playing = playing
end

function Spritesheet:update(dt)
	if self.playing then 
		self.frameTimer = self.frameTimer + dt
	end
	
	if self.frameTimer > self.frameSpeed then
		self.currentFrame = self.currentFrame + 1
		if self.currentFrame >= self.frameCount then self.currentFrame = 0 end

		self.quad:setViewport(self.currentFrame * self.frameSize.x, 0, self.frameSize.x, self.frameSize.y)
		self.frameTimer = 0
	end
end

function Spritesheet:draw(x, y)
	love.graphics.draw(self.sprite, self.quad, x, y)
end

return Spritesheet

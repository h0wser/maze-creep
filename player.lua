local Vector = require("vector")
local Spritesheet = require("spritesheet")

local Player = {}
Player.__index = Player

function Player.new()
	local self = {}
	setmetatable(self, Player)

	self.spritesheet = Spritesheet.new("assets/player-front.png", Vector.new(16, 16), 0.10)

	self.pos = Vector.new(0, 0)
	self.vel = Vector.new(0, 0)
	self.acc = Vector.new(0, 0)

	self.acceleration = 900
	self.friction = 700
	self.brakingFriction = 1600

	return self
end

function Player:solveVerticalCollisions(map, projectedPosition)
	if self.vel.y > 0 then
		-- bot left
		if map:isSolidTile(math.floor((projectedPosition.x + 4) / 16), math.floor((projectedPosition.y + 16) / 16)) then
			local offset = projectedPosition.y - math.floor((projectedPosition.y + 16) / 16) * 16 + 16
			projectedPosition.y = projectedPosition.y - offset
			self.vel.y = 0
		end
		-- bot right
		if map:isSolidTile(math.floor((projectedPosition.x + 12) / 16), math.floor((projectedPosition.y + 16) / 16)) then
			local offset = projectedPosition.y - math.floor((projectedPosition.y + 16) / 16) * 16 + 16
			projectedPosition.y = projectedPosition.y - offset
			self.vel.y = 0
		end
	elseif self.vel.y < 0 then 
		-- top left
		if map:isSolidTile(math.floor((projectedPosition.x + 4) / 16), math.floor((projectedPosition.y) / 16)) then
			local offset = math.floor((projectedPosition.y) / 16) * 16 + 16 - projectedPosition.y
			projectedPosition.y = projectedPosition.y + offset
			self.vel.y = 0
		end
		-- top right
		if map:isSolidTile(math.floor((projectedPosition.x + 12) / 16), math.floor((projectedPosition.y) / 16)) then
			local offset = math.floor((projectedPosition.y) / 16) * 16 + 16 - projectedPosition.y 
			projectedPosition.y = projectedPosition.y + offset
			self.vel.y = 0
		end
	end
end

function Player:solveHorizontalCollisions(map, projectedPosition)
	if self.vel.x > 0 then
		-- top right
		if map:isSolidTile(math.floor((projectedPosition.x + 16) / 16), math.floor((projectedPosition.y + 4) / 16)) then
			local offset =  projectedPosition.x - math.floor((projectedPosition.x) / 16) * 16
			projectedPosition.x = projectedPosition.x - offset
			self.vel.x = 0
		end
		-- bot right
		if map:isSolidTile(math.floor((projectedPosition.x + 16) / 16), math.floor((projectedPosition.y + 12) / 16)) then
			local offset = projectedPosition.x - math.floor((projectedPosition.x) / 16) * 16 
			projectedPosition.x = projectedPosition.x - offset
			self.vel.x = 0
		end
	elseif self.vel.x < 0 then 
		-- top left 
		if map:isSolidTile(math.floor((projectedPosition.x) / 16), math.floor((projectedPosition.y + 4) / 16)) then
			local offset = math.floor((projectedPosition.x) / 16) * 16 + 16 - projectedPosition.x
			projectedPosition.x = projectedPosition.x + offset
			self.vel.x = 0
		end
		-- bot left
		if map:isSolidTile(math.floor((projectedPosition.x) / 16), math.floor((projectedPosition.y + 12) / 16)) then
			local offset = math.floor((projectedPosition.x) / 16) * 16 + 16 - projectedPosition.x
			projectedPosition.x = projectedPosition.x + offset
			self.vel.x = 0
		end
	end
end

function Player:update(dt, map)

	if love.keyboard.isDown("left")  then self.acc.x = -1 end 
	if love.keyboard.isDown("right") then self.acc.x = 1  end 
	if love.keyboard.isDown("up")    then self.acc.y = -1 end 
	if love.keyboard.isDown("down")  then self.acc.y = 1  end 

	if self.vel:length() > 0 then
		local friction = Vector:new()
		if love.keyboard.isDown(" ") then 
			friction = self.vel:normalized() * self.brakingFriction * dt
		else
			friction = self.vel:normalized() * self.friction * dt
		end
		if friction:length() > self.vel:length() then friction = self.vel end
		self.vel = self.vel - friction
		self.spritesheet:setPlaying(true)
	else
		self.spritesheet:setPlaying(false)
	end

	if self.acc:length() > 0 then
		self.acc:normalize()
		self.acc = self.acc * self.acceleration * dt
	end

	self.vel = self.vel + self.acc

	local projectedPosition = self.pos + self.vel * dt

	if math.abs(self.vel.x) > math.abs(self.vel.y) then 
		self:solveHorizontalCollisions(map, projectedPosition)
		self:solveVerticalCollisions(map, projectedPosition)
	else
		self:solveVerticalCollisions(map, projectedPosition)
		self:solveHorizontalCollisions(map, projectedPosition)
	end

	self.pos = projectedPosition
	self.acc.x = 0
	self.acc.y = 0

	self.spritesheet:update(dt)
end

function Player:draw()
	self.spritesheet:draw(self.pos.x, self.pos.y)
end

return Player

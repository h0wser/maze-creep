local Vector = require("vector")
local Spritesheet = require("spritesheet")

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
	local self = {}
	setmetatable(self, Enemy)

	self.animation = Spritesheet.new("assets/enemy.png", Vector.new(16, 16), 0.25)
	self.animation:setPlaying(true)

	self.pos = Vector.new(0, 0)
	self.vel = Vector.new(0, 0)
	self.acc = Vector.new(0, 0)

	self.acceleration = 900
	self.friction = 700
	self.brakingFriction = 1600

	return self
end

function Enemy:solveVerticalCollisions(map, projectedPosition)
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

function Enemy:solveHorizontalCollisions(map, projectedPosition)
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

function Enemy:update(dt, map, player)

	if math.floor(player.pos.x) < math.floor(self.pos.x) then self.acc.x = -1 end 
	if math.floor(player.pos.x) > math.floor(self.pos.x) then self.acc.x = 1  end 
	if math.floor(player.pos.y) < math.floor(self.pos.y) then self.acc.y = -1 end 
	if math.floor(player.pos.y) > math.floor(self.pos.y) then self.acc.y = 1  end 

	if self.vel:length() > 0 then
		local friction = Vector:new()
		friction = self.vel:normalized() * self.friction * dt

		if friction:length() > self.vel:length() then friction = self.vel end
		self.vel = self.vel - friction
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

	self.animation:update(dt)
end

function Enemy:draw()
	self.animation:draw(self.pos.x, self.pos.y)
end

return Enemy


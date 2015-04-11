local Vector = require("vector")

local Player = {}
Player.__index = Player

function Player.new()
	local self = {}
	setmetatable(self, Player)

	self.sprite = love.graphics.newImage("assets/player.png")

	self.pos = Vector.new(0, 0)
	self.vel = Vector.new(0, 0)
	self.acc = Vector.new(0, 0)

	self.accelerationScaling = 30
	self.decelerationFactor = 0.9

	return self
end

function Player:solveVerticalCollisions(map, projectedPosition)
	if self.vel.y > 0 then
		-- bot left
		if map:isSolidTile(math.floor((projectedPosition.x + 4) / 16), math.floor((projectedPosition.y + 16) / 16)) then
			local offset = projectedPosition.y - math.floor((projectedPosition.y + 16) / 16) * 16 + 16
			projectedPosition.y = projectedPosition.y - offset
		end
		-- bot right
		if map:isSolidTile(math.floor((projectedPosition.x + 12) / 16), math.floor((projectedPosition.y + 16) / 16)) then
			local offset = projectedPosition.y - math.floor((projectedPosition.y + 16) / 16) * 16 + 16
			projectedPosition.y = projectedPosition.y - offset
		end
	elseif self.vel.y < 0 then 
		-- top left
		if map:isSolidTile(math.floor((projectedPosition.x + 4) / 16), math.floor((projectedPosition.y) / 16)) then
			local offset = math.floor((projectedPosition.y) / 16) * 16 + 16 - projectedPosition.y
			projectedPosition.y = projectedPosition.y + offset
		end
		-- top right
		if map:isSolidTile(math.floor((projectedPosition.x + 12) / 16), math.floor((projectedPosition.y) / 16)) then
			local offset = math.floor((projectedPosition.y) / 16) * 16 + 16 - projectedPosition.y 
			projectedPosition.y = projectedPosition.y + offset
		end
	end
end

function Player:solveHorizontalCollisions(map, projectedPosition)
	if self.vel.x > 0 then
		-- top right
		if map:isSolidTile(math.floor((projectedPosition.x + 16) / 16), math.floor((projectedPosition.y + 4) / 16)) then
			local offset =  projectedPosition.x - math.floor((projectedPosition.x) / 16) * 16
			projectedPosition.x = projectedPosition.x - offset
		end
		-- bot right
		if map:isSolidTile(math.floor((projectedPosition.x + 16) / 16), math.floor((projectedPosition.y + 12) / 16)) then
			local offset = projectedPosition.x - math.floor((projectedPosition.x) / 16) * 16 
			projectedPosition.x = projectedPosition.x - offset
		end
	elseif self.vel.x < 0 then 
		-- top left 
		if map:isSolidTile(math.floor((projectedPosition.x) / 16), math.floor((projectedPosition.y + 4) / 16)) then
			local offset = math.floor((projectedPosition.x) / 16) * 16 + 16 - projectedPosition.x
			projectedPosition.x = projectedPosition.x + offset
		end
		-- bot left
		if map:isSolidTile(math.floor((projectedPosition.x) / 16), math.floor((projectedPosition.y + 12) / 16)) then
			local offset = math.floor((projectedPosition.x) / 16) * 16 + 16 - projectedPosition.x
			projectedPosition.x = projectedPosition.x + offset
		end
	end
end

function Player:update(dt, map)

	if love.keyboard.isDown("left")  then self.acc.x = -1 end 
	if love.keyboard.isDown("right") then self.acc.x = 1  end 
	if love.keyboard.isDown("up")    then self.acc.y = -1 end 
	if love.keyboard.isDown("down")  then self.acc.y = 1  end 

	if self.acc:length() ~= 0 then
		self.acc:normalize()
		self.acc = self.acc * self.accelerationScaling
	end

	self.vel = self.vel + self.acc
	self.vel = self.vel * self.decelerationFactor

	local projectedPosition = self.pos + self.vel * dt

	if math.abs(self.vel.x) > math.abs(self.vel.y) then 
		self:solveHorizontalCollisions(map, projectedPosition)
		self:solveVerticalCollisions(map, projectedPosition)
	else
		self:solveHorizontalCollisions(map, projectedPosition)
		self:solveVerticalCollisions(map, projectedPosition)
	end

	self.pos = projectedPosition
	self.acc.x = 0
	self.acc.y = 0
end

function Player:draw()
	love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
end

return Player

local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
	local self = {}
	setmetatable(self, Vector)

	self.x = x or 0
	self.y = y or 0

	return self
end

-- Functions
function Vector:length()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector.__eq(lhs, rhs)
	return (lhs.x == rhs.x) and (lhs.y == rhs.y)
end

function Vector:normalize()
	local len = self:length()
	self.x = self.x / len;
	self.y = self.y / len;
end

function Vector.dot(a, b)
	return a.x * b.x + a.y * b.y
end

-- Operators (+-/*==)
function Vector.__add(lhs, rhs)
	return Vector.new(lhs.x + rhs.x, lhs.y + rhs.y)
end

function Vector.__sub(lhs, rhs)
	return Vector.new(lhs.x - rhs.x, lhs.y - rhs.y)
end

function Vector.__mul(lhs, rhs)
	if type(lhs) == "number" then
		return Vector.new(rhs.x * lhs, rhs.y * lhs)
	else
		return Vector.new(lhs.x * rhs, lhs.y * rhs)
	end
end

function Vector.__div(lhs, rhs)
	assert(type(lhs) ~= "number", "Can't divide number with Vector")
	return Vector.new(lhs.x / rhs, lhs.y / rhs)
end

return Vector

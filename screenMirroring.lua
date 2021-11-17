
component = require("component")
os = require("os")
gpu = component.gpu

local screens = component.list('screen')

local i = 0

for i in pairs(screens) do
	gpu.bind(i)
	gpu.set	(3, 8, "Screen Number " .. i)
end


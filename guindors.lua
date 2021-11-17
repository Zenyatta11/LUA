local comp = require("component")
local gpu = comp.gpu

i = 0
x = 0
y = 0

while i < 240 do
	gpu.setBackground(i)
	gpu.fill(i, 0, 1, 20, " ")
	i = i + 1
end
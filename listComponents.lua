
component = require("component")
os = require("os")
componentType = "screen"

for address, componentType in component.list() do
	print(address)
	print(component.type(address))
	os.sleep(1)
end


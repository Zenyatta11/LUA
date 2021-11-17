local baseName = "Moon-chan Base"
local pressureAmt = 0.5

local component = require("component")
local computer = require("computer")
local sides = require("sides")
local os = require("os")
local gpu = component.gpu
local term = require "term"
local math = require "math"

local airDetector = component.proxy(component.get("1b0"))
local innerDoor = component.proxy(component.get("373"))
local outerDoor = component.proxy(component.get("28a"))
local screens = component.list('screen')

local pressureLevel = 0
local hasOxygen = 0
local flickering = false
local doorStates = 0

local innerLights = false
local outerLights = false

local innerOpen = 0
local outerOpen = 0

local outerDoorState = "Locked"
local innerDoorState = "Locked"
local errorString = "              "

local pressureString = "##########"

innerDoor.setOutput(sides.south, 0)
outerDoor.setOutput(sides.south, 0)

innerDoor.setOutput(sides.bottom, 15)
outerDoor.setOutput(sides.bottom, 15)

local b = 4
local i = 0
local a = 0	

for i in pairs(screens) do -- limpiamos todas las pantallas
	gpu.bind(i)
	gpu.setResolution(30,13)
	gpu.fill(0,0,31,14," ")
	gpu.set	(3, 10, "estartin guindors...")
	gpu.set(3,12,"[")
	gpu.set(27,12,"]")
	gpu.set	(2, 13, "Scn " .. a)
	a = a + 1
end

while b < 26 do
	for i in pairs(screens) do
		gpu.bind(i)
		gpu.set(b,12,"|")
		os.sleep(0.05)
	end
	b = b + 1
end

computer.beep()
computer.beep()
a = 0

for i in pairs(screens) do -- limpiamos todas las pantallas
	gpu.bind(i)
	gpu.fill(0,0,31,14," ")
	gpu.set	(2, 13, "Scn " .. a)
	a = a + 1
end

repeat
	for i in pairs(screens) do
		gpu.bind(i)
		gpu.set	(3, 2, baseName)
		gpu.set	(3, 3, "WEST AIRLOCK")
		gpu.set	(14, 5, "          ]")
		gpu.set	(3, 5, "Pressure: [" .. pressureString)
		gpu.set	(3, 7, "Outer Door " .. outerDoorState)
		gpu.set	(3, 8, "Inner Door " .. innerDoorState)
		gpu.set	(3, 12, errorString)
	end
	hasOxygen = airDetector.getInput(sides.south)
	innerOpen = innerDoor.getInput(sides.top)
	outerOpen = outerDoor.getInput(sides.top)
	
	a = pressureLevel
	pressureString = ""
	while a > 0 do
		pressureString = pressureString .. "|"
		a = a - 1
	end
	
	if(innerOpen > 0 and hasOxygen > 0 and pressureLevel == 10 and not flickering) then
		innerDoor.setOutput(sides.south, 15)
		doorStates = 0
		errorString = "              "
		outerDoorState = "Locked"
		innerDoorState = "Opened"
		innerDoor.setOutput(sides.bottom, 0)
	elseif(outerOpen > 0 and hasOxygen > 0 and pressureLevel == 0 and not flickering) then
		outerDoor.setOutput(sides.south, 15)
		doorStates = 2
		outerDoorState = "Opened"
		innerDoorState = "Locked"
		outerDoor.setOutput(sides.bottom, 0)
	elseif(outerOpen > 0 and pressureLevel > 0 and not flickering) then
		flickering = true
		doorStates = 1
		outerDoorState = "Locked"
		innerDoorState = "Locked"
		innerDoor.setOutput(sides.south, 0)
		innerDoor.setOutput(sides.bottom, 15)
	elseif(innerOpen > 0 and pressureLevel == 0 and not flickering) then
		flickering = true
		doorStates = 3
		outerDoorState = "Locked"
		innerDoorState = "Locked"
		outerDoor.setOutput(sides.south, 0)
		outerDoor.setOutput(sides.bottom, 15)
	end
	
	if(flickering) then
		computer.beep()
		if(doorStates == 1) then
			pressureLevel = pressureLevel - pressureAmt
			if(outerLights) then
				outerDoor.setOutput(sides.bottom, 15)
				outerLights = false
			else
				outerDoor.setOutput(sides.bottom, 0)
				outerLights = true
			end
			if(pressureLevel <= 0) then
				pressureLevel = 0
				flickering = false
				outerDoor.setOutput(sides.south, 15)
				innerDoor.setOutput(sides.south, 0)
				doorStates = 2
				errorString = "              "
				outerDoorState = "Opened"
				innerDoorState = "Locked"
				outerDoor.setOutput(sides.bottom, 0)
				innerDoor.setOutput(sides.bottom, 15)
				computer.beep()
			end
		elseif(doorStates == 3) then
			pressureLevel = pressureLevel + pressureAmt
			if(innerLights) then
				innerDoor.setOutput(sides.bottom, 15)
				innerLights = false
			else
				innerDoor.setOutput(sides.bottom, 0)
				innerLights = true
			end
			if(pressureLevel >= 10) then
				pressureLevel = 10
				flickering = false
				if(hasOxygen > 0) then
					innerDoor.setOutput(sides.south, 15)
					outerDoor.setOutput(sides.south, 0)
					
					doorStates = 2
					outerDoorState = "Locked"
					innerDoorState = "Opened"
					errorString = "              "
					innerDoor.setOutput(sides.bottom, 0)
					outerDoor.setOutput(sides.bottom, 15)
					computer.beep()
				else
					innerDoor.setOutput(sides.south, 0)
					outerDoor.setOutput(sides.south, 15)
					
					doorStates = 2
					outerDoorState = "Locked"
					innerDoorState = "Forced"
					errorString = "Hull Breached!"
					computer.beep()
					computer.beep()
					computer.beep()
					innerDoor.setOutput(sides.bottom, 0)
					outerDoor.setOutput(sides.bottom, 15)
				end
			end
		end
	end
	
	os.sleep(0.5)
until airDetector.getInput(sides.west) > 0
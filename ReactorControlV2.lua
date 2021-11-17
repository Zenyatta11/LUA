
-- Reactor Program

local component = require "component"
local event = require "event"
local term = require "term"
local math = require "math"
local sides = require("sides")
local computer = require "computer"

local reactor = component.nc_fission_reactor
local reactorName = "Firularita I"
local forced = "AUTO"
local redstone = component.redstone
local power = reactor.getEnergyStored() 
local waituntilcold = false

reactorX = reactor.getLengthX()
reactorY = reactor.getLengthY()
reactorZ = reactor.getLengthZ()
maxHeat = reactorX * reactorY * reactorZ * 25000
maxPower = reactorX * reactorY * reactorZ * 64000
print("Initializing...")

repeat
	term.clear()
	
	printString = ""
	deactivateReactor = 0
	
	if reactor.isComplete() then
		local heatPercent = math.floor(reactor.getHeatLevel() / maxHeat * 10000)
		heatPercent = heatPercent / 100
		
		power = reactor.getEnergyStored() 
		local powerPercent = math.floor(power / maxPower * 10000)
		powerPercent = powerPercent / 100
		
		local cells = reactor.getNumberOfCells()
		
		if(powerPercent > 80) then
			deactivateReactor = deactivateReactor + 1
		elseif(powerPercent < 20 and not waituntilcold) then
			deactivateReactor = 0
		end
		
		if(heatPercent > 50) then
			forced = "HOT"
			deactivateReactor = deactivateReactor + 1
			waituntilcold = true
		elseif(heatPercent < 20) then
			forced = "AUTO"
			waituntilcold = false
		end
		
		if(waituntilcold) then
			deactivateReactor = 8
			computer.beep()
		end
		
		input = 0
		input = input + redstone.getInput(sides.front)
		input = input + redstone.getInput(sides.back)
		input = input + redstone.getInput(sides.left)
		input = input + redstone.getInput(sides.right)
		
		if( input > 0) then
			forced = "FORCED"
			deactivateReactor = 0
		end
		
		if(reactorOn) then
			strReactor = "ONLINE"
		else
			strReactor = "OFFLINE"
		end
		
		printString = "\nReactor " .. reactorName .. ": " .. strReactor .. "[" .. forced .. "]"
		printString = printString .. "\n\nHeat: " .. heatPercent .. "%"
		printString = printString .. "\nPower: " .. powerPercent .. "%"
		
		if(waituntilcold) then
			printString = printString .. "\n\nForced cooldown."
		end
		
	else
		printString = "\nReactor [" .. reactorName .. "] decomissioned!"
	end
	
	if (deactivateReactor == 0 or forced == "FORCED") then
		reactorOn = true
		reactor.activate()
	else
		reactorOn = false
		reactor.deactivate()
	end
	
	print(printString)
	
	os.sleep(0.2)
until event.pull(0.2) == "interrupted"

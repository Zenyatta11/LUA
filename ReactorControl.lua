
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

local reactorOn = true
reactor.activate()
reactorX = reactor.getLengthX()
reactorY = reactor.getLengthY()
reactorZ = reactor.getLengthZ()
maxHeat = reactorX * reactorY * reactorZ * 25000
maxPower = reactorX * reactorY * reactorZ * 64000
print("Initializing...")

repeat
	term.clear()
	input = 0
	input = input + redstone.getInput(sides.front)
	input = input + redstone.getInput(sides.back)
	input = input + redstone.getInput(sides.left)
	input = input + redstone.getInput(sides.right)
	if( input > 0) then
		reactorOn = true
		forced = "FORCED"
	elseif forced ~= "COOLING" then
		forced = "AUTO"
	end
	
	if reactor.isComplete() then
		local heatPercent = math.floor(reactor.getHeatLevel() / maxHeat * 10000)
		heatPercent = heatPercent / 100
		if(heatPercent >= 50) then
			reactor.deactivate()
			reactorOn = false
			forced = "COOLING"
			waituntilcold = true
		elseif(heatPercent < 20) then
			waituntilcold = false
			forced = "AUTO"
			reactor.activate()
			reactorOn = true
		end
		print()
		if reactorOn then
			print("Reactor " .. reactorName .. ": Online [" .. forced .. "]")
		else 
			print("Reactor " .. reactorName .. ": Offline [" .. forced .. "]")
		end
		print()
		print("Size: " .. reactorX .. " x " .. reactorY .. " x " .. reactorZ)
		print()
		
		print("Heat: " .. heatPercent .. "%")
		
		power = reactor.getEnergyStored() 
		local powerPercent = math.floor(power / maxPower * 10000)
		powerPercent = powerPercent / 100
		
		print("Power: " ..  powerPercent .. "%")
		
		if waituntilcold == false then
			if(power > maxPower / 2 and forced == "AUTO") then
				reactorOn = false
				reactor.deactivate()
			elseif(power < maxPower / 8 and forced == "AUTO") then
				reactorOn = true
				reactor.activate()
			elseif forced == "FORCED" then
				reactor.activate()
				reactorOn = true
			end
		end
		
		if(waituntilcold) then
			computer.beep()
		end
		
	else
		print("Reactor [" .. reactorName .. "] decomissioned!")
	end
	os.sleep(0.2)
until event.pull(1) == "interrupted"

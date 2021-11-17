-- Reactor Program

local reactorName = "Firularita II"

-- programa en si

local component = require "component"
local event = require "event"
local term = require "term"
local math = require "math"
local sides = require("sides")
local computer = require "computer"
local gpu = component.gpu
local inventory = component.inventory_controller
--gpu.setResolution(90,30)

local reactor = component.reactor_chamber
local forced = "AUTO"
local redstone = component.redstone
local waituntilcold = false

local reactorOn = true

maxHeat = reactor.getMaxHeat()

local w, h = gpu.getResolution()

local reactorStatus = "Offline"
local reactorRunMode = "AUTO"
local heatString = "##########"
local fuelRemaining = -1

local reactorStatusOld = "Offline"
local reactorRunModeOld = "AUTO"
local heatPercentOld = -1
local powerLevelOld = 0
local fuelRemainingOld = 88888

gpu.fill(0,0,w+1,h+1," ")
gpu.set	(3, 3, "Reactor " .. reactorName .. ": " .. reactorStatus .. " [" .. reactorRunMode .. "]")

gpu.set	(3, 8, "Temperature:  [" .. heatString .. "]")
gpu.set	(3, 10, "Power: #######")
gpu.set	(3, 9, "Fuel: 9999%     ")
gpu.set	(3, 15, "estartin guindors...")
os.sleep(5)
gpu.set	(3, 13, "Powered by")
gpu.set	(3, 15, "          \n L O R D    Z E N Y A T T A \n")
		
repeat
	local heatPercent = math.floor(reactor.getHeat() / maxHeat * 100)
	local powerLevel = reactor.getReactorEUOutput()
	
	if(inventory.getStackInSlot(sides.top, 1) ~= nil) then
		fuelRemaining = math.floor((inventory.getStackInSlot(sides.top, 1).maxDamage - inventory.getStackInSlot(sides.top, 1).damage) / inventory.getStackInSlot(sides.top, 1).maxDamage * 100)
	else
		fuelRemaining = -1
	end
	
	if(heatPercent > 90) then
		heatString = "||||||||||"
	elseif(heatPercent > 80) then
		heatString = "||||||||| "
	elseif(heatPercent > 70) then
		heatString = "||||||||  "
	elseif(heatPercent > 60) then
		heatString = "|||||||   "
	elseif(heatPercent > 50) then
		heatString = "||||||    "
	elseif(heatPercent > 40) then
		heatString = "|||||     "
	elseif(heatPercent > 30) then
		heatString = "||||      "
	elseif(heatPercent > 20) then
		heatString = "|||       "
	elseif(heatPercent > 10) then
		heatString = "||        "
	elseif(heatPercent > 10) then
		heatString = "||        "
	elseif(heatPercent >= 0) then
		heatString = "|         "
	end
	
	if(heatPercent >= 60) then
		computer.beep()
	end
	
	if (powerLevel > 0) then
		reactorStatus = "Online"
	else
		reactorStatus = "Offline"
	end
	
	if (fuelRemaining < 0) then
		computer.beep()
		reactorRunMode = "NO FUEL"
	elseif (fuelRemaining < 2) then
		computer.beep()
		reactorRunMode = "NO POWER"
	elseif (fuelRemaining < 10) then
		reactorRunMode = "LOW POWER"
	else
		reactorRunMode = "AUTO"
	end
	
	if(not (reactorStatus == reactorStatusOld) or not (reactorRunMode == reactorRunModeOld)) then
		reactorStatusOld = reactorStatus
		gpu.set	(3, 3, "Reactor " .. reactorName .. ": " .. reactorStatus .. " [" .. reactorRunMode .. "]")
	end
	
	if(heatPercentOld ~= heatPercent) then
		heatPercentOld = heatPercent
		gpu.set	(3, 8, "Temperature:    [" .. heatString .. "]")
	end
	
	if(fuelRemainingOld ~= fuelRemaining) then
		fuelRemainingOld = fuelRemaining
		gpu.set	(3, 9, "Fuel: " .. fuelRemaining .. "%     ")
	end
	
	if(powerLevelOld ~= powerLevel) then
		powerLevelOld = powerLevel
		gpu.set	(3, 10, "Power: " .. powerLevel .. " EU/t   ")
	end
until redstone.getInput(sides.bottom) > 0

-- Reactor Program

local reactorName = "Firularita I"

-- programa en si

local component = require "component"
local event = require "event"
local term = require "term"
local math = require "math"
local sides = require("sides")
local computer = require "computer"
local gpu = component.gpu

--gpu.setResolution(90,30)

local reactor = component.nc_fission_reactor
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

local w, h = gpu.getResolution()
local color_background = 0x00ADAC
local color_title = 0x0704AD
local color_titletext = 0xFFFFFF
local color_yellow = 0xDDE551
local color_black = 0x424242

local reactorStatus = "Offline"
local reactorRunMode = "AUTO"
local heatString = "##########"
local powerString = "##########"

local reactorStatusOld = "Offline"
local reactorRunModeOld = "AUTO"
local heatPercentOld = -1
local powerPercentOld = -1

local deactivateReactor = 0
reactor.deactivate()

--gpu.setBackground(color_background)
--gpu.fill(0,0,w+1,h+1," ")
--gpu.setBackground(color_title)
--gpu.fill(2,2,w-4,3," ")
gpu.fill(0,0,w+1,h+1," ")
gpu.set	(3, 3, "Reactor " .. reactorName .. ": " .. reactorStatus .. " [" .. reactorRunMode .. "]")

gpu.set	(3, 8, "Temperature:  [" .. heatString .. "]")
gpu.set	(3, 10, "Power Stored: [" .. powerString .. "]")
gpu.set	(3, 15, "estartin guindors...")
os.sleep(5)
gpu.set	(3, 13, "Powered by")
gpu.set	(3, 15, "          \n L O R D    Z E N Y A T T A \n")

repeat
	if reactor.isComplete() then
		deactivateReactor = 0
		local heatPercent = math.floor(reactor.getHeatLevel() / maxHeat * 100)
		local powerPercent = math.floor(reactor.getEnergyStored()  / maxPower * 100)
		
		if(powerPercent > 90) then
			powerString = "||||||||||"
		elseif(powerPercent > 80) then
			powerString = "||||||||| "
		elseif(powerPercent > 70) then
			powerString = "||||||||  "
		elseif(powerPercent > 60) then
			powerString = "|||||||   "
		elseif(powerPercent > 50) then
			powerString = "||||||    "
		elseif(powerPercent > 40) then
			powerString = "|||||     "
		elseif(powerPercent > 30) then
			powerString = "||||      "
		elseif(powerPercent > 20) then
			powerString = "|||       "
		elseif(powerPercent > 10) then
			powerString = "||        "
		elseif(powerPercent > 0) then
			powerString = "|         "
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
		
		input = 0
		input = input + redstone.getInput(sides.front)
		input = input + redstone.getInput(sides.back)
		input = input + redstone.getInput(sides.left)
		input = input + redstone.getInput(sides.right)
		
		if(powerPercent > 80) then
			deactivateReactor = 2
		elseif(powerPercent < 20 and not waituntilcold) then
			deactivateReactor = 1
		end
		
		if(heatPercent > 20) then
			reactorRunMode = "TOO HOT"
			deactivateReactor = 2
			waituntilcold = true
		elseif(heatPercent == 0) then
			reactorRunMode = "AUTO"
			waituntilcold = false
		end
		
		if(waituntilcold) then
			deactivateReactor = 2
			computer.beep()
		end
		
		if(input > 0) then
			reactorRunMode = "FORCED"
			deactivateReactor = 1
		end
		
		if (deactivateReactor == 1 or reactorRunMode == "FORCED") then
			reactorStatus = "Online"
			reactor.activate()
		elseif deactivateReactor > 1 then
			reactorStatus = "Offline"
			reactor.deactivate()
		end
		
		if(not (reactorStatus == reactorStatusOld) or not (reactorRunMode == reactorRunModeOld)) then
			reactorStatusOld = reactorStatus
			gpu.set	(3, 3, "Reactor " .. reactorName .. ": " .. reactorStatus .. " [" .. reactorRunMode .. "]")
		end
		
		gpu.set	(3, 6, math.floor(reactor.getCurrentProcessTime()/60/20) .. "m - " .. reactor.getFissionFuelName)
		
		reactorProcessing = "Standby"
		if(reactor.isProcessing()) then
			reactorProcessing = "Working"
		end
		
		gpu.set	(3, 7, "Status: " .. reactorProcessing)
		
		if(heatPercentOld ~= heatPercent) then
			heatPercentOld = heatPercent
			gpu.set	(3, 8, "Temperature:    [" .. heatString .. "]")
		end
		
		if(powerPercentOld ~= powerPercent) then
			powerPercentOld = powerPercent
			gpu.set	(3, 10, "Power Stored:   [" .. powerString .. "]")
		end
	else
		gpu.set	(3, 3, "Reactor " .. reactorName .. ": Offline [DECOMISSIONED]")
		gpu.set	(3, 10, "Power Stored:   [##########]")
		gpu.set	(3, 8, "Temperature:    [##########]")
	end
until redstone.getInput(sides.bottom) > 0
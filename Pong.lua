local gameSpeed = 0.2
local sliderSize = 4

local component = require "component"
local event = require "event"
local term = require "term"
local math = require "math"
local sides = require("sides")
local computer = require "computer"
local gpu = component.gpu

local playerA = component.proxy(component.get("330"))
local playerB = component.proxy(component.get("f66"))
local centerRS = component.proxy(component.get("419"))

local playerA_lastStateDown = playerA.getInput(sides,south)
local playerA_lastStateUp = playerA.getInput(sides,top)

local playerB_lastStateDown = playerB.getInput(sides,south)
local playerB_lastStateUp = playerB.getInput(sides,top)

gpu.setResolution(50,16)

local screenHeight = 16
local screenWidth = 50
local centerX = screenWidth / 2
local centerY = screenHeight / 2

local sliderA = 6
local sliderB = 6

local scoreA = 0
local scoreB = 0

local pong_x = 0
local pong_y = 0
local pong_up = 0
local pong_side = 0

function resetRS()
	local blocks = component.list('redstone')
	for i in blocks do
		component.proxy(component.get(i)).setOutput(sides.bottom,0)
		component.proxy(component.get(i)).setOutput(sides.top,0)
		component.proxy(component.get(i)).setOutput(sides.west,0)
		component.proxy(component.get(i)).setOutput(sides.east,0)
		component.proxy(component.get(i)).setOutput(sides.north,0)
		component.proxy(component.get(i)).setOutput(sides.south,0)
	end
end

function restartLevel()
	resetRS()
	pong_x = centerX
	pong_y = centerY
	pong_up = math.random(-2,2)
	pong_side = math.random(-2,2)
	sliderA = 6
	sliderB = 6
	redrawScreen()
	os.sleep(1)
	
	centerRS.setOutput(sides.west,15)
	centerRS.setOutput(sides.west,0)
	os.sleep(1)
	
	centerRS.setOutput(sides.west,15)
	centerRS.setOutput(sides.west,0)
	os.sleep(1)
	
	centerRS.setOutput(sides.west,15)
	centerRS.setOutput(sides.west,0)
	os.sleep(3)
	
	centerRS.setOutput(sides.east,15)
	centerRS.setOutput(sides.east,0)
end

function drawBar(posY, posX)
	gpu.set(posX,posY,"█")
	gpu.set(posX,posY+1,"█")
	gpu.set(posX,posY+2,"█")
	gpu.set(posX,posY+3,"█")
end

function drawScore()
	gpu.set(centerX-4,0,scoreA .. "    ")
	gpu.set(centerX+4,0,scoreB .. "    ")
end

function drawBall(clear)
	if clear then
		gpu.set(pong_x,pong_y,"█")
	else
		gpu.set(pong_x,pong_y," ")
	end
end

function redrawScreen()
	gpu.fill(0,0,51,17," ")
	drawScore()
	drawBar(sliderA, 2, false)
	drawBar(sliderB, screenWidth-2, false)
	drawBall(true)
end

restartLevel()

repeat
	local actualState = playerA.getInput(sides.south)
	if(actualState > 0) then
		gpu.set(2, sliderA, " ")
		sliderA = sliderA + 1
		if(sliderA > screenHeight-sliderSize+1) then
			sliderA = screenHeight - sliderSize+1
		end
	end
	
	actualState = playerB.getInput(sides.south)
	if(actualState > 0) then
		gpu.set(screenWidth-2, sliderB, " ")
		sliderB = sliderB + 1
		if(sliderB > screenHeight-sliderSize+1) then
			sliderB = screenHeight - sliderSize+1
		end
	end
	
	actualState = playerA.getInput(sides.top)
	if(actualState > 0) then
		gpu.set(2, sliderA+3, " ")
		sliderA = sliderA - 1
		if(sliderA < 1) then
			sliderA = 1
		end
	end
	
	actualState = playerB.getInput(sides.top)
	if(actualState > 0) then
		gpu.set(screenWidth-2, sliderB+3, " ")
		sliderB = sliderB - 1
		if(sliderB < 1) then
			sliderB = 1
		end
	end
	
	drawBar(sliderB, screenWidth-2)
	drawBar(sliderA, 2)
	
	drawBall(false)
	pong_x = pong_x + pong_up
	pong_y = pong_y + pong_side
	drawBall(true)
	
	if(pong_x < 2) then
		if(sliderA >= pong_y - 3 and sliderA < pong_y) then
			pong_up = math.random(-2,2)
			pong_side = math.random(1,2)
		else
			scoreB = scoreB + 1
			playerB.setOutput(sides.east, 15)
			drawScore()
			os.sleep(3)
			playerB.setOutput(sides.east, 0)
			restartLevel()
		end
	end
	
	if (pong_x > screenWidth-2) then
		if(sliderB >= pong_y - 3 and sliderB < pong_y) then
			pong_up = math.random(-2,2)
			pong_side = math.random(-2,-1)
		else
			scoreA = scoreA + 1
			playerA.setOutput(sides.east, 15)
			drawScore()
			os.sleep(3)
			playerA.setOutput(sides.east, 0)
			restartLevel()
		end
	end
	
	if (pong_y < 2) then
		pong_up = math.random(1,2)
		pong_side = math.random(-2,2)
	end
	
	if (pong_y > screenHeight-2) then
		pong_up = math.random(-2,-1)
		pong_side = math.random(-2,2)
	end
	
	if(pong_up == 0) then
		local pick = math.random(0,1)
		if pick == 0 then
			pong_up = -1
		else
			pong_up = 1
		end
	elseif (pong_side == 0) then
		local pick = math.random(0,1)
		if pick == 0 then
			pong_side = -1
		else
			pong_side = 1
		end
	end
	
	drawScore()
	os.sleep(gameSpeed)
until centerRS.getInput(sides.bottom) > 0


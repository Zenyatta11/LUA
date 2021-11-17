-- Reactor Program
-- Variables modifcables
local reactorName = "Firularita II"

-- Requirements (de aca para abajo no toques nada que no sepas que hace

local component = require "component"
local event = require "event"
local term = require "term"
local math = require "math"
local sides = require("sides")
local computer = require "computer"
local gpu = component.gpu
local screens = component.list('screen')
local reactor = component.nc_fission_reactor
local redstone = component.redstone
local power = reactor.getEnergyStored() 

-- El reactor en si, seteando cosas importantes

reactorX = reactor.getLengthX()
reactorY = reactor.getLengthY()
reactorZ = reactor.getLengthZ()
maxHeat = reactorX * reactorY * reactorZ * 25000
maxPower = reactorX * reactorY * reactorZ * 64000

-- Estado del reactor

local forced = "AUTO"
local waituntilcold = false
local reactorOn = true

-- Seteos de las pantallas

local w, h = gpu.getResolution()
local updateScreens = true

-- Variables para mostrar

local reactorStatus = "Offline"
local reactorRunMode = "AUTO"
local heatString = "##########"
local powerString = "##########"
local errorString = ""
local reactorProcessing = "Booting"

-- Control de estados para evitar el flickering de la pantalla

local reactorProcessingOld
local reactorStatusOld = "Offline"
local reactorRunModeOld = "AUTO"
local heatPercentOld = -1
local powerPercentOld = -1
local errorStringOld = ""
local fuelOld = ""
local reactorCompleteOld = false
local fuel = ""

-- ANTE LA DUDA arrancamos con el reactor apagado

local deactivateReactor = 0
reactor.deactivate()

-- El programa en si, esto es la animacion de booteo

local b = 4
local i = 0

for i in pairs(screens) do -- limpiamos todas las pantallas
	gpu.bind(i)
	gpu.fill(0,0,w+1,h+1," ")
end

while b < 46 do
	local a = 0	
	for i in pairs(screens) do
		gpu.bind(i)
		gpu.set	(3, 14, "estartin guindors...")
		gpu.set(3,15,"[")
		gpu.set(47,15,"]")
		gpu.set(b,15,"|")
		gpu.set	(2, 16, "Scn " .. a)
		a = a + 1
		os.sleep(0.05)
	end
	b = b + 1
end

repeat
	reactorComplete = reactor.isComplete() -- Chequeamos si el reactor esta armado
	if reactorComplete then
		if not reactorComplete == reactorCompleteOld then -- Chequeamos si fue terminado de armar recien
			reactorCompleteOld = reactorComplete
			local i = 0
			local a = 0
			for i in pairs(screens) do -- Hay que ir por toooodas las pantallas una por una y dibujar. Asi ahorramos GPUs
				gpu.bind(i) -- cambiamos de pantalla
				gpu.fill(0,0,w+1,h+1," ") -- Borramos la pantalla
				gpu.set	(3, 3, "Reactor " .. reactorName .. ": " .. reactorStatus .. " [" .. reactorRunMode .. "]")
				gpu.set	(2, 16, "Scn " .. a) -- Escribimos info
				a = a + 1
			end
		end
		
		deactivateReactor = 0 -- Si este valor es mayor a cero, el reactor se apaga.
		
		local heatPercent = math.floor(reactor.getHeatLevel() / maxHeat * 100) -- Obtenemos porcentajes de calor y energia guardada
		local powerPercent = math.floor(reactor.getEnergyStored()  / maxPower * 100)
		
		fuel = reactor.getFissionFuelName() -- Nombre del combustible a quemar
		errorString = reactor.getProblem() -- Si hay algun problema
		
		powerString = ""
		local a = powerPercent
		while a > 0 do
			powerString = powerString .. "|" -- Barrita de energia, mas lindo que un numero
			a = a - 10
		end
		
		a = heatPercent
		heatString = ""
		while a > 0 do
			heatString = heatString .. "|"
			a = a - 10
		end
		
		input = 0
		input = input + redstone.getInput(sides.front) -- Hacemos que cualquier lado sirva asi nos ahorramos tener que fijarnos
		input = input + redstone.getInput(sides.back) -- que el adaptador de redstone este mirando hacia el lado correcto
		input = input + redstone.getInput(sides.left)
		input = input + redstone.getInput(sides.right)
		
		if(powerPercent > 80) then
			deactivateReactor = 2 -- Apagamos el reactor si tiene mas del 80% de energia guardada
		elseif(powerPercent < 20 and not waituntilcold) then -- Si tiene menos del 20%, prendamoslo
			deactivateReactor = 1
		end
		
		if(heatPercent > 20) then -- Si tiene mas del 20% de calor, apaguemoslo!
			reactorRunMode = "TOO HOT" -- Hay que tomar en cuenta el refresh rate de esto, cuanto menor calor se corta en, mas seguro es
			deactivateReactor = 2
			waituntilcold = true
		elseif(heatPercent == 0) then -- Si no, que siga en la suya
			reactorRunMode = "AUTO"
			waituntilcold = false
		end
		
		if(waituntilcold) then -- Para que haga ruido si se esta enfriando pero deberia estar andando
			deactivateReactor = 2
			computer.beep()
		end
		
		if(input > 0) then -- Para obligarlo a andar. Fijate que esta abajo del chequeo de calor.
			reactorRunMode = "FORCED" -- No se va a apagar si levanta temperatura, ojo con esto
			deactivateReactor = 1
		end
		
		if (deactivateReactor == 1 or reactorRunMode == "FORCED") then
			reactorStatus = "Online" -- Aca activamos / apagamos el reactor dependiendo del valor de deactivateReactor
			reactor.activate()
		elseif deactivateReactor > 1 then
			reactorStatus = "Offline"
			reactor.deactivate()
		end
		
		if not (fuel == "TBU - Ox") then
			reactorStatus = "WRONG FUEL"
			reactor.deactivate()
		end
		
		-- De aca para abajo es para fijarse si tenemos que refrescar las pantallas
		
		if(not (reactorStatus == reactorStatusOld) or not (reactorRunMode == reactorRunModeOld)) then
			reactorStatusOld = reactorStatus 
			updateScreen = true
		end
		
		if(reactor.isProcessing()) then
			reactorProcessing = "Working"
		else
			reactorProcessing = "Standby"
		end
		
		if(not reactorProcessing == reactorProcessingOld) then
			updateScreens = true
			reactorProcessingOld = reactorProcessing
		end
		
		if(heatPercentOld ~= heatPercent) then
			heatPercentOld = heatPercent
			updateScreens = true
		end
		
		if(powerPercentOld ~= powerPercent) then
			powerPercentOld = powerPercent
			updateScreens = true
		end
		
		if(fuelOld ~= fuel) then
			fuelOld = fuel
			updateScreens = true
		end
		
		if(errorStringOld ~= errorString) then
			errorStringOld = errorString
			updateScreens = true
		end
		
		if(updateScreens) then -- aca las refrescamos
			updateScreens = false
			local i = 0
			local a = 0
			for i in pairs(screens) do
				gpu.bind(i)
				gpu.set	(20, 10, "          ]")
				gpu.set	(3, 10, "Power Stored:   [" .. powerString)
				gpu.set	(3, 12, errorString .. "          ")
				gpu.set	(20, 8, "          ]")
				gpu.set	(3, 8, "Temperature:    [" .. heatString)
				gpu.set	(3, 7, "Status: " .. reactorProcessing .. "        ")
				gpu.set	(3, 6, "Fuel: " .. fuel .. "        ")
				gpu.set	(3, 13, "Powered by        ")
				gpu.set	(3, 15, "          \n L O R D    Z E N Y A T T A \n")
				gpu.set	(3, 3, "Reactor " .. reactorName .. ": " .. reactorStatus .. " [" .. reactorRunMode .. "]        ")
				gpu.set	(2, 16, "Scn " .. a)
				a = a + 1
			end
		end
	else
		if not reactorComplete == reactorCompleteOld then
			local i = 0 -- Si no esta completo, indicar que esta "en reparacion"
			local a = 0
			for i in pairs(screens) do
				gpu.bind(i)
				gpu.fill(0,0,w+1,h+1," ")
				gpu.set	(3, 3, "Reactor " .. reactorName .. " Under Repairs")
				gpu.set	(2, 16, "Scn " .. a)
				a = a + 1
			end
		end
	end
until redstone.getInput(sides.bottom) > 0 -- Aca pongo para terminar el programa si apretamos el boton abajo del redstone I/O


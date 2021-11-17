
local term = require "term"
local component = require "component"
local gpu = component.gpu

gpu.set(1, 1,"██████████████████████████████████████████████████")
gpu.set(1, 2,"███                                            ███")
gpu.set(1, 3,"███           Rinoceronte de Sumatra           ███") 
gpu.set(1, 4,"███                                            ███")
gpu.set(1, 5,"██████████████████████████████████████████████████")
gpu.set(1, 6,"                                                  ")



local i = 0;
local j = 0;
local pages = 1;

while true do
	gpu.set(1,16,"                                                  ")
	
	if i == 0 then
		gpu.set(1, 7,"       Como otras especies de rinocerontes, los de")
		gpu.set(1, 8,"Sumatra son animales solitarios y territoriales   ")
		gpu.set(1, 9,"que solo conocen el grupo formado por la hembra y ")
		gpu.set(1,10,"su única cría, que paren cada tres o cuatro años. ")
		gpu.set(1,11,"                                                  ")
		gpu.set(1,12,"      Su pequeño tamaño es especialmente útil para")
		gpu.set(1,13,"moverse a través de la espesa maleza de las selvas")
		gpu.set(1,14,"del sureste asiático donde viven.                ")
		gpu.set(1,15,"                                                  ")
	elseif i == 1 then
		gpu.set(1, 7,"A pesar de su nombre, estos animales nunca han    ")
		gpu.set(1, 8,"estado restringidos a la isla de Sumatra. Su área ")
		gpu.set(1, 9,"de distribución original se extendía por las      ")
		gpu.set(1,10,"faldas del Himalaya en Bután, India oriental,     ")
		gpu.set(1,11,"Birmania, Indochina, sur de China, Malaca, Sumatra")
		gpu.set(1,12," y Borneo, pero la caza y destrucción de su       ")
		gpu.set(1,13,"hábitat le hace correr un grave peligro de        ")
		gpu.set(1,14,"extinción en la actualidad.                       ")
		gpu.set(1,15,"                                                  ")
	end
	
	while j < 50 do
		os.sleep(1)
		gpu.set(j + 1,16,"|")
		j = j + 1
	end
	
	j = 0
	i = i + 1
	
	if i > pages then
		i = 0
	end
end
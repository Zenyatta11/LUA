
local term = require "term"
local component = require "component"
local gpu = component.gpu

gpu.set(1, 1,"██████████████████████████████████████████████████")
gpu.set(1, 2,"███                                            ███")
gpu.set(1, 3,"███               SPIDER MONKEY                ███")
gpu.set(1, 4,"███                                            ███")
gpu.set(1, 5,"██████████████████████████████████████████████████")
gpu.set(1, 6,"                                                  ")



local i = 0;
local j = 0;
local pages = 1;

while true do
	gpu.set(1,16,"                                                  ")
	
	if i == 0 then
		gpu.set(1, 7,"                                                  ")
		gpu.set(1, 7,"Viven desde el sur México hasta el río Tapajós en ")
		gpu.set(1, 8,"la Amazonia brasileña.                            ")
		gpu.set(1,11,"Son primordialmente arbóreos, cumplen la mayor    ")
		gpu.set(1,12,"parte de sus actividades en las densas cubiertas  ")
		gpu.set(1,13,"de los bosques y selvas lluviosos y tupidos donde ")
		gpu.set(1,14,"habita.                                           ")
		gpu.set(1,9,"                                                  ")
		gpu.set(1,10,"                                                  ")
		gpu.set(1,15,"                                                  ")
	elseif i == 1 then
		gpu.set(1, 7,"Según la especie, su cuerpo mide de 65 a 90 cm de ")
		gpu.set(1, 8,"longitud, y la cola prensil de 60 a 92 cm. Son de ")
		gpu.set(1, 9,"apariencia más esbelta que los otros monos.       ")
		gpu.set(1,10,"Tienen cuatro dedos, sin pulgares. El cuerpo es   ")
		gpu.set(1,11,"alargado y los miembros largos; el color de las   ")
		gpu.set(1,12,"diferentes especies varía de castaño claro a      ")
		gpu.set(1,14,"Las hembras tienen un clítoris alargado           ")
		gpu.set(1,13,"negro.                                            ")
		gpu.set(1,15,"que suele superar el tamaño del pene del macho.   ")
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

local term = require "term"
local component = require "component"
local gpu = component.gpu

gpu.set(1, 1,"██████████████████████████████████████████████████")
gpu.set(1, 2,"███                                            ███")
gpu.set(1, 3,"███                                            ███")
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
		gpu.set(1, 8,"                                                  ")
		gpu.set(1, 9,"                                                  ")
		gpu.set(1,10,"                                                  ")
		gpu.set(1,11,"                                                  ")
		gpu.set(1,12,"                                                  ")
		gpu.set(1,13,"                                                  ")
		gpu.set(1,14,"                                                  ")
		gpu.set(1,15,"                                                  ")
	elseif i == 1 then
		gpu.set(1, 7,"                                                  ")
		gpu.set(1, 8,"                                                  ")
		gpu.set(1, 9,"                                                  ")
		gpu.set(1,10,"                                                  ")
		gpu.set(1,11,"                                                  ")
		gpu.set(1,12,"                                                  ")
		gpu.set(1,13,"                                                  ")
		gpu.set(1,14,"                                                  ")
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
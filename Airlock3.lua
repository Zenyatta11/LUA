local door = 4

while true do
	os.pullEvent("redstone")
	if rs.getInput("left") then
		if door == 0 then
			rs.setOutput("top", true)
			sleep(1)
			rs.setOutput("top", false)
			sleep(1)
			rs.setOutput("top", true)
			sleep(1)
			rs.setOutput("top", false)
			sleep(1)
			rs.setOutput("top", true)
			sleep(1)
			rs.setOutput("top", false)
			sleep(2)
			door = 1
			rs.setOutput("bottom", false)
		else
			rs.setOutput("bottom", true)
			rs.setOutput("front", true)
			door = 0
		end
	elseif rs.getInput("right") then
		if door == 0 then
			rs.setOutput("top", true)
			sleep(1)
			rs.setOutput("top", false)
			sleep(1)
			rs.setOutput("top", true)
			sleep(1)
			rs.setOutput("top", false)
			sleep(1)
			rs.setOutput("top", true)
			sleep(1)
			rs.setOutput("top", false)
			sleep(2)
			door = 2
			rs.setOutput("front", false)
		else
			rs.setOutput("bottom", true)
			rs.setOutput("front", true)
			door = 0
		end
	end
	
	rs.setOutput("top", false)
	sleep(5)
	rs.setOutput("top", true)
end
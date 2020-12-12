--[[

--Documentation:
--@ ClockTimeLightSystem
--@ Santeeisweird9

--# Summary of code

A system that controls streetlights/lamps based on the time of day.

--Order of code:

--//Services
--//Constants
--//Functions
--//Implicitly-ran code

]]


-- // VARIABLES
local RunService = game:GetService("RunService")
local lighting = game:GetService("Lighting")

local TimeToTurnOn = 18 -- time to turn on
local TimeToTurnOff = 6 -- time to turn off


local lightDir = workspace:WaitForChild("LightExample")

function timeChange()
	while wait() do
		lighting.ClockTime = lighting.ClockTime + 0.001
	end
end

spawn(timeChange)


while wait(0.1) do
	if lighting:GetMinutesAfterMidnight() >= TimeToTurnOn * 60 then
		for _,v in pairs(lightDir:GetDescendants()) do
			if v:IsA("Light") then
				v.Enabled = true
				v.Parent.Material = Enum.Material.Neon
				--print("ran on")
			end
		end
	elseif lighting:GetMinutesAfterMidnight() >= TimeToTurnOff * 60 then
		for _,v in pairs(lightDir:GetDescendants()) do
			if v:IsA("Light") then
				v.Enabled = false
				v.Parent.Material = Enum.Material.Plastic
				--print("ran off")
			end
		end
	end
end

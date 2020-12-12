--[[

--Documentation:
--@ ChangingLight
--@ Santeeisweird9

--# Summary of code

This basically changes the color of the lights based on the beat of the music.

--Order of code:

--//Constants
--//Functions
--//Implicitly-ran code

]]


local maxLoudness = 210 -- adjust as neccessary

local lightModel = workspace:WaitForChild("ChangingLights") -- change as neccessary
local soundDirectory = workspace:WaitForChild("Sounds") -- change as necessary

-- leave everything else alone

local sound
local debounce = false
local detected = false
local looping = false


function getSound()
	for i,v in pairs(soundDirectory:GetChildren()) do
		if v:IsA("Sound") and v.IsPlaying and sound == nil and debounce then
			sound = v
			print("Detected sound!")
			debounce = false
			detected = true
			wait(.5)
		elseif detected == false and debounce then
			sound = nil
			looping = true
			wait(.5)
		end
	end
end

local lights = {}
local beams = {}
local sprites = {}

for i,v in pairs(lightModel:GetDescendants()) do
	if v:IsA("Light") or v:IsA("SpotLight") or v:IsA("SurfaceLight") or v:IsA("PointLight") or v.Name == "light" then
		table.insert(lights,i,v)
	end
end

for i,v in pairs(lightModel:GetDescendants()) do
	if v:IsA("Beam") then
		table.insert(beams,i,v)
	end
end

for i,v in pairs(lightModel:GetDescendants()) do
	if v:IsA("ImageLabel") then
		table.insert(sprites,i,v)
	end
end

function colorChange()
	if sound == nil then
		debounce = true
		getSound()
		return
	end
	if debounce == false then
		detected = false
		
		local isBeat = false
		local loudness = sound.PlaybackLoudness
		local r = math.random(1,255)
		local g = math.random(1,255)
		local b = math.random(1,255)
		
		if loudness == 0 then
			sound = nil
			detected = false
		end
		
		if loudness > maxLoudness then
			isBeat = true
		end
		
		if isBeat then
			for i,v in pairs(lights) do
				v.Color = Color3.fromRGB(r,g,b)
			end
			for i,v in pairs(beams) do
				v.Color = ColorSequence.new(Color3.fromRGB(r,g,b),Color3.fromRGB(r,g,b))
			end
			for i,v in pairs(sprites) do
				v.ImageColor3 = Color3.fromRGB(r,g,b)
			end
		end
	end
end

game:GetService("RunService").Heartbeat:Connect(colorChange)
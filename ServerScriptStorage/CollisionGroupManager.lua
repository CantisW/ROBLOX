--[[

--Documentation:
--@ CollisionGroupManager
--@ Santeeisweird9

--# Summary of code

Initializes group rank-based doors at the start of the server.
Originally meant for a game project, but I have since then used this in other projects.

--Order of code:

--//Services
--//Constants
--//Functions
--//Implicitly-ran code

]]

-- // VARIABLES

local physics = game:GetService("PhysicsService")
local players = game:GetService("Players")


local doors = {} -- keep empty

local doorsDirectory = workspace.TeamDoors -- change to a MODEL which contains all of your doors

for i,v in pairs(doorsDirectory:GetChildren()) do -- handles the table
	table.insert(doors, i, v)
end


local collisionGroupName = "employeeDoor"

local playerGroup = "employees"

local groupId = 0 -- set to group
local groupRank = 255 -- set to rank

-- setting up groups
physics:CreateCollisionGroup(collisionGroupName)

for i = 1,#doors do
	physics:SetPartCollisionGroup(doors[i], collisionGroupName)
end

physics:CreateCollisionGroup(playerGroup)

-- // CODE - DON'T CHANGE UNLESS YOU KNOW WHAT YOU'RE DOING

function setCollisionGroup(character, group)
	for _,v in pairs(character:GetChildren()) do
		if v:IsA("BasePart") and group >= groupRank or group == 255 then	
			physics:SetPartCollisionGroup(v, playerGroup)
		end
	end
	character.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") and group >= groupRank or group == 255 then	
			physics:SetPartCollisionGroup(descendant, playerGroup)
		end
	end)
end

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		setCollisionGroup(character, player:GetRankInGroup(groupId))
	end)
end)


-- make both groups not interact
physics:CollisionGroupSetCollidable(collisionGroupName, playerGroup, false)
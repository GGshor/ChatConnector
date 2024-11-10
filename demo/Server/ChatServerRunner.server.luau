local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local ChatConnector = require(ReplicatedStorage:WaitForChild("ChatConnector"))
local TestPart = Workspace:WaitForChild("SpawnLocation")

task.delay(2, function()
    local TestChannel = ChatConnector:AddChannel("TestChannel", false)

    local speaker = ChatConnector:GetSpeaker(Players:GetPlayers()[1].Name)
    speaker:AddChannel("TestChannel")

    speaker:SetExtraData("NameColor", Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)))
    speaker:SetExtraData("ChatColor", Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)))
    
    speaker:SetExtraData("Tags", {
        {
            TagColor = Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)),
            TagText = "TestTag1",
        },
        {
            TagColor = Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)),
            TagText = "TestTag2",
        }
    })
end)

while true do
    ChatConnector:Chat(TestPart, "Colors 🥳", Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)))

    task.wait(math.random(1, 5))

    ChatConnector:Chat(TestPart, "No colors 😭")

    task.wait(math.random(1, 5))
end
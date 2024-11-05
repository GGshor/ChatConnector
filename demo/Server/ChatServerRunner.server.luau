local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local ChatConnector = require(ReplicatedStorage:WaitForChild("ChatConnector"))
local TestPart = Workspace:WaitForChild("SpawnLocation")

while true do
    ChatConnector:Chat(TestPart, "Colors 🥳", Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)))

    task.wait(math.random(1, 5))

    ChatConnector:Chat(TestPart, "No colors 😭")

    task.wait(math.random(1, 5))
end
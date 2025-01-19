local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TextChatService = game:GetService("TextChatService")

local ChatConnector = require(ReplicatedStorage:WaitForChild("ChatConnector"))
local TestPart = Workspace:WaitForChild("SpawnLocation")

task.delay(2, function()
    local TestSpeaker = ChatConnector:AddSpeaker("Testing")
    ChatConnector:AddChannel("TestChannel", false)

    TestSpeaker:JoinChannel("All")

    TestSpeaker:SetExtraData("NameColor", Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)))
    TestSpeaker:SetExtraData("ChatColor", Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)))

    TestSpeaker:SetExtraData("Tags", {
        {
            TagColor = Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)),
            TagText = "TestTag1",
        },
        {
            TagColor = Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)),
            TagText = "TestTag2",
        }
    })

    while true do
        TestSpeaker:SayMessage("Hi!", "All")
        task.wait(math.random(1, 5))
    end
end)

while true do
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        ChatConnector:Chat(TestPart, "Colors 🥳", Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255)))

        task.wait(math.random(1, 5))

        ChatConnector:Chat(TestPart, "No colors 😭")

        task.wait(math.random(1, 5))
    else
        -- Demo place is using old chat
        ChatConnector:Chat(TestPart, "Colors 🥳", Enum.ChatColor.Red)

        task.wait(math.random(1, 5))

        ChatConnector:Chat(TestPart, "No colors 😭")

        task.wait(math.random(1, 5))

        ChatConnector:Chat(TestPart, "Colors 🥳", Enum.ChatColor.Blue)

        task.wait(math.random(1, 5))
    end

end
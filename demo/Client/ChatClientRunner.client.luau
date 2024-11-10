local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage:WaitForChild("ChatConnector"))

local ChatSettings = require(ReplicatedStorage:WaitForChild("ChatConnector"):WaitForChild("ChatSettings"))

ChatSettings.ShowChannelsBar = true
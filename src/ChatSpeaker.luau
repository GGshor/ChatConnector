local Players = game:GetService("Players")


local Types = require(script.Parent:WaitForChild("Types"))

local ChatSpeaker = {}
ChatSpeaker.__index = ChatSpeaker

function ChatSpeaker.SetExtraData(self: Types.ChatSpeaker, dataName: string, dataValue: any)
    self.ExtraData[dataName] = dataValue
end

function ChatSpeaker.new(name: string): Types.ChatSpeaker
    local self = {
        Name = name,
        ExtraData = {},
        ActiveChannels = {},
    } :: Types.ChatSpeaker

    for _, player: Player in Players:GetPlayers() do
        if player.Name:lower() == name:lower() then
            self.Player = player
            break
        end
    end

    return setmetatable(self, ChatSpeaker)
end

return ChatSpeaker
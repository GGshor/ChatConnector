local ServerScriptService = game:GetService("ServerScriptService")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local ChatColorConverter = require(script.Parent:WaitForChild("ChatColorConverter"))

local ChatService = nil
local ChatServerModule = nil

-- Load in legacy services if we're using the old legacy chat
if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
    ChatService = game:GetService("Chat")

    if RunService:IsServer() then
        ChatServerModule = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
    end
end

return function (method: string, ...: any...): any
    if not ChatService then
        return false -- Return false as we're running the new TextChatService
    end

    -- Internal API call to know we're using the old version without calling any methods
    if method == "_InternalLegacyCheck" then
        return true
    end

    -- Just here for easy switching between legacy and text chat service. (Mostly used when the new Text Chat Service is being buggy.)
    if method == "SendSystemMessage" then 
        local message = {...}
        return StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = message[1]
        })
    end

    -- Change the third argument to be nil
    if method == "Chat" then
        return ChatService:Chat(...)
    end

    return ChatServerModule[method](ChatServerModule, ...)
end
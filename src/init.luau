--[[
    Connects the old Chat to the new TextChatService
]]


local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")

local Types = require(script:WaitForChild("Types"))
local ChatChannel = require(script:WaitForChild("ChatChannel"))

local ChatConnector = {
    ChatChannels = {}
} :: Types.ChatConnectorAPI

local ClientEvent = script:WaitForChild("ClientEvent")

--[=[
    Transforms the Color3 instance to a RGB string.

    @param color Color3 -- The Color3 instance you want to transform.

    @return string -- The made string
]=]
local function Color3ToRGBString(color: Color3): string
    return `{math.floor(color.R * 255 + 0.5)}, {math.floor(color.G * 255 + 0.5)}, {math.floor(color.B * 255 + 0.5)}`
end

--[=[
    Creates a text bubble above instance or character.

    @param partOrCharacter Instance -- The part or character model you want to show the bubble of
    @param message string -- The text you want to display in the bubble
    @param color Color3? -- Optional color that you can make the text in the bubble.

    @return nil
]=]
function ChatConnector:Chat(partOrCharacter: Instance , message: string, color: Color3?): ()
    if RunService:IsClient() then
        -- Prevent part from being nil
        if typeof(partOrCharacter) ~= "Instance" then
            return
        elseif partOrCharacter:IsA("Model") then
            -- Ensure that model is character
            if not partOrCharacter:FindFirstChild("HumanoidRootPart") then
                return
            end
        end

        -- Wrap message with color if color was given
        if typeof(color) == "Color3" then
            TextChatService:DisplayBubble(partOrCharacter, `<font color="rgb({Color3ToRGBString(color)})">{message}</font>`)
        else
            TextChatService:DisplayBubble(partOrCharacter, message)
        end
    else
        ClientEvent:FireAllClients("Chat", partOrCharacter, message, color)
    end
end


--[=[
    Creates a new TextChannel if it doesn't exist already.

    @param channelName string -- The channel name
    @param autoJoin boolean -- Automatically add users to channel, by default true

    @return Types.ChatChannel
]=]
function ChatConnector:AddChannel(channelName: string, autoJoin: boolean?): Types.ChatChannel
    -- Prevent Clients from running this method
    if RunService:IsClient() then
        return
    end

    -- Check if channel is already registered
    if self.ChatChannels[channelName] then
        return self.ChatChannels[channelName]
    end

    -- Create the channel and save it
    local newChannel = ChatChannel.new(channelName, autoJoin)
    self.ChatChannels[channelName] = newChannel

    return newChannel
end

--[=[
    Connects the events fired from Server to the appropriate  methods.

    @param methodName string -- The method name.
    @param ... -- The arguments that should be given to the method.
]=]
if RunService:IsClient() then
    ClientEvent.OnClientEvent:Connect(function(methodName: string, ...)
        task.spawn(ChatConnector[methodName], ChatConnector, ...)
    end)
end

return ChatConnector

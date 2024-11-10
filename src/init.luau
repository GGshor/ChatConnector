--[[
    Connects the old Chat to the new TextChatService
]]


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")

local Types = require(script:WaitForChild("Types"))
local ChatChannel = require(script:WaitForChild("ChatChannel"))
local ChatSpeaker = require(script:WaitForChild("ChatSpeaker"))
local LoadSettings = require(script:WaitForChild("LoadSettings"))

local ChatConnector = {
    ChatChannels = {},
    Speakers = {}
} :: Types.ChatConnectorAPI

local ClientEvent = script:WaitForChild("ClientEvent")
local ClientRequest = script:WaitForChild("ClientRequest")

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
    Sends a system message, mostly used interal.

    @param message string -- The text you want to send
    @param channelName string -- The channel name

    @return nil
]=]
function ChatConnector:SendSystemMessage(message: string, textChannel: Types.ChatChannel, metadata: string?)
    if RunService:IsClient() then
        textChannel._textChannel:DisplaySystemMessage(message, metadata)
    else
        ClientEvent:FireAllClients("SendSystemMessage", message, textChannel, metadata)
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

    -- All is the old name
    if channelName:lower() == "all" then
        channelName = "General"
    end

    -- Check if channel is already registered
    if self.ChatChannels[channelName:lower()] then
        return self.ChatChannels[channelName]
    end

    -- Create TextChannels folder if Roblox doesn't make it
    if TextChatService.CreateDefaultTextChannels == false and TextChatService:FindFirstChild("TextChannels") == nil then
        local channelsFolder = Instance.new("Folder")
        channelsFolder.Name = "TextChannels"
        channelsFolder.Parent = TextChatService
    end

    -- Create the channel and save it
    local newChannel = ChatChannel.new(channelName, autoJoin) :: Types.ChatChannel
    self.ChatChannels[channelName:lower()] = newChannel

    return newChannel
end

--[=[
    Returns a TextChannel if it exists.

    @param channelName string -- The channel name

    @return Types.ChatChannel?
]=]
function ChatConnector:GetChannel(channelName: string): Types.ChatChannel?
    -- Prevent Clients from running this method
    if RunService:IsClient() then
        return
    end

    -- "All" is the old general channel name
    if channelName:lower() == "all" then
        channelName = "General"
    end

    return self.ChatChannels[channelName:lower()] or self:AddChannel(channelName)
end

--[=[
    Creates a new Speaker if it doesn't exist already.

    @param speakerName string -- The speaker name

    @return Types.ChatSpeaker
]=]
function ChatConnector:AddSpeaker(speakerName: string): Types.ChatSpeaker
    -- Prevent Clients from running this method
    if RunService:IsClient() then
        return
    end

    -- Check if channel is already registered
    if self.Speakers[speakerName:lower()] then
        return self.Speakers[speakerName:lower()]
    end

    -- Create the channel and save it
    local newSpeaker = ChatSpeaker.new(speakerName) :: Types.ChatSpeaker
    self.Speakers[speakerName:lower()] = newSpeaker

    newSpeaker.JoinChannel = function(speaker: Types.ChatSpeaker, channelName: string)
        if table.find(speaker.ActiveChannels, channelName:lower()) or speaker.Player == nil then
            return
        end

        local foundChannel = self:GetChannel(channelName)
        if foundChannel then
            table.insert(speaker.ActiveChannels, channelName:lower())
            foundChannel:AddUserAsync(speaker.Player.UserId)
        end
    end

    newSpeaker.SayMessage = function(speaker: Types.ChatSpeaker, message: string, channelName: string)
        if speaker.Player then
            error("Can't send message because Speaker is a player!")
        end

        ChatConnector:SendSystemMessage(message, self:GetChannel(channelName), speaker.Name)
    end

    return newSpeaker
end

--[=[
    Gets a speaker
]=]
function ChatConnector:GetSpeaker(speakerName: string): Types.ChatSpeaker
    if RunService:IsClient() then
        return ClientRequest:InvokeServer("GetSpeaker", speakerName)
    end

    if self.Speakers[speakerName:lower()] then
        return self.Speakers[speakerName:lower()]
    end

    -- Check if player has a speaker
    for _, players in Players:GetPlayers() do
        if players.Name:lower():match(speakerName:lower()) then
            return self:AddSpeaker(players.Name)
        end
    end
end


-- Sets up the server events
if RunService:IsServer() then
    ClientRequest.OnServerInvoke = function(_, method: string, ...: any...)
        if method == "GetSpeaker" then
            return ChatConnector:GetSpeaker(...)
        end
    end
end

-- Sets up the client events
if RunService:IsClient() then
    --[=[
        Connects the events fired from Server to the appropriate  methods.

        @param methodName string -- The method name.
        @param ... -- The arguments that should be given to the method.
    ]=]
    ClientEvent.OnClientEvent:Connect(function(methodName: string, ...)
        task.spawn(ChatConnector[methodName], ChatConnector, ...)
    end)

    -- Load in settings
    LoadSettings()

    -- Customize incoming messages
    TextChatService.OnIncomingMessage = function(message: TextChatMessage)
        local properties = Instance.new("TextChatMessageProperties")
        local foundPlayer = message.TextSource and Players:GetPlayerByUserId(message.TextSource.UserId)
        local speaker: Types.ChatSpeaker?
        
        if foundPlayer then
            speaker = ChatConnector:GetSpeaker(foundPlayer.Name)
        else
            speaker = ChatConnector:GetSpeaker(message.Metadata)
        end

        if not speaker then
            return properties
        end

        if speaker.ExtraData["Tags"] then
            local newPrefix = ""
            for _, tag: Types.ChatSpeakerTag in speaker.ExtraData["Tags"] do
                newPrefix = `{newPrefix}<font color="rgb({Color3ToRGBString(tag.TagColor or Color3.fromRGB(255, 0, 255))})">[{tag.TagText or "???"}]</font> `
            end

            if speaker.ExtraData["NameColor"] then
                newPrefix = `{newPrefix}<font color="rgb({Color3ToRGBString(speaker.ExtraData["NameColor"])})">{message.PrefixText}</font>`
            else
                newPrefix = `{newPrefix}{message.PrefixText}`
            end

            properties.PrefixText = newPrefix
        end

        if speaker.ExtraData["ChatColor"] then
            properties.Text = `<font color="rgb({Color3ToRGBString(speaker.ExtraData["ChatColor"])})">{message.Text}</font>`
        end

        return properties
    end
end

return ChatConnector

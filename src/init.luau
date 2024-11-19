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
local LegacySupport = require(script:WaitForChild("LegacySupport"))
local ChatColorConverter = require(script:WaitForChild("ChatColorConverter"))

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
function ChatConnector:Color3ToRGBString(color: Color3): string
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
    local legacyResponse = LegacySupport("Chat", partOrCharacter, message, color)

    -- If we're running legacy, return legacy response
    if legacyResponse ~= false then
        return legacyResponse
    end

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
            TextChatService:DisplayBubble(partOrCharacter, `<font color="rgb({ChatConnector:Color3ToRGBString(color)})">{message}</font>`)
        elseif typeof(color) == "EnumItem" and color.EnumType == Enum["ChatColor"] or typeof(color) == "string" then -- Old chat required an enum, for future proofing also supports the name of the color
            TextChatService:DisplayBubble(partOrCharacter, `<font color="rgb({ChatConnector:Color3ToRGBString(ChatColorConverter.ChatColorToColor3(color))})">{message}</font>`)
        else
            TextChatService:DisplayBubble(partOrCharacter, message)
        end
    else
        ClientEvent:FireAllClients("Chat", partOrCharacter, message, color)
    end
end

--[=[
    Sends a system message, mostly used internal.

    @param message string -- The text you want to send
    @param channelName string -- The channel name

    @return nil
]=]
function ChatConnector:SendSystemMessage(message: string, textChannel: Types.ChatChannel, metadata: string?)
    local legacyResponse = LegacySupport("SendSystemMessage", message)

    -- If we're running legacy, return legacy response
    if legacyResponse ~= false then
        return legacyResponse
    end

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
    local legacyResponse = LegacySupport("AddChannel", channelName, autoJoin)

    -- If we're running legacy, return legacy response
    if legacyResponse ~= false then
        return legacyResponse
    end

    -- Prevent Clients from running this method
    if RunService:IsClient() then
        return
    end

    -- All is the old name
    if channelName:lower() == "all" then
        channelName = "RBXGeneral"
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
function ChatConnector:GetChannel(channelName: string, limitedRequest: boolean?): Types.ChatChannel?
    local legacyResponse = LegacySupport("SendSystemMessage", channelName)

    -- If we're running legacy, return legacy response
    if legacyResponse ~= false then
        return legacyResponse
    end

    -- Prevent Clients from running this method
    if RunService:IsClient() then
        return ClientRequest:InvokeServer("GetChannel", channelName)
    end

    -- "All" is the old general channel name
    if channelName:lower() == "all" then
        channelName = "RBXGeneral"
    end

    if self.ChatChannels[channelName:lower()] then
        return self.ChatChannels[channelName:lower()]
    elseif typeof(limitedRequest) == "nil" then
        for _, channel: TextChannel in TextChatService:WaitForChild("TextChannels"):GetDescendants() do
            if channel.Name:lower() == channelName:lower() then
                return self:AddChannel(channelName)
            end
        end
    end
end

--[=[
    Creates a new Speaker if it doesn't exist already.

    @param speakerName string -- The speaker name

    @return Types.ChatSpeaker
]=]
function ChatConnector:AddSpeaker(speakerName: string): Types.ChatSpeaker
    local legacyResponse = LegacySupport("AddSpeaker", speakerName)

    -- If we're running legacy, return legacy response
    if legacyResponse ~= false then
        return legacyResponse
    end

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

        ChatConnector:SendSystemMessage(message, self:GetChannel(channelName or "All"), `ChatConnector.ChatSpeaker.{speaker.Name}`)
    end

    return newSpeaker
end

--[=[
    Gets a speaker
]=]
function ChatConnector:GetSpeaker(speakerName: string): Types.ChatSpeaker
    local legacyResponse = LegacySupport("GetSpeaker", speakerName)

    -- If we're running legacy, return legacy response
    if legacyResponse ~= false then
        return legacyResponse
    end

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
    -- Only run setup if we're using the new version
    if LegacySupport("_InternalLegacyCheck") == false then
        -- Connect client requests
        ClientRequest.OnServerInvoke = function(_, method: string, ...: any...)
            if method == "GetSpeaker" then
                return ChatConnector:GetSpeaker(...)
            elseif method == "GetChannel" then
                return ChatConnector:GetChannel(..., true)
            end
        end

        -- Add system speaker
        ChatConnector:AddSpeaker("System"):SetExtraData({
            ["NameColor"] = Color3.new(1, 0, 0),
            ["ChatColor"] = Color3.new(1, 0, 0)
        })

        local function OnChannelAdded(channel: TextChannel?)
            if channel:IsA("TextChannel") == false then
                return
            end

            ChatConnector:AddChannel(channel.Name)
        end
        TextChatService:WaitForChild("TextChannels").DescendantAdded:Connect(OnChannelAdded)
        for _, channel in TextChatService:GetDescendants() do
            task.spawn(OnChannelAdded, channel)
        end
    else
        warn("[ChatConnector] Legacy chat is still enabled! Methods will return their original response from the legacy chat!")
    end
end

-- Sets up the client events
if RunService:IsClient() then
    -- Only run setup if we're using the new version
    if LegacySupport("_InternalLegacyCheck") == false then
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

        -- Replicate messages from other channels that player is in to General
        TextChatService.OnIncomingMessage = function(message: TextChatMessage)
            local properties = Instance.new("TextChatMessageProperties")
            if message.TextSource and message.TextChannel.Name:match("RBXGeneral") == nil and message.Status == Enum.TextChatMessageStatus.Success and Players:GetPlayerByUserId(message.TextSource.UserId) ~= Players.LocalPlayer then
                ChatConnector:SendSystemMessage(message.Text, ChatConnector:GetChannel("All"), `ChatConnector.Replicator.{message.TextChannel.Name}.{Players:GetPlayerByUserId(message.TextSource.UserId).Name}`)
            end
            return properties
        end

        -- Customize incoming messages
        TextChatService.OnChatWindowAdded = function(message: TextChatMessage)	
            local properties = TextChatService.ChatWindowConfiguration:DeriveNewMessageProperties()
            local speaker: Types.ChatSpeaker?
            local tags = {}

            --// Skip if meta contains roblox message
            if message.Metadata:match("Roblox.") then
                return properties
            end

            if message.Metadata:match("ChatConnector.Replicator") and message.Metadata ~= "" then
                local channel = message.Metadata:split(".")[3]
                speaker = ChatConnector:GetSpeaker(message.Metadata:split(".")[4])

                if channel:match("RBXTeam") then
                    table.insert(tags, {
                        TagColor = speaker.Player.TeamColor.Color,
                        TagText = speaker.Player.Team.Name
                    })
                elseif channel:match("RBXWhisper:") then
                    table.insert(tags, {
                        TagColor = Color3.new(1, 1, 1),
                        TagText = "Whisper"
                    })
                else
                    table.insert(tags, {
                        TagColor = Color3.new(1, 1, 1),
                        TagText = channel:gsub("RBX", "")
                    })
                end
            elseif message.TextSource then
                speaker = ChatConnector:GetSpeaker(Players:GetPlayerByUserId(message.TextSource.UserId).Name)
            elseif typeof(message.Metadata) == "string" and message.Metadata ~= "" then
                speaker = ChatConnector:GetSpeaker(message.Metadata:split("ChatConnector.ChatSpeaker.")[2])
            end

            if message.TextSource == nil and message.Metadata:match("ChatConnector.ChatSpeaker") == nil then	
                if message.TextChannel.Name:match("RBXWhisper:") then
                    local whisper = TextChatService:WaitForChild("TextChatCommands"):WaitForChild("RBXWhisperCommand") :: TextChatCommand
                    local split = message.TextChannel.Name:gsub("RBXWhisper:"):split("_")
                    local player1, player2 = Players:GetPlayerByUserId(split[1]), Players:GetPlayerByUserId(split[2])

                    local target = player1 ~= Players.LocalPlayer and player1 or player2

                    properties.Text = `<font color="rgb({ChatConnector:Color3ToRGBString(Color3.new(1, 0 , 0))})">Run /{whisper.PrimaryAlias} {target.DisplayName}!</font>`
                    properties.PrefixText = "System:"
                else
                    properties.Text = `<font color="rgb({ChatConnector:Color3ToRGBString(Color3.new(1, 0 , 0))})">You can't send messages here!</font>`
                    properties.PrefixText = "System:"
                end
            end

            if not speaker then
                return properties
            end

            --// Load tags
            for _, foundTag in speaker.ExtraData["Tags"] or {} do
                table.insert(tags, foundTag)
            end

            if speaker.Player and message.PrefixText == "" then
                if speaker.Player.Team then
                    message.PrefixText = `<font color="rgb({ChatConnector:Color3ToRGBString(speaker.Player.TeamColor.Color)})">{speaker.Player.DisplayName}: </font>`
                else
                    message.PrefixText = `{speaker.Player.DisplayName}: `
                end
            elseif not speaker.Player then
                message.PrefixText = `{speaker.Name}: `
            end

            --// Add tags to text
            local newPrefix = ""
            for _, tag: Types.ChatSpeakerTag in tags do
                newPrefix = `{newPrefix}<font color="rgb({ChatConnector:Color3ToRGBString(tag.TagColor or Color3.fromRGB(255, 0, 255))})">[{tag.TagText or "???"}]</font> `
            end

            --// Add color to the name that overrides the default color
            if speaker.ExtraData["NameColor"] then
                newPrefix = `{newPrefix}<font color="rgb({ChatConnector:Color3ToRGBString(speaker.ExtraData["NameColor"])})">{message.PrefixText}</font>`
            else
                newPrefix = `{newPrefix}<font color="rgb({ChatConnector:Color3ToRGBString(speaker.Player and speaker.Player.TeamColor.Color or Color3.new(1, 1, 1))})">{message.PrefixText}</font>`
            end

            properties.PrefixText = newPrefix

            --// Update text color
            if speaker.ExtraData["ChatColor"] then
                properties.Text = `<font color="rgb({ChatConnector:Color3ToRGBString(speaker.ExtraData["ChatColor"])})">{message.Text}</font>`
            else
                properties.Text = message.Text
            end

            return properties
        end

        --// Fix whisper chat if command is enabled
        if TextChatService.CreateDefaultCommands == true then
            local whisper = TextChatService:WaitForChild("TextChatCommands"):WaitForChild("RBXWhisperCommand") :: TextChatCommand
            TextChatService:WaitForChild("TextChannels").ChildAdded:Connect(function(newChannel: TextChannel)
                if newChannel.Name:match(Players.LocalPlayer.UserId) then
                    local split = newChannel.Name:gsub("RBXWhisper:", ""):split("_")
                    local player1, player2 = Players:GetPlayerByUserId(split[1]), Players:GetPlayerByUserId(split[2])

                    local target = player1 ~= Players.LocalPlayer and player1 or player2
                    newChannel:SendAsync(`{whisper.PrimaryAlias} {target.DisplayName}`)
                end
            end)
        end
    else
        warn("[ChatConnector] Legacy chat is still enabled! Methods will return their original response from the legacy chat!")
    end
end

return ChatConnector

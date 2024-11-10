local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local Types = require(script.Parent:WaitForChild("Types"))

local ChangeableProperties = {"AutoJoin", "Joinable", "Private"}

local ChatChannel = {}
ChatChannel.__index = ChatChannel

--[=[
    Finds the first TextChannel in TextChatService which matches the name.

    @param textChannelName string -- The name of the channel

    @return TextChannel? -- The found textchannel
]=]
local function findTextChannel(textChannelName: string): TextChannel?
    local descendants = TextChatService:GetDescendants()
    
    -- Select first text channel which matches the name
    for _, textChannel: TextChannel in descendants do
        if textChannel.Name:gsub("RBX", ""):lower() == textChannelName:lower() and textChannel:IsA("TextChannel") then
            return textChannel
        end
    end

    -- Return nil just to be sure
    return nil
end

--[=[
    Adds a player to the channel.

    @param userid number -- The userid of player
]=]
function ChatChannel:AddUserAsync(userid: number)
    self._textChannel:AddUserAsync(userid)
end

--[=[
    Creates a new ChatChannel.

    @param channelName string -- The channel name
    @param autoJoin boolean -- Should players automatically be added?

    @return Types.ChatChannel
]=]
function ChatChannel.new(channelName: string, autoJoin: boolean?): Types.ChatChannel
    local self = {
        Name = channelName,
        Speakers = {},
        AutoJoin = true,
        Joinable = false, -- DEPRECATED // Prevents old scripts from erroring
        Private = false, -- DEPRECATED // Prevents old scripts from erroring
        __newindex = function(currentSelf: Types.ChatChannel, key, value)
            if table.find(ChangeableProperties, key) then
                if key == "AutoJoin" and (typeof(value) == "boolean" or typeof(value) == "nil")  then
                    currentSelf.AutoJoin = value and true or false
                    currentSelf._textChannel:SetAttribute("AutoJoin", currentSelf.AutoJoin)

                    -- Add players to channel if autojoin is enabled
                    if currentSelf.AutoJoin then
                        for _, player: Player in Players:GetPlayers() do
                            currentSelf._textChannel:AddUserAsync(player.UserId)
                        end
                    end
                end
            else
                error(`{key} is not a property of ChatChannel!`)
            end
        end
    } :: Types.ChatChannel

    self._textChannel = findTextChannel(channelName)

    -- Create a new channel if it doesn't exist already
    if not self._textChannel then
        self._textChannel = Instance.new("TextChannel")
        self._textChannel.Name = channelName
        self._textChannel.Parent = TextChatService:WaitForChild("TextChannels")
    end

    -- Set auto join
    self.AutoJoin = autoJoin and true or false
    self._textChannel:SetAttribute("AutoJoin", self.AutoJoin)

    -- Add speakers when added to the channel
    self._textChannel.ChildAdded:Connect(function(child: TextSource?)
        if child:IsA("TextSource") then
            self.Speakers[child.Name] = child
        end
    end)

    -- Add players to channel if autojoin is enabled
    if self.AutoJoin then
        Players.PlayerAdded:Connect(function(player)
            if self.AutoJoin then
                self._textChannel:AddUserAsync(player.UserId)
            end
        end)
        for _, player: Player in Players:GetPlayers() do
            self._textChannel:AddUserAsync(player.UserId)
        end
    end

    return setmetatable(self, ChatChannel)
end

return ChatChannel
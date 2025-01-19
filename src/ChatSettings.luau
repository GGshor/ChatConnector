--[[
	Adds support for changing settings and redirects to the correct setting

	No check is enabled here due to the old settings module.
]]
--!nocheck

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Types = require(script.Parent:WaitForChild("Types"))
local LegacySupport = require(script.Parent:WaitForChild("LegacySupport"))

-- If we're running on legacy chat, return old chat settings module
if LegacySupport("_InternalLegacyCheck") == true then
	return require(game:GetService("Chat"):WaitForChild("ClientChatModules"):WaitForChild("ChatSettings"))
end

local Settings = {}

---[[ Chat Behavior Settings ]]
Settings.WindowDraggable = false -- DEPRECATED
Settings.WindowResizable = false -- DEPRECATED
Settings.ShowChannelsBar = false -- ChannelTabsConfiguration.Enabled
Settings.GamepadNavigationEnabled = false -- DEPRECATED
Settings.AllowMeCommand = false -- DEPRECATED
Settings.ShowUserOwnFilteredMessage = true -- DEPRECATED
Settings.ChatOnWithTopBarOff = false -- DEPRECATED
Settings.ScreenGuiDisplayOrder = 6	-- DEPRECATED

Settings.ShowFriendJoinNotification = true -- TODO: Players.Added: Player:IsFriend()

Settings.BubbleChatEnabled = Players.BubbleChat -- BubbleChatConfiguration.Enabled
Settings.ClassicChatEnabled = Players.ClassicChat -- ChatWindowConfiguration.Enabled

---[[ Chat Text Size Settings ]]
Settings.ChatWindowTextSize = 18 -- ChatWindowConfiguration.TextSize
Settings.ChatChannelsTabTextSize = 18 -- ChannelTabsConfiguration.TextSize
Settings.ChatBarTextSize = 18 -- ChatInputBarConfiguration.TextSize
Settings.ChatWindowTextSizePhone = 14 -- DEPRECATED
Settings.ChatChannelsTabTextSizePhone = 18 -- DEPRECATED
Settings.ChatBarTextSizePhone = 14 -- DEPRECATED

---[[ Font Settings ]]
Settings.DefaultFont = Enum.Font.SourceSansBold -- ChatWindowConfiguration.FontFace
Settings.ChatBarFont = Enum.Font.SourceSansBold -- ChatInputBarConfiguration.FontFace

----[[ Color Settings ]]
Settings.BackGroundColor = Color3.new(0, 0, 0) -- ChatWindowConfiguration.BackgroundColor3
Settings.DefaultMessageColor = Color3.new(1, 1, 1) -- ChatWindowConfiguration.TextColor3
Settings.DefaultNameColor = Color3.new(1, 1, 1) -- TODO: OnTextMessage
Settings.ChatBarBackGroundColor = Color3.new(0, 0, 0) -- ChatInputBarConfiguration.BackgroundColor3
Settings.ChatBarBoxColor = Color3.new(1, 1, 1) -- DEPRECATED
Settings.ChatBarTextColor = Color3.new(0, 0, 0) -- ChatInputBarConfiguration.TextColor3
Settings.ChannelsTabUnselectedColor = Color3.new(0, 0, 0) -- ChannelTabsConfiguration.BackgroundColor3
Settings.ChannelsTabSelectedColor = Color3.new(30/255, 30/255, 30/255) -- ChannelTabsConfiguration.SelectedTabColor3
Settings.DefaultChannelNameColor = Color3.fromRGB(35, 76, 142) -- DEPRECATED
Settings.WhisperChannelNameColor = Color3.fromRGB(102, 14, 102) -- DEPRECATED
Settings.ErrorMessageTextColor = Color3.fromRGB(245, 50, 50) -- DEPRECATED

---[[ Window Settings ]]
Settings.MinimumWindowSize = UDim2.new(0.3, 0, 0.25, 0) -- DEPRECATED
Settings.MaximumWindowSize = UDim2.new(1, 0, 1, 0) -- DEPRECATED
Settings.DefaultWindowPosition = UDim2.new(0, 0, 0, 0) -- DEPRECATED
local extraOffset = (7 * 2) + (5 * 2) -- Extra chat bar vertical offset
Settings.DefaultWindowSizePhone = UDim2.new(0.5, 0, 0.5, extraOffset) -- DEPRECATED
Settings.DefaultWindowSizeTablet = UDim2.new(0.4, 0, 0.3, extraOffset) -- DEPRECATED
Settings.DefaultWindowSizeDesktop = UDim2.new(0.3, 0, 0.25, extraOffset)-- DEPRECATED

---[[ Fade Out and In Settings ]]
Settings.ChatWindowBackgroundFadeOutTime = 3.5 -- DEPRECATED
Settings.ChatWindowTextFadeOutTime = 30 -- DEPRECATED
Settings.ChatDefaultFadeDuration = 0.8 -- DEPRECATED
Settings.ChatShouldFadeInFromNewInformation = false -- DEPRECATED
Settings.ChatAnimationFPS = 20.0 -- DEPRECATED

---[[ Channel Settings ]]
Settings.GeneralChannelName = "General" -- DEPRECATED, but for scripts relying it's been set to "General"
Settings.EchoMessagesInGeneralChannel = true -- DEPRECATED
Settings.ChannelsBarFullTabSize = 4 -- DEPRECATED
Settings.MaxChannelNameLength = 12 -- DEPRECATED
Settings.MaxChannelNameCheckLength = 50 -- DEPRECATED
Settings.RightClickToLeaveChannelEnabled = false -- DEPRECATED
Settings.MessageHistoryLengthPerChannel = 50 -- DEPRECATED
Settings.ShowJoinAndLeaveHelpText = false -- DEPRECATED

---[[ Message Settings ]]
Settings.MaximumMessageLength = 200 -- TODO:  OnTextMessage
Settings.DisallowedWhiteSpace = {"\n", "\r", "\t", "\v", "\f"} -- TODO:  OnTextMessage
Settings.ClickOnPlayerNameToWhisper = true -- DEPRECATED
Settings.ClickOnChannelNameToSetMainChannel = true -- DEPRECATED
Settings.BubbleChatMessageTypes = {"Message", "Whisper"} -- DEPRECATED

---[[ Misc Settings ]]
Settings.WhisperCommandAutoCompletePlayerNames = true -- DEPRECATED

--[[ Display Names ]]
--Uses DisplayNames instead of UserNames in chat messages
Settings.PlayerDisplayNamesEnabled = true --DEPRECATED
Settings.WhisperByDisplayName = true -- DEPRECATED

local ChangedEvent = Instance.new("BindableEvent")

local proxyTable = setmetatable({},
{
	__index = function(_, index)
		return Settings[index]
	end,
	__newindex = function(_, index, value)
        if RunService:IsClient() == false then
            warn("ChatSettings: Attempted to change a setting on the server.")
            return
        end

		Settings[index] = value
		ChangedEvent:Fire(index, value)
	end,
})

rawset(proxyTable, "SettingsChanged", ChangedEvent.Event)

return proxyTable :: Types.ChatSettings
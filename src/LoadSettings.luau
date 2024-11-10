local TextChatService = game:GetService("TextChatService")

local BubbleChatConfiguration = TextChatService:WaitForChild("BubbleChatConfiguration") :: BubbleChatConfiguration
local ChatWindowConfiguration = TextChatService:WaitForChild("ChatWindowConfiguration") :: ChatWindowConfiguration
local ChatInputBarConfiguration = TextChatService:WaitForChild("ChatInputBarConfiguration") :: ChatInputBarConfiguration

local ChatSettings = require(script.Parent:WaitForChild("ChatSettings"))

local DefaultChatSettings = table.clone(ChatSettings)

local function defaultOrNewValue(valueName: string, expectedType: string, newValue: any): any
    if typeof(newValue) == "nil" then
        return DefaultChatSettings[valueName]
    elseif typeof(newValue) ~= expectedType then
        error(`[ChatSettings] Invalid type for "{valueName}": expected "{expectedType}", got "{typeof(newValue)}"`)
    else
        return newValue
    end
end

local Convert = {
    ["ShowChannelsBar"] = function(newValue: boolean)
        if TextChatService:FindFirstChild("ChannelTabsConfiguration") then
            TextChatService:FindFirstChild("ChannelTabsConfiguration").Enabled = defaultOrNewValue("ShowChannelsBar", "boolean", newValue)
        else
            warn("[ChatSettings] You don't have the channels feature yet! Please make sure to update your Roblox client if you think you should have it!")
        end
    end,
    ["BubbleChatEnabled"] = function(newValue: boolean)
        BubbleChatConfiguration.Enabled = defaultOrNewValue("BubbleChatEnabled", "boolean", newValue)
    end,
    ["ClassicChatEnabled"] = function(newValue: boolean)
        ChatWindowConfiguration.Enabled = defaultOrNewValue("ClassicChatEnabled", "boolean", newValue)
    end,
    ["ChatWindowTextSize"] = function(newValue: number)
        ChatWindowConfiguration.TextSize = defaultOrNewValue("ChatWindowTextSize", "number", newValue)
    end,
    ["ChatChannelsTabTextSize"] = function(newValue: number)
        if TextChatService:FindFirstChild("ChannelTabsConfiguration") then
            TextChatService:FindFirstChild("ChannelTabsConfiguration").TextSize = defaultOrNewValue("ChatChannelsTabTextSize", "number", newValue)
        else
            warn("[ChatSettings] You don't have the channels feature yet! Please make sure to update your Roblox client if you think you should have it!")
        end
    end,
    ["ChatBarTextSize"] = function(newValue: number)
        ChatInputBarConfiguration.TextSize = defaultOrNewValue("ChatBarTextSize", "number", newValue)
    end,
    ["DefaultFont"] = function(newValue: Enum.Font)
        local success, response = pcall(Font.fromEnum, defaultOrNewValue("DefaultFont", "EnumItem", newValue))
        if success then
            ChatWindowConfiguration.FontFace = response
            return
        end

        warn(`[ChatSettings] {newValue} is not a supported font anymore! Defaulting back to: Enum.Font.BuilderSansMedium.`)

        ChatWindowConfiguration.FontFace = Font.fromEnum(Enum.Font.BuilderSansMedium)
    end,
    ["ChatBarFont"] = function(newValue: Enum.Font)
        local success, response = pcall(Font.fromEnum, defaultOrNewValue("ChatBarFont", "EnumItem", newValue))

        if success then
            ChatInputBarConfiguration.FontFace = response
            return
        end

        warn(`[ChatSettings] {newValue} is not a supported font anymore! Defaulting back to: Enum.Font.BuilderSansMedium.`)

        ChatInputBarConfiguration.FontFace = Font.fromEnum(Enum.Font.BuilderSansMedium)
    end,
    ["BackGroundColor"] = function(newValue: Color3)
        ChatWindowConfiguration.BackgroundColor3 = defaultOrNewValue("BackGroundColor", "Color3", newValue)
    end,
    ["DefaultMessageColor"] = function(newValue: Color3)
        ChatWindowConfiguration.TextColor3 = defaultOrNewValue("DefaultMessageColor", "Color3", newValue)
    end,
    ["ChatBarBackGroundColor"] = function(newValue: Color3)
        ChatInputBarConfiguration.BackgroundColor3 = defaultOrNewValue("ChatBarBackGroundColor", "Color3", newValue)
    end,
    ["ChatBarTextColor"] = function(newValue: Color3)
        ChatInputBarConfiguration.TextColor3 = defaultOrNewValue("ChatBarTextColor", "Color3", newValue)
    end,
    ["ChannelsTabUnselectedColor"] = function(newValue: Color3)
        if TextChatService:FindFirstChild("ChannelTabsConfiguration") then
            TextChatService:FindFirstChild("ChannelTabsConfiguration").BackgroundColor3 = defaultOrNewValue("ChannelsTabUnselectedColor", "Color3", newValue)
        else
            warn("[ChatSettings] You don't have the channels feature yet! Please make sure to update your Roblox client if you think you should have it!")
        end
    end,
    ["ChannelsTabSelectedColor"] = function(newValue: Color3)
        if TextChatService:FindFirstChild("ChannelTabsConfiguration") then
            TextChatService:FindFirstChild("ChannelTabsConfiguration").SelectedTabColor3 = defaultOrNewValue("ChannelsTabSelectedColor", "Color3", newValue)
        else
            warn("[ChatSettings] You don't have the channels feature yet! Please make sure to update your Roblox client if you think you should have it!")
        end
    end
}


return function()
    ChatSettings.SettingsChanged:Connect(function(index: string, newValue: any)
        if Convert[index] then
            Convert[index](newValue)
        else
            warn(`[ChatSettings] {index} is deprecated and doesn't do anything anymore!`)
        end
    end)
end
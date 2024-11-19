local ChatColorConverter = {}

-- Mapping Enum.ChatColor to Color3 values
local ChatColorToColor3 = {
    ["Blue"] = Color3.fromRGB(0, 0, 255),
    ["Green"] = Color3.fromRGB(0, 255, 0),
    ["Red"] = Color3.fromRGB(255, 0, 0),
    ["White"] = Color3.fromRGB(255, 255, 255)
}

-- Function to calculate the Euclidean distance between two Color3 values
local function colorDistance(color1, color2)
    return math.sqrt(
        (color1.R - color2.R) ^ 2 +
        (color1.G - color2.G) ^ 2 +
        (color1.B - color2.B) ^ 2
    )
end

-- Function to find the closest matching ChatColor Enum for a Color3
function ChatColorConverter.Color3ToChatColor(color: Color3)
    local closestEnum = nil
    local smallestDistance = math.huge

    for chatColor: string, predefinedColor in ChatColorToColor3 do
        local distance = colorDistance(color, predefinedColor)
        if distance < smallestDistance then
            smallestDistance = distance
            closestEnum = Enum["ChatColor"][chatColor]
        end
    end

    return closestEnum
end

-- Function to convert a ChatColor Enum to its corresponding Color3
function ChatColorConverter.ChatColorToColor3(enum: EnumItem): Color3
    if typeof(enum) == "EnumItem" and enum.EnumType == Enum["ChatColor"] then
        return ChatColorToColor3[enum.Name]
    elseif typeof(enum) == "string" then
        return ChatColorToColor3[enum]
    else
        error("Input must be an Enum.ChatColor or the color name.")
    end
end

return ChatColorConverter

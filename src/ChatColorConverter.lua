local ChatColorConverter = {}

-- Mapping predefined chat colors to Color3 values
local ChatColorToColor3 = {
    Blue = Color3.fromRGB(0, 0, 255),
    Green = Color3.fromRGB(0, 255, 0),
    Red = Color3.fromRGB(255, 0, 0),
    White = Color3.fromRGB(255, 255, 255)
}

-- Function to calculate the Euclidean distance between two Color3 values
local function colorDistance(color1: Color3, color2: Color3): number
    return math.sqrt(
        (color1.R - color2.R) ^ 2 +
        (color1.G - color2.G) ^ 2 +
        (color1.B - color2.B) ^ 2
    )
end

-- Function to find the closest matching chat color for a given Color3
function ChatColorConverter.Color3ToChatColor(color: Color3): string
    if typeof(color) ~= "Color3" then
        error("Input must be a Color3 value.")
    end

    local closestEnum = nil
    local smallestDistance = math.huge

    for chatColor, predefinedColor in ChatColorToColor3 do
        local distance = colorDistance(color, predefinedColor)
        if distance < smallestDistance then
            smallestDistance = distance
            closestEnum = chatColor
        end
    end

    return closestEnum or "Unknown"
end

-- Function to convert a chat color name or Enum-like value to its corresponding Color3
function ChatColorConverter.ChatColorToColor3(enum: any): Color3
    if typeof(enum) == "string" and ChatColorToColor3[enum] then
        return ChatColorToColor3[enum]
    else
        error("Input must be a valid chat color name (e.g., 'Blue', 'Red', etc.).")
    end
end

return ChatColorConverter

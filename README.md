Here's a `README.md` for the `ChatBridge` module:

---

# ChatBridge Module

The `ChatBridge` module is designed to provide compatibility between Roblox's legacy `Chat` service and the new `TextChatService`. It mimics legacy functionality, allowing developers to use familiar methods, events, and options from the old `Chat` service with the new system.

This module supports:
- Sending chat messages
- Filtering messages for broadcasts and private chats
- Custom channels
- Speaker management
- System messages

## Setup

1. Place the `ChatBridge` module in **ServerScriptService > ChatModules**.
2. Initialize the module by creating a Script in **ServerScriptService** that requires and configures `ChatBridge`.

## Basic Usage

Here's a quick start guide to initialize and test the `ChatBridge` module:

```lua
-- Script in ServerScriptService
local ChatBridge = require(game.ServerScriptService.ChatModules.ChatBridge)

-- Enable legacy chat compatibility
ChatBridge:EnableLegacySupport()  

-- Create the main chat channel
local mainChannel = ChatBridge:AddChannel("Main")

-- Add players as speakers in the main channel
game.Players.PlayerAdded:Connect(function(player)
    local speaker = ChatBridge:AddSpeaker(player.Name)
    ChatBridge:JoinChannel(player.Name, "Main")
end)

-- Connect to the Chatted event to listen for all chat messages
ChatBridge.Chatted.Event:Connect(function(player, message)
    print(player.Name .. " said: " .. message)
end)
```

## API Reference

### Core Chat Methods

1. **ChatBridge:Chat(instance, message, color)**  
   Send a chat message with an optional color.
   ```lua
   ChatBridge:Chat(player.Character, "Hello!", Enum.ChatColor.Blue)
   ```

2. **ChatBridge:FilterStringForBroadcast(message, player)**  
   Filters a message for broadcasting.
   ```lua
   local filteredMessage = ChatBridge:FilterStringForBroadcast("Hello everyone!", player)
   ```

3. **ChatBridge:FilterStringForPlayerAsync(message, fromPlayer, toPlayer)**  
   Filters a message for a specific player, useful for private messages.
   ```lua
   local filteredMessage = ChatBridge:FilterStringForPlayerAsync("Hello!", fromPlayer, toPlayer)
   ```

4. **ChatBridge:CanUsersChatAsync(userId1, userId2)**  
   Checks if two users can chat.
   ```lua
   local canChat = ChatBridge:CanUsersChatAsync(user1.UserId, user2.UserId)
   ```

### Channel Methods

1. **ChatBridge:AddChannel(channelName)**  
   Creates a custom chat channel.
   ```lua
   local mainChannel = ChatBridge:AddChannel("Main")
   ```

2. **ChatBridge:RemoveChannel(channelName)**  
   Removes a custom chat channel.
   ```lua
   ChatBridge:RemoveChannel("Main")
   ```

3. **ChatBridge:GetChannel(channelName)**  
   Retrieves a channel by name.
   ```lua
   local channel = ChatBridge:GetChannel("Main")
   ```

### Speaker Methods

1. **ChatBridge:AddSpeaker(speakerName)**  
   Adds a player as a speaker in the chat system.
   ```lua
   local speaker = ChatBridge:AddSpeaker(player.Name)
   ```

2. **ChatBridge:RemoveSpeaker(speakerName)**  
   Removes a speaker from the chat system.
   ```lua
   ChatBridge:RemoveSpeaker(player.Name)
   ```

3. **ChatBridge:GetSpeaker(speakerName)**  
   Retrieves a speaker by name.
   ```lua
   local speaker = ChatBridge:GetSpeaker(player.Name)
   ```

4. **ChatBridge:SayMessage(speakerName, message, channelName)**  
   Sends a message in a specified channel from a speaker.
   ```lua
   ChatBridge:SayMessage(player.Name, "Hello!", "Main")
   ```

5. **ChatBridge:JoinChannel(speakerName, channelName)**  
   Adds a speaker to a channel.
   ```lua
   ChatBridge:JoinChannel(player.Name, "Main")
   ```

6. **ChatBridge:LeaveChannel(speakerName, channelName)**  
   Removes a speaker from a channel.
   ```lua
   ChatBridge:LeaveChannel(player.Name, "Main")
   ```

7. **ChatBridge:SendSystemMessage(message, channelName)**  
   Sends a system message to all speakers in a specified channel.
   ```lua
   ChatBridge:SendSystemMessage("Welcome to the game!", "Main")
   ```

### Events

- **ChatBridge.Chatted**: Mimics the legacy `Chat.Chatted` event, firing whenever a player sends a message. 
  ```lua
  ChatBridge.Chatted.Event:Connect(function(player, message)
      print(player.Name .. " said: " .. message)
  end)
  ```

## Example Use Case

Here's an example of creating a private chat channel:

```lua
-- Create a private channel
local privateChannel = ChatBridge:AddChannel("Private")

-- Add players to the private channel
ChatBridge:JoinChannel("Player1", "Private")
ChatBridge:JoinChannel("Player2", "Private")

-- Send a message in the private channel
ChatBridge:SayMessage("Player1", "This is a private message", "Private")
```

## Notes

- This module is designed to closely mimic legacy chat behavior but may have slight differences due to the new `TextChatService` structure.
- Colors, filtering, and channels are approximations and may need adjustments depending on the specific requirements of the game.

## License

This module is free to use and modify in any Roblox game. Attribution is appreciated but not required.

--- 

This README covers the purpose, setup, usage, and API reference of the `ChatBridge` module.
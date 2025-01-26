# ChatConnector Module

A module that connects the legacy Roblox chat system to the new `TextChatService`.

## Setup
You can get the module through downloading it through the GitHub [release](https://github.com/GGshor/ChatConnector/releases/latest/download/ChatConnector.rbxm) or by using the [Marketplace](https://create.roblox.com/store/asset/108798205227072/ChatConnector) on Roblox.
Place this module in `ReplicatedStorage` and **require it at least once on the client and server** to enable chat functionality across all players.

## Functions

### `ChatConnector:Chat(partOrCharacter, message, color)`
Displays a text bubble above a part or character.

- **`partOrCharacter`** (Instance): Target instance (part or character model).
- **`message`** (string): Text to display.
- **`color`** (Color3, optional): Color for the text, default is black.

#### Example:
```lua
ChatConnector:Chat(workspace.SpawnLocation, "Hello!", Color3.fromRGB(0, 255, 0))
```

### `ChatConnector:SendSystemMessage(message, channel, metadata)`
Sends a system message to the channel.

- **`message`** (string): Text to display.
- **`channel`** (ChatChannel): The channel to send it to.
- **`metadata`** (string, optional): Any metadata to send along with it

#### Example:
```lua
ChatConnector:SendSystemMessage("Hello!", ChatConnector:GetChannel("SecretTeam"), "System")
```

### `ChatConnector:AddChannel(channelName, autoJoin)`
Creates a new `TextChannel` if it doesn't exist already.

- **`channelName`** (string): The name of the channel to add.
- **`autoJoin`** (boolean, optional): Whether users should automatically join the channel. Defaults to `true` if not provided.

#### Example:
```lua
local newChannel = ChatConnector:AddChannel("SecretTeam")
```

### `ChatConnector:GetChannel(channelName)`
Returns a TextChannel if it exists.

- **`channelName`** (string): The name of the channel to get.

#### Example:
```lua
local foundChannel = ChatConnector:GetChannel("SecretTeam")
```

### `ChatConnector:AddSpeaker(speakerName)`
Creates a new `ChatSpeaker` if it doesn't exist already.

- **`speakerName`** (string): The name of the speaker to add.

#### Example:
```lua
local newSpeaker = ChatConnector:AddSpeaker("Alex")
```

### `ChatConnector:GetSpeaker(speakerName)`
Returns a ChatSpeaker if it exists.

- **`speakerName`** (string): The name of the speaker to get.

#### Example:
```lua
local foundSpeaker = ChatConnector:GetSpeaker("Alex")
```

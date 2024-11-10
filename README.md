# ChatConnector Module

A module that connects the legacy Roblox chat system to the new `TextChatService`.

## Setup
Place this module in `ReplicatedStorage` and **require it at least once on the client** to enable chat functionality across all players.

## Functions

### `ChatConnector:Chat(partOrCharacter, message, color)`
Displays a text bubble above a part or character.

- **`partOrCharacter`** (Instance): Target instance (part or character model).
- **`message`** (string): Text to display.
- **`color`** (Color3, optional): Color for the text, default is black.

#### Example:
```lua
ChatConnector:Chat(workspace.SpawnLocation, "Hello!", Color3.fromRGB(0, 255, 0))  -- Green text
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

- **`channelName`** (string): The name of the channel to add.

#### Example:
```lua
local foundChannel = ChatConnector:GetChannel("SecretTeam")
```
export type ChatSpeakerTag = {
    TagColor: Color3,
    TagText: string
}

export type ChatSpeaker = {
    Name: string,
    Player: Player?,
    ExtraData: {[string]: any},
    ActiveChannels: {},

    JoinChannel: (channelName: string) -> (),
    SetExtraData: (dataName: string, dataValue: any) -> (),
    SayMessage: (message: string, channelName: string) -> ()
}

export type ChatChannel = {
    Name: string,
    Speakers: {[string]: TextSource},
    AutoJoin: boolean,
    Joinable: boolean, -- Deprecated, but maybe used in Future?
    Private: boolean, -- Deprecated, but good feature for ChatChannelService?
    TextChannel: TextChannel?,

    AddUserAsync: (self: ChatChannel, userid: number) -> (),
}

export type ChatConnectorAPI = {
    ChatChannels: {[string]: ChatChannel},
	Speakers: {[string]: ChatSpeaker},
    ChannelAdded: RBXScriptSignal,

	Color3ToRGBString: (self: ChatConnectorAPI, color: Color3) -> string,

    Chat: (self: ChatConnectorAPI, partOrCharacter: Instance , message: string, color: Color3?) -> (),
    SendSystemMessage: (self: ChatConnectorAPI, message: string, textChannel: ChatChannel, metadata: string?) -> (),
    AddChannel: (self: ChatConnectorAPI, channelName: string, autoJoin: boolean?) -> ChatChannel,
    GetChannel: (self: ChatConnectorAPI, channelName: string) -> ChatChannel?,
    AddSpeaker: (self: ChatConnectorAPI, speakerName: string) -> ChatSpeaker,
    GetSpeaker: (self: ChatConnectorAPI, speakerName: string) -> ChatSpeaker?
}

export type ChatSettings = {
    -- Chat Behaviour Settings
    WindowDraggable: boolean,
    WindowResizable: boolean,
    ShowChannelsBar: boolean,
    GamepadNavigationEnabled: boolean,
    AllowMeCommand: boolean,
    ShowUserOwnFilteredMessage: boolean,
    ChatOnWithTopBarOff: boolean,
    ScreenGuiDisplayOrder: number,
    ShowFriendJoinNotification: boolean,
    BubbleChatEnabled: boolean,
    ClassicChatEnabled: boolean,

    -- Chat Text Size Settings
    ChatWindowTextSize: number,
    ChatChannelsTabTextSize: number,
    ChatBarTextSize: number,
    ChatWindowTextSizePhone: number,
    ChatChannelsTabTextSizePhone: number,
    ChatBarTextSizePhone: number,

    -- Font Settings
    DefaultFont: Enum.Font,
    ChatBarFont: Enum.Font,

    -- Color Settings
    BackGroundColor: Color3,
    DefaultMessageColor: Color3,
    DefaultNameColor: Color3,
    ChatBarBackGroundColor: Color3,
    ChatBarBoxColor: Color3,
    ChatBarTextColor: Color3,
    ChannelsTabUnselectedColor: Color3,
    ChannelsTabSelectedColor: Color3,
    DefaultChannelNameColor: Color3,
    WhisperChannelNameColor: Color3,
    ErrorMessageTextColor: Color3,

    -- Window Settings
    MinimumWindowSize: UDim2,
    MaximumWindowSize: UDim2,
    DefaultWindowPosition: UDim2,
    DefaultWindowSizePhone: UDim2,
    DefaultWindowSizeTablet: UDim2,
    DefaultWindowSizeDesktop: UDim2,

    -- Fade Out and In Settings
    ChatWindowBackgroundFadeOutTime: number,
    ChatWindowTextFadeOutTime: number,
    ChatDefaultFadeDuration: number,
    ChatShouldFadeInFromNewInformation: boolean,
    ChatAnimationFPS: number,

    -- Channel Settings
    GeneralChannelName: string?,
    EchoMessagesInGeneralChannel: boolean,
    ChannelsBarFullTabSize: number,
    MaxChannelNameLength: number,
    MaxChannelNameCheckLength: number,
    RightClickToLeaveChannelEnabled: boolean,
    MessageHistoryLengthPerChannel: number,
    ShowJoinAndLeaveHelpText: boolean,

    -- Message Settings
    MaximumMessageLength: number,
    DisallowedWhiteSpace: {string},
    ClickOnPlayerNameToWhisper: boolean,
    ClickOnChannelNameToSetMainChannel: boolean,
    BubbleChatMessageTypes: {string},

    -- Misc Settings
    WhisperCommandAutoCompletePlayerNames: boolean,

    -- Display Names
    PlayerDisplayNamesEnabled: boolean,
    WhisperByDisplayName: boolean,

    -- Event
    SettingsChanged: RBXScriptSignal
}


return {}
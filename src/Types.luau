export type ChatChannel = {
    Name: string,
    Speakers: {[string]: TextSource},
    AutoJoin: boolean,
    Joinable: boolean, -- Deprecated, but maybe used in Future?
    Private: boolean -- Deprecated, but good feature for ChatChannelService?
}

export type ChatConnectorAPI = {
    ChatChannels: {[string]: ChatChannel},

    Chat: (self: ChatConnectorAPI, partOrCharacter: Instance , message: string, color: Color3?) -> (),
    AddChannel: (self: ChatConnectorAPI, channelName: string, autoJoin: boolean?) -> ChatChannel
}

return {}
export type ChatConnectorAPI = {
    Chat: (self: ChatConnectorAPI, partOrCharacter: Instance , message: string, color: Color3?) -> ()
}

return {}
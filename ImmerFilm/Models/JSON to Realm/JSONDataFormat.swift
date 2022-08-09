import Foundation

struct JSONDataFormat: Decodable {
    let storyName: String
    let characters: [Character]
    let importedMediaLibraryItems: [ImportedMediaLibraryItem]
    let voicemails: [ImportedVoicemailItem]
}

struct Character: Decodable {
    let characterName: String
    let characterProfilePicture: String
    let characterHidden: Bool
    let conversationSteps: [StoryStep]
    let conversationHistory: [ConversationHistoryItem]
}

struct StoryStep: Decodable {
    let stepID: Int
    let title: String
    let choice1: String
    let choice1Destination: Int
    let choice2: String
    let choice2Destination: Int
    let choice3: String
    let choice3Destination: Int
    let contentUnlocking: [ContentUnlocking]
}

struct ContentUnlocking: Decodable {
    let contentType: String
    let contentID: Int
    let unlockDelay: Int
}

struct ImportedMediaLibraryItem: Decodable {
    let mediaLibraryItemID:Int
    let mediaName: String
    let mediaType: String
    let mediaHidden: Bool
}

struct ConversationHistoryItem: Decodable {
    let title:String
    let sender: String
    let timestamp:String
}

struct ImportedVoicemailItem: Decodable {
    let voicemailItemID: Int
    let callerName: String
    let callerProfilePicture: String
    let audioName: String
    let voicemailHidden: Bool
}


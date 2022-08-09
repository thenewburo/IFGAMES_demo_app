import Foundation
import RealmSwift

struct ImportJSONToRealm {
    
    var realm = try! Realm()
    

    
    func loadDataFromJSON() {
        
        try! realm.write {
            realm.deleteAll()
        }
          
        if let path = Bundle.main.path(forResource: "MorbiusV2", ofType: "json") {
            do {
                let storyData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(JSONDataFormat.self, from: storyData)
                
                let jsonCharactersArray = decodedData.characters
                
                for jsonCharacter in jsonCharactersArray {
                    
                    let newVirtualCharacter = VirtualCharacter()
                    newVirtualCharacter.characterName = jsonCharacter.characterName
                    newVirtualCharacter.characterProfilePicture = jsonCharacter.characterProfilePicture
                    newVirtualCharacter.characterHidden = jsonCharacter.characterHidden
                    save(virtualCharacter: newVirtualCharacter)
                    
                    for virtualCharacterInteraction in jsonCharacter.conversationSteps {
                        do {
                            try realm.write {
                                let newVirtualCharacterInteraction = VirtualCharacterInteraction()
                                newVirtualCharacterInteraction.interactionID = virtualCharacterInteraction.stepID
                                newVirtualCharacterInteraction.characterText = virtualCharacterInteraction.title
                                newVirtualCharacterInteraction.userReplyOption1 = virtualCharacterInteraction.choice1
                                newVirtualCharacterInteraction.userReplyOption1NextInteraction = virtualCharacterInteraction.choice1Destination
                                newVirtualCharacterInteraction.userReplyOption2 = virtualCharacterInteraction.choice2
                                newVirtualCharacterInteraction.userReplyOption2NextInteraction = virtualCharacterInteraction.choice2Destination
                                newVirtualCharacterInteraction.userReplyOption3 = virtualCharacterInteraction.choice3
                                newVirtualCharacterInteraction.userReplyOption3NextInteraction = virtualCharacterInteraction.choice3Destination

                                for contentUnlocking in virtualCharacterInteraction.contentUnlocking {
                                    let newContentUnlockingItem = ContentUnlockingItem()
                                    newContentUnlockingItem.contentType = contentUnlocking.contentType
                                    newContentUnlockingItem.contentID = contentUnlocking.contentID
                                    newContentUnlockingItem.unlockDelay = contentUnlocking.unlockDelay
                                    newVirtualCharacterInteraction.contentUnlockingItems.append(newContentUnlockingItem)
                                }
                                
                                newVirtualCharacter.virtualCharacterInteractions.append(newVirtualCharacterInteraction)

                            }
                        } catch {
                            print("Error adding virtual character interaction")
                        }
                    }
                    
                    for jsonConversationHistoryItem in jsonCharacter.conversationHistory {
                        do {
                            try realm.write {
                                let newVirtualCharacterInteractionHistory = VirtualCharacterInteractionHistory()
                                newVirtualCharacterInteractionHistory.interactionType = jsonConversationHistoryItem.sender
                                newVirtualCharacterInteractionHistory.interactionText = jsonConversationHistoryItem.title
                                
                                let dateFormatImporter = DateFormatter()
                                dateFormatImporter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                if let importedDate = dateFormatImporter.date(from: jsonConversationHistoryItem.timestamp) {
                                    newVirtualCharacterInteractionHistory.interactionTimestamp = importedDate
                                }
                                
                                newVirtualCharacter.virtualCharacterInteractionsHistory.append(newVirtualCharacterInteractionHistory)
                            }
                        } catch {
                            print("Error adding virtual character interaction history")
                        }
                    }
                    
                }
                
                let jsonMediaLibraryArray = decodedData.importedMediaLibraryItems
                
                for jsonMediaLibraryItem in jsonMediaLibraryArray {
                    
                    let newMediaLibraryItem = MediaLibraryItem()
                    newMediaLibraryItem.mediaName = jsonMediaLibraryItem.mediaName
                    newMediaLibraryItem.mediaType = jsonMediaLibraryItem.mediaType
                    newMediaLibraryItem.mediaHidden = jsonMediaLibraryItem.mediaHidden
                    save(newMediaLibraryItem: newMediaLibraryItem)
                }
                
                let jsonVoicemailArray = decodedData.voicemails
                
                for jsonVoicemailItem in jsonVoicemailArray {
                    
                    let newVoicemailItem = VoicemailItem()
                    newVoicemailItem.voicemailItemID = jsonVoicemailItem.voicemailItemID
                    newVoicemailItem.callerName = jsonVoicemailItem.callerName
                    newVoicemailItem.callerProfilePicture = jsonVoicemailItem.callerProfilePicture
                    newVoicemailItem.audioName = jsonVoicemailItem.audioName
                    newVoicemailItem.mediaHidden = jsonVoicemailItem.voicemailHidden
                    save(newVoicemailItem: newVoicemailItem)
                }
                
            } catch let error {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("Invalid JSON file path")
        }
    }
    
    
    func save(virtualCharacter: VirtualCharacter) {
        do {
            try realm.write {
                realm.add(virtualCharacter)
            }
        } catch {
            print("Error saving new virtual character \(error)")
        }
    }
    
    func save(newMediaLibraryItem: MediaLibraryItem) {
        do {
            try realm.write {
                realm.add(newMediaLibraryItem)
            }
        } catch {
            print("Error saving new media library character \(error)")
        }
    }
    
    func save(newVoicemailItem: VoicemailItem) {
        do {
            try realm.write {
                realm.add(newVoicemailItem)
            }
        } catch {
            print("Error saving new voicemail \(error)")
        }
    }
}

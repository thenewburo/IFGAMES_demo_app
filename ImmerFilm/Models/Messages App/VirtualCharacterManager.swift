import Foundation
import RealmSwift

struct VirtualCharacterManager {
    
    let realm = try! Realm()
    var virtualCharacterInteractionsHistory: List<VirtualCharacterInteractionHistory>?
    
    var selectedVirtualCharacter : VirtualCharacter? {
        didSet{
            virtualCharacterInteractionsHistory = selectedVirtualCharacter?.virtualCharacterInteractionsHistory
        }
    }
    
    func getVisibleContactsList() -> Results<VirtualCharacter> {
        return realm.objects(VirtualCharacter.self).filter("characterHidden == false").sorted(byKeyPath: "characterName")
    }
    
    func getActiveConversationContactsList() -> Results<VirtualCharacter> {
        return realm.objects(VirtualCharacter.self).filter("virtualCharacterInteractionsHistory.@count > 0 AND characterHidden == false").sorted(byKeyPath: "mostRecentInteractionTimestamp", ascending: false)
    }
    
    func submitUserResponse(userResponse: String) {
        clearSupercededInteractionHistoryItems()

        do {
            try realm.write {
                let newVirtualCharacterInteractionHistoryItem = VirtualCharacterInteractionHistory()
                newVirtualCharacterInteractionHistoryItem.interactionType = "User"
                newVirtualCharacterInteractionHistoryItem.interactionText = userResponse
                newVirtualCharacterInteractionHistoryItem.parentCharacterName = selectedVirtualCharacter!.characterName
                newVirtualCharacterInteractionHistoryItem.interactionTimestamp = Date()
                virtualCharacterInteractionsHistory!.append(newVirtualCharacterInteractionHistoryItem)
            }
        } catch {
            print("Error adding user based interaction history")
        }
        
        do {
            try realm.write {
                if userResponse == selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption1 ?? "No content to compare to" {
                    selectedVirtualCharacter?.currentStoryPosition = selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption1NextInteraction ?? 0
                } else if userResponse == selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption2 ?? "No content to compare to" {
                    selectedVirtualCharacter?.currentStoryPosition = selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption2NextInteraction ?? 0
                } else if userResponse == selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption3 ?? "No content to compare to" {
                    selectedVirtualCharacter?.currentStoryPosition = selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption3NextInteraction ?? 0
                }
                
                selectedVirtualCharacter?.mostRecentInteractionTimestamp = Date()
            }
        } catch {
            print("Error updating currentStoryPosition")
        }
        
    }
    
    //
    func clearSupercededInteractionHistoryItems() {
        let predicate = NSPredicate(format: "ANY owningCharacter.characterName == %@ AND interactionStatus == %@", selectedVirtualCharacter!.characterName, "pending")
        let outstandingNotificationsForSelectedUser : Results<VirtualCharacterInteractionHistory> = realm.objects(VirtualCharacterInteractionHistory.self).filter(predicate)
        
        do {
            try realm.write {
                for outstandingNotificationForSelectedUser in outstandingNotificationsForSelectedUser {
                    outstandingNotificationForSelectedUser.interactionStatus = "superceded"
                    
                    let notificationManager = NotificationManager()
                    notificationManager.cancelScheduledNotification(notificationUuid: outstandingNotificationForSelectedUser.notificationUuid)
                }
            }
        } catch {
            print("Error clearing future message notifications")
        }
    }
    
    func requestVirtualCharacterResponse() {
        checkForUnlockableItems()
        insertVirtualCharacterReply()
        setupTimedFurtherReplies()
    }
        
        
        
    func checkForUnlockableItems() {
        let contentUnlockingItems = selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].contentUnlockingItems
        if let unwrappedContentUnlockingItems  = contentUnlockingItems {
            for contentUnlockingItem in unwrappedContentUnlockingItems {
                
                do {
                    try realm.write {
                        if contentUnlockingItem.contentType == "Voicemail" {
                            print("Unlocking: \(contentUnlockingItem.contentType)")
                            let voicemailList = realm.objects(VoicemailItem.self)
                            voicemailList[contentUnlockingItem.contentID].mediaHidden = false
                            voicemailList[contentUnlockingItem.contentID].voicemailHiddenUntil = Date().addingTimeInterval(TimeInterval(contentUnlockingItem.unlockDelay-2))
 
                            let notificationManager = NotificationManager()
                            notificationManager.scheduleLocalNotification(notificationType: "Voicemail", notificationTitle: "New Voicemail", notificationSubtitle: "New Voicemail received from \(voicemailList[contentUnlockingItem.contentID].callerName)", notificationDelay: contentUnlockingItem.unlockDelay, contentToLaunch: "voicemail", itemToLaunch: voicemailList[contentUnlockingItem.contentID].callerName, notificationUuid: UUID().uuidString)
                            
                        } else if contentUnlockingItem.contentType == "Character" {
                            print("Unlocking: \(contentUnlockingItem.contentType)")
                            let characterList = realm.objects(VirtualCharacter.self)
                            characterList[contentUnlockingItem.contentID].characterHidden = false
                            
                        } else if contentUnlockingItem.contentType == "Media" {
                            print("Unlocking: \(contentUnlockingItem.contentType)")
                            let mediaList = realm.objects(MediaLibraryItem.self)
                            
                            mediaList[contentUnlockingItem.contentID].mediaHidden = false
                            

                            let newVirtualCharacterInteractionHistoryItem = VirtualCharacterInteractionHistory()

                            if mediaList[contentUnlockingItem.contentID].mediaType == "Image" {
                                newVirtualCharacterInteractionHistoryItem.interactionType = "VirtualCharacterImage"
                            } else if mediaList[contentUnlockingItem.contentID].mediaType == "Video" {
                                newVirtualCharacterInteractionHistoryItem.interactionType = "VirtualCharacterVideo"
                            }
                            
                            newVirtualCharacterInteractionHistoryItem.interactionImageName = mediaList[contentUnlockingItem.contentID].mediaName
                            newVirtualCharacterInteractionHistoryItem.parentCharacterName = selectedVirtualCharacter!.characterName
                            newVirtualCharacterInteractionHistoryItem.interactionTimestamp = Date()
                            virtualCharacterInteractionsHistory!.append(newVirtualCharacterInteractionHistoryItem)
                        }
                    }
                } catch {
                    print("Error updating unlock status")
                }

                if contentUnlockingItem.contentType == "OtherContentExample" {

                    print("Unlocking: \(contentUnlockingItem.contentType)")

                    let otherCharacterID = contentUnlockingItem.contentID
                    let characterList = realm.objects(VirtualCharacter.self)
                    let unlockedCharacter = characterList[otherCharacterID]

                    var subVirtualCharacterManager = VirtualCharacterManager()
                    subVirtualCharacterManager.selectedVirtualCharacter = unlockedCharacter
                    subVirtualCharacterManager.setupTimedFurtherReplies()
                }
            }
        }
    }
    
    func insertVirtualCharacterReply() {
        

        do {
            try realm.write {
                let newVirtualCharacterInteractionHistoryItem = VirtualCharacterInteractionHistory()
                newVirtualCharacterInteractionHistoryItem.interactionType = "VirtualCharacter"
                newVirtualCharacterInteractionHistoryItem.interactionText = selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].characterText ?? "No response from character"
                newVirtualCharacterInteractionHistoryItem.parentCharacterName = selectedVirtualCharacter!.characterName
                newVirtualCharacterInteractionHistoryItem.interactionTimestamp = Date()
                virtualCharacterInteractionsHistory!.append(newVirtualCharacterInteractionHistoryItem)
            }
        } catch {
            print("Error adding virtual character interaction history")
        }
    }
    
    func setupTimedFurtherReplies() {
        
        let contentUnlockingItems = selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].contentUnlockingItems
        if let unwrappedContentUnlockingItems  = contentUnlockingItems {
            for contentUnlockingItem in unwrappedContentUnlockingItems {

                do {
                    try realm.write {
                        if contentUnlockingItem.contentType == "ConversationStep" {
                            print("Unlocking: \(contentUnlockingItem.contentType)")

                            let futureStoryStepID = contentUnlockingItem.contentID
                            print("Virtual Character Manager - requestVirtualCharacterResponse - unlock conversationStep with contentID = \(futureStoryStepID) with delay of \(contentUnlockingItem.unlockDelay)")
                            
                            let futureStoryStepInteractionText = selectedVirtualCharacter?.virtualCharacterInteractions[futureStoryStepID].characterText
                            
                            if let futureStoryStepInteractionText = futureStoryStepInteractionText {

                                let newVirtualCharacterInteractionHistoryItem = VirtualCharacterInteractionHistory()
                                newVirtualCharacterInteractionHistoryItem.interactionType = "VirtualCharacter"
                                newVirtualCharacterInteractionHistoryItem.interactionText = futureStoryStepInteractionText
                                newVirtualCharacterInteractionHistoryItem.interactionHiddenUntil = Date().addingTimeInterval(TimeInterval(contentUnlockingItem.unlockDelay-2))
                                print("Unlock timestamp: \(newVirtualCharacterInteractionHistoryItem.interactionHiddenUntil)")
                                newVirtualCharacterInteractionHistoryItem.interactionStoryStepID = futureStoryStepID
                                newVirtualCharacterInteractionHistoryItem.interactionStatus = "pending"
                                newVirtualCharacterInteractionHistoryItem.notificationUuid = UUID().uuidString
                                newVirtualCharacterInteractionHistoryItem.parentCharacterName = selectedVirtualCharacter!.characterName
                                newVirtualCharacterInteractionHistoryItem.interactionTimestamp = newVirtualCharacterInteractionHistoryItem.interactionHiddenUntil
                                virtualCharacterInteractionsHistory!.append(newVirtualCharacterInteractionHistoryItem)

                                let notificationManager = NotificationManager()
                                notificationManager.scheduleLocalNotification(notificationType: "Message",
                                                                              notificationTitle: "New Message from \(selectedVirtualCharacter?.characterName ?? "Unknown Number")",
                                    notificationSubtitle: futureStoryStepInteractionText,
                                    notificationDelay: contentUnlockingItem.unlockDelay,
                                    contentToLaunch: "message",

                                    itemToLaunch: selectedVirtualCharacter?.characterName ?? "undefined",

                                    notificationUuid: newVirtualCharacterInteractionHistoryItem.notificationUuid
                                )
                            }
                        }
                    }
                } catch {
                    print("Error updating conversation step unlock status")
                }
                
            }
        }
    }
    

    func updateCurrentStoryStepForAllVirtualCharacters() {
        let currentTimestamp = Date()
        let predicate = NSPredicate(format: "interactionHiddenUntil < %@ AND interactionStatus == %@", currentTimestamp as NSDate, "pending")
        let sortByCharacterThenByMostRecent = [SortDescriptor(keyPath: "parentCharacterName"), SortDescriptor(keyPath: "interactionHiddenUntil", ascending: false)]
        let pendingNotificationsCurrentlyDisplayed : Results<VirtualCharacterInteractionHistory> = realm.objects(VirtualCharacterInteractionHistory.self).filter(predicate).sorted(by: sortByCharacterThenByMostRecent)
        
        var previousCharacterName = ""
        
        do {
            try realm.write {
                for pendingNotificationCurrentlyDisplayed in pendingNotificationsCurrentlyDisplayed {
                    pendingNotificationCurrentlyDisplayed.interactionStatus =  "displayed"
                    let currentCharacterName = pendingNotificationCurrentlyDisplayed.owningCharacter.first?.characterName
                    if currentCharacterName != previousCharacterName {
                        pendingNotificationCurrentlyDisplayed.owningCharacter.first?.currentStoryPosition = pendingNotificationCurrentlyDisplayed.interactionStoryStepID
                    }
                    previousCharacterName = currentCharacterName ?? ""
                }
            }
        } catch {
            print("Error clearing down outstanding displayed pending message history items")
        }
    }
    
    
    func getUserReplyOption1() -> String {
        return selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption1 ?? "No available answer"
    }
    
    func getUserReplyOption2() -> String {
        return selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption2 ?? "No available answer"
    }
    
    func getUserReplyOption3() -> String {
        return selectedVirtualCharacter?.virtualCharacterInteractions[selectedVirtualCharacter?.currentStoryPosition ?? 0].userReplyOption3 ?? "No available answer"
    }
}

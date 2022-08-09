import Foundation
import RealmSwift

class VirtualCharacterInteractionHistory: Object {
    var owningCharacter = LinkingObjects(fromType: VirtualCharacter.self, property: "virtualCharacterInteractionsHistory")
    
    @objc dynamic var interactionType : String = ""
    @objc dynamic var interactionText : String = ""
    @objc dynamic var interactionImageName : String = ""
    
    @objc dynamic var interactionHiddenUntil = Date(timeIntervalSince1970: 1)
    
    @objc dynamic var interactionStoryStepID : Int = 0
    
    @objc dynamic var interactionStatus : String = "displayed"
    
    @objc dynamic var notificationUuid : String = ""
    
    @objc dynamic var parentCharacterName : String = ""
    
    @objc dynamic var interactionTimestamp = Date(timeIntervalSince1970: 1)
    
}

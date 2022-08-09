import Foundation
import RealmSwift

class VirtualCharacter: Object {
    @objc dynamic var characterID : Int = 0
    @objc dynamic var characterName : String = ""
    @objc dynamic var characterProfilePicture = ""
    @objc dynamic var characterHidden : Bool = false
    @objc dynamic var mostRecentInteractionTimestamp = Date(timeIntervalSince1970: 1)
    @objc dynamic var currentStoryPosition : Int = 0
    
    let virtualCharacterInteractions = List<VirtualCharacterInteraction>()
    let virtualCharacterInteractionsHistory = List<VirtualCharacterInteractionHistory>()
    
}

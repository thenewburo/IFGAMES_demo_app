import Foundation
import RealmSwift

class VirtualCharacterInteraction: Object {
    var owningCharacter = LinkingObjects(fromType: VirtualCharacter.self, property: "virtualCharacterInteractions")
    
    @objc dynamic var interactionID : Int = 0
    @objc dynamic var characterText : String = ""
    @objc dynamic var userReplyOption1 : String = ""
    @objc dynamic var userReplyOption1NextInteraction : Int = 0
    @objc dynamic var userReplyOption2 : String = ""
    @objc dynamic var userReplyOption2NextInteraction : Int = 0
    @objc dynamic var userReplyOption3 : String = ""
    @objc dynamic var userReplyOption3NextInteraction : Int = 0
    
    let contentUnlockingItems = List<ContentUnlockingItem>()
}

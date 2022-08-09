import Foundation
import RealmSwift

class ContentUnlockingItem: Object {
    @objc dynamic var contentType : String = ""
    @objc dynamic var contentID : Int = 0
    @objc dynamic var unlockDelay : Int = 0
    var owningInteraction = LinkingObjects(fromType: VirtualCharacterInteraction.self, property: "contentUnlockingItems")
}

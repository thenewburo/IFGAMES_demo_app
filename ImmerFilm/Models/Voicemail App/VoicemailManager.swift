import Foundation
import RealmSwift

struct VoicemailManager {
    
    let realm = try! Realm()
    
    func getVisibleVoicemailItems() -> Results<VoicemailItem> {
        let currentTimestamp = Date()
        let predicate = NSPredicate(format: "voicemailHiddenUntil < %@ AND mediaHidden == false", currentTimestamp as NSDate)
        return realm.objects(VoicemailItem.self).filter(predicate)
    }
}

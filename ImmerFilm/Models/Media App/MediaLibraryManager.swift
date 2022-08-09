import Foundation
import RealmSwift

struct MediaLibraryManager {
    
    let realm = try! Realm()
    
    func getVisibleMediaItems() -> Results<MediaLibraryItem> {
        return realm.objects(MediaLibraryItem.self).filter("mediaHidden == false")
    }
}


import Foundation
import RealmSwift

class MediaLibraryItem: Object {
   
    @objc dynamic var mediaName : String = ""
    @objc dynamic var mediaType : String = ""
    @objc dynamic var mediaHidden : Bool = true
}

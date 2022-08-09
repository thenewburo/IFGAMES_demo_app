import Foundation
import RealmSwift

class VoicemailItem: Object {
   
    @objc dynamic var voicemailItemID : Int = 0
    @objc dynamic var callerName : String = ""
    @objc dynamic var callerProfilePicture : String = ""
    @objc dynamic var audioName : String = ""
    @objc dynamic var mediaHidden : Bool = false
    @objc dynamic var voicemailHiddenUntil = Date(timeIntervalSince1970: 1)
    
}

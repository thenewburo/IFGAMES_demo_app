import Foundation
import RealmSwift

struct SetupRealmDB {
    
    let realm = try! Realm()
    
    func populateTestDataToRealm() {
        let newVirtualCharacter = VirtualCharacter()
        newVirtualCharacter.characterName = "Frank1"
        newVirtualCharacter.characterID = 1
        self.save(virtualCharacter: newVirtualCharacter)
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
    
}

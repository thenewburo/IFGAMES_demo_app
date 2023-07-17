import UIKit
import RealmSwift

class VirtualCharacterConversationListViewController: UIViewController {
    
    @IBOutlet weak var messageThreadsTableView: UITableView!
                    
    let realm = try! Realm()
    
    let virtualCharacterManager = VirtualCharacterManager()
        
    var newVirtualCharacterConversation : VirtualCharacter?
    
    var selectedVirtualCharacterToDisplay : VirtualCharacter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                                
        messageThreadsTableView.dataSource = self
        messageThreadsTableView.delegate = self
        virtualCharacterManager.updateCurrentStoryStepForAllVirtualCharacters()
        
        messageThreadsTableView.backgroundView = UIImageView(image: UIImage(named: "MessagesBackground"))
        messageThreadsTableView.backgroundView?.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messageThreadsTableView.reloadData()
    }
    
    func openNewConversation(virtualCharacter: VirtualCharacter) {
        newVirtualCharacterConversation = virtualCharacter
        self.performSegue(withIdentifier: Constants.messageDetailSegueNewConversation, sender: self)
    }
    
    func openSpecifiedConversation(characterName: String) {
        print("Open specified conversation with character: \(characterName)")
        let predicate = NSPredicate(format: "characterName == %@", characterName)
        let specifiedVirtualCharacter : Results<VirtualCharacter> = realm.objects(VirtualCharacter.self).filter(predicate)
        
        if specifiedVirtualCharacter.count > 0 {
            selectedVirtualCharacterToDisplay = specifiedVirtualCharacter[0]
            print("Found specified conversation with character: \(selectedVirtualCharacterToDisplay?.characterName ?? "No character specified")")
            self.performSegue(withIdentifier: Constants.messageDetailSegue, sender: self)
    }
}


    @IBAction func homeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func newConversation(_ sender: UIBarButtonItem) {
        print("New conversation button pressed")
    }
}
    


extension VirtualCharacterConversationListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        virtualCharacterManager.getActiveConversationContactsList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.messageThreadCell, for: indexPath)
        cell.textLabel?.text = virtualCharacterManager.getActiveConversationContactsList()[indexPath.row].characterName
        cell.detailTextLabel?.text = virtualCharacterManager.getActiveConversationContactsList()[indexPath.row].virtualCharacterInteractionsHistory.filter("interactionStatus == 'displayed'").last?.interactionText
        cell.imageView?.image = UIImage(named: virtualCharacterManager.getActiveConversationContactsList()[indexPath.row].characterProfilePicture)
        return cell
    }
}


extension VirtualCharacterConversationListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVirtualCharacterToDisplay = virtualCharacterManager.getActiveConversationContactsList()[indexPath.row]
        if selectedVirtualCharacterToDisplay?.characterName.contains("Team-IF") ?? false {
            self.performSegue(withIdentifier: "MessageListToLiveChatSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: Constants.messageDetailSegue, sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.messageDetailSegue {
            let destinationViewController = segue.destination as! VirtualCharacterConversationViewController
            destinationViewController.selectedVirtualCharacter = selectedVirtualCharacterToDisplay
        } else if segue.identifier == Constants.messageDetailSegueNewConversation {
            let destinationViewController = segue.destination as! VirtualCharacterConversationViewController
            if let selectedNewConversationContact = newVirtualCharacterConversation {
                destinationViewController.selectedVirtualCharacter = selectedNewConversationContact
            }
        }
    }
}

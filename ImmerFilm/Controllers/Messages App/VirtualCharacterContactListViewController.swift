import UIKit
import RealmSwift

class VirtualCharacterContactListViewController: UIViewController {

    @IBOutlet weak var contactListTableView: UITableView!
    
    let virtualCharacterManager = VirtualCharacterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactListTableView.dataSource = self
        contactListTableView.delegate = self
    }
}

extension VirtualCharacterContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return virtualCharacterManager.getVisibleContactsList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contactListCell, for: indexPath)
        cell.textLabel?.text = virtualCharacterManager.getVisibleContactsList()[indexPath.item].characterName
        cell.imageView?.image = UIImage(named: virtualCharacterManager.getVisibleContactsList()[indexPath.row].characterProfilePicture)
        return cell
    }
    
}

extension VirtualCharacterContactListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if virtualCharacterManager.getVisibleContactsList()[indexPath.row].characterName.contains("Team-IF") {
        } else {
            let parentViewController = self.navigationController?.viewControllers.first as! VirtualCharacterConversationListViewController
            self.navigationController?.popViewController(animated: false)
            parentViewController.openNewConversation(virtualCharacter: virtualCharacterManager.getVisibleContactsList()[indexPath.row])
        }
    }
    
}

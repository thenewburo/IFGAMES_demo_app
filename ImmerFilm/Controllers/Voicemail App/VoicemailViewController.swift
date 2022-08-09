import UIKit
import RealmSwift

class VoicemailViewController: UIViewController {
    
    @IBOutlet weak var voicemailItemsTableView: UITableView!
    
    let voicemailManager = VoicemailManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        voicemailItemsTableView.dataSource = self
        voicemailItemsTableView.register(UINib(nibName: Constants.voicemailItemCellNibName, bundle: nil), forCellReuseIdentifier: Constants.voicemailItemCell)
        
        voicemailItemsTableView.backgroundView = UIImageView(image: UIImage(named: "MessagesBackground"))
        voicemailItemsTableView.backgroundView?.contentMode = .scaleAspectFill
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        let voicemailItemsTableViewRows = voicemailItemsTableView.indexPathsForVisibleRows
        if let unwrappedVoicemailItemsTableViewRows = voicemailItemsTableViewRows {
            for voicemailItemsTableViewRow in unwrappedVoicemailItemsTableViewRows {
                let cell = voicemailItemsTableView.cellForRow(at: voicemailItemsTableViewRow) as! VoicemailListItem
                cell.stop()
            }
        }
        self.dismiss(animated: true)
    }
}


extension VoicemailViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        voicemailManager.getVisibleVoicemailItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.voicemailItemCell, for: indexPath) as! VoicemailListItem
        cell.callerName.text = voicemailManager.getVisibleVoicemailItems()[indexPath.row].callerName
        cell.callerProfilePicture.image = UIImage(named: voicemailManager.getVisibleVoicemailItems()[indexPath.row].callerProfilePicture)
        cell.callerProfilePicture.frame = CGRect(x: 100,y: 10,width: 50,height: 50)
        cell.audioName = voicemailManager.getVisibleVoicemailItems()[indexPath.row].audioName
        return cell
    }
}





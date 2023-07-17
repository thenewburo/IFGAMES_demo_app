import UIKit
//import Firebase
import RealmSwift

class VirtualCharacterConversationViewController: UIViewController {
    
    @IBOutlet weak var messageDetailTableView: UITableView!
    @IBOutlet weak var replyOption1Button: UIButton!
    @IBOutlet weak var replyOption2Button: UIButton!
    @IBOutlet weak var replyOption3Button: UIButton!
        
//    let db = Firestore.firestore()
    
    var virtualCharacterManager = VirtualCharacterManager()
    
    var virtualCharacterInteractionsHistory: Results<VirtualCharacterInteractionHistory>?
    
    var selectedVirtualCharacter : VirtualCharacter? {
        didSet{
            virtualCharacterManager.selectedVirtualCharacter = selectedVirtualCharacter
            reloadVisibleMessagesQuery()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageDetailTableView.dataSource = self
        messageDetailTableView.register(UINib(nibName: Constants.messageDetailCellNibName, bundle: nil), forCellReuseIdentifier: Constants.messageDetailCell)
        
        virtualCharacterManager.updateCurrentStoryStepForAllVirtualCharacters()
        
        updateUserReplyOptions()
                
        reloadVisibleMessagesQuery()

        reloadMessageDetailTableViewAndScroll()
                
    }

    func reloadVisibleMessagesQuery() {
        let currentTimestamp = Date()
        let predicate = NSPredicate(format: "interactionHiddenUntil < %@ AND interactionStatus !=%@", currentTimestamp as NSDate, "superceded")
        virtualCharacterInteractionsHistory = selectedVirtualCharacter?.virtualCharacterInteractionsHistory.filter(predicate)
    }
    
    @IBAction func replySelectionMade(_ sender: UIButton) {
        
        if let userReply = sender.currentTitle {
            logUserSelectionToFirestore(userResponse: userReply)
        }
        
        hideReplyButtons()
        
        virtualCharacterManager.submitUserResponse(userResponse : sender.currentTitle!)
        
        reloadMessageDetailTableViewAndScroll()
        
        virtualCharacterManager.requestVirtualCharacterResponse()

        delayWithSeconds(1.5){
            
            self.reloadMessageDetailTableViewAndScroll()
            
            self.updateUserReplyOptions()
            
            self.showReplyButtons()
        }
    }
    
    func updateUserReplyOptions() {
        replyOption1Button.setTitle(virtualCharacterManager.getUserReplyOption1(), for: .normal)
        replyOption2Button.setTitle(virtualCharacterManager.getUserReplyOption2(), for: .normal)
        replyOption3Button.setTitle(virtualCharacterManager.getUserReplyOption3(), for: .normal)
        
        if virtualCharacterManager.getUserReplyOption1().count<1 {
            replyOption1Button.isHidden = true
        } else {
            replyOption1Button.isHidden = false
        }
        
        if virtualCharacterManager.getUserReplyOption2().count<1 {
            replyOption2Button.isHidden = true
        } else {
            replyOption2Button.isHidden = false
        }
        
        if virtualCharacterManager.getUserReplyOption3().count<1 {
            replyOption3Button.isHidden = true
        } else {
            replyOption3Button.isHidden = false
        }
        
        reloadMessageDetailTableViewAndScroll()
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func reloadMessageDetailTableViewAndScroll() {
        messageDetailTableView.reloadData()
        if let unwrappedVirtualCharacterInteractionsHistory = virtualCharacterInteractionsHistory {
            let indexPath = IndexPath(row: unwrappedVirtualCharacterInteractionsHistory.count-1, section: 0)
            if unwrappedVirtualCharacterInteractionsHistory.count > 0 {
                DispatchQueue.main.async {
                    self.messageDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    func logUserSelectionToFirestore(userResponse : String) {
//        if let currentUserEmail = Auth.auth().currentUser?.email {
//            self.db.collection(Constants.FireStoreData.firebaseMessageSelectionCollectionName).addDocument(data: [Constants.FireStoreData.replySelection: userResponse, Constants.FireStoreData.userEmail: currentUserEmail]) { (error) in
//                if let e = error {
//                    print("Error saving data to firestore: \(e.localizedDescription)")
//                }
//            }
//        }
    }
    
    func hideReplyButtons() {
        replyOption1Button.isUserInteractionEnabled = false
        replyOption2Button.isUserInteractionEnabled = false
        replyOption3Button.isUserInteractionEnabled = false
        
        fadeOut(view: replyOption1Button, delay: 0)
        fadeOut(view: replyOption2Button, delay: 0)
        fadeOut(view: replyOption3Button, delay: 0)
    }
    
    func showReplyButtons() {
        self.replyOption1Button.self.isUserInteractionEnabled = true
        self.replyOption2Button.self.isUserInteractionEnabled = true
        self.replyOption3Button.self.isUserInteractionEnabled = true
        
        self.fadeIn(view: self.replyOption1Button, delay: 0)
        self.fadeIn(view: self.replyOption2Button, delay: 0)
        self.fadeIn(view: self.replyOption3Button, delay: 0)
    }
    
    func fadeOut(view : UIView, delay: TimeInterval) {
        let animationDuration = 0.5
        UIView.animate(withDuration: animationDuration, delay: 0, options: [UIView.AnimationOptions.curveEaseOut], animations: {
            view.alpha = 0.0
        }, completion: nil)
    }
    
    func fadeIn(view : UIView, delay: TimeInterval) {
        let animationDuration = 0.5
        UIView.animate(withDuration: animationDuration, delay: 0.5, options: [UIView.AnimationOptions.curveEaseOut], animations: {
            view.alpha = 1.0
        }, completion: nil)
    }
    
}


extension VirtualCharacterConversationViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return virtualCharacterInteractionsHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.messageDetailCell, for: indexPath) as! MessageItem
        cell.backgroundColor = UIColor(named: "clear")
        cell.messageText.text = virtualCharacterInteractionsHistory?[indexPath.row].interactionText ?? ""
        
        if let messageTimestamp = virtualCharacterInteractionsHistory?[indexPath.row].interactionTimestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let dateString = dateFormatter.string(from: messageTimestamp)
            cell.messageTimestamp.text = dateString
        }
        
        let interactionType = virtualCharacterInteractionsHistory?[indexPath.row].interactionType ?? "VirtualCharacter"
        cell.clearImageViewCell()
        cell.messageBubble.layer.opacity = 1
        
        
        cell.hideVirtualCharacterTypingReplyDots()
        
        if interactionType == "VirtualUser" || interactionType == "User" {
            cell.automatedMessageSpacerView.isHidden = true
            cell.userMessageSpacerView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.userMessageBubbleColour)
            cell.messageText.textColor = UIColor(named: "UserMessageTextColor")
            cell.messageBubble.layer.opacity = 0.8
           
            let totalTableItems = messageDetailTableView.numberOfRows(inSection: indexPath.section)
            let currentTableItemIndex = indexPath.row
            if currentTableItemIndex == (totalTableItems-1) {
                cell.showVirtualCharacterTypingReplyDots()
                cell.virtualCharacterReplyingAnimationView.backgroundColor = UIColor(named: Constants.automatedMessageBubbleColour)
                cell.virtualCharacterReplyingAnimationView.layer.cornerRadius = 10
            }
        } else if interactionType == "VirtualCharacterImage" {
            cell.automatedMessageSpacerView.isHidden = false
            cell.userMessageSpacerView.isHidden = true
            cell.messageBubble.backgroundColor = nil
            cell.addImageViewCell(imageName: virtualCharacterInteractionsHistory?[indexPath.row].interactionImageName ?? "", mediaType: "Image")
        }  else if interactionType == "VirtualCharacterVideo" {
            cell.automatedMessageSpacerView.isHidden = false
            cell.userMessageSpacerView.isHidden = true
            cell.messageBubble.backgroundColor = nil
            cell.addImageViewCell(imageName: virtualCharacterInteractionsHistory?[indexPath.row].interactionImageName ?? "", mediaType: "Video")
        } else {
            cell.automatedMessageSpacerView.isHidden = false
            cell.userMessageSpacerView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.automatedMessageBubbleColour)
            cell.messageText.textColor = UIColor(named: "AutomatedMessageTextColor")
            cell.messageBubble.layer.opacity = 0.8
            cell.automatedMessageProfilePicture.image = UIImage(named: selectedVirtualCharacter?.characterProfilePicture ?? "DefaultProfilePicture")
        }
        return cell
    }
}

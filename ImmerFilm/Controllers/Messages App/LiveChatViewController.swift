import UIKit
//import Firebase
import RealmSwift

class LiveChatViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var messageDetailTableView: UITableView!
    @IBOutlet weak var replyTextField: UITextField!
    
    @IBOutlet weak var liveChatBottomViewDistance: NSLayoutConstraint!
//    let db = Firestore.firestore()
    
    var messagesArray: [LiveChatMessage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyTextField.delegate = self
        
        messageDetailTableView.dataSource = self
        messageDetailTableView.register(UINib(nibName: Constants.messageDetailCellNibName, bundle: nil), forCellReuseIdentifier: Constants.messageDetailCell)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
                         
        messageDetailTableView.backgroundView = UIImageView(image: UIImage(named: "MessagesBackground"))
        messageDetailTableView.backgroundView?.contentMode = .scaleAspectFill
        
        loadMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear() {
        liveChatBottomViewDistance.constant = 320
    }
    
    @objc func keyboardWillDisappear() {
        liveChatBottomViewDistance.constant = 30
    }
    
    func reloadMessageDetailTableViewAndScroll() {
        DispatchQueue.main.async {
            self.messageDetailTableView.reloadData()
            if self.messagesArray.count > 0 {
                let indexPath = IndexPath(row: self.messagesArray.count-1, section: 0)
                 self.messageDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func loadMessages() {
        
//        db.collection("chatTable").order(by: "messageTimestamp").addSnapshotListener { (querySnapshot, error) in
//            if let e = error {
//                print("Error loading from Firebase \(e)")
//            } else {
//                print("Loading data from Firestore")
//                if let snapShotDocuments = querySnapshot?.documents {
//                    self.messagesArray = []
//                    for document in snapShotDocuments {
//                        print("Loading document")
//                        let data = document.data()
//                        if let messageSender = data["messageSender"] as? String, let messageBody = data["messageBody"] as? String {
//                            print("Loading: \(messageBody)")
//                            let newMessage = LiveChatMessage(messageSender: messageSender, messageBody: messageBody)
//                            self.messagesArray.append(newMessage)
//                        }
//                    }
//                }
//            }
//            self.reloadMessageDetailTableViewAndScroll()
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageDetailTableView.dequeueReusableCell(withIdentifier: Constants.messageDetailCell, for: indexPath) as! MessageItem
        
        
        cell.messageText.text = messagesArray[indexPath.row].messageBody
        
        cell.backgroundColor = UIColor(named: "clear")
        cell.messageBubble.layer.opacity = 0.8
        
        cell.hideVirtualCharacterTypingReplyDots()
        cell.messageTimestamp.isHidden = true
        
//        if messagesArray[indexPath.row].messageSender != Auth.auth().currentUser?.email {
//            cell.automatedMessageSpacerView.isHidden = true
//            cell.userMessageSpacerView.isHidden = false
//            cell.messageBubble.backgroundColor = UIColor(named: Constants.userMessageBubbleColour)
//            cell.messageText.textColor = UIColor(named: "UserMessageTextColor")
//        } else {
//            cell.automatedMessageSpacerView.isHidden = false
//            cell.userMessageSpacerView.isHidden = true
//            cell.messageBubble.backgroundColor = UIColor(named: Constants.automatedMessageBubbleColour)
//            cell.messageText.textColor = UIColor(named: "AutomatedMessageTextColor")
//        }

        cell.automatedMessageProfilePicture.image = UIImage(named: "AppIcon")
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        replyTextField.endEditing(true)
        return false
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
//        if let messageSender = Auth.auth().currentUser?.email, let messageBody = replyTextField.text {
//
//            db.collection("chatTable").addDocument(data: ["messageSender": messageSender, "messageBody": messageBody, "messageTimestamp": Date().timeIntervalSince1970]) { (error) in
//                if let e = error {
//                    print("Could not save to Firestore \(e)")
//                } else {
//                    print("Saved data to Firestore")
//                }
//            }
//        }
        
        replyTextField.text = ""
        replyTextField.resignFirstResponder()
        loadMessages()
    }
}

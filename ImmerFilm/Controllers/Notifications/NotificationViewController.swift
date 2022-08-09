import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var notificationTypeLabel: UILabel!
    @IBOutlet weak var contentBodyLabel: UILabel!
    
    var contentToLaunch: String?
    var itemToLaunch: String?
    var contentBody: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contentToLaunch?.contains("message") ?? false {
            notificationIcon.image = #imageLiteral(resourceName: "Messages")
            notificationTypeLabel.text = "MESSAGES"
            senderNameLabel.text = itemToLaunch ?? "Unknown"
            if let contentBody = contentBody {
                contentBodyLabel.text = contentBody
            }
        } else if contentToLaunch?.contains("voicemail") ?? false {
            notificationIcon.image = #imageLiteral(resourceName: "Phone")
            notificationTypeLabel.text = "VOICEMAIL"
            senderNameLabel.text = itemToLaunch ?? "Unknown"
            contentBodyLabel.text = "New Voicemail received from \(itemToLaunch ?? "Unknown")"
        }  else if contentToLaunch?.contains("webbrowser") ?? false {
                   notificationIcon.image = #imageLiteral(resourceName: "IF-Logo")
                   notificationTypeLabel.text = "WEBSITE LINK"
                   senderNameLabel.text = itemToLaunch ?? "Unknown"
                   contentBodyLabel.text = "New website link received"
               }
        contentBodyLabel.lineBreakMode = .byWordWrapping
        contentBodyLabel.numberOfLines = 3

    }

    override func viewDidDisappear(_ animated: Bool) {
    }
    
    @IBAction func notificationPressed(_ sender: UIButton) {
        if let contentToLaunch = contentToLaunch, let itemToLaunch = itemToLaunch {
            let notificationManager = NotificationManager()
            notificationManager.processClickedUponNotificationFromInternalNotification(contentToLaunch: contentToLaunch, itemToLaunch: itemToLaunch)
        }
    }
}

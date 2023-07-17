import UIKit
import AVKit

class WelcomeViewController: UIViewController {
        
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // Set aspects of buttons
        guard let loginButton = loginButton, let registerButton = registerButton else { return }
        loginButton.contentHorizontalAlignment = .fill
        loginButton.contentVerticalAlignment = .fill
        loginButton.imageView?.contentMode = .scaleAspectFit
        
        registerButton.contentHorizontalAlignment = .fill
        registerButton.contentVerticalAlignment = .fill
        registerButton.imageView?.contentMode = .scaleAspectFit
    }

    @objc func displayPopUp(contentToLaunch: String, itemToLaunch: String, contentBody: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let notificationViewController = storyboard.instantiateViewController(withIdentifier: "notificationViewControllerID") as! NotificationViewController
        notificationViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        notificationViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        notificationViewController.contentToLaunch = contentToLaunch
        notificationViewController.itemToLaunch = itemToLaunch
        notificationViewController.contentBody = contentBody
        
        if let popoverPresentationController = notificationViewController.popoverPresentationController {
            
            let notificationViewControllerDelegate = NotificationPopoverPresentationControllerDelegate()
            
            popoverPresentationController.delegate = notificationViewControllerDelegate
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.permittedArrowDirections = []
            popoverPresentationController.sourceRect = CGRect(x: 1, y: 1, width: 1, height: 1)
            popoverPresentationController.popoverLayoutMargins.top = 250
            popoverPresentationController.popoverLayoutMargins.left = 20
            popoverPresentationController.popoverLayoutMargins.right = 20
            
            SoundPlayer.sharedInstance.playSound(soundFile: "Notification")
            
            UIApplication.topMostViewController?.present(notificationViewController, animated: true, completion: nil)
            
        }
    }
        
}





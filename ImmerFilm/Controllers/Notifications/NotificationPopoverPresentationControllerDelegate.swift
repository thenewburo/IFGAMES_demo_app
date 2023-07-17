import UIKit

class NotificationPopoverPresentationControllerDelegate : UIViewController, UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
            
}

import UIKit

class AlwaysPopupSegue : UIStoryboardSegue, UIPopoverPresentationControllerDelegate
{
    override init(identifier: String?, source: UIViewController, destination: UIViewController)
    {
        super.init(identifier: identifier, source: source, destination: destination)
        destination.modalPresentationStyle = UIModalPresentationStyle.popover
        destination.popoverPresentationController!.delegate = self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

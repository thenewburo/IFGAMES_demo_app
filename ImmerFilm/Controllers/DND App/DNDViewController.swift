import UIKit
import WebKit

class DNDViewController: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var DNDScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //DNDScrollView.bounces = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }

    @IBAction func homeButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let homeScreenViewControllerReference = appDelegate.homeScreenViewControllerReference
        if let homeScreenViewController = homeScreenViewControllerReference {
            homeScreenViewController.dismiss(animated: true, completion: nil)

        }
    }
}

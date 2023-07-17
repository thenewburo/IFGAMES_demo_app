import UIKit
import WebKit

class WebBrowserViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: UIView!
    
    var wKWebView: WKWebView!
    
    var selectedURL = "https://www.google.co.uk"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let myURL = URL(string: selectedURL)
       
        let myRequest = URLRequest(url: myURL!)
        
        let webConfiguration = WKWebViewConfiguration()
        wKWebView = WKWebView(frame: webView.frame, configuration: webConfiguration)
        wKWebView.uiDelegate = self
        self.webView.addSubview(wKWebView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        wKWebView.load(myRequest)
    }
    
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let homeScreenViewControllerReference = appDelegate.homeScreenViewControllerReference
        if let homeScreenViewController = homeScreenViewControllerReference {
            homeScreenViewController.dismiss(animated: true, completion: nil)
            
        }
    }
}


import UIKit
//import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorTextView: UITextView!
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.contentHorizontalAlignment = .fill
        registerButton.contentVerticalAlignment = .fill
        registerButton.imageView?.contentMode = .scaleAspectFit
        
        backButton.contentHorizontalAlignment = .fill
        backButton.contentVerticalAlignment = .fill
        backButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
//        if let email = emailTextField.text, let password = passwordTextField.text {
//            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//                if let e = error {
//                    print("Error when registering user: \(e.localizedDescription)")
//                    self.errorTextView.text = e.localizedDescription
//                } else {
                    self.performSegue(withIdentifier: Constants.registerToVideoIntroSegue, sender: self)
//                }
//            }
//        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

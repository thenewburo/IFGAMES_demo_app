import UIKit
//import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var emailtextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorTextView: UITextView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
//    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.contentHorizontalAlignment = .fill
        loginButton.contentVerticalAlignment = .fill
        loginButton.imageView?.contentMode = .scaleAspectFit
        
        backButton.contentHorizontalAlignment = .fill
        backButton.contentVerticalAlignment = .fill
        backButton.imageView?.contentMode = .scaleAspectFit
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
//        if let email = emailtextField.text, let password = passwordTextField.text {
//            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//                if let e = error {
//                    print("Error loging in \(e)")
//                    self.errorTextView.text = e.localizedDescription
//                } else {
//
//                    if let currentUserEmail = Auth.auth().currentUser?.email {
//                        self.db.collection(Constants.FireStoreData.firebaseLoginCollectionName).addDocument(data: [Constants.FireStoreData.userEmail: currentUserEmail]) { (error) in
//                            if let e = error {
//                                print("Error saving data to firestore: \(e.localizedDescription)")
//                            } else {
//                                print("Successfully logged sign in to Firestore")
//                            }
//                        }
//                    }
//
                    self.performSegue(withIdentifier: Constants.loginToVideoIntroSegue, sender: self)
//                }
//            }
//        }
        
    }
        
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

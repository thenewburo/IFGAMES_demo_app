import UIKit

class PinCodeViewController: UIViewController {
       
    var mostRecentAttempts = [0,0,0,0]
    var correctPin = [2,4,6,8]

    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneButton.subviews.first?.contentMode = .scaleAspectFit
        twoButton.subviews.first?.contentMode = .scaleAspectFit
        threeButton.subviews.first?.contentMode = .scaleAspectFit
        fourButton.subviews.first?.contentMode = .scaleAspectFit
        fiveButton.subviews.first?.contentMode = .scaleAspectFit
        sixButton.subviews.first?.contentMode = .scaleAspectFit
        sevenButton.subviews.first?.contentMode = .scaleAspectFit
        eightButton.subviews.first?.contentMode = .scaleAspectFit
        nineButton.subviews.first?.contentMode = .scaleAspectFit
        zeroButton.subviews.first?.contentMode = .scaleAspectFit
    }

    @IBAction func pinCodeButtonPressed(_ sender: UIButton) {
        print("Pin code button \(String(describing: sender.currentTitle)) pressed")
        
        let numberPressed = Int(sender.currentTitle ?? "0")
        
        mostRecentAttempts[0] = mostRecentAttempts[1]
        mostRecentAttempts[1] = mostRecentAttempts[2]
        mostRecentAttempts[2] = mostRecentAttempts[3]
        mostRecentAttempts[3] = numberPressed ?? 0
        
        if (mostRecentAttempts == correctPin) {
            print("Correct Pin Entered")
            self.performSegue(withIdentifier: "PinCodeToMediaLibrarySegue", sender: self)
        } else {
            print("Tested entry of: \(mostRecentAttempts)")
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.returnToHomeScreen()
    }
}
    

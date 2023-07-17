import UIKit
import AVKit

class MusicMasterViewController: UIViewController {
        
    var playerState = "Detail"
    
    var musicPlayer: AVAudioPlayer?
    
    @IBOutlet weak var musicImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMusicPlayer()
    }
    
    func loadMusicPlayer() {
        let path = Bundle.main.path(forResource: "FurElise", ofType: "mp3")
         if let audioFilePath = path {
             do {
             let url = URL(fileURLWithPath: audioFilePath)
             musicPlayer = try AVAudioPlayer(contentsOf: url)
             } catch {
                 print("Error loading voicemail audio file \(error)")
             }
         }
    }
    
    @IBAction func musicOverlayButtonPressed(_ sender: Any) {
        if playerState == "Detail" {
            musicImageView.image = UIImage(named: "MusicPaused")
            playerState = "MusicPaused"
        } else if playerState == "MusicPaused" {
            musicPlayer?.play()
            musicImageView.image = UIImage(named: "MusicPlaying")
            playerState = "MusicPlaying"
        } else if playerState == "MusicPlaying" {
            musicPlayer?.pause()
            musicImageView.image = UIImage(named: "MusicPaused")
            playerState = "MusicPaused"
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.returnToHomeScreen()
    }
}

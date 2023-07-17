import UIKit
import RealmSwift
import AVKit

class RealityClashViewController: UIViewController {
    
    var videoPlayer: AVPlayer?
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayback()
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.returnToHomeScreen()
    }
    
    
    func setupVideoPlayback() {
        let path = Bundle.main.path(forResource: "Reality1", ofType: "mov")
        if let path = path {
            videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
            videoPlayerLayer.frame = self.videoView.bounds
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem, queue: nil) { (_) in
            }
            self.videoView.layer.addSublayer(videoPlayerLayer)
            videoPlayer?.play()
            
        }
    }
    
}

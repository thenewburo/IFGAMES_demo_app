import UIKit
import AVKit

class VideoIntroViewController: UIViewController {
    
    
    @IBOutlet weak var videoView: UIView!
    var videoPlayer: AVPlayer?
    
    
    @IBAction func panDetected(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            
            if (gestureRecognizer.view!.center.x < 30) {
                gestureRecognizer.view!.center = CGPoint(x: 30, y: gestureRecognizer.view!.center.y)
            } else if (gestureRecognizer.view!.center.x > 280) {
                gestureRecognizer.view!.center = CGPoint(x: 280, y: gestureRecognizer.view!.center.y)
                self.performSegue(withIdentifier: Constants.videoIntroToHomeScreenSegue, sender: self)
            } else if (gestureRecognizer.view!.center.x < 270) {
              gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
                
            } else {
                SoundPlayer.sharedInstance.playSound(soundFile: "Unlock")
                self.performSegue(withIdentifier: Constants.videoIntroToHomeScreenSegue, sender: self)
            }
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayback()
        SoundPlayer.sharedInstance.playSound(soundFile: "GlitchStatic")
    }
    
    func setupVideoPlayback() {
        let path = Bundle.main.path(forResource: "GlitchNoFade", ofType: "mp4")
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

import UIKit
import AVKit

class VideoViewController: AVPlayerViewController {
    
    var selectedMediaItem : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
    }
    
    func playVideo() {
        if let videoFilename = selectedMediaItem {
            print("Selected video filename: \(videoFilename)")
            guard let path = Bundle.main.path(forResource: videoFilename, ofType: "mp4") else {
                print("Video not found")
                return
            }
            let videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
            self.player = videoPlayer
            self.player?.play()
        }
    }
    
}

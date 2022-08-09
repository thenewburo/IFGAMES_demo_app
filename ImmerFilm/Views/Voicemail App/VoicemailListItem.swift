import UIKit
import AVKit

class VoicemailListItem: UITableViewCell {
    
    @IBOutlet weak var callerName: UILabel!
    @IBOutlet weak var audioProgressIndicator: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var callerProfilePicture: UIImageView!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    var timer: Timer?
    
    var voicemailPlayer: AVAudioPlayer?
    
    var audioName : String? {
        didSet{
            
            let path = Bundle.main.path(forResource: audioName, ofType: "mp3")
            if let audioFilePath = path {
                do {
                let url = URL(fileURLWithPath: audioFilePath)
                voicemailPlayer = try AVAudioPlayer(contentsOf: url)
                    let (minutes, seconds) = secondsToMinutesSeconds(seconds: Int(voicemailPlayer?.duration ?? 0))
                    remainingTime.text = "-\(minutes):\(seconds)"
                } catch {
                    print("Error loading voicemail audio file \(error)")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.callerProfilePicture.layer.cornerRadius = 25
        self.callerProfilePicture.layer.masksToBounds = true
        
        cellBackgroundView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0))
    }

    func stop() {
        voicemailPlayer?.stop()
        voicemailPlayer?.currentTime = 0
        updateSlider()
        timer?.invalidate()
    }
    
    func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
      return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func updateSlider() {
        audioProgressIndicator.value = (Float)((voicemailPlayer?.currentTime ?? 1)/(voicemailPlayer?.duration ?? 1))
        var (minutes, seconds) = secondsToMinutesSeconds(seconds: Int((voicemailPlayer?.duration ?? 0) - (voicemailPlayer?.currentTime ?? 0)))
        remainingTime.text = "-\(minutes):\(seconds)"
        (minutes, seconds) = secondsToMinutesSeconds(seconds: Int(voicemailPlayer?.currentTime ?? 0))
        currentTime.text = "\(minutes):\(seconds)"
    }
    
    @IBAction func play(_ sender: UIButton) {
        if voicemailPlayer?.isPlaying ?? true {
        voicemailPlayer?.stop()
            timer?.invalidate()
            playPauseButton.isSelected = false
        } else {
        voicemailPlayer?.play()
        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        playPauseButton.isSelected = true
        }
    }

    @IBAction func pause(_ sender: UIButton) {
        voicemailPlayer?.pause()
        timer?.invalidate()
    }
    
    @IBAction func stop(_ sender: UIButton) {
        
        voicemailPlayer?.currentTime = 0
        updateSlider()
        
    }
    
    @IBAction func audioProgressSlider(_ sender: UISlider) {
        if let fileDuration = voicemailPlayer?.duration {
            voicemailPlayer?.stop()
            voicemailPlayer?.currentTime = fileDuration * Double(sender.value)
        }
    }
}

import AVFoundation

class SoundPlayer {
    
    class var sharedInstance : SoundPlayer {
        struct Static {
            static let instance : SoundPlayer = SoundPlayer()
        }
        return Static.instance
    }
    
    var musicPlayer: AVAudioPlayer?
    
    init() {

    }
    
    func playSound(soundFile: String) {
        
        let path = Bundle.main.path(forResource: soundFile, ofType: "mp3")
        if let audioFilePath = path {
            do {
                let url = URL(fileURLWithPath: audioFilePath)
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer?.play()
            } catch {
                print("Error loading voicemail audio file \(error)")
            }
        }
        
    }
}

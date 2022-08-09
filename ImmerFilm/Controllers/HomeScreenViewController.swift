import UIKit
import RealmSwift
import AVKit

class HomeScreenViewController: UIViewController {
    
    
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.homeScreenViewControllerReference = self
        
    }
    
    @IBAction func launchGoogleMapsPressed(_ sender: Any) {
        openWebBrower(url: "https://www.google.com/maps/dir/Flatiron+Building,+175+5th+Ave,+New+York,+NY+10010,+United+States/The+Cathedral+Church+of+St.+John+the+Divine/@40.7992182,-73.9612226,14z/data=!4m14!4m13!1m5!1m1!1s0x89c259a3f71c1f67:0xde2a6125ed704926!2m2!1d-73.9896986!2d40.7410605!1m5!1m1!1s0x0:0xc4a30e125ef40bff!2m2!1d-73.9618754!2d40.8038356!3e0")
    }
    
    @IBAction func launchInstagramPressed(_ sender: Any) {
        openWebBrower(url: "https://www.instagram.com/drmorbiusInsta/?hl=en")
    }
    
    @IBAction func launcImmerfilmPressed(_ sender: Any) {
        openWebBrower(url: "https://www.ifgamesco.com")
    }
    
    func openWebBrower(url: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webBrowserViewController = storyboard.instantiateViewController(withIdentifier: "webBrowserViewControllerID") as! WebBrowserViewController
        webBrowserViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        webBrowserViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        webBrowserViewController.selectedURL = url
        present(webBrowserViewController, animated: true, completion: nil)
    }
    

    @IBAction func triggerFireEffect(_ sender: UIButton) {
        setupVideoPlayback()
    }
    
    @IBAction func reloadRealmDB(_ sender: Any) {
        print("Reload Realm files")
        let importJSONToRealm = ImportJSONToRealm()
        importJSONToRealm.loadDataFromJSON()
        
        var virtualCharacterManager = VirtualCharacterManager()
        let realm = try! Realm()
        
        let characterName = "Martine"
        let predicate = NSPredicate(format: "characterName == %@", characterName)
        let specifiedVirtualCharacter : Results<VirtualCharacter> = realm.objects(VirtualCharacter.self).filter(predicate)
        if specifiedVirtualCharacter.count > 0 {
            let selectedVirtualCharacter = specifiedVirtualCharacter[0]
            virtualCharacterManager.selectedVirtualCharacter = selectedVirtualCharacter
            virtualCharacterManager.requestVirtualCharacterResponse()
        }
    }
    
    @IBAction func deleteRealmFiles(_ sender: Any) {
        print("Deleting Realm files")
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management"),
        ]
        for URL in realmURLs {
            try? FileManager.default.removeItem(at: URL)
        }
    }
    
       func setupVideoPlayback() {
            let path = Bundle.main.url(forResource: "Flame", withExtension: "mp4")
            if let path = path {
                let playerItem = AVPlayerItem(url: path)
                let videoPlayer = AVPlayer(playerItem: playerItem)
                let videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
                videoPlayerLayer.pixelBufferAttributes = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
                videoPlayerLayer.bounds = videoView.bounds
                videoPlayerLayer.position = videoView.center
                videoView.layer.addSublayer(videoPlayerLayer)
                playerItem.videoComposition = createVideoComposition(for: playerItem)
                videoPlayer.play()
            }
    
    }
    
    func createVideoComposition(for playerItem: AVPlayerItem) -> AVVideoComposition {
      let videoSize = CGSize(width: 1280, height: 720)
      let composition = AVMutableVideoComposition(asset: playerItem.asset, applyingCIFiltersWithHandler: { request in
        let filter = AlphaFrameFilter()
        filter.inputImage = request.sourceImage
        filter.maskImage = request.sourceImage 
        return request.finish(with: filter.outputImage!, context: nil)
      })

      composition.renderSize = videoSize
      return composition
    }
    
 
}
    


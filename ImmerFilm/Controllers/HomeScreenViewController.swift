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
        openWebBrower(url: "https://www.google.com/maps/search/bermudes+island/@32.3755011,-64.6610619,477m/data=!3m1!1e3")
    }
    
    @IBAction func launchInstagramPressed(_ sender: Any) {
        openWebBrower(url: "https://www.instagram.com/joemanganiello/?hl=en")
    }
    
    
    @IBAction func launcImmerfilmPressed(_ sender: Any) {
        openWebBrower(url: "https://death-saves.com/")
    }
    

    @IBAction func launchDeathSaves(_ sender: Any) {
        openWebBrower(url: "https://death-saves.com/collections/new-for-black-friday-2020-temporary/products/d-d-dragon-126-hoodie")
        
    }
    
    func openWebBrower(url: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webBrowserViewController = storyboard.instantiateViewController(withIdentifier: "webBrowserViewControllerID") as! WebBrowserViewController
        webBrowserViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        webBrowserViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        webBrowserViewController.selectedURL = url
        present(webBrowserViewController, animated: false, completion: nil)
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
    


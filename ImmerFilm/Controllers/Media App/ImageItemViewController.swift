import UIKit

class ImageItemViewController: UIViewController {
    

    @IBOutlet weak var mediaLibraryImage: UIImageView!
    
    var selectedMediaItem : String?
    var selectedMediaItemUIImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedMediaItemName = selectedMediaItem {
            mediaLibraryImage.image = UIImage(named: selectedMediaItemName)
        } else if let unwrappedSelectedMediaItemUIImage = selectedMediaItemUIImage {
            mediaLibraryImage.image = unwrappedSelectedMediaItemUIImage
        }
    }
    
    @IBAction func closeMediaItemView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
    

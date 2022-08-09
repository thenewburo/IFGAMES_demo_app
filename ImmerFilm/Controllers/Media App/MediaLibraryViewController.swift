import UIKit

class MediaLibraryViewController: UIViewController {
    
    @IBOutlet weak var mediaLibraryCollectionView: UICollectionView!
    
    let mediaLibraryManager = MediaLibraryManager()
    
    var selectedMediaItem: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaLibraryCollectionView.delegate = self
        mediaLibraryCollectionView.dataSource = self
    }
    
    
    func displaySpecificImageItem(selectedMediaItemName: String) {
        selectedMediaItem = selectedMediaItemName
        self.performSegue(withIdentifier: Constants.imageItemSegue, sender: self)
    }
    
    func displaySpecificVideoItem(selectedMediaItemName: String) {
        selectedMediaItem = selectedMediaItemName
        self.performSegue(withIdentifier: Constants.videoViewSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.imageItemSegue {
            let destinationViewController = segue.destination as! ImageItemViewController
            destinationViewController.selectedMediaItem = selectedMediaItem
        } else if segue.identifier == Constants.videoViewSegue {
            let destinationViewController = segue.destination as! VideoViewController
            destinationViewController.selectedMediaItem = selectedMediaItem
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = mediaLibraryCollectionView.cellForItem(at: indexPath)
        selectedCell?.layer.borderColor = UIColor.lightGray.cgColor
        selectedCell?.layer.borderWidth = 1
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.returnToHomeScreen()
    }
}


extension MediaLibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaLibraryManager.getVisibleMediaItems().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mediaLibraryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaLibraryCell", for: indexPath) as! MediaLibraryCell
        mediaLibraryCell.mediaLibraryImage.image = UIImage(named: mediaLibraryManager.getVisibleMediaItems()[indexPath.item].mediaName)
        mediaLibraryCell.layer.borderColor = UIColor.lightGray.cgColor
        mediaLibraryCell.layer.borderWidth = 1
        return mediaLibraryCell
    }
}

extension MediaLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = mediaLibraryCollectionView.cellForItem(at: indexPath)
        selectedCell?.layer.borderColor = UIColor.gray.cgColor
        selectedCell?.layer.borderWidth = 2
        
        if mediaLibraryManager.getVisibleMediaItems()[indexPath.item].mediaType == "Image" {
            
            if let indexPath = mediaLibraryCollectionView.indexPathsForSelectedItems {
                selectedMediaItem = mediaLibraryManager.getVisibleMediaItems()[indexPath[0].row].mediaName
                self.performSegue(withIdentifier: Constants.imageItemSegue, sender: self)
            }
            
        } else if mediaLibraryManager.getVisibleMediaItems()[indexPath.item].mediaType == "Video" {
            if let indexPath = mediaLibraryCollectionView.indexPathsForSelectedItems {
                selectedMediaItem = mediaLibraryManager.getVisibleMediaItems()[indexPath[0].row].mediaName
                self.performSegue(withIdentifier: Constants.videoViewSegue, sender: self)
            }
        }
    }
}
    
    
    extension MediaLibraryViewController : UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return (CGSize(width: (self.mediaLibraryCollectionView.frame.size.width-20)/3, height: (self.mediaLibraryCollectionView.frame.size.width-20)/3))
        }
}

import UIKit

class MessageItem: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageTimestamp: UILabel!
    
    @IBOutlet weak var userMessageSpacerView: UIView!
    @IBOutlet weak var userMessageProfilePicture: UIImageView!
    
    @IBOutlet weak var automatedMessageSpacerView: UIView!
    @IBOutlet weak var automatedMessageProfilePicture: UIImageView!
        
    @IBOutlet weak var virtualCharacterReplyingAnimationView: VirtualCharacterReplyingAnimation!
    
    @IBOutlet weak var virtualCharacterReplyingAnimationViewHeight: NSLayoutConstraint!
    
    
    var messageImageName: String = ""
    var selectedMediaType: String = ""
    
    internal var aspectConstraint : NSLayoutConstraint? {
           didSet {
               if oldValue != nil {
                   messageImage.removeConstraint(oldValue!)
               }
               if aspectConstraint != nil {
                   messageImage.addConstraint(aspectConstraint!)
               }
           }
       }

       override func prepareForReuse() {
           super.prepareForReuse()
           aspectConstraint = nil
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = 10
        userMessageProfilePicture.layer.cornerRadius = 20
        automatedMessageProfilePicture.layer.cornerRadius = 20
        
        userMessageProfilePicture.layer.shadowColor = UIColor(named: Constants.messageShadowColour)?.cgColor
        userMessageProfilePicture.layer.shadowOpacity = 1.0
        userMessageProfilePicture.layer.shadowRadius = 5
        userMessageProfilePicture.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        userMessageProfilePicture.layer.masksToBounds = true
        userMessageProfilePicture.layer.borderWidth = 2
        userMessageProfilePicture.layer.borderColor = UIColor(named: "ProfilePictureBorderColor")?.cgColor
        
        automatedMessageProfilePicture.layer.shadowColor = UIColor(named: Constants.messageShadowColour)?.cgColor
        automatedMessageProfilePicture.layer.shadowOpacity = 1.0
        automatedMessageProfilePicture.layer.shadowRadius = 5
        automatedMessageProfilePicture.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        automatedMessageProfilePicture.layer.masksToBounds = true
        automatedMessageProfilePicture.layer.borderWidth = 2
        automatedMessageProfilePicture.layer.borderColor = UIColor(named: "ProfilePictureBorderColor")?.cgColor

    }
    
    func addImageViewCell (imageName: String, mediaType: String) {
        messageImage.layer.cornerRadius = 10
        selectedMediaType = mediaType
                
        messageImage.image = UIImage(named: imageName)
        messageImageName = imageName
        
        if let validImage = messageImage.image, let validMessageImage = messageImage {
            let imageAspectRatio = validImage.size.width/validImage.size.height
            let constraint = NSLayoutConstraint(item: validMessageImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: validMessageImage, attribute: NSLayoutConstraint.Attribute.height, multiplier: imageAspectRatio, constant: 0.0)
            constraint.priority = UILayoutPriority(rawValue: 999)
            aspectConstraint = constraint
        }
    }

    func clearImageViewCell() {
        messageImage.image = nil
    }
    
    @IBAction func cellPressed(_ sender: UIButton) {
        if let selectedImage = messageImage.image {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if selectedMediaType == "Image" {
                let imageItemViewController = storyboard.instantiateViewController(withIdentifier: "imageItemViewControllerID") as! ImageItemViewController
                imageItemViewController.modalPresentationStyle = UIModalPresentationStyle.popover
                imageItemViewController.selectedMediaItemUIImage = selectedImage
                UIApplication.topMostViewController?.present(imageItemViewController, animated: true, completion: nil)
            } else if selectedMediaType == "Video" {
                let videoViewController = storyboard.instantiateViewController(withIdentifier: "videoViewControllerID") as! VideoViewController
                videoViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                videoViewController.selectedMediaItem = messageImageName
                UIApplication.topMostViewController?.present(videoViewController, animated: true, completion: nil)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showVirtualCharacterTypingReplyDots() {
        virtualCharacterReplyingAnimationViewHeight.constant = 30
        virtualCharacterReplyingAnimationView.isHidden = false
    }
    
    func hideVirtualCharacterTypingReplyDots() {
        virtualCharacterReplyingAnimationViewHeight.constant = 10
        virtualCharacterReplyingAnimationView.isHidden = true
    }
}

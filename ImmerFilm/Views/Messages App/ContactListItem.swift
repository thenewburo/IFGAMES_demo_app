import UIKit

class ContactListItem: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 10,y: 5,width: 50,height: 50)
        self.imageView?.layer.cornerRadius = 25
        self.imageView?.layer.masksToBounds = true;
        self.textLabel?.frame = CGRect(x: 80, y: 20, width: self.frame.width - 150, height: 20)
        self.detailTextLabel?.text = ""
        self.backgroundColor = UIColor.clear
        
        self.textLabel?.textColor = .white
    }
}


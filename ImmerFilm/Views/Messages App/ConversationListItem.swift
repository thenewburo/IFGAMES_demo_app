import UIKit

class ConversationListItem: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        
        self.contentView.backgroundColor = UIColor(named: "ConversationListItemBackgroundColor")
        self.contentView.layer.cornerRadius = 10
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 10,y: 10,width:45 ,height: 45)
        self.imageView?.layer.cornerRadius = 25
        self.imageView?.layer.masksToBounds = true;
        self.textLabel?.frame = CGRect(x: 80, y: 10, width: self.frame.width - 150, height: 20)
        self.detailTextLabel?.frame = CGRect(x: 80, y: 35, width: self.frame.width - 150, height: 15)
        self.backgroundColor = UIColor.clear
        
        self.textLabel?.textColor = .white
        self.detailTextLabel?.textColor = .white
        
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10))
        
    }
}


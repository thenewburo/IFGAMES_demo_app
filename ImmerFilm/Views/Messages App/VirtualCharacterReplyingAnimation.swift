import UIKit

class VirtualCharacterReplyingAnimation: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ball1: UIImageView!
    @IBOutlet weak var ball2: UIImageView!
    @IBOutlet weak var ball3: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    var animationTimer: Timer?
    

    override init(frame: CGRect) {
    super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("VirtualCharacterReplyingAnimation", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.layer.cornerRadius = 10
        animationTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(runAnimation), userInfo: nil, repeats: true)
    }
    
    @objc func runAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.ball3.alpha = 1
            self.ball1.alpha = 0.3
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
            self.ball2.alpha = 1
            self.ball3.alpha = 0.3
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                self.ball1.alpha = 1
                self.ball2.alpha = 0.3
                })})})}
    
}

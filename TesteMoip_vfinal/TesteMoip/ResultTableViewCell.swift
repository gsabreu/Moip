import UIKit

class ResultTableViewCell: UITableViewCell {
    
    var order:Orders?

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var ownIdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var valorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var methoImg: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        valorLabel.textColor = UIColor.blueColor()
        emailLabel.textColor = UIColor.darkGrayColor()
        ownIdLabel.textColor = UIColor.lightGrayColor()
        dateLabel.textColor = UIColor.darkGrayColor() 
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

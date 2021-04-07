//
//  LeaguesCell.swift
//  Sports App
//
//  Created by Ahmed Badry on 3/21/21.
//

import UIKit

class LeaguesCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var labelCell: UILabel!
    
    var arrayTest = [LeaguesDettailsModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

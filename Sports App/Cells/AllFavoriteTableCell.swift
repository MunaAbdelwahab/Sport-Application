//
//  AllFavoriteTableCell.swift
//  Sports App
//
//  Created by Muna Abdelwahab on 3/28/21.
//

import UIKit

class AllFavoriteTableCell: UITableViewCell {

    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var leagueImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

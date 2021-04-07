//
//  TeamDetails.swift
//  Sports App
//
//  Created by Ahmed Badry on 3/27/21.
//

import UIKit
import SDWebImage
class TeamDetails: UIViewController {

    @IBOutlet weak var stadiumImage: UIImageView!
    @IBOutlet weak var teamImg: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var leagueName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var foundedLabel: UILabel!
    @IBOutlet weak var stadiumName: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var arrayOfAllTeams = [Teams]()
    var indexy :Int?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        stadiumImage.sd_setImage(with: URL (string: arrayOfAllTeams[indexy!].strStadiumThumb!), placeholderImage:UIImage(named: "placeholder.png"))
        teamImg.sd_setImage(with: URL (string: arrayOfAllTeams[indexy!].strTeamBadge!), placeholderImage:UIImage(named: "placeholder.png"))
        teamName.text = arrayOfAllTeams[indexy!].strTeam
        leagueName.text = arrayOfAllTeams[indexy!].strLeague
        countryName.text = arrayOfAllTeams[indexy!].strCountry
        foundedLabel.text = arrayOfAllTeams[indexy!].intFormedYear
        stadiumName.text = arrayOfAllTeams[indexy!].strStadium
        descLabel.text = arrayOfAllTeams[indexy!].strDescriptionEN
    }
}

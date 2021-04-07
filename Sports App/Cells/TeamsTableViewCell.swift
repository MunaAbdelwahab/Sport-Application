//
//  TeamsTableViewCell.swift
//  Sports App
//
//  Created by Ahmed Badry on 3/25/21.
//

import UIKit
import SDWebImage

class TeamsTableViewCell: UITableViewCell {

    @IBOutlet weak var myCollection: UICollectionView!
    
    var allTeamsUrl = "https://www.thesportsdb.com/api/v1/json/1/lookup_all_teams.php?id="
    var arrayOfAllTeams = [Teams]()
    var leagueId : String? {
        didSet {
            ApiServices.instance.getDataFromApi(url: self.allTeamsUrl + leagueId!) { [self] (data: Json4SwiftT?, error) in
                if let error = error{
                    print(error)
                }else{
                    guard data != nil else { return}
                    arrayOfAllTeams = (data?.teams)!
                }
                DispatchQueue.main.async {
                    myCollection.reloadData()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myCollection.dataSource = self
        myCollection.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
extension TeamsTableViewCell: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAllTeams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamsCollectionViewCell", for: indexPath) as! TeamsCollectionViewCell
        cell.teamsImage.sd_setImage(with: URL (string: arrayOfAllTeams[indexPath.row].strTeamBadge!))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeamDetails") as! TeamDetails
        let currentController = self.getCurrentViewController()
        vc.arrayOfAllTeams = arrayOfAllTeams
        vc.indexy = indexPath.row
        currentController?.present(vc, animated: false, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
}

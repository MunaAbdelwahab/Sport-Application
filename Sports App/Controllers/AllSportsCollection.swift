//
//  AllSportsCollection.swift
//  Sports App
//
//  Created by Ahmed Badry on 3/20/21.
//

import UIKit
import SDWebImage

class AllSportsCollection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionGrid: UICollectionView!
    
    //all sports
    var sportsUrl = "https://www.thesportsdb.com/api/v1/json/1/all_sports.php"
    var arrayOfAllSports = [SportsModel]()
    
    // all leagues
    var leaguesUrl = "https://www.thesportsdb.com/api/v1/json/1/all_leagues.php"
    var arrayOfAllLeagues = [LeaguesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiServices.instance.getDataFromApi(url: self.sportsUrl) { [self] (data: Json4SwiftS?, error) in
            if let error = error{
                print(error)
            }else{
                guard data != nil else { return}
                arrayOfAllSports =  (data?.sports)!
                DispatchQueue.main.async {
                    self.collectionGrid.reloadData()
                }
            }
        }
        
        ApiServices.instance.getDataFromApi(url: self.leaguesUrl) { [self] (data: Json4SwiftL?, error) in
            if let error = error{
                print(error)
            }else{
                guard data != nil else { return}
                arrayOfAllLeagues =  (data?.leagues)!
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAllSports.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionGrid.dequeueReusableCell(withReuseIdentifier: "AllSportsCollectionCell", for: indexPath) as! AllSportsCollectionCell
        cell.labelCell.text = arrayOfAllSports[indexPath.row].strSport
        cell.imgCell.sd_setImage(with: URL (string: arrayOfAllSports[indexPath.row].strSportThumb!), placeholderImage:UIImage(named: "placeholder.png"))
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let leagues = self.storyboard?.instantiateViewController(identifier: "LeaguesViewController") as! LeaguesViewController
        var arrayOfSelected = [LeaguesModel]()
        
        for i in 0 ..< arrayOfAllLeagues.count {
            if arrayOfAllSports[indexPath.row].strSport == arrayOfAllLeagues[i].strSport {
               arrayOfSelected.append(arrayOfAllLeagues[i])
            }
        }
        leagues.arrayOfLeagues = arrayOfSelected
        self.navigationController?.pushViewController(leagues, animated: true)
    }
}

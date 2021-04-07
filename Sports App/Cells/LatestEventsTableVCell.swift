//
//  LatestEventsTableVCell.swift
//  Sports App
//
//  Created by Ahmed Badry on 3/25/21.
//

import UIKit

class LatestEventsTableVCell: UITableViewCell {

    @IBOutlet weak var myCollection: UICollectionView!
    
    var teamsUrl = "https://www.thesportsdb.com/api/v1/json/1/lookupteam.php?id="
    let dispatchGroup = DispatchGroup()
    var arrayOfIDSTeam1 = [String]()
    var arrayOfIDSTeam2 = [String]()
    var arrayOfURLS1 = [String]()
    var arrayOfURLS2 = [String]()
    var arrayOfAllTeam1 = [Teams]()
    var arrayOfAllTeam2 = [Teams]()
    
    var arrayOfAllEvents = [Events]() {
        didSet {
            for i in 0..<arrayOfAllEvents.count {
                arrayOfURLS1.append(teamsUrl)
                arrayOfURLS2.append(teamsUrl)
                if arrayOfAllEvents[i].idHomeTeam != nil && arrayOfAllEvents[i].idAwayTeam != nil {
                    arrayOfURLS1[i].append(arrayOfAllEvents[i].idHomeTeam!)
                    arrayOfURLS2[i].append(arrayOfAllEvents[i].idAwayTeam!)
                }
            }
            
            for i in 0..<arrayOfAllEvents.count {
                ApiServices.instance.getDataFromApi(url: self.arrayOfURLS1[i]) { [self] (data: Json4SwiftT?, error) in
                    if let error = error{
                        print(error)
                    }else{
                        guard data != nil else { return}
                        arrayOfAllTeam1.append(contentsOf: (data?.teams)!)
                    }
                }
            }
            
            for i in 0..<arrayOfAllEvents.count {
                dispatchGroup.enter()
                ApiServices.instance.getDataFromApi(url: self.arrayOfURLS2[i]) { [self] (data: Json4SwiftT?, error) in
                    if let error = error{
                        print(error)
                    }else{
                        guard data != nil else { return}
                        arrayOfAllTeam2.append(contentsOf: (data?.teams)!)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) { [self] in
                myCollection.reloadData()
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
extension LatestEventsTableVCell :UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAllEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsCollectionViewCell", for: indexPath) as! LatestEventsCollectionViewCell
        cell.date.text = arrayOfAllEvents[indexPath.row].dateEvent
        cell.time.text = arrayOfAllEvents[indexPath.row].strTime
        cell.team1Name.text = arrayOfAllEvents[indexPath.row].strHomeTeam
        cell.team2Name.text = arrayOfAllEvents[indexPath.row].strAwayTeam
        for i in 0..<arrayOfAllTeam1.count {
            
            if arrayOfAllEvents[indexPath.row].strHomeTeam == arrayOfAllTeam1[i].strTeam {
                if arrayOfAllTeam1[i].strTeamBadge != nil {
                    cell.team1Image.sd_setImage(with: URL (string: arrayOfAllTeam1[i].strTeamBadge!))
                }
            }
            
            if arrayOfAllEvents[indexPath.row].strAwayTeam == arrayOfAllTeam2[i].strTeam {
                if arrayOfAllTeam2[i].strTeamBadge != nil {
                    cell.team2Image.sd_setImage(with: URL (string: arrayOfAllTeam2[i].strTeamBadge!))
                }
            }
        }
        cell.team2Res.text = arrayOfAllEvents[indexPath.row].intAwayScore
        cell.team1Res.text = arrayOfAllEvents[indexPath.row].intHomeScore
        return cell
    }    
}

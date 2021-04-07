//
//  LeaguesViewController.swift
//  Sports App
//
//  Created by Ahmed Badry on 3/21/21.
//https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id=4328

import UIKit
import SDWebImage

class LeaguesViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate  {
    
    @IBOutlet weak var leaguesTableView: UITableView!
    
    var arrayOfLeagues = [LeaguesModel]()
    let fixedUrl = "https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id="
    var arrayOfURLS = [String]()
    var arrayOfSelected = [LeaguesDettailsModel]()
    var arrayOfDetails = [LeaguesDettailsModel]()
    var arrayOfUrlImages = [String]()
    var arrayOfUrlYoutube = [String]()
    var arrayOfLeaguesName = [String]()
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Leagues"
        
        for i in 0..<arrayOfLeagues.count {
            arrayOfURLS.append(fixedUrl)
            arrayOfURLS[i].append(arrayOfLeagues[i].idLeague!)
        }
        
        reloadTableData()
        dispatchGroup.notify(queue: .main) { [self] in
            sortData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:LeaguesCell = tableView.dequeueReusableCell(withIdentifier: "LeaguesCell",for:indexPath) as! LeaguesCell
        
        if  arrayOfDetails [indexPath.row].strBadge != nil{
            cell.imageCell.sd_setImage(with: URL (string: arrayOfDetails [indexPath.row].strBadge!), placeholderImage:UIImage(named: "placeholder.png"))
        }
        
        cell.labelCell.text =  arrayOfDetails[indexPath.row].strLeague
        cell.imageCell.layer.borderWidth = 1.0
        cell.imageCell.layer.masksToBounds = false
        cell.imageCell.layer.borderColor = UIColor.blue.cgColor
        cell.imageCell.layer.cornerRadius = cell.imageCell.frame.size.width / 2
        cell.imageCell.clipsToBounds = true

        if (arrayOfDetails[indexPath.row].strYoutube!.isEmpty) {
            cell.button.setImage(UIImage(named: "notfound.png"), for: .normal)
            cell.button.isEnabled = false
       
        } else {
            cell.button.setImage(UIImage(named: "youtube.png"), for: .normal)
            cell.button.isEnabled = true
            cell.button.tag = indexPath.row
            cell.button.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leaguesDetailsVC = storyboard?.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as! LeaguesDetailsViewController
        leaguesDetailsVC.leagueId = arrayOfDetails[indexPath.row].idLeague!
        leaguesDetailsVC.leagueStr = arrayOfDetails[indexPath.row].strLeague!
        leaguesDetailsVC.leagueBadge = arrayOfDetails[indexPath.row].strBadge!
        leaguesDetailsVC.leagueYoutub = arrayOfDetails[indexPath.row].strYoutube!
        self.present(leaguesDetailsVC, animated: true, completion: nil)
    }
    
    @objc func connected(sender: UIButton) {
        let buttonTag = sender.tag
        let videosVC = storyboard?.instantiateViewController(withIdentifier: "LeagueVideosViewController") as! LeagueVideosViewController
        let stringURL = arrayOfDetails[buttonTag].strYoutube
        videosVC.channelURL = "https://" + stringURL!
        self.present(videosVC, animated: true, completion: nil)
    }
    
    fileprivate func reloadTableData() {
        for i in 0..<arrayOfLeagues.count {
            dispatchGroup.enter()
            ApiServices.instance.getDataFromApi(url: self.arrayOfURLS[i]) { [self] (data: Json4SwiftD?, error) in
                if let error = error{
                    print(error)
                }else{
                    guard data != nil else { return}
                    arrayOfDetails.append(contentsOf: (data?.leagues)!)
                }
                dispatchGroup.leave()
            }
        }
    }
    
    func sortData() {
        arrayOfDetails.sort(by: {(id1, id2) -> Bool in
            if let idleague1 = id1.idLeague, let idleague2 = id2.idLeague {
                return idleague1 < idleague2
            }
            return false
        })
        self.leaguesTableView.reloadData()
    }
}

//
//  AllFavoriteTableViewController.swift
//  Sports App
//
//  Created by Ahmed Badry on 3/27/21.
//

import UIKit
import CoreData
import Network
import SDWebImage
import Reachability
import Alamofire

class AllFavoriteTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfURLS = [String]()
    let dispatchGroup = DispatchGroup()
    let fixedUrl = "https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id="
    var leagueID : String?
    let reachability = try! Reachability()
    var isReachability: Bool?
    var arrayOfIDS = [IDS]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkInternet() -> Bool{
            return NetworkReachabilityManager()?.isReachable ?? false
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCoreData()
        sortData()
        
        if checkInternet() {
            isReachability = true
        } else {
            print("No internet")
            isReachability = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        arrayOfIDS.removeAll()
    }
}

extension AllFavoriteTableViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfIDS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllFavoriteTableCell", for: indexPath) as! AllFavoriteTableCell
        cell.leagueName.text = arrayOfIDS[indexPath.row].strLeagues
        cell.leagueImage.sd_setImage(with: URL (string: arrayOfIDS[indexPath.row].badgeLeagues!))
        if (arrayOfIDS[indexPath.row].youtubLeagues!.isEmpty) {
            cell.videoButton.setImage(UIImage(named: "notfound.png"), for: .normal)
            cell.videoButton.isEnabled = false
       
        } else {
            cell.videoButton.setImage(UIImage(named: "youtube.png"), for: .normal)
            cell.videoButton.isEnabled = true
            cell.videoButton.tag = indexPath.row
            cell.videoButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leaguesDetailsVC = storyboard?.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as! LeaguesDetailsViewController
        if isReachability == false {
            let alert = UIAlertController(title: "Warning", message: "There's no internet connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            leaguesDetailsVC.leagueId = arrayOfIDS[indexPath.row].idLeagues!
        }
        self.present(leaguesDetailsVC, animated: true, completion: nil)
    }
    
    @objc func connected(sender: UIButton) {
        let buttonTag = sender.tag
        let videosVC = storyboard?.instantiateViewController(withIdentifier: "LeagueVideosViewController") as! LeagueVideosViewController
        let stringURL = arrayOfIDS[buttonTag].youtubLeagues
        videosVC.channelURL = "https://" + stringURL!
        self.present(videosVC, animated: true, completion: nil)
    }
    
    func sortData() {
        arrayOfIDS.sort(by: {(id1, id2) -> Bool in
            if let idleague1 = id1.idLeagues, let idleague2 = id2.idLeagues {
                return idleague1 < idleague2
            }
            return false
        })
        self.tableView.reloadData()
    }
    
    func getCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IDS")
        do {
            arrayOfIDS = try (managedContext.fetch(fetchRequest) as? [IDS])!
        } catch let error as NSError {
            print(error)
        }
    }
}

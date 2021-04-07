//
//  LeaguesDetailsViewController.swift
//  Sports App
//
//  Created by Muna Abdelwahab on 3/23/21.
//

import UIKit
import  CoreData

class LeaguesDetailsViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var leagueId : String = ""
    var leagueStr : String = ""
    var leagueBadge : String = ""
    var leagueYoutub : String = ""
    var eventsUrl = "https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id="
    var arrayOfAllEvents : [Events]?
    var arrayOfIDS = [IDS]()
    @IBOutlet weak var buttonF: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiServices.instance.getDataFromApi(url: self.eventsUrl + leagueId) { [self] (data: Json4SwiftE?, error) in
            if let error = error{
                print(error)
            }else{
                guard data != nil else { return}
                if (data?.events) != nil {
                    arrayOfAllEvents =  (data?.events)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
       
        if arrayOfIDS.count == 0  {
            buttonF.setImage(UIImage(named: "unlike"), for: .normal)
        }else  {
            for i in 0..<arrayOfIDS.count {
                if leagueId == arrayOfIDS[i].value(forKey: "idLeagues") as? String {
                    buttonF.setImage(UIImage(named: "like"), for: .normal)
                }
            }
        }
        if buttonF.currentImage == nil {
            buttonF.setImage(UIImage(named: "unlike"), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "UpComingTableViewCell", for: indexPath) as! UpComingTableViewCell
            cell1.arrayOfAllEvents = arrayOfAllEvents ?? []
            return cell1
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "LatestEventsTableVCell", for: indexPath) as! LatestEventsTableVCell
            cell2.arrayOfAllEvents = arrayOfAllEvents ?? []
            return cell2
        case 2:
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "TeamsTableViewCell", for: indexPath) as! TeamsTableViewCell
            cell3.leagueId = leagueId
            return cell3
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName = ""
        switch section {
        case 0 :
            sectionName = "UpComing Events"
            break
        case 1 :
            sectionName = "Latest Events"
            break
        case 2 :
            sectionName = "Teams"
            break
        default: break
            
        }
        return sectionName
    }
    
    @IBAction func favouriteButton(_ sender: UIButton) {
        if buttonF.currentImage == UIImage(named: "like"){
            buttonF.setImage(UIImage(named: "unlike"), for: .normal)
            //delete from core data
            deleteData()
        } else if buttonF.currentImage == UIImage(named: "unlike") {
            buttonF.setImage(UIImage(named: "like"), for: .normal)
            SaveData()
        }
    }
    
    func SaveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "IDS", in: managedContext)
        let leagueID = NSManagedObject(entity: entity!, insertInto: managedContext)
        leagueID.setValue(leagueId, forKey: "idLeagues")
        leagueID.setValue(leagueStr, forKey: "strLeagues")
        leagueID.setValue(leagueBadge, forKey: "badgeLeagues")
        leagueID.setValue(leagueYoutub, forKey: "youtubLeagues")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
        appDelegate.saveContext()
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
    
    func deleteData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "IDS")
        let predicate = NSPredicate(format: "idLeagues==\(String(describing: leagueId))")
        let result = try? managedContext.fetch(fetchRequest)
        _ = result! as! [IDS]
        fetchRequest.predicate = predicate
        let objects = try! managedContext.fetch(fetchRequest)
        for obj in objects {
            managedContext.delete(obj as NSManagedObject)
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error)
        }
        appDelegate.saveContext()
    }
}


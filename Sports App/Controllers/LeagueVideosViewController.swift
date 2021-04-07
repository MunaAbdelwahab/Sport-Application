//
//  LeagueVideosViewController.swift
//  Sports App
//
//  Created by Muna Abdelwahab on 3/23/21.
//

import UIKit
import WebKit

class LeagueVideosViewController: UIViewController {

    @IBOutlet weak var videosChannel: WKWebView!
    var channelURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videosChannel.load(URLRequest(url: URL(string: channelURL!)!))
    }
}

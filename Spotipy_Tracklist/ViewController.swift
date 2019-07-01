//
//  ViewController.swift
//  Spotipy_Tracklist
//
//  Created by Yannick Lehnhausen on 01.07.19.
//  Copyright © 2019 Yannick Lehnhausen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    let urlString = "<path-to-tracklist>";
    private var myTableView: UITableView!
    private var tracklist: NSMutableArray!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        let dp = DataProvider()
        self.tracklist = dp.fetchDataFromUrl(urlString: urlString)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createTable()
        // Do any additional setup after loading the view.
    }
    
    func createTable()
    {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Num: \(indexPath.row)")
        print("Value: \(tracklist[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((tracklist) != nil) {
            return tracklist.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cellId")
        let track = tracklist[indexPath.row] as! Track
        cell.textLabel!.text = "\(track.artists.componentsJoined(by: ", "))"
        cell.detailTextLabel!.lineBreakMode = .byCharWrapping
        cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel!.text = "Album: \(track.album)\nSong: \(track.name)\nPlayed on the \(track.playedDate)"
        return cell
    }
}


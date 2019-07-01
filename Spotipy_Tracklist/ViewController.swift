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

    let urlString = "<path-to-tracklist";
    private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let dp = DataProvider()

    private var tracklist: NSMutableArray!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
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
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.view.addSubview(tableView)
    }
    
    @objc func reloadData()
    {
        DispatchQueue.main.async {
            self.tracklist = self.dp.fetchDataFromUrl(urlString: self.urlString)
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
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


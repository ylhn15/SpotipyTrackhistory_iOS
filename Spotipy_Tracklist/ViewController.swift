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

    var urlString = UserDefaults.standard.string(forKey: "tracklist-url")
    private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let dp = DataProvider()

    private var tracklist: NSMutableArray!

    override func viewWillLayoutSubviews() {
        let width = self.view.frame.width
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: barHeight, width: width, height: 44))
        self.view.addSubview(navigationBar);
        let navigationItem = UINavigationItem(title: "Spotify Tracklist")
        
        let settingsButton = UIBarButtonItem(title: NSString(string: "\u{2699}\u{0000FE0E}") as String, style: .plain, target: self, action: #selector(openUrlSettings))
        let font = UIFont.systemFont(ofSize: 28) // adjust the size as required
        let attributes = [NSAttributedString.Key.font: font]
        settingsButton.setTitleTextAttributes(attributes, for: .normal)
        
        navigationItem.rightBarButtonItem = settingsButton
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc func openUrlSettings(sender : AnyObject){
        let alertController = UIAlertController(title: "Set URL", message: "", preferredStyle: UIAlertController.Style.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            UserDefaults.standard.setValue(textField.text, forKey: "tracklist-url")
            self.urlString = textField.text
            self.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "URL"
            if((self.urlString) != nil) {
                textField.text = self.urlString
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.edgesForExtendedLayout = []
        self.tracklist = dp.fetchDataFromUrl(urlString: self.urlString ?? "")
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createTable()
        // Do any additional setup after loading the view.
    }
    
    func createTable()
    {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 44
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
            self.tracklist = self.dp.fetchDataFromUrl(urlString: self.urlString ?? "")
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


//
//  DataProvider.swift
//  Spotipy_Tracklist
//
//  Created by Yannick Lehnhausen on 01.07.19.
//  Copyright © 2019 Yannick Lehnhausen. All rights reserved.
//

import Foundation

class DataProvider
{
    
    func fetchDataFromUrl(urlString: String) -> NSMutableArray
    {
        let url = NSURL(string: urlString)
        var tracklist = NSMutableArray()
        
        let data = try? NSData(contentsOf: url! as URL, options: NSData.ReadingOptions())
        if((data) != nil) {
            let jsonObj = try? JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)
            tracklist = self.createTracklistFromJson(json: jsonObj!)
        }
        return tracklist
    }
    
    func createTracklistFromJson(json: Any) -> NSMutableArray
    {
        var tracklist: NSMutableArray = NSMutableArray()
        let jsonObjAsArray = json as! NSArray
        for track in jsonObjAsArray {
            let trackDict = track as! NSDictionary
            let album = trackDict.value(forKey: "album") as! String
            let artists = trackDict.value(forKey: "artists") as! NSArray
            let name = trackDict.value(forKey: "name") as! String
            let playedDate = trackDict.value(forKey: "played_date") as! String
            let newTrack = Track.init(album: album, artists: artists
                , name: name, playedDate: playedDate)
            tracklist.add(newTrack)
        }
        tracklist =  NSMutableArray(array: tracklist.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        return tracklist
    }
    
}

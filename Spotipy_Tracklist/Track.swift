//
//  Track.swift
//  Spotipy_Tracklist
//
//  Created by Yannick Lehnhausen on 01.07.19.
//  Copyright © 2019 Yannick Lehnhausen. All rights reserved.
//

import Foundation

class Track
{
    var album:String = ""
    var artists:NSArray
    var name:String
    var playedDate:String
    
    init(album: String, artists: NSArray, name:String, playedDate: String) {
        self.album = album
        self.artists = artists
        self.name = name
        self.playedDate = playedDate
    }
}

//
//  Album.swift
//  VVAudioPlayer
//
//  Created by HanLiu on 2019/12/21.
//

import Foundation

class Album: Compilation {
    
    var artist = ""
    
//    let songs = LinkingObjects(fromType: Song.self, property: "album")
    
    convenience init(title: String, artist: String) {
        self.init()
        self.title = title
        self.artist = artist
    }
}

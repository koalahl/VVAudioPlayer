//
//  Song.swift
//  VVAudioPlayer
//
//  Created by HanLiu on 2019/12/21.
//

import UIKit

class Song:Equatable {
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.urlStr == rhs.urlStr
    }
    
    
    var title = ""
    var urlStr = ""
    var fileSubpath = ""
    var album: Album?
    var artwork: UIImage? {
        return album?.artwork
    }
    
    var url: URL {
            return URL(fileURLWithPath: self.urlStr)
    //        return URL(fileURLWithPath: filePath)
    }
    
    private var filePath: String {
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = documentsUrl.appendingPathComponent("Music").appendingPathComponent(fileSubpath)
        return fileUrl.path
    }
    
    convenience init(title: String, url: URL) {
        self.init()
        self.title = title
        self.urlStr = url.path
        self.fileSubpath = url.lastPathComponent

    }
    func removeSongFile() {
        try? FileManager.default.removeItem(at: url)
    }

}

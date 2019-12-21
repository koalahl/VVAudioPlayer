//
//  Compilation.swift
//  VVAudioPlayer
//
//  Created by HanLiu on 2019/12/21.
//

import UIKit

class Compilation {
    
    var title = ""
    var artworkSubpath: String?
    var creationDate = Date()
    
    var id = UUID().uuidString
    
    var artwork: UIImage? {
        get {
            guard let path = artworkPath else { return nil }
            let url = URL(fileURLWithPath: path)
            guard let data = try? Data(contentsOf: url) else { return nil }
            return UIImage(data: data, scale: UIScreen.main.scale)
        }
        set {
            removeArtwork()
            guard let image = newValue else {
                return
            }
            let fileManager = FileManager.default
            let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let artworksUrl = documentsUrl.appendingPathComponent("Artworks", isDirectory: true)
            if !fileManager.directoryExists(artworksUrl.path) {
                try! fileManager.createDirectory(atPath: artworksUrl.path, withIntermediateDirectories: true)
            }
            let pathComponent = UUID().uuidString + ".png"
            let artworkUrl = artworksUrl.appendingPathComponent(pathComponent)
            
            guard let data = image.pngData() else { return }
            
            do {
                try data.write(to: artworkUrl)
                artworkSubpath = pathComponent
            } catch {
                if fileManager.fileExists(atPath: artworkUrl.path) {
                    try? fileManager.removeItem(atPath: artworkUrl.path)
                }
            }
        }
    }
    
    func getArtworkAsync(completion: @escaping (UIImage?) -> ()) {
        guard let path = artworkPath else { return completion(nil) }
        DispatchQueue.global(qos: .userInteractive).async {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                let artwork = UIImage(data: data, scale: UIScreen.main.scale) else {
                    return DispatchQueue.main.async { completion(nil) }
            }
            DispatchQueue.main.async {
                completion(artwork)
            }
        }
    }
    
    private func removeArtwork() {
        guard let path = artworkPath else {
            return
        }
        artworkSubpath = nil
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            try? fileManager.removeItem(atPath: path)
        }
    }
    
    private var artworkPath: String? {
        guard let subpath = artworkSubpath else {
            return nil
        }
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let artworkUrl = documentsUrl.appendingPathComponent("Artworks").appendingPathComponent(subpath)
        return artworkUrl.path
    }
    
}

extension FileManager {
    
    func directoryExists(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func changeUrlIfExists(_ url: URL) -> URL {
        var url = url
        var index = 1
        while fileExists(atPath: url.path) {
            var pathComponent = url.deletingPathExtension().lastPathComponent
            if index > 1 {
                pathComponent = pathComponent.replacingOccurrences(of: "\(index - 1)", with: "")
            }
            pathComponent += "\(index)"
            url = url.deletingLastPathComponent().appendingPathComponent(pathComponent)
                .appendingPathExtension(url.pathExtension)
            index += 1
        }
        return url
    }
}


//
//  MusicInfo.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/19/23.
//

import Foundation
import SwiftUI

struct musicInfoModel {
    var title: String
    var artist: String
    var albumCover: UIImage
    var blurredAlbumCover: UIImage
    var totalTime: Double
    var lyrics: String

    init(title: String="untitled", artist: String="No artist", albumCover: UIImage = UIImage(resource: .default), blurredAlbumCover: UIImage = UIImage(resource: .default), totalPlayTime: Double = 0.1, lyrics: String = "No Lyrics") {
        self.title = title
        self.artist = artist
        self.albumCover = albumCover
        self.blurredAlbumCover = blurredAlbumCover
        self.totalTime = totalPlayTime
        self.lyrics = lyrics
        
        setBlurredAlbumCover()
    }
    
    mutating func setBlurredAlbumCover() {
        self.blurredAlbumCover = ImageEditor().blurImage(image: self.albumCover, blurAmount: 5.0)
    }
}

//
//  AudioPlayer.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/18/23.
//

import UIKit
import AVFoundation

func fetchAudioMetadata(from url: URL) async -> musicInfoModel {
    let _ = url.startAccessingSecurityScopedResource()
    let asset = AVAsset(url: url)
   
    
    var title: String?
    var album: String?
    var artist: String?
    var coverImage: UIImage?
    var lyrics: String?
    
    do {
        let metadata: [AVMetadataItem] = try await asset.load(.commonMetadata)
        
        for item in metadata {
            print("key: \(String(describing: item.commonKey?.rawValue)), value: \(await String(describing: try item.load(.value)))")
            // 각 타입에 따른 메타데이터 정보 추출
            if item.commonKey?.rawValue == "title" {
                title = try await item.load(.stringValue)
            }
            else if item.commonKey?.rawValue == "albumName" {
                album = try await item.load(.stringValue)
                print(album ?? ".")
            }
            else if item.commonKey?.rawValue == "artist" {
                artist = try await item.load(.stringValue)
            }
            else if item.commonKey?.rawValue == "artwork" {
                if let imageData = try await item.load(.dataValue){
                    coverImage = UIImage(data: imageData)
                }
            }
        }
        
    } catch {
        print(error.localizedDescription)
    }
   
    
    
    do {
        if let lyricMetadata = try await asset.load(.lyrics) {
            lyrics = lyricMetadata
        }
    } catch {
        print(error.localizedDescription)
    }
    
    // 디폴트 값 설정
    let finalTitle = title ?? "Untitled"
    //let finalAlbum = album ?? "Untitled Album"
    let finalArtist = artist ?? "Unknown Artist"
    let finalCoverImage = coverImage ?? UIImage(resource: .album)  // 미리 저장한 디폴트 이미지를 사용
    let finalLyrics = lyrics ?? "가사 없음"
    
    print(finalLyrics)
    let _ = url.stopAccessingSecurityScopedResource()
    return musicInfoModel(title: finalTitle, artist: finalArtist, albumCover: finalCoverImage, lyrics: finalLyrics)
}

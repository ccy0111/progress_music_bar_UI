//
//  AudioPlayer.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/19/23.
//

import Foundation
import UIKit
import AVFoundation


struct AudioPlayer {
    
    var audioPlayer: AVAudioPlayer! = AVAudioPlayer()
    var info: musicInfoModel = musicInfoModel()
    
    mutating func load(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 음악 재생 함수
    func play() {
        audioPlayer.play()
    }
    
    // 특정 시간부터 재생
    func play(from time: TimeInterval) {
        audioPlayer.currentTime = time
        audioPlayer.play()
    }
    
    // 음악 정지 함수
    func pause() {
        audioPlayer.pause()
    }
    
    // 음악의 총 길이 가져오기
    func getTotalTime() -> Double {
        return audioPlayer.duration
    }
    
    // 현재 재생 위치 가져오기
    func getCurrentTime() -> TimeInterval {
        return audioPlayer.currentTime
    }
}

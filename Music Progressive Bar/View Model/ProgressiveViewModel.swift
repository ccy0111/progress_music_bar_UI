//
//  ProgressiveViewModel.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/16/23.
//

import Foundation
import SwiftUI

struct ProgressiveViewModel {
    let strokeOpacity: CGFloat = 0.7
    let strokeLineWidth: CGFloat = 10.0
    @Binding var Image: UIImage
    
    func getImageFrame() -> CGSize {
        let ratio = Image.size.width / Image.size.height
        let height = Const.deviceHeight
        let width = ratio * height
        
        return CGSize(width: width, height: height)
    }
    
    func getImageOffset() -> [CGFloat] {
        let imageSize = getImageFrame()
        
        let xOffset = (Const.deviceWidth - imageSize.width) / 2
        let yOffset = (Const.deviceHeight - imageSize.height) / 2
        return [xOffset, yOffset]
    }
    
    func getProgressBarFrame() -> CGFloat {
        return Const.deviceWidth <= 450 ? Const.deviceWidth : 450
    }
    func getStrokeFrame() -> CGFloat {
        return getProgressBarFrame() - strokeLineWidth
    }
}

struct timerModel {
    @Binding var secondsElapsed: Double
    
    func getDegressFromTime() -> Double {
        return secondsElapsed * (360 / 100)
    }
}

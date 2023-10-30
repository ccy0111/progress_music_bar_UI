//
//  ProgressiveViewModel.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/16/23.
//

import Foundation
import SwiftUI

struct viewConst {
    static let strokeOpacity: CGFloat = 0.7
    static let strokeLineWidth: CGFloat = 4.0
    static let strokeLinePadding: CGFloat = 10.0
    static let maxImageSize: CGFloat = 450
}

struct ProgressiveViewModel {
    
    @Binding var Image: UIImage

    func getBackgroundFrame() -> CGSize {
        let ratio = Image.size.width / Image.size.height
        let height = Const.deviceHeight
        let width = ratio * height
        
        return CGSize(width: width, height: height)
    }
    
    // about ProgressBar Info
    func getProPosition() -> CGPoint {
        let x = Const.deviceWidth / 2
        let y = Const.deviceHeight / 2.5
        return CGPoint(x: x, y: y)
    }
    
    func getProFrame() -> CGFloat {
        let frame = Const.deviceWidth - 50 - viewConst.strokeLineWidth - viewConst.strokeLinePadding
        
        return frame <= viewConst.maxImageSize ? frame : viewConst.maxImageSize
    }
    
    // about Stroke view Info
    func getStrokeFrame() -> CGFloat {
        return getProFrame() + viewConst.strokeLineWidth + viewConst.strokeLinePadding
        
    }
    
    func getStrokeLineWidth() -> CGFloat {
        return viewConst.strokeLineWidth
    }
    
    func getStrokeOpacity() -> CGFloat {
        return viewConst.strokeOpacity
    }
    
    // Testing
    func getRadius() -> CGFloat {
        return getStrokeFrame() / 2
    }
    
    func getTestPosition() -> CGPoint {
        return CGPoint(x: Const.deviceWidth / 2, y: getProFrame() - getRadius() - 10)
    }
    // about InnerCircle
    func getInnerCircleFrame() -> CGFloat {
        return getProFrame() / 3
    }
    
    func getInnerCircleOpacity() -> Double {
        return 0.9
    }
    // about ZStack Frame
    func getStackFrame() -> CGFloat {
        return getProPosition().y + getProFrame() / 2
    }
    
    func getBackGroundLinear() -> LinearGradient {
        return LinearGradient(colors: [Color.concept.opacity(0.5),
                                       Color.concept.opacity(0.0)],
                              startPoint: .bottom, endPoint: .top)
    }
}


struct ProgressBarWithTime: ProgressViewStyle {
    
    var nowTime: Double
    var totalTime: Double
    
    func makeBody(configuration: Configuration) -> some View {
        VStack
        {
            HStack {
                Text(nowTime.timeInterval())
                    .foregroundStyle(.white)
                    .font(.system(size: 20, design: .rounded))
                Spacer()
                Text(totalTime.timeInterval())
                    .foregroundStyle(.white)
                    .font(.system(size: 20, design: .rounded))
            }
            
            ProgressView(configuration)
                .tint(.concept.opacity(0.7))
        }
    }
}



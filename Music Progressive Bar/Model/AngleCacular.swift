//
//  AngleCacular.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/18/23.
//

import Foundation
import SwiftUI

struct AngleCalculator {
   
    func getAtan(center: CGPoint, pos: CGPoint) -> Double {
        let angle = atan2(pos.y - center.y, pos.x - center.x)
        let value = angle *  Const.halfCycle / .pi
        return value
    }
    
    func modifyDiffer(differ: Double) -> Double {
        if differ > Const.halfCycle {
            return differ - Const.oneCycle
        } 
        else if differ < -Const.halfCycle {
            return differ + Const.oneCycle
        }
        return differ
    }
    
    func anglePerSec(totalTime: Double) -> Double {
        return (Const.fps / totalTime) * Const.oneCycle
    }
    
    func getNomalizedAngle(angle: Double) -> Double {
        if angle > Const.oneCycle {
            return Const.oneCycle
        }
        else if angle < 0 {
            return 0
        }
        return angle
    }
}

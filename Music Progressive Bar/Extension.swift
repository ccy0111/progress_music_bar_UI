//
//  Extension.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/23/23.
//

import SwiftUI
import Foundation

extension Double {
    func timeInterval() -> String {
        let time = Int(self)
        
        let min = time / 60
        let sec = time % 60
        
        let ret = String(format: "%02d:%02d", min, sec)
        return ret
    }
}

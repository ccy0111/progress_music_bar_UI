//
//  EventHandler.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/19/23.
//

import Foundation
import SwiftUI

struct stateManager {
    @Binding var paused: Bool
    @Binding var nowDragging: Bool
    @Binding var musicSelected: Bool
    
    func letDrag() {
        paused = true
        nowDragging = true
    }
    
    func letDragEnd() {
        paused = false
        nowDragging = false
    }
    
    func isPlayable() -> Bool {
        return musicSelected && !paused
    }
}

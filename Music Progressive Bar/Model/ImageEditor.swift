//
//  ImageEditor.swift
//  Music Progressive Bar
//
//  Created by 하승민 on 10/16/23.
//

import Foundation
import UIKit
import CoreImage

struct ImageEditor {
    
    func blurImage(image: UIImage, blurAmount: Double) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        
        // CIGaussianBlur 필터 생성
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return image }
        blurFilter.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        // 필터 적용
        guard let outputImage = blurFilter.outputImage else { return image }
        
        // CIImage를 UIImage로 변환
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return image }
        
        return UIImage(cgImage: cgImage)
    }
    
}

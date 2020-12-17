//
//  ColorUtility.swift
//  HowdySlider
//
//  Created by Rado Hečko on 17/12/2020.
//

import UIKit

// Source: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
extension UIColor {
    
    convenience init(hex: String) {
        var int = UInt64()
        let a, r, g, b: UInt64
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        Scanner(string: hex).scanHexInt64(&int)
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}

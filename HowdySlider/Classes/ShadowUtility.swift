//
//  ShadowUtility.swift
//  HowdySlider
//
//  Created by Rado Hečko on 17/12/2020.
//

import UIKit

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        let backgroundCGColor = backgroundColor?.cgColor
        
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.backgroundColor =  backgroundCGColor
        backgroundColor = nil
    }
}

//
//  UIFont+Extensions.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 29/7/23.
//

import UIKit.UIFont

extension UIFont {
    
    static func themeFont(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Avenir", size: size) else {
          return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
    
    static func mediumThemeFont(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Avenir", size: size) else {
            return UIFont.boldSystemFont(ofSize: size)
        }
        return customFont
    }
    
    static func boldThemeFont(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Avenir", size: size) else {
            return UIFont.boldSystemFont(ofSize: size)
        }
        return customFont
    }
}

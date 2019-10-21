//
//  UIColor+HexColor.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import UIKit

extension UIColor {
    static func hexColor(_ hexColor: Int64) -> UIColor {
        let red = (CGFloat)((hexColor & 0xFF0000) >> 16) / 255.0
        let green = (CGFloat)((hexColor & 0xFF00) >> 8) / 255.0
        let blue = (CGFloat)(hexColor & 0xFF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

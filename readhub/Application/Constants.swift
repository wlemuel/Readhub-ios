//
//  Constants.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Env {
        static let prod: Bool = {
            #if DEBUG
                return false
            #else
                return true
            #endif
        }()

        static func isProd() -> Bool {
            return prod
        }

        static func isDebug() -> Bool {
            return !prod
        }
    }
}

// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
let kScreenW = UIScreen.main.bounds.width

struct MetricsGlobal {
    static let padding: CGFloat = 10.0
}

// MARK: - 颜色方法

func kRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

// MARK: - 常用按钮颜色

// 颜色参考 http://www.sioe.cn/yingyong/yanse-rgb-16/

let kThemeWhiteColor = UIColor.hexColor(0xFFFFFF)
let kThemeSeperatorColor = UIColor.hexColor(0xF8F8F8)
let kThemeGrayColor = UIColor.hexColor(0xFAFAFA)
let kThemeHintColor = UIColor.hexColor(0x999999)
let kThemeLogoColor = UIColor.hexColor(0x156197)
let kThemeTabColor = UIColor.hexColor(0x757575)
let kThemeBlackColor = UIColor.hexColor(0x000000)
let kThemeMainColor = UIColor.hexColor(0x206A9C)
let kThemeSecondColor = UIColor.hexColor(0x737373)

// MARK: - 自定义打印方法

func kLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG

        let fileName = (file as NSString).lastPathComponent

        print("\(fileName):(\(lineNum))-\(message)")

    #endif
}

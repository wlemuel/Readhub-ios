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

// MARK: - 颜色方法

func kRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func kColor(light: UIColor, dark: UIColor) -> UIColor {
    return UIColor { (trainCollection) -> UIColor in
        if trainCollection.userInterfaceStyle == .dark {
            return dark
        } else {
            return light
        }
    }
}

// MARK: - 系统配色 (light/dark mode)

let kThemePrimaryColor = kColor(light: UIColor.hexColor(0x007AFF), dark: UIColor.hexColor(0x0A8AFF))
let kThemeSecondaryColor = kColor(light: UIColor.hexColor(0x0066FF), dark: UIColor.hexColor(0x82C0FF))

let kThemeBaseColor = kColor(light: UIColor.hexColor(0xEEEEEE), dark: UIColor.hexColor(0x111111))
let kThemeBase2Color = kColor(light: UIColor.hexColor(0xF7F7F7), dark: UIColor.hexColor(0x080808))
let kThemeBase3Color = kColor(light: UIColor.hexColor(0x969696), dark: UIColor.hexColor(0x696969))

let kThemeFontColor = kColor(light: UIColor.hexColor(0x333333), dark: UIColor.hexColor(0xCCCCCC))
let kThemeFont2Color = kColor(light: UIColor.hexColor(0x8E8E8E), dark: UIColor.hexColor(0x717171))
let kThemeFont3Color = kColor(light: UIColor.hexColor(0xBBBBBB), dark: UIColor.hexColor(0x444444))
let kThemeFont4Color = kColor(light: UIColor.hexColor(0xADC0CD), dark: UIColor.hexColor(0x523F32))

let kThemeBackgroundColor = kColor(light: UIColor.hexColor(0xFFFFFF), dark: UIColor.hexColor(0x000000))

// MARK: - 元素间距

let kMargin: CGFloat = 40.0
let kMargin2: CGFloat = 30.0
let kMargin3: CGFloat = 16.0
let kMargin4: CGFloat = 10.0

// MARK: - 自定义打印方法

func kLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG

        let fileName = (file as NSString).lastPathComponent

        print("\(fileName):(\(lineNum))-\(message)")

    #endif
}

// MARK: - 文本提示

let kMsgNoNetwork = "网络异常，请检查网络设置"
let kMsgNoData = "暂无数据"
let kMsgLoading = "加载中 ..."


// MARK: - 信息相关参数

let kFeedbackUrl = "https://support.qq.com/product/97725"
let kTelegramUrl = "https://t.me/readhubplus"
let kAuthorUrl = "https://github.com/wlemuel"
let kProjectUrl = "https://github.com/wlemuel/Readhub-ios"

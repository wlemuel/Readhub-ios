//
//  ViewUtils.swift
//  readhub
//
//  Created by Steve Lemuel on 2019/11/9.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import SafariServices
import UIKit

struct ViewUtils {
    static func delay(_ delay: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    static func gotoUrl(viewcontroller: UIViewController, rawUrl: String, enterReader: Bool = false) {
        if let url = URL(string: rawUrl) {
            let safariConfig = SFSafariViewController.Configuration()
            safariConfig.entersReaderIfAvailable = enterReader

            let safariVC = SFSafariViewController(url: url, configuration: safariConfig)
            safariVC.preferredBarTintColor = kThemeBase2Color
            safariVC.preferredControlTintColor = kThemePrimaryColor

            viewcontroller.present(safariVC, animated: true, completion: nil)
        }
    }
}

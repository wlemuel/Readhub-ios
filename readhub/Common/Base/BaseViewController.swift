//
//  BaseViewController.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        kLog("init: \(type(of: self))")
        
        view.backgroundColor = kThemeWhiteColor
    }

    deinit {
        kLog("deinit: \(type(of: self))")
    }
}

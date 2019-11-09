//
//  ViewUtils.swift
//  readhub
//
//  Created by Steve Lemuel on 2019/11/9.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation

struct ViewUtils {
    static func delay(_ delay: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

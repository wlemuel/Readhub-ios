//
//  Constants.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation

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

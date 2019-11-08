//
//  SettingSection.swift
//  readhub
//
//  Created by Steve Lemuel on 11/8/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit

enum SettingType {
    case url
    case plain
    case plainUrl
    case support
}

struct SettingModel {
    let type: SettingType
    let name: String
    let descr: String
    let url: String

    init(type: SettingType, name: String, descr: String = "", url: String = "") {
        self.type = type
        self.name = name
        self.descr = descr
        self.url = url
    }
}

extension SettingModel: IdentifiableType {
    typealias Identity = String
    var identity: String {
        return name
    }
}

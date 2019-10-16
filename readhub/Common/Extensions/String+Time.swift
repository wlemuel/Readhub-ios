//
//  String+Time.swift
//  readhub
//
//  Created by Steve Lemuel on 10/16/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import SwiftDate

extension String {
    func getFriendTime() -> String {
        let str = self
        
        let date = str.toDate("yyyy-MM-dd'T'HH:mm:ss.SSSZ")?.date
        return (date?.toRelative(style: RelativeFormatter.defaultStyle(), locale: Locales.chinese))!
    }
}

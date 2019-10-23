//
//  UIViewExtension.swift
//  readhub
//
//  Created by Steve Lemuel on 10/23/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

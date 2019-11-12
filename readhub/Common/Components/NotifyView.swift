//
//  NotifyView.swift
//  readhub
//
//  Created by Steve Lemuel on 11/8/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import SnapKit
import Then
import UIKit

fileprivate struct Metrics {
    static let contentHeight: CGFloat = 40.0
    static let contentWidth: CGFloat = 150.0

    static let msgFontSize: CGFloat = 13.0
}

class NotifyView: UIView {
    // MARK: - Private

    private static var sharedView: NotifyView!
    private var msgLabel: UILabel!

    // MARK: - Public

    override init(frame: CGRect) {
        super.init(frame: frame)

        msgLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: Metrics.msgFontSize)
            $0.text = ""
            $0.textColor = UIColor.white
        }

        addSubview(msgLabel)
        msgLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backgroundColor = kThemePrimaryColor

        layer.masksToBounds = false
        layer.cornerRadius = Metrics.contentHeight / 2
        layer.shadowColor = kThemeFont2Color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    static func showIn(viewController: UIViewController, message: String) {
        let displayVC = viewController

        if sharedView == nil {
            sharedView = NotifyView()
        }

        sharedView.msgLabel.text = message

        if sharedView.superview == nil {
            sharedView.alpha = 0.0

            displayVC.view.addSubview(sharedView)
            
            sharedView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().inset(kMargin3)
                make.centerX.equalToSuperview()
                make.height.equalTo(Metrics.contentHeight)
                make.width.equalTo(Metrics.contentWidth)
            }
            
            sharedView.fadeIn()

            // this call needs to be counter balanced on fadeOut [1]
            sharedView.perform(#selector(fadeOut), with: nil, afterDelay: 5.0)
        }
    }

    // MARK: Animations

    func fadeIn() {
        UIView.animate(withDuration: 0.33, animations: {
            self.alpha = 1.0
        })
    }

    @objc func fadeOut() {
        // [1] Counter balance previous perfom:with:afterDelay
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        UIView.animate(withDuration: 0.33, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

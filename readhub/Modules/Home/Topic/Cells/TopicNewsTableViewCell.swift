//
//  TopicNewsTableViewCell.swift
//  readhub
//
//  Created by Steve Lemuel on 10/23/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

fileprivate struct Metrics {
    static let titleFontSize: CGFloat = 15.0
    static let siteFontSize: CGFloat = 13.0
}

class TopicNewsTableViewCell: UITableViewCell {
    // MARK: Public properties -

    var titleLabel: UILabel!
    var siteLabel: UILabel!

    // MARK: Private properties -

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
        setupRx()
    }

    private func setupLayout() {
        contentView.backgroundColor = kThemeBase2Color
        
        let dotLabel = UILabel().then {
            $0.textColor = kThemeFontColor
            $0.font = UIFont.systemFont(ofSize: Metrics.titleFontSize)
            $0.text = "◦  "
        }
        addSubview(dotLabel)
        dotLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }

        titleLabel = UILabel().then {
            $0.textColor = kThemeFontColor
            $0.font = UIFont.systemFont(ofSize: Metrics.titleFontSize)
            $0.numberOfLines = 1
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kMargin3)
            make.right.equalToSuperview()
        }

        siteLabel = UILabel().then {
            $0.textColor = kThemeFont3Color
            $0.font = UIFont.systemFont(ofSize: Metrics.siteFontSize)
        }
        addSubview(siteLabel)
        siteLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(dotLabel.snp.right)
            make.bottom.equalToSuperview().inset(kMargin3)
        }
    }

    private func setupRx() {
    }

    func setValueForCell(model: TopicItemNewsModel) {
        titleLabel.text = model.title
        siteLabel.text = model.siteName
    }
}

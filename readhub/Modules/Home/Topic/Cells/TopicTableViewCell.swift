//
//  TopicTableViewCell.swift
//  readhub
//
//  Created by Steve Lemuel on 10/22/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import SnapKit
import Then
import UIKit

fileprivate struct Metrics {
    static let lineSpacing: CGFloat = 8.0

    static let titleFontSize: CGFloat = 19.0
    static let titleHeight: CGFloat = 60.0

    static let summaryFontSize: CGFloat = 15.0

    static let timeFontSize: CGFloat = 13.0
}

class TopicTableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    var summaryLabel: UILabel!
    var timeLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    private func setupLayout() {
        contentView.backgroundColor = kThemeGrayColor

        titleLabel = UILabel().then {
            $0.textColor = kThemeBlackColor
            $0.numberOfLines = 2
            $0.font = UIFont.systemFont(ofSize: Metrics.titleFontSize)
        }
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview().inset(MetricsGlobal.padding)
        })

        summaryLabel = UILabel().then {
            $0.textColor = kThemeSecondColor
            $0.numberOfLines = 3
            $0.font = UIFont.systemFont(ofSize: Metrics.summaryFontSize)
        }
        addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(MetricsGlobal.padding)
            make.left.right.equalToSuperview().inset(MetricsGlobal.padding)
        })

        timeLabel = UILabel().then {
            $0.textColor = kThemeHintColor
            $0.font = UIFont.systemFont(ofSize: Metrics.timeFontSize)
        }
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints({ make in
            make.bottom.equalToSuperview().inset(MetricsGlobal.padding)
            make.top.equalTo(summaryLabel.snp.bottom).offset(MetricsGlobal.padding)
            make.left.right.equalToSuperview().inset(MetricsGlobal.padding)
        })
    }

    func setValueForCell(model: TopicItemModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary

        let timestamp = model.publishDate?.getFriendTime() ?? ""

        timeLabel.text = "\(timestamp)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

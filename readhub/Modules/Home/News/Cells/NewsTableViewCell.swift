//
//  NewsTableViewCell.swift
//  readhub
//
//  Created by Steve Lemuel on 10/16/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import SnapKit
import Then
import UIKit

fileprivate struct Metrics {
    static let lineSpacing: CGFloat = 8.0

    static let titleFontSize: CGFloat = 18.0
    static let titleHeight: CGFloat = 60.0

    static let summaryFontSize: CGFloat = 14.0

    static let timeFontSize: CGFloat = 13.0
}

class NewsTableViewCell: UITableViewCell {
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
        contentView.backgroundColor = kThemeBase2Color

        titleLabel = UILabel().then {
            $0.textColor = kThemeFontColor
            $0.numberOfLines = 2
            $0.font = UIFont.systemFont(ofSize: Metrics.titleFontSize)
        }
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview().inset(kMargin3)
        })

        summaryLabel = UILabel().then {
            $0.textColor = kThemeFont2Color
            $0.numberOfLines = 3
            $0.font = UIFont.systemFont(ofSize: Metrics.summaryFontSize)
        }
        addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(kMargin3)
            make.left.right.equalToSuperview().inset(kMargin3)
        })

        timeLabel = UILabel().then {
            $0.textColor = kThemeFont3Color
            $0.font = UIFont.systemFont(ofSize: Metrics.timeFontSize)
        }
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints({ make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(kMargin3)
            make.left.right.bottom.equalToSuperview().inset(kMargin3)
        })

        let hline = UIView().then {
            $0.backgroundColor = kThemeFont3Color
        }
        addSubview(hline)
        hline.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(kMargin3)
        }
    }

    func setValueForCell(model: NewsItemModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary

        let siteName = model.siteName ?? ""
        let authorName = model.authorName ?? ""
        let timestamp = model.publishDate?.getFriendTime() ?? ""
        let seperator = authorName == "" ? "" : "/"

        timeLabel.text = "\(siteName) \(seperator) \(authorName)  \(timestamp)"

//        summaryLabel.setLineSpacing(lineHeightMultiple: 1.2)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

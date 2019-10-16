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
    static let titleFontSize: CGFloat = 18.0
    static let titleHeight: CGFloat = 57.0
    
    static let summaryFontSize: CGFloat = 15.0
    static let summaryHeight: CGFloat = 65.0
    
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

    func setupLayout() {
        contentView.backgroundColor = kThemeGrayColor
        
        titleLabel = UILabel().then {
            $0.textColor = kThemeBlackColor
            $0.numberOfLines = 2
            $0.font = UIFont.systemFont(ofSize: Metrics.titleFontSize)
        }
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(MetricsGlobal.padding)
            make.height.equalTo(Metrics.titleHeight)
        })

        summaryLabel = UILabel().then {
            $0.textColor = kThemeSecondColor
            $0.numberOfLines = 3
            $0.font = UIFont.systemFont(ofSize: Metrics.summaryFontSize)
        }
        addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(MetricsGlobal.padding)
            make.height.equalTo(Metrics.summaryHeight)
        })

        timeLabel = UILabel().then {
            $0.textColor = kThemeSecondColor
            $0.font = UIFont.systemFont(ofSize: Metrics.timeFontSize)
        }
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview()
            make.top.equalTo(summaryLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(MetricsGlobal.padding)
            make.width.equalToSuperview()
        })
        
    }

    func setValueForCell(model: NewsItemModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.summary
        timeLabel.text = model.publishDate?.getFriendTime()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

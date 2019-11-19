//
//  TopicTableViewCell.swift
//  readhub
//
//  Created by Steve Lemuel on 10/22/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import NSObject_Rx
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

fileprivate struct Metrics {
    static let lineSpacing: CGFloat = 8.0

    static let titleFontSize: CGFloat = 18.0
    static let titleHeight: CGFloat = 60.0

    static let summaryFontSize: CGFloat = 15.0

    static let timeFontSize: CGFloat = 13.0

    static let goButtonHeight: CGFloat = 60.0

    static let cellHeight: CGFloat = 50.0
}

class TopicTableViewCell: UITableViewCell {
    // MARK: Public properties -

    var titleLabel: UILabel!
    var summaryLabel: UILabel!
    var timeLabel: UILabel!
    var newsTableView: UITableView!
    var goBtn: UIButton!

    private var topicId: String = ""

    // MARK: Private properties -

    private let news = BehaviorRelay<[TopicItemNewsModel]>(value: [])
    private let newsCellId = "TopicNewsCell"

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
            $0.numberOfLines = 0
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
            make.top.equalTo(summaryLabel.snp.bottom).offset(kMargin4)
            make.left.right.bottom.equalToSuperview().inset(kMargin3)
        })

        newsTableView = UITableView().then {
            $0.rowHeight = Metrics.cellHeight
            $0.separatorStyle = .none

            $0.register(TopicNewsTableViewCell.self, forCellReuseIdentifier: newsCellId)
        }
        addSubview(newsTableView)
        newsTableView.isHidden = true

        goBtn = UIButton().then {
            $0.setTitle("", for: .normal)
            $0.setTitleColor(kThemeSecondaryColor, for: .normal)
        }
        addSubview(goBtn)
        goBtn.isHidden = true

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

    private func setupRx() {
        goBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }

                if self.topicId != "", let topicViewController = self.parentViewController as? TopicViewController {
                    ViewUtils.gotoUrl(viewcontroller: topicViewController, rawUrl: "https://readhub.cn/topic/\(self.topicId)")
                }

            }).disposed(by: rx.disposeBag)

        let dataDriver = news.asDriver()
        dataDriver.drive(newsTableView.rx.items(cellIdentifier: newsCellId, cellType: TopicNewsTableViewCell.self)) { _, model, cell in
            cell.setValueForCell(model: model)
        }.disposed(by: rx.disposeBag)

        newsTableView.rx.modelSelected(TopicItemNewsModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let `self` = self else { return }

                if let topicViewController = self.parentViewController as? TopicViewController {
                    ViewUtils.gotoUrl(viewcontroller: topicViewController, rawUrl: model.mobileUrl ?? "", enterReader: true)
                }
            }).disposed(by: rx.disposeBag)
    }

    func setValueForCell(model: TopicItemModel) {
        topicId = model.id ?? ""

        titleLabel.text = model.title
        summaryLabel.text = model.expanded ? model.summary : ""

        summaryLabel.setLineSpacing(lineHeightMultiple: 1.3)

        let timestamp = model.publishDate?.getFriendTime() ?? ""

        timeLabel.text = "\(timestamp)"

        goBtn.setTitle(model.expanded ? "查看主题 ▷" : "", for: .normal)

        var newsList = model.newsArray ?? []

        // show the top 3 news
        if newsList.count > 3 {
            newsList.replaceSubrange(3 ..< newsList.endIndex, with: [])
        }

        if model.expanded {
            news.accept(newsList)
        }

        newsTableView.isHidden = !model.expanded
        goBtn.isHidden = !model.expanded

        // update constraints
        timeLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(summaryLabel.snp.bottom).offset(kMargin4)
            make.left.right.equalToSuperview().inset(kMargin3)
            
            if !model.expanded {
                make.bottom.equalToSuperview().inset(kMargin3).priority(.low)
            }
        }
        
        newsTableView.snp.remakeConstraints { make in
            if model.expanded {
                make.top.equalTo(timeLabel.snp.bottom).offset(kMargin).priority(.low)
                make.left.right.equalToSuperview().inset(kMargin3)
                make.height.equalTo(Metrics.cellHeight * CGFloat(newsList.count)).priority(.low)
            }
        }

        goBtn.snp.remakeConstraints { make in
            if model.expanded {
                make.top.equalTo(newsTableView.snp.bottom).priority(.low)
                make.height.equalTo(Metrics.goButtonHeight).priority(.low)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(kMargin3).priority(.low)
            }
        }

        updateConstraints()
    }
}

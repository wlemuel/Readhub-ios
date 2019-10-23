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
import SafariServices
import SnapKit
import Then
import UIKit

fileprivate struct Metrics {
    static let lineSpacing: CGFloat = 8.0

    static let titleFontSize: CGFloat = 19.0
    static let titleHeight: CGFloat = 60.0

    static let summaryFontSize: CGFloat = 16.0

    static let timeFontSize: CGFloat = 13.0

    static let goButtonHeight: CGFloat = 50.0

    static let cellHeight: CGFloat = 50.0
}

class TopicTableViewCell: UITableViewCell {
    // MARK: Public properties -

    var titleLabel: UILabel!
    var summaryLabel: UILabel!
    var timeLabel: UILabel!
    var newsTableView: UITableView!
    var goBtn: UIButton!

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
            $0.numberOfLines = 0
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
            make.top.equalTo(summaryLabel.snp.bottom).offset(MetricsGlobal.padding)
            make.left.right.equalToSuperview().inset(MetricsGlobal.padding)
        })

        newsTableView = UITableView()
        addSubview(newsTableView)
        newsTableView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(MetricsGlobal.padding)
            make.left.right.equalToSuperview().inset(MetricsGlobal.padding)
            make.height.equalTo(1).priority(.high)
        }
        newsTableView.register(TopicNewsTableViewCell.self, forCellReuseIdentifier: newsCellId)
//        newsTableView.estimatedRowHeight = Metrics.cellHeight
//        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.rowHeight = Metrics.cellHeight
        newsTableView.separatorStyle = .none

        goBtn = UIButton().then {
            $0.setTitle("", for: .normal)
            $0.setTitleColor(kThemeBlackSecondaryColor, for: .normal)
        }
        addSubview(goBtn)
        goBtn.snp.makeConstraints { make in
            make.top.equalTo(newsTableView.snp.bottom)
            make.height.equalTo(1)
            make.width.bottom.equalToSuperview()
        }
    }

    private func setupRx() {
        goBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }

                print("click \(String(describing: self.titleLabel.text))")

            }).disposed(by: rx.disposeBag)

        let dataDriver = news.asDriver()
        dataDriver.drive(newsTableView.rx.items(cellIdentifier: newsCellId, cellType: TopicNewsTableViewCell.self)) { _, model, cell in
            cell.setValueForCell(model: model)
        }.disposed(by: rx.disposeBag)

        newsTableView.rx.modelSelected(TopicItemNewsModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let `self` = self else { return }

                if let url = URL(string: model.mobileUrl ?? ""), let topicViewController = self.parentViewController as? TopicViewController {
                    let safariConfig = SFSafariViewController.Configuration()
                    safariConfig.entersReaderIfAvailable = true

                    let safariVC = SFSafariViewController(url: url, configuration: safariConfig)

                    topicViewController.present(safariVC, animated: true, completion: nil)
                }
            }).disposed(by: rx.disposeBag)
    }

    func setValueForCell(model: TopicItemModel) {
        titleLabel.text = model.title
        summaryLabel.text = model.expanded ? model.summary : ""
        
        summaryLabel.setLineSpacing(lineHeightMultiple: 1.3)

        let timestamp = model.publishDate?.getFriendTime() ?? ""

        timeLabel.text = "\(timestamp)"

        goBtn.setTitle(model.expanded ? "查看主题 ▷" : "", for: .normal)

        let newsList = model.newsArray ?? []

        if model.expanded {
            news.accept(newsList)
        }

        newsTableView.snp.updateConstraints { make in
            make.height.equalTo(model.expanded ? Metrics.cellHeight * CGFloat(newsList.count) : 1).priority(.high)
        }

        goBtn.snp.updateConstraints { make in
            make.height.equalTo(model.expanded ? Metrics.goButtonHeight : 1)
        }
    }
}

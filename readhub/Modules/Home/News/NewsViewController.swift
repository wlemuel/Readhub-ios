//
//  BaseNewsViewController.swift
//  readhub
//
//  Created by Steve Lemuel on 10/22/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import MJRefresh
import RxCocoa
import RxSwift
import SafariServices

fileprivate struct Metrics {
    static let cellHeight: CGFloat = 150.0
}

class NewsViewController: BaseViewController {
    // MARK: Private -

    private var presenter: HomePresenterInterface!
    private var newsType: NewsType = .news

    private var tableView: UITableView!
    private var dataDriver: Driver<[NewsItemModel]>!
    private var errorDriver: Driver<ReadhubApiError>!
    private var lastCursor: String = ""

    private let disposeBag = DisposeBag()
    private let cellId = "NewsCell"

    init(newsType: NewsType, presenter: HomePresenterInterface) {
        self.presenter = presenter
        self.newsType = newsType

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupRx()
    }

    private func setupLayout() {
        tableView = UITableView()
        tableView?.register(NewsTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView!)

        tableView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })

        tableView?.estimatedRowHeight = Metrics.cellHeight
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = kThemeBase2Color

        tableView?.mj_header = MJRefreshNormalHeader()
        tableView?.mj_footer = MJRefreshBackNormalFooter()
    }

    private func setupRx() {
        // handle network data
        switch newsType {
        case .news:
            dataDriver = presenter.news.asDriver()
        case .technews:
            dataDriver = presenter.technews.asDriver()
        case .blockchain:
            dataDriver = presenter.blockchains.asDriver()
        default: break
        }

        dataDriver.drive(tableView!.rx.items(cellIdentifier: cellId, cellType: NewsTableViewCell.self)) { _, model, cell in
            cell.setValueForCell(model: model)
        }.disposed(by: disposeBag)

        dataDriver.map { _ in true }
            .drive(tableView!.mj_header.rx.endRefreshing)
            .disposed(by: disposeBag)

        dataDriver.map { _ in true }
            .drive(tableView!.mj_footer.rx.endRefreshing)
            .disposed(by: disposeBag)

        // update lastcursor
        dataDriver.filter { $0.count > 0 }
            .map { $0.last }
            .asObservable()
            .subscribe(onNext: { [weak self] item in
                guard let `self` = self else { return }

                self.lastCursor = item?.publishDate?.toUnixMillTime() ?? ""
            }).disposed(by: disposeBag)

        errorDriver = presenter.errors.asDriver(onErrorJustReturn: .serverFailed(newsType: .all))

        errorDriver.asObservable()
            .subscribe(onNext: { [weak self] error in
                guard let `self` = self else { return }

                switch error {
                case let .serverFailed(newsType):
                    if newsType == self.newsType {
                        self.showNetworkErrorView()
                    }
                case let .noData(newsType):
                    if newsType == self.newsType {
                        self.showEmptyView()
                    }
                default: break
                }

            }).disposed(by: disposeBag)

        // handle tableview events
        tableView?.rx.modelSelected(NewsItemModel.self).subscribe(onNext: { [weak self] model in
            guard let `self` = self else { return }

            if let url = URL(string: model.mobileUrl ?? "") {
                let safariConfig = SFSafariViewController.Configuration()
                safariConfig.entersReaderIfAvailable = true

                let safariVC = SFSafariViewController(url: url, configuration: safariConfig)
                self.present(safariVC, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)

        tableView?.mj_header.rx.refreshing
            .startWith(())
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                switch self.newsType {
                case .news:
                    self.presenter.getNewsList(lastCursor: "", true)
                case .technews:
                    self.presenter.getTechnewsList(lastCursor: "", true)
                case .blockchain:
                    self.presenter.getBlockchainList(lastCursor: "", true)
                default: break
                }
            }).disposed(by: disposeBag)

        tableView?.mj_footer.rx.refreshing
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                if self.lastCursor == "" {
                    self.tableView?.mj_footer.endRefreshing()
                    return
                }

                switch self.newsType {
                case .news:
                    self.presenter.getNewsList(lastCursor: self.lastCursor, false)
                case .technews:
                    self.presenter.getTechnewsList(lastCursor: self.lastCursor, false)
                case .blockchain:
                    self.presenter.getBlockchainList(lastCursor: self.lastCursor, false)
                default: break
                }
            }).disposed(by: disposeBag)
    }

    private func showNetworkErrorView() {
        endMjRefresh()

        let label = UILabel().then {
            $0.text = kmsgNoNetwork
            $0.textColor = kThemeFont2Color
            $0.textAlignment = .center
        }

        tableView?.backgroundView = label
    }

    private func showEmptyView() {
        endMjRefresh()

        let label = UILabel().then {
            $0.text = kmsgNoData
            $0.textColor = kThemeFont2Color
            $0.textAlignment = .center
        }

        tableView?.backgroundView = label
    }

    private func endMjRefresh() {
        tableView?.mj_header.endRefreshing()
        tableView?.mj_footer.endRefreshing()
    }
}

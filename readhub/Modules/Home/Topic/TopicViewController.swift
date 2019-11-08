//
//  TopicViewController.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import MJRefresh
import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

fileprivate struct Metrics {
    static let cellHeight: CGFloat = 300.0
}

class TopicViewController: BaseViewController {
    // MARK: Private properties -

    private var tableView: UITableView!
    private var presenter: HomePresenterInterface!

    private var dataDriver: Driver<[TopicItemModel]>!
    private var errorDriver: Driver<ReadhubApiError>!
    private var lastCursor: String = ""

    private let disposeBag = DisposeBag()

    private let cellId = "TopicCell"

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(presenter: HomePresenterInterface) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupRx()
    }

    private func setupLayout() {
        tableView = UITableView()
        tableView?.register(TopicTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)

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
        dataDriver = presenter.topics.asDriver()

        dataDriver.drive(tableView!.rx.items(cellIdentifier: cellId, cellType: TopicTableViewCell.self)) { _, model, cell in
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

                self.lastCursor = String(item!.order!)
            }).disposed(by: disposeBag)

        errorDriver = presenter.errors.asDriver(onErrorJustReturn: .serverFailed(newsType: .unknown))

        errorDriver.asObservable()
            .subscribe(onNext: { [weak self] error in
                guard let `self` = self else { return }

                switch error {
                case let .serverFailed(newsType):
                    if newsType == .topic {
                        self.showNetworkErrorView()
                    }
                case let .noData(newsType):
                    if newsType == .topic {
                        self.showEmptyView()
                    }
                default: break
                }

            }).disposed(by: disposeBag)

        // setup tableview
        tableView?.mj_header.rx.refreshing
            .startWith(())
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.presenter.getTopicList(lastCursor: "", true)
            }).disposed(by: disposeBag)

        tableView?.mj_footer.rx.refreshing
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                if self.lastCursor == "" {
                    self.tableView?.mj_footer.endRefreshing()
                    return
                }

                self.presenter.getTopicList(lastCursor: self.lastCursor, false)

            }).disposed(by: disposeBag)

        tableView?.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }

                self.presenter.toggleTopicCellAt(index: indexPath.row)

            }).disposed(by: disposeBag)
    }

    private func showNetworkErrorView() {
        endMjRefresh()

        let label = UILabel().then {
            $0.text = kMsgNoNetwork
            $0.textColor = kThemeFont2Color
            $0.textAlignment = .center
        }

        tableView?.backgroundView = label
    }

    private func showEmptyView() {
        endMjRefresh()

        let label = UILabel().then {
            $0.text = kMsgNoData
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

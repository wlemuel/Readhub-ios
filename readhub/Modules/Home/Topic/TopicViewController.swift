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

    static let notifyHeight: CGFloat = 40.0
    static let notifyWidth: CGFloat = 150.0
    static let notifyFontSize: CGFloat = 13.0
}

class TopicViewController: BaseViewController {
    // MARK: Private properties -

    private var tableView: UITableView!
    private var notifyView: UIButton!

    private var presenter: HomePresenterInterface!

    private var dataDriver: Driver<[TopicItemModel]>!
    private var errorDriver: Driver<ReadhubApiError>!
    private var notifyDriver: Driver<NewsType>!

    private var lastCursor: String = ""

    private let disposeBag = DisposeBag()

    private let cellId = "TopicCell"
    private var isNotifying = false

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

        // setup notify view
        notifyView = UIButton().then {
            $0.backgroundColor = kThemePrimaryColor
            $0.setTitle("", for: .normal)
            $0.setTitleColor(kThemeBase2Color, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: Metrics.notifyFontSize)
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: Metrics.notifyHeight, bottom: 0, right: 0)

            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = Metrics.notifyHeight / 2
            $0.layer.shadowColor = kThemeFont3Color.cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)

            let icon = UILabel().then {
                $0.font = UIFont(name: "iconFont", size: Metrics.notifyFontSize)
                $0.text = "\u{eb99}"
                $0.textColor = kThemeBase2Color
            }
            $0.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(Metrics.notifyHeight / 2)
            }
        }
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

        // notify handler
        notifyDriver = presenter.notifies.asDriver(onErrorJustReturn: .unknown)

        notifyDriver.asObservable()
            .subscribe(onNext: { [weak self] newsType in
                guard let `self` = self else { return }

                if newsType == .topic {
                    self.showNotify()
                }
            }).disposed(by: disposeBag)

        // setup tableview
        tableView?.mj_header.rx.refreshing
            .startWith(())
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.hideNotify()

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

        // setup notify view
        notifyView.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.hideNotify()

                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

                ViewUtils.delay(0.3) {
                    self.presenter.getTopicList(lastCursor: "", true)
                }

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

    private func showNotify() {
        if isNotifying {
            return
        }

        isNotifying = true

        notifyView.alpha = 0
        notifyView.setTitle("有新话题，点击查看", for: .normal)

        view.addSubview(notifyView)
        notifyView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(kMargin3)
            make.centerX.equalToSuperview()
            make.height.equalTo(Metrics.notifyHeight)
            make.width.equalTo(Metrics.notifyWidth)
        }

        UIView.animate(withDuration: 0.33, animations: {
            self.notifyView.alpha = 1.0
        })
    }

    private func hideNotify() {
        if !isNotifying {
            return
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self)

        UIView.animate(withDuration: 0.33, animations: {
            self.notifyView.alpha = 0.0
        }, completion: { _ in
            self.notifyView.removeFromSuperview()
            self.isNotifying = false
        })
    }
}

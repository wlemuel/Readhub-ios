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

fileprivate struct Metrics {
    static let cellHeight: CGFloat = 150.0

    static let notifyHeight: CGFloat = 40.0
    static let notifyWidth: CGFloat = 180.0
    static let notifyFontSize: CGFloat = 13.0
}

class NewsViewController: BaseViewController {
    // MARK: Private -

    private var presenter: HomePresenterInterface!
    private var newsType: NewsType = .news

    private var tableView: UITableView!
    private var notifyView: UIButton!

    private var dataDriver: Driver<[NewsItemModel]>!
    private var errorDriver: Driver<ReadhubApiError>!
    private var notifyDriver: Driver<NewsType>!

    private var lastCursor: String = ""
    private var lastReadMark: Int = 0
    private var tempReadMark: Int = 0

    private let disposeBag = DisposeBag()
    private let cellId = "NewsCell"

    private var isNotifying = false

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

        showLoadingView()

        // setup notify view
        notifyView = UIButton().then {
            $0.backgroundColor = kThemePrimaryColor
            $0.setTitle("", for: .normal)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: Metrics.notifyFontSize)
            $0.contentHorizontalAlignment = .left
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: Metrics.notifyHeight, bottom: 0, right: 0)

            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = Metrics.notifyHeight / 2
            $0.layer.shadowColor = kThemeFont3Color.cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)

            let icon = UILabel().then {
                $0.font = UIFont(name: "iconFont", size: Metrics.notifyFontSize)
                $0.text = "\u{eb99}"
                $0.textColor = UIColor.white
            }
            $0.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(Metrics.notifyHeight / 2)
            }
        }
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
            cell.setValueForCell(model: model, showReadMark: model.id == self.lastReadMark)
        }.disposed(by: disposeBag)

        dataDriver.map { _ in true }
            .drive(tableView!.mj_header.rx.endRefreshing)
            .disposed(by: disposeBag)

        dataDriver.map { _ in true }
            .drive(tableView!.mj_footer.rx.endRefreshing)
            .disposed(by: disposeBag)

        // update lastcursor
        dataDriver.filter { $0.count > 0 }
            .map { ($0.first, $0.last) }
            .asObservable()
            .subscribe(onNext: { [weak self] pair in
                guard let `self` = self, let first = pair.0, let last = pair.1,
                    let firstId = first.id else { return }

                self.lastCursor = last.publishDate?.toUnixMillTime() ?? ""
                self.tempReadMark = firstId
            }).disposed(by: disposeBag)

        errorDriver = presenter.errors.asDriver(onErrorJustReturn: .serverFailed(newsType: .unknown))

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

        // notify handler
        notifyDriver = presenter.notifies.asDriver(onErrorJustReturn: .unknown)

        notifyDriver.asObservable()
            .subscribe(onNext: { [weak self] newsType in
                guard let `self` = self else { return }

                if newsType == self.newsType {
                    self.showNotify()
                }
            }).disposed(by: disposeBag)

        // handle tableview events
        tableView?.rx.modelSelected(NewsItemModel.self).subscribe(onNext: { [weak self] model in
            guard let `self` = self else { return }

            ViewUtils.gotoUrl(viewcontroller: self, rawUrl: model.mobileUrl ?? "", enterReader: true)

        }).disposed(by: disposeBag)

        tableView?.mj_header.rx.refreshing
            .startWith(())
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.hideNotify()

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

//        tableView.rx.contentOffset
//            .map { $0.y }
//            .subscribe(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//
//                if self.isNotifying {
//                    self.hideNotify()
//                }
//
//            }).disposed(by: disposeBag)

        // setup notify view
        notifyView.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }

                self.hideNotify()

                self.lastReadMark = self.tempReadMark

                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

                ViewUtils.delay(0.3) {
                    switch self.newsType {
                    case .news:
                        self.presenter.getNewsList(lastCursor: "", true)
                    case .technews:
                        self.presenter.getTechnewsList(lastCursor: "", true)
                    case .blockchain:
                        self.presenter.getBlockchainList(lastCursor: "", true)
                    default: break
                    }
                }

            }).disposed(by: disposeBag)
    }

    private func showNetworkErrorView() {
        endMjRefresh()

        showBgView(msg: kMsgNoNetwork)
    }

    private func showEmptyView() {
        endMjRefresh()

        showBgView(msg: kMsgNoData)
    }

    private func showLoadingView() {
        showBgView(msg: kMsgLoading)
    }

    private func showBgView(msg: String) {
        let label = UILabel().then {
            $0.text = msg
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
        notifyView.setTitle("有新资讯，点击查看", for: .normal)

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

//
//  BaseNewsViewController.swift
//  readhub
//
//  Created by Steve Lemuel on 10/22/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import RxSwift

enum NewsType {
    case news
    case technews
    case blockchain
}

fileprivate struct Metrics {
    static let cellHeight: CGFloat = 150.0
}

class NewsViewController: BaseViewController {
    private var presenter: HomePresenterInterface!
    private var newsType: NewsType = .news

    private var tableView: UITableView!

    var disposeBag = DisposeBag()

    init(newsType: NewsType, presenter: HomePresenterInterface) {
        self.presenter = presenter
        self.newsType = newsType

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        switch newsType {
        case .news:
            presenter.getNewsList()
        case .technews:
            presenter.getTechnewsList()
        case .blockchain:
            presenter.getBlockchainList()
        }
    }

    func setupLayout() {
        tableView = UITableView()
        tableView?.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        view.addSubview(tableView!)

        tableView?.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })

        tableView?.estimatedRowHeight = Metrics.cellHeight
        tableView?.rowHeight = UITableView.automaticDimension

//        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
//        tableView?.addSubview(refreshControl)
//
//        refreshControl.rx.controlEvent(.valueChanged)
//            .subscribe(onNext: { [weak self] _ in
//                guard let `self` = self else { return }
//
//                self.presenter.getNewsList()
//            }).disposed(by: disposeBag)

        switch newsType {
        case .news:
            presenter.newsListObservable.observeOn(MainScheduler.instance)
            .map { $0.data ?? [] }
            .bind(to: tableView!.rx.items(cellIdentifier: "NewsCell", cellType: NewsTableViewCell.self)) { _, model, cell in
                cell.setValueForCell(model: model)
            }.disposed(by: disposeBag)
        case .technews:
            presenter.technewsListObservable.observeOn(MainScheduler.instance)
            .map { $0.data ?? [] }
            .bind(to: tableView!.rx.items(cellIdentifier: "NewsCell", cellType: NewsTableViewCell.self)) { _, model, cell in
                cell.setValueForCell(model: model)
            }.disposed(by: disposeBag)
        case .blockchain:
            presenter.blockchainListObservable.observeOn(MainScheduler.instance)
            .map { $0.data ?? [] }
            .bind(to: tableView!.rx.items(cellIdentifier: "NewsCell", cellType: NewsTableViewCell.self)) { _, model, cell in
                cell.setValueForCell(model: model)
            }.disposed(by: disposeBag)
        }
        
    }
}

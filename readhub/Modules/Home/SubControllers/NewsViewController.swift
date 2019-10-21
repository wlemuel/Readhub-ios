//
//  NewsViewController.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

fileprivate struct Metrics {
    static let cellHeight: CGFloat = 150.0
}

class NewsViewController: BaseHomeViewController {
    private var tableView: UITableView?
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        presenter.getNewsList()
    }

    func setupLayout() {
        
        tableView = UITableView()
        tableView?.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        view.addSubview(tableView!)
        
        tableView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        tableView?.estimatedRowHeight = Metrics.cellHeight
        tableView?.rowHeight = UITableView.automaticDimension
        
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        tableView?.addSubview(refreshControl)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                self.presenter.getNewsList()
            }).disposed(by: disposeBag)

        presenter.newsListObservable.observeOn(MainScheduler.instance)
            .map { $0.data ?? [] }
            .bind(to: tableView!.rx.items(cellIdentifier: "NewsCell", cellType: NewsTableViewCell.self)) { _, model, cell in
                cell.setValueForCell(model: model)
            }.disposed(by: disposeBag)
    }
}


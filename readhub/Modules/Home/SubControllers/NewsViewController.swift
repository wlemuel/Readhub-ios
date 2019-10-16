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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        presenter.getNewsList()
    }

    func setupLayout() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView?.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        view.addSubview(tableView!)

        tableView!.rx.setDelegate(self).disposed(by: disposeBag)

        presenter.newsListObservable.observeOn(MainScheduler.instance)
            .map { $0.data ?? [] }
            .bind(to: tableView!.rx.items(cellIdentifier: "NewsCell", cellType: NewsTableViewCell.self)) { _, model, cell in
                cell.setValueForCell(model: model)
            }.disposed(by: disposeBag)
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metrics.cellHeight
    }
}

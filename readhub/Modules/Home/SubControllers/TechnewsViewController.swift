//
//  TechnewsViewController.swift
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

class TechnewsViewController: BaseHomeViewController {
    private var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

        presenter.getTechnewsList()
    }

    func setupLayout() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView?.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        view.addSubview(tableView!)
        tableView?.estimatedRowHeight = Metrics.cellHeight
        tableView?.rowHeight = UITableView.automaticDimension

        presenter.technewsListObservable.observeOn(MainScheduler.instance)
            .map { $0.data ?? [] }
            .bind(to: tableView!.rx.items(cellIdentifier: "NewsCell", cellType: NewsTableViewCell.self)) { _, model, cell in
                cell.setValueForCell(model: model)
            }.disposed(by: disposeBag)
    }
}


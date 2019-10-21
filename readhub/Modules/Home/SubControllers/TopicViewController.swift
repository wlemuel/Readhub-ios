//
//  TopicViewController.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class TopicViewController: BaseHomeViewController {
    // MARK: Private properties -

    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    private func setupLayout() {
        tableView = UITableView()
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        tableView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
//        let items = Observable.just([
//            "文本输入框的用法",
//            "开关按钮的用法",
//            "进度条的用法",
//            "文本标签的用法",
//            ])
//         
//        //设置单元格数据（其实就是对 cellForRowAt 的封装）
//        items
//            .bind(to: tableView.rx.items) { (tableView, row, element) in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
//                cell.textLabel?.text = "\(row)：\(element)"
//                return cell
//            }
//        .disposed(by: rx.disposeBag)
        
        
    }
}

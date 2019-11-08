//
//  HomeViewController.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright (c) 2019 Steve Lemuel. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import TYPagerController
import UIKit

fileprivate struct Metric {
    static let pagerBarFontSize: CGFloat = 18.0
    static let pagerBarHeight: CGFloat = 40.0

    static let logoFontSize: CGFloat = 25.0
}

final class HomeViewController: BaseViewController {
    // MARK: - Public properties -

    var presenter: HomePresenterInterface!

    // MARK: - Private properties -

    private let disposeBag = DisposeBag()

    private var titleView: UIView!
    private var settingBtn: UIImageView!
    private var bookmarkBtn: UIButton!
    private var pageVC: TYTabPagerController!

    private let titles: [String] = ["热门话题", "科技动态", "开发者", "区块链"]

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.startUpdateCheck()
    }

    override func viewWillDisappear(_ animated: Bool) {
        presenter.stopUpdateCheck()
    }
}

// MARK: - Extensions -

extension HomeViewController: HomeViewInterface {
}

private extension HomeViewController {
    func configure() {
        let output = Home.ViewOutput()

        _ = presenter.configure(with: output)
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = kThemeBase2Color
    }

    func setupLayout() {
        setupTitleView()
        setupPageController()
    }

    func setupTitleView() {
        let logo = UIBarButtonItem(title: "Readhub+", style: .plain, target: self, action: nil).then {
            let attributes = [
                NSAttributedString.Key.foregroundColor: kThemePrimaryColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: Metric.logoFontSize),
            ]
            $0.setTitleTextAttributes(attributes, for: .normal)
        }

        navigationItem.leftBarButtonItem = logo

        let settings = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(gotoSettings))
        navigationItem.rightBarButtonItem = settings
    }

    func setupPageController() {
        pageVC = TYTabPagerController().then {
            $0.pagerController.layout.prefetchItemCount = 3
            $0.tabBar.layout.cellWidth = kScreenW * 0.24
            $0.tabBar.layout.progressColor = kThemePrimaryColor
            $0.tabBar.layout.selectedTextColor = kThemePrimaryColor
            $0.tabBar.backgroundColor = kThemeBase2Color
            $0.tabBar.layout.cellSpacing = 0
            $0.tabBar.layout.cellEdging = 0
            $0.tabBar.layout.normalTextFont = UIFont.systemFont(ofSize: Metric.pagerBarFontSize)
            $0.tabBar.layout.selectedTextFont = UIFont.systemFont(ofSize: Metric.pagerBarFontSize)
            $0.tabBar.layout.adjustContentCellsCenter = true
            $0.tabBarHeight = Metric.pagerBarHeight
        }

        addChild(pageVC)
        view.addSubview(pageVC.view)

        pageVC.delegate = self
        pageVC.dataSource = self

        let pageView = pageVC.view

        pageView?.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        pageVC.reloadData()

        // 设置起始页
        pageVC.pagerController.scrollToController(at: 0, animate: false)
    }

    func setRx() {
    }

    @objc func gotoSettings() {
        navigationController?.pushWireframe(SettingsWireframe())
    }
}

extension HomeViewController: TYTabPagerControllerDelegate, TYTabPagerControllerDataSource {
    func numberOfControllersInTabPagerController() -> Int {
        return titles.count
    }

    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        if index == 0 {
            let VC = TopicViewController(presenter: presenter)
            VC.view.backgroundColor = kThemeBase2Color
            return VC
        } else if index == 1 {
            let VC = NewsViewController(newsType: .news, presenter: presenter)
            VC.view.backgroundColor = kThemeBase2Color
            return VC
        } else if index == 2 {
            let VC = NewsViewController(newsType: .technews, presenter: presenter)
            VC.view.backgroundColor = kThemeBase2Color
            return VC
        } else if index == 3 {
            let VC = NewsViewController(newsType: .blockchain, presenter: presenter)
            VC.view.backgroundColor = kThemeBase2Color
            return VC
        }

        let VC = UIViewController()
        VC.view.backgroundColor = kThemeBase2Color
        return VC
    }

    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        return titles[index]
    }
}

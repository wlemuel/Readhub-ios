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
    static let pagerBarFontSize = UIFont.systemFont(ofSize: 18.0)
    static let pagerBarHeight: CGFloat = 40.0
    static let titleHeight: CGFloat = 50.0

    static let titleIconSize: CGFloat = 25.0
    static let titleIconMargin: CGFloat = 15.0
}

final class HomeViewController: BaseViewController {
    // MARK: - Public properties -

    var presenter: HomePresenterInterface!

    // MARK: - Private properties -

    private let disposeBag = DisposeBag()

    private var titleView: UIView!
    private var settingBtn: UIImageView!
    private var bookmarkBtn: UIButton!

    private let titles: [String] = ["热门话题", "科技动态", "开发者", "区块链"]
    private let pageVC = TYTabPagerController().then {
        $0.pagerController.scrollView?.backgroundColor = kThemeMainColor
        $0.pagerController.layout.prefetchItemCount = 3
        $0.tabBar.layout.cellWidth = kScreenW * 0.25
        $0.tabBar.layout.progressColor = kThemeMainColor
        $0.tabBar.layout.selectedTextColor = kThemeMainColor
        $0.tabBar.backgroundColor = kThemeWhiteColor
        $0.tabBar.layout.cellSpacing = 0
        $0.tabBar.layout.cellEdging = 0
        $0.tabBar.layout.normalTextFont = Metric.pagerBarFontSize
        $0.tabBar.layout.selectedTextFont = Metric.pagerBarFontSize
        $0.tabBarHeight = Metric.pagerBarHeight
    }

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

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupLayout() {
        setupTitleView()
        setupPageController()
    }

    private func setupTitleView() {
        titleView = UIView().then {
            $0.backgroundColor = kThemeWhiteColor
        }
        view.addSubview(titleView!)
        titleView.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(Metric.titleHeight)
        })

        let logoLabel = UILabel().then {
            $0.text = "Readhub+"
            $0.textColor = kThemeMainColor
            $0.font = UIFont.systemFont(ofSize: 25)
        }
        titleView.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(MetricsGlobal.padding)
            make.centerY.equalToSuperview()
        }

        let hline = UIView().then {
            $0.backgroundColor = kThemeSeperatorColor
        }
        titleView.addSubview(hline)
        hline.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(2)
            make.left.right.equalToSuperview()
        }

        settingBtn = UIImageView(image: UIImage(named: "icon_settings"))
        titleView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Metric.titleIconSize)
            make.right.equalToSuperview().offset(0 - Metric.titleIconMargin)
        }
    }

    private func setupPageController() {
        addChild(pageVC)
        view.addSubview(pageVC.view)

        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.view.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        pageVC.reloadData()

        // 设置起始页
        pageVC.pagerController.scrollToController(at: 0, animate: false)
    }

    private func setRx() {
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
}

extension HomeViewController: TYTabPagerControllerDelegate, TYTabPagerControllerDataSource {
    func numberOfControllersInTabPagerController() -> Int {
        return titles.count
    }

    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        if index == 0 {
            let VC = TopicViewController(presenter: presenter)
            VC.view.backgroundColor = kThemeGrayColor
            return VC
        } else if index == 1 {
            let VC = NewsViewController(newsType: .news, presenter: presenter)
            VC.view.backgroundColor = kThemeGrayColor
            return VC
        } else if index == 2 {
            let VC = NewsViewController(newsType: .technews, presenter: presenter)
            VC.view.backgroundColor = kThemeGrayColor
            return VC
        } else if index == 3 {
            let VC = NewsViewController(newsType: .blockchain, presenter: presenter)
            VC.view.backgroundColor = kThemeGrayColor
            return VC
        }

        let VC = UIViewController()
        VC.view.backgroundColor = kThemeWhiteColor
        return VC
    }

    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        return titles[index]
    }
}

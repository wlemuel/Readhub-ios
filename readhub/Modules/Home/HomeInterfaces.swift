//
//  HomeInterfaces.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright (c) 2019 Steve Lemuel. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import RxCocoa
import RxSwift
import UIKit

enum Home {
    struct ViewOutput {
    }

    struct ViewInput {
    }
}

protocol HomeWireframeInterface: WireframeInterface {
}

protocol HomeViewInterface: ViewInterface {
}

protocol HomePresenterInterface: PresenterInterface {
    func configure(with output: Home.ViewOutput) -> Home.ViewInput

    // MARK: Observables -

    var topics: BehaviorRelay<[TopicItemModel]> { get }
    var news: BehaviorRelay<[NewsItemModel]> { get }
    var technews: BehaviorRelay<[NewsItemModel]> { get }
    var blockchains: BehaviorRelay<[NewsItemModel]> { get }

    // MARK: Functions -

    func getTopicList(lastCursor: String, _ refresh: Bool)
    func getNewsList(lastCursor: String, _ refresh: Bool)
    func getTechnewsList(lastCursor: String, _ refresh: Bool)
    func getBlockchainList(lastCursor: String, _ refresh: Bool)
}

protocol HomeInteractorInterface: InteractorInterface {
    func getTopicList(lastCursor: String, pageSize: Int) -> Single<TopicListModel>

    func getNewsList(lastCursor: String, pageSize: Int) -> Single<NewsListModel>

    func getTechnewsList(lastCursor: String, pageSize: Int) -> Single<TechnewsListModel>

    func getBlockchainList(lastCursor: String, pageSize: Int) -> Single<BlockchainListModel>
}

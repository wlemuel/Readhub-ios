//
//  HomePresenter.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright (c) 2019 Steve Lemuel. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

final class HomePresenter {
    // MARK: - Public prperties -

    var topicListObservable: Observable<TopicListModel> {
        return topicsSubject.asObserver()
    }

    var newsListObservable: Observable<NewsListModel> {
        return newsSubject.asObserver()
    }

    var technewsListObservable: Observable<TechnewsListModel> {
        return technewsSubject.asObserver()
    }

    var blockchainListObservable: Observable<BlockchainListModel> {
        return blockchainSubject.asObserver()
    }

    // MARK: - Private properties -

    private unowned let view: HomeViewInterface
    private let interactor: HomeInteractorInterface
    private let wireframe: HomeWireframeInterface

    private let topicsSubject = PublishSubject<TopicListModel>()
    private let newsSubject = PublishSubject<NewsListModel>()
    private let technewsSubject = PublishSubject<TechnewsListModel>()
    private let blockchainSubject = PublishSubject<BlockchainListModel>()

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle -

    init(view: HomeViewInterface, interactor: HomeInteractorInterface, wireframe: HomeWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension HomePresenter: HomePresenterInterface {
    func configure(with output: Home.ViewOutput) -> Home.ViewInput {
        return Home.ViewInput()
    }

    func getTopicList() {
        interactor.getTopicList(lastCursor: "", pageSize: 10)
            .subscribe(onSuccess: { [weak self] topicList in
                guard let `self` = self else { return }

                self.topicsSubject.onNext(topicList)
            }) { error in
                print(error)
            }.disposed(by: disposeBag)
    }

    func getNewsList() {
        interactor.getNewsList(lastCursor: "", pageSize: 20)
            .subscribe(onSuccess: { [weak self] newsList in
                guard let `self` = self else { return }

                self.newsSubject.onNext(newsList)
            }) { error in
                print(error)
            }.disposed(by: disposeBag)
    }

    func getTechnewsList() {
        interactor.getTechnewsList(lastCursor: "", pageSize: 20)
            .subscribe(onSuccess: { [weak self] technewsList in
                guard let `self` = self else { return }

                self.technewsSubject.onNext(technewsList)
            }) { error in
                print(error)
            }.disposed(by: disposeBag)
    }

    func getBlockchainList() {
        interactor.getBlockchainList(lastCursor: "", pageSize: 20)
            .subscribe(onSuccess: { [weak self] blockchainList in
                guard let `self` = self else { return }

                self.blockchainSubject.onNext(blockchainList)
            }) { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}

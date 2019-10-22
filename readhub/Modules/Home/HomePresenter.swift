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

    // MARK: - Private properties -

    private unowned let view: HomeViewInterface
    private let interactor: HomeInteractorInterface
    private let wireframe: HomeWireframeInterface

    var topics = BehaviorRelay<[TopicItemModel]>(value: [])
    var news = BehaviorRelay<[NewsItemModel]>(value: [])
    var technews = BehaviorRelay<[NewsItemModel]>(value: [])
    var blockchains = BehaviorRelay<[NewsItemModel]>(value: [])

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

    func getTopicList(lastCursor: String, _ refresh: Bool) {
        interactor.getTopicList(lastCursor: lastCursor, pageSize: 10)
            .subscribe(onSuccess: { [weak self] topicList in
                guard let `self` = self else { return }

                if refresh {
                    self.topics.accept(topicList.data ?? [])
                } else {
                    self.topics.accept(self.topics.value + (topicList.data ?? []))
                }

            }) { error in
                print(error)
            }.disposed(by: disposeBag)
    }

    func getNewsList(lastCursor: String, _ refresh: Bool) {
        interactor.getNewsList(lastCursor: lastCursor, pageSize: 20)
            .subscribe(onSuccess: { [weak self] newsList in
                guard let `self` = self else { return }

                if refresh {
                    self.news.accept(newsList.data ?? [])
                } else {
                    self.news.accept(self.news.value + (newsList.data ?? []))
                }
            }) { error in
                print(error)
            }.disposed(by: disposeBag)
    }

    func getTechnewsList(lastCursor: String, _ refresh: Bool) {
        interactor.getTechnewsList(lastCursor: lastCursor, pageSize: 20)
            .subscribe(onSuccess: { [weak self] technewsList in
                guard let `self` = self else { return }

                if refresh {
                    self.technews.accept(technewsList.data ?? [])
                } else {
                    self.technews.accept(self.technews.value + (technewsList.data ?? []))
                }

            }) { error in
                print(error)
            }.disposed(by: disposeBag)
    }

    func getBlockchainList(lastCursor: String, _ refresh: Bool) {
        interactor.getBlockchainList(lastCursor: lastCursor, pageSize: 20)
            .subscribe(onSuccess: { [weak self] blockchainList in
                guard let `self` = self else { return }

                if refresh {
                    self.blockchains.accept(blockchainList.data ?? [])
                } else {
                    self.blockchains.accept(self.blockchains.value + (blockchainList.data ?? []))
                }
            }) { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}

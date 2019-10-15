//
//  ReadhubModels.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation

struct TopicListModel: Codable {
    var pageSize: Int?
    var totalItems: Int?
    var totalPages: Int?
    var data: [TopicItemModel]?
}

struct TopicItemModel: Codable {
    var id: String?
    var title: String?
    var summary: String?
    var publishDate: String?
    var newsArray: [TopicItemNewsModel]?
}

struct TopicItemNewsModel: Codable {
    var id: String?
    var siteName: String?
    var title: String?
    var summary: String?
    var url: String?
    var mobileUrl: String?
    var publishDate: String?
}

struct NewsListModel: Codable {
    var pageSize: Int?
    var totalItems: Int?
    var totalPages: Int?
    var data: [NewsItemModel]?
}

struct NewsItemModel: Codable {
    var id: Int?
    var title: String?
    var summary: String?
    var summaryAuto: String?
    var siteName: String?
    var url: String?
    var mobileUrl: String?
    var publishDate: String?
    var authorName: String?
}

struct TechnewsListModel: Codable {
    var pageSize: Int?
    var totalItems: Int?
    var totalPages: Int?
    var data: [NewsItemModel]?
}

struct BlockchainListModel: Codable {
    var pageSize: Int?
    var totalItems: Int?
    var totalPages: Int?
    var data: [NewsItemModel]?
}


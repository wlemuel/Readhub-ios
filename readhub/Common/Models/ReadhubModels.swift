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
    let id: String?
    let newsArray: [TopicItemNewsModel]?
    let createdAt: String?
    let eventData: [TopicItemEventModel]?
    let publishDate: String?
    let summary: String?
    let title: String?
    let updatedAt: String?
    let timeline: String?
    let order: Int?
    let hasInstantView: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case newsArray
        case createdAt
        case eventData
        case publishDate
        case summary
        case title
        case updatedAt
        case timeline
        case order
        case hasInstantView
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        newsArray = try values.decodeIfPresent([TopicItemNewsModel].self, forKey: .newsArray)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        eventData = try values.decodeIfPresent([TopicItemEventModel].self, forKey: .eventData)
        publishDate = try values.decodeIfPresent(String.self, forKey: .publishDate)
        summary = try values.decodeIfPresent(String.self, forKey: .summary)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        timeline = try values.decodeIfPresent(String.self, forKey: .timeline)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        hasInstantView = try values.decodeIfPresent(Bool.self, forKey: .hasInstantView)
    }
}

struct TopicItemNewsModel: Codable {
    let id: Int?
    let url: String?
    let title: String?
    let siteName: String?
    let mobileUrl: String?
    let autherName: String?
    let duplicateId: Int?
    let publishDate: String?
    let language: String?
    let statementType: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case siteName
        case mobileUrl
        case autherName
        case duplicateId
        case publishDate
        case language
        case statementType
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        siteName = try values.decodeIfPresent(String.self, forKey: .siteName)
        mobileUrl = try values.decodeIfPresent(String.self, forKey: .mobileUrl)
        autherName = try values.decodeIfPresent(String.self, forKey: .autherName)
        duplicateId = try values.decodeIfPresent(Int.self, forKey: .duplicateId)
        publishDate = try values.decodeIfPresent(String.self, forKey: .publishDate)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        statementType = try values.decodeIfPresent(Int.self, forKey: .statementType)
    }
}

struct TopicItemEventModel: Codable {
    let id : Int?
    let topicId : String?
    let eventType : Int?
    let entityId : String?
    let entityType : String?
    let entityName : String?
    let state : Int?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case topicId = "topicId"
        case eventType = "eventType"
        case entityId = "entityId"
        case entityType = "entityType"
        case entityName = "entityName"
        case state = "state"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        topicId = try values.decodeIfPresent(String.self, forKey: .topicId)
        eventType = try values.decodeIfPresent(Int.self, forKey: .eventType)
        entityId = try values.decodeIfPresent(String.self, forKey: .entityId)
        entityType = try values.decodeIfPresent(String.self, forKey: .entityType)
        entityName = try values.decodeIfPresent(String.self, forKey: .entityName)
        state = try values.decodeIfPresent(Int.self, forKey: .state)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
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

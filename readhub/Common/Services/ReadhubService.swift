//
//  ReadhubService.swift
//  readhub
//
//  Created by Steve Lemuel on 10/15/19.
//  Copyright © 2019 Steve Lemuel. All rights reserved.
//

import Foundation
import Moya

enum ReadhubApi {
    // 热门话题
    case topicList(lastCursor: String, pageSize: Int)

    // 话题详情
    case topicDetail(topicId: String)

    // 科技动态
    case newsList(lastCursor: String, pageSize: Int)

    // 开发者资讯
    case technewsList(lastCursor: String, pageSize: Int)

    // 区块链资讯
    case blockchainList(lastCursor: String, pageSize: Int)

    // 招聘行情
    case jobsList(lastCursor: String, pageSize: Int)

    // 检查是否有新资讯
//    case newCount(lastCursor: String)
}

enum ReadhubApiError {
    case noData(newsType: NewsType)
    case noMoreData(newsType: NewsType)
    case serverFailed(newsType: NewsType)
}

extension ReadhubApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.readhub.cn")!
    }

    var path: String {
        switch self {
        case .topicList:
            return "topic"
        case let .topicDetail(topicId):
            return "topic/\(topicId)"
        case .newsList:
            return "news"
        case .technewsList:
            return "technews"
        case .blockchainList:
            return "blockchain"
        case .jobsList:
            return "jobs"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        var params: [String: Any] = [:]

        switch self {
        case let .topicList(lastCursor, pageSize),
             let .newsList(lastCursor, pageSize),
             let .technewsList(lastCursor, pageSize),
             let .blockchainList(lastCursor, pageSize),
             let .jobsList(lastCursor, pageSize):

            params["lastCursor"] = lastCursor
            params["pageSize"] = pageSize
        case .topicDetail:
            break
        }

        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }

    var headers: [String: String]? {
        return nil
    }
}

let readhubProvider = MoyaProvider<ReadhubApi>(plugins: {
    let networkConfigure = NetworkLoggerPlugin.Configuration(logOptions: .verbose)

    if Constants.Env.isDebug() {
        return [NetworkLoggerPlugin(configuration: networkConfigure)]
    } else {
        return []
    }
}())

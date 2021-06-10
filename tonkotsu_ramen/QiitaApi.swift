//
//  QiitaApi.swift
//  tonkotsu_ramen
//
//  Created by 宮本光直 on 2021/06/10.
//

import Foundation
import Moya

enum QiitaAPI {
    case swift
    case search(searchWord: String)
}

extension QiitaAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }

    var path: String {
        return "/api/v2/items"
    }

    var method: Moya.Method {
        return Moya.Method.get
    }

//    var parameters: [String: Any] {
//        switch self {
//        case .swift: return ["tag": "swift"]
//        case .flutter: return ["tag": "swift"]
//
//        }
//    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .swift:
            return .requestParameters(parameters: ["query": "swift"], encoding: URLEncoding.queryString )
        case let .search(_: searchWord):
            return .requestParameters(parameters: ["query": searchWord], encoding: URLEncoding.queryString )
        }
    }

    var headers: [String : String]? {
        return nil
    }
}

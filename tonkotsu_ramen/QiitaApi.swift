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
    case laravel
}

extension QiitaAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://qiita.com/api/v2/items")!
    }

    var path: String {
        return ""
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
        return .requestPlain
    }

    var headers: [String : String]? {
        return nil
    }
}

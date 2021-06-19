import Foundation
import Moya

enum QiitaAPI {
    case all
    case searchByText(searchWord: String)
    case searchByCategory(category: String)
}

extension QiitaAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIConst.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .all, .searchByText:
            return APIConst.BASE_PATH + "/items"
        case .searchByCategory(let category):
            return APIConst.BASE_PATH + "tags/\(category)/items"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .all, .searchByText, .searchByCategory:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .all:
            return .requestPlain
            
        case .searchByText(let searchWord):
            return .requestParameters(parameters: ["query": searchWord], encoding: URLEncoding.queryString)
            
        case .searchByCategory(let category):
            return .requestParameters(parameters: ["tag": category], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

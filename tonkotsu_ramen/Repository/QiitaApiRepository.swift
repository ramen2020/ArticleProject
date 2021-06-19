import Foundation
import Moya
import RxSwift

final class QiitaApiRepository {
    private static let apiProvider = MoyaProvider<QiitaAPI>()
    private static let disposeBag = DisposeBag()
}

extension QiitaApiRepository {
    
    static func fetchQiitaArticles() -> Observable<[Article]> {
        return apiProvider.rx.request(.all)
            .map { response in
                let decoder = JSONDecoder()
                return try decoder.decode([Article].self, from: response.data)
            }.asObservable()
    }
    
    static func fetchQiitaArticlesBySearchWord(searchWord: String) -> Observable<[Article]> {
        apiProvider.rx.request(.searchByText(searchWord: searchWord))
            .map { response in
                let decoder = JSONDecoder()
                return try decoder.decode([Article].self, from: response.data)}
            .asObservable()
    }

    static func fetchQiitaArticlesByCategory(category: String) -> Observable<[Article]> {
        apiProvider.rx.request(.searchByCategory(category: category))
            .map { response in
                let decoder = JSONDecoder()
                return try decoder.decode([Article].self, from: response.data)}
            .asObservable()
    }
}

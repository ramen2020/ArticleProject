import Foundation
import Moya
import RxSwift

protocol QiitaApiRepositoryProtocol {
    static func fetchQiitaArticles() -> Observable<[Article]>
    static func fetchQiitaArticlesBySearchWord(searchWord: String) -> Observable<[Article]>
    static func fetchQiitaArticlesByCategory(category: String) -> Observable<[Article]>
}

final class QiitaApiRepository {
    private static let apiProvider = MoyaProvider<QiitaAPI>()
    private static let disposeBag = DisposeBag()
}

extension QiitaApiRepository: QiitaApiRepositoryProtocol {
    
    static func fetchQiitaArticles() -> Observable<[Article]> {
        return apiProvider.rx.request(.all)
            .map { response in
                switch response.statusCode {
                case 200...399:
                    do {
                        let decoder = JSONDecoder()
                        return try decoder.decode([Article].self, from: response.data)
                    } catch {
                        throw ArticleCustomError.mappingError
                    }
                case 400...403:
                    throw ArticleCustomError.errorResponse(
                        try JSONDecoder().decode(ArticleError.self, from: response.data)
                    )
                case 500:
                    throw ArticleCustomError.internalError
                case 502:
                    throw ArticleCustomError.badGatewayError
                case 503:
                    throw ArticleCustomError.serviceUnavailableError
                default:
                    throw ArticleCustomError.unexpectedError
                }
            }.asObservable()
    }
    
    static func fetchQiitaArticlesBySearchWord(searchWord: String) -> Observable<[Article]> {
        apiProvider.rx.request(.searchByText(searchWord: searchWord))
            .map { response in
                switch response.statusCode {
                case 200...399:
                    do {
                        let decoder = JSONDecoder()
                        return try decoder.decode([Article].self, from: response.data)
                    } catch {
                        throw ArticleCustomError.mappingError
                    }
                case 400...403:
                    throw ArticleCustomError.errorResponse(
                        try JSONDecoder().decode(ArticleError.self, from: response.data)
                    )
                case 500:
                    throw ArticleCustomError.internalError
                case 502:
                    throw ArticleCustomError.badGatewayError
                case 503:
                    throw ArticleCustomError.serviceUnavailableError
                default:
                    throw ArticleCustomError.unexpectedError
                }
            }
            .asObservable()
    }

    static func fetchQiitaArticlesByCategory(category: String) -> Observable<[Article]> {
        apiProvider.rx.request(.searchByCategory(category: category))
            .map { response in
                switch response.statusCode {
                case 200...399:
                    do {
                        let decoder = JSONDecoder()
                        return try decoder.decode([Article].self, from: response.data)
                    } catch {
                        throw ArticleCustomError.mappingError
                    }
                case 400...404:
                    throw ArticleCustomError.errorResponse(
                        try JSONDecoder().decode(ArticleError.self, from: response.data)
                    )
                case 500:
                    throw ArticleCustomError.internalError
                case 502:
                    throw ArticleCustomError.badGatewayError
                case 503:
                    throw ArticleCustomError.serviceUnavailableError
                default:
                    throw ArticleCustomError.unexpectedError
                }
            }
            .asObservable()
    }
}

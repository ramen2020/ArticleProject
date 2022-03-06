import Foundation
import Moya
import RxSwift

protocol QiitaApiRepositoryProtocol {
    func fetchQiitaArticles() -> Observable<[Article]>
    func fetchQiitaArticlesBySearchWord(searchWord: String) -> Observable<[Article]>
    func fetchQiitaArticlesByCategory(category: String) -> Observable<[Article]>
}

final class QiitaApiRepository {
    static let shared = QiitaApiRepository()
    private let apiProvider = MoyaProvider<QiitaAPI>()
    private let disposeBag = DisposeBag()
}

extension QiitaApiRepository: QiitaApiRepositoryProtocol {
    
    func fetchQiitaArticles() -> Observable<[Article]> {
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
    
    func fetchQiitaArticlesBySearchWord(searchWord: String) -> Observable<[Article]> {
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

    func fetchQiitaArticlesByCategory(category: String) -> Observable<[Article]> {
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

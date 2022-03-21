
import Foundation
import RxCocoa
import RxSwift

@testable import tonkotsu_ramen

final class MockQiitaApiRepository: QiitaApiRepositoryProtocol {

    let articles: [Article]

    init(articles: [Article]) {
        self.articles = articles
    }
    
    func fetchQiitaArticles() -> Observable<[Article]> {
        return Observable.of(articles).asObservable()
    }

    func fetchQiitaArticlesBySearchWord(searchWord: String) -> Observable<[Article]> {
        let filterArticles = articles.filter{
            $0.title.contains(searchWord)
        }
        return Observable.of(filterArticles).asObservable()
    }

    func fetchQiitaArticlesByCategory(category: String) -> Observable<[Article]> {
        let filterArticles = articles.filter { article in
                article.tags.contains { tag in
                    tag.name == category
                }
            }

        return Observable.of(filterArticles).asObservable()
    }
}


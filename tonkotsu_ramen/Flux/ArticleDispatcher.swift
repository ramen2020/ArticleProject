import RxCocoa
import RxSwift

final class ArticleDispatcher {
    static let shared = ArticleDispatcher()

    let articles = PublishRelay<[Article]>()
    let error = PublishRelay<Error>()
}
